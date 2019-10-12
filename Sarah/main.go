package main

import (
  "github.com/gin-gonic/gin"
  "fmt"
  "io/ioutil"
  "log"
  "encoding/json"
//  "math/rand"
//  "time"
  "flag"
)

type FieldData struct {
	Width             int     `json:"width"`
	Height            int     `json:"height"`
	Points            [][]int `json:"points"`
	StartedAtUnixTime int     `json:"startedAtUnixTime"`
	Turn              int     `json:"turn"`
	Tiled             [][]int `json:"tiled"`
	Teams             []struct {
		TeamID int `json:"teamID"`
		Agents []struct {
			AgentID int `json:"agentID"`
			X       int `json:"x"`
			Y       int `json:"y"`
		} `json:"agents"`
		TilePoint int `json:"tilePoint"`
		AreaPoint int `json:"areaPoint"`
	} `json:"teams"`
	Actions []interface{} `json:"actions"`
}

// エージェントの行動を受け取る構造体 {{{
type  Action struct {
  AgentID int `json:"agentID"`
  Type string `json:"type"`
  Dx int `json:"dx"`
  Dy int `json:"dy"`
}

type Actions struct {
  AgentActions []Action `json:"actions"`
}
// }}}

// jsonファイルの読み込み
func getFieldData() FieldData {
  // ファイルから読み取り
  bytes, err := ioutil.ReadFile("A.json")

  if err != nil {
    log.Fatal(err)
  }

  var field FieldData

    // fieldのstructに格納
  if err := json.Unmarshal(bytes, &field); err != nil {
    log.Fatal(err)
  }

  return field
}

func main() {
  flag.Parse()
  args := flag.Args()
  isHumanPower := false
  if len(args) > 0 {
    isHumanPower = true
  }
  r := gin.Default()
  field := getFieldData()
  fmt.Println(field)
  sendFieldData(r, field)
  rsvActionData(r, &field, isHumanPower)
  r.Run()
}

// フィールドデータの返却
func sendFieldData(r *gin.Engine, field FieldData) {
  r.GET("/matches/:id", func(c *gin.Context) {
      c.JSON(200, field)
      })
}

func rsvActionData(r *gin.Engine, field *FieldData, isHumanPower bool) {
  var actions Actions
  r.POST("/matches/:id/action", func(c *gin.Context) {
      c.BindJSON(&actions)
      for i := 0; i < len(field.Teams[0].Agents); i++ {
        field.Teams[0].Agents[i].X = field.Teams[0].Agents[i].X
        field.Teams[0].Agents[i].Y = field.Teams[0].Agents[i].Y
        field.Teams[1].Agents[i].X = field.Teams[1].Agents[i].X
        field.Teams[1].Agents[i].Y = field.Teams[1].Agents[i].Y
      }
      fmt.Println(actions)
      if actions.AgentActions[0].AgentID == 4 {
        updateFieldData(field, actions, 2)
      } else {
        updateFieldData(field, actions, 1)
      }
      // dx := []int{-1, -1, 0, 1, 1, 1, 0, -1};
      // dy := []int{0, -1, -1, -1, 0, 1, 1, 1};
      // if !isHumanPower {
      //   rand.Seed(time.Now().UnixNano())
      //   var randAction Actions
      //   for i := 0; i < len(field.Teams[0].Agents); i++ {
      //     var tmp Action
      //     tmp.AgentID = 0
      //     tmp.Type = "move"
      //     dir := rand.Intn(8)
      //     tmp.Dx = dx[dir]
      //     tmp.Dy = dy[dir]
      //     randAction.AgentActions = append(randAction.AgentActions, tmp)
      //   }
      //   updateFieldData(field, randAction, 2);
      // } else {
      //   var humanAction Actions
      //   ageID := 4
      //   for i := 0; i < len(field.Teams[0].Agents); i++ {
      //     var tmp Action
      //
      //     tmp.AgentID = ageID
      //     var tmpAgeMove int
      //     fmt.Printf("エージェント%dの動き >> ", ageID)
      //     fmt.Scan(&tmpAgeMove)
      //     tmp.Dx = dx[tmpAgeMove]
      //     tmp.Dy = dy[tmpAgeMove]
      //     humanAction.AgentActions = append(humanAction.AgentActions, tmp)
      //     ageID++
      //   }
      //   updateFieldData(field, humanAction, 2);
      // }

  })
}

func checkDuplicate(whichTeam bool, tmpPos [][]int, agentNum int, field FieldData) {
  if whichTeam {
    for i := 0; i < agentNum; i++ {
      for j := 0; j < len(tmpPos); j++ {
        if i != j && tmpPos[i][0] == tmpPos[j][0] && tmpPos[i][1] == tmpPos[j][1] {
          tmpPos[i][0] = field.Teams[0].Agents[i].X - 1
          tmpPos[i][1] = field.Teams[0].Agents[i].Y - 1

          if j < agentNum {
            tmpPos[j][0] = field.Teams[0].Agents[j].X - 1
            tmpPos[j][1] = field.Teams[0].Agents[j].Y - 1
          }
        }
      }
    }
  } else {
    for i := 0; i < agentNum; i++ {
      for j := 0; j < len(tmpPos); j++ {
        if i != j && tmpPos[i][0] == tmpPos[j][0] && tmpPos[i][1] == tmpPos[j][1] {
          tmpPos[i][0] = field.Teams[1].Agents[i].X - 1
          tmpPos[i][1] = field.Teams[1].Agents[i].Y - 1

          if j < agentNum {
            tmpPos[j][0] = field.Teams[0].Agents[j].X - 1
            tmpPos[j][1] = field.Teams[0].Agents[j].Y - 1
          }
        }
      }
    }
  }
}

func updateFieldData(field *FieldData, action Actions, whichTeam int) {
  agentNum := len(field.Teams[0].Agents)
  tmpPos := make([][]int, agentNum * 2)

  for i := 0; i < agentNum * 2; i++ {
    tmpPos[i] = []int{0, 0}
  }

  if whichTeam == field.Teams[0].TeamID {
    for i := 0; i < agentNum; i++ {
      tmpPos[i][0] = field.Teams[0].Agents[i].X + action.AgentActions[i].Dx - 1
      tmpPos[i][1] = field.Teams[0].Agents[i].Y + action.AgentActions[i].Dy - 1

      if tmpPos[i][0] < 0 || field.Width <= tmpPos[i][0] {
        tmpPos[i][0] = field.Teams[0].Agents[i].X - 1
        tmpPos[i][1] = field.Teams[0].Agents[i].Y - 1
      } else if tmpPos[i][1] < 0 || field.Height <= tmpPos[i][1] {
        tmpPos[i][0] = field.Teams[0].Agents[i].X - 1
        tmpPos[i][1] = field.Teams[0].Agents[i].Y - 1
      }

      if field.Tiled[tmpPos[i][1]][tmpPos[i][0]] == field.Teams[1].TeamID {
        tmp := []int{field.Teams[0].Agents[i].X - 1, field.Teams[0].Agents[i].Y - 1}
        tmpPos = append(tmpPos, tmp)
      }
    }

    checkDuplicate(true, tmpPos, agentNum, *field)
    checkDuplicate(true, tmpPos, agentNum, *field)

    for i := 0; i < agentNum; i++ {
      if field.Tiled[tmpPos[i][1]][tmpPos[i][0]] == field.Teams[1].TeamID {
        field.Tiled[tmpPos[i][1]][tmpPos[i][0]] = 0
      } else {
        field.Teams[0].Agents[i].X = tmpPos[i][0] + 1
        field.Teams[0].Agents[i].Y = tmpPos[i][1] + 1
        field.Tiled[tmpPos[i][1]][tmpPos[i][0]] = field.Teams[0].TeamID
      }
    }
  } else {
    for i := 0; i < agentNum; i++ {
      tmpPos[i][0] = field.Teams[1].Agents[i].X + action.AgentActions[i].Dx - 1
      tmpPos[i][1] = field.Teams[1].Agents[i].Y + action.AgentActions[i].Dy - 1

      if tmpPos[i][0] < 0 || field.Width <= tmpPos[i][0] {
        tmpPos[i][0] = field.Teams[1].Agents[i].X - 1
        tmpPos[i][1] = field.Teams[1].Agents[i].Y - 1
      } else if tmpPos[i][1] < 0 || field.Height <= tmpPos[i][1] {
        tmpPos[i][0] = field.Teams[1].Agents[i].X - 1
        tmpPos[i][1] = field.Teams[1].Agents[i].Y - 1
      }

      fmt.Println(tmpPos[i][0])
      fmt.Println(tmpPos[i][1])
      if field.Tiled[tmpPos[i][1]][tmpPos[i][0]] == field.Teams[0].TeamID {
        tmp := []int{field.Teams[1].Agents[i].X - 1, field.Teams[1].Agents[i].Y - 1}
        tmpPos = append(tmpPos, tmp)
      }
    }

    checkDuplicate(false, tmpPos, agentNum, *field)
    checkDuplicate(false, tmpPos, agentNum, *field)

    for i := 0; i < agentNum; i++ {
      if field.Tiled[tmpPos[i][1]][tmpPos[i][0]] == field.Teams[0].TeamID {
        field.Tiled[tmpPos[i][1]][tmpPos[i][0]] = 0
      } else {
        field.Teams[1].Agents[i].X = tmpPos[i][0] + 1
        field.Teams[1].Agents[i].Y = tmpPos[i][1] + 1
        field.Tiled[tmpPos[i][1]][tmpPos[i][0]] = field.Teams[1].TeamID
      }
    }
  }
}
