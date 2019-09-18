package main

import (
  "github.com/gin-gonic/gin"
  "fmt"
  "io/ioutil"
  "log"
  "encoding/json"
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

func main() {
  r := gin.Default()
  field := getFieldData()
  fmt.Println(field)
  sendFieldData(r, field)
  rsvActionData(r)
  r.Run()
}

// フィールドデータの返却
func sendFieldData(r *gin.Engine, field FieldData) {
  r.GET("/matches/:id", func(c *gin.Context) {
      c.JSON(200, field)
      })
}

func rsvActionData(r *gin.Engine) {
  var actions Actions
  r.POST("/matches/:id/action", func(c *gin.Context) {
      c.BindJSON(&actions)
      log.Print(actions)
  })
}

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
