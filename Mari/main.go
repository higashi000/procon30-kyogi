package main

import (
	"fmt"
  "net"
  "bytes"
	"encoding/json"
	"io/ioutil"
	"log"
  "strconv"
  "net/http"
  "strings"
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

type Actions struct {
  AgentID int `json:"agentID"`
  MovePattern string `json:"type"`
  Dx int `json:"dx"`
  Dy int `json:"dy"`
}

var myTeamID int
var maxTurn string

func main() {
  flag.Parse()
  args := flag.Args()

  myTeamID, _ = strconv.Atoi(args[2])
  maxTurn = args[3]
  serverAddress := args[0] + ":" + args[1]

  fmt.Println(serverAddress)

  listener, err := net.Listen("tcp", serverAddress)

  if err != nil {
    fmt.Println("error")
    return
  }
  defer listener.Close()

  for {
    connectClient(listener)
    go connectClient(listener)
  }
}

func connectClient(listener net.Listener) {
  conn, err := listener.Accept()

  if err != nil {
    fmt.Println("error")
    return
  }
  defer conn.Close()

  rsvData := make([]byte, 4018)
  n, err := conn.Read(rsvData)
  if err != nil {
    fmt.Println("error")
  }
  switch string(rsvData[0]) {
    case "1" :
      conn.Write([]byte(convertJsonToSendData()))
    case "2" :
      sendResultData(conn, "8080", "1", string(rsvData[2:n]))
  }
}

func sendResultData(conn net.Conn, port string, matchID string, rsvData string) {

  parseData := strings.Split(rsvData, ";")

  sendMoveInform := `{"actions":[`
  for i := 0; i < len(parseData) - 1; i++ {
    agentData := strings.Split(parseData[i], " ")
    sendMoveInform += `{"agentID":` + agentData[0] + "," + `"dx":` + agentData[2] + "," + `"dy":` + agentData[3] + "," + `"type":` + `"` + agentData[1] + `"` + "}"
    if i < len(parseData) - 2 {
      sendMoveInform += ","
    }
  }
  sendMoveInform += `]}`

  procon30RequestUrl := "http://localhost:" + port + "/matches/"  + matchID + "/action"
  procon30Token := "procon30_example_token"

  req, err := http.NewRequest(
    "POST",
    procon30RequestUrl,
    bytes.NewBuffer([]byte(sendMoveInform)),
  )
  if err != nil {
    fmt.Println("error")
    return
  }
  req.Header.Set("Authorization", procon30Token)
  req.Header.Set("Content-Type", "application/json")

  client := &http.Client{}
  resp, err := client.Do(req)

  fmt.Println(resp);

  defer resp.Body.Close()
}

func requestFieldData(matchID string, port string, rsvData *[]byte) {
  procon30RequestUrl := "http://localhost:" + port + "/matches/"  + matchID
  procon30Token := "procon30_example_token"

  req, err := http.NewRequest("GET", procon30RequestUrl, nil)
  if err != nil {
    fmt.Println("error")
    return
  }
  req.Header.Set("Authorization", procon30Token)

  client := new(http.Client)
  resp, err := client.Do(req)
  defer resp.Body.Close()

  rsvFieldData, _ := ioutil.ReadAll(resp.Body)

  *rsvData = rsvFieldData
}

func sendAgentActions() {
  // エージェントの行動送るやつ
  // そのうち書く
}

// JsonをsolverとGUIに送るために変換
func convertJsonToSendData() string {
  var fieldData FieldData

  var rsvData []byte

  requestFieldData("1", "8080", &rsvData)

  if err := json.Unmarshal(rsvData, &fieldData); err != nil {
    log.Fatal(err)
  }

  var convertData string

  convertData += strconv.Itoa(fieldData.Width)
  convertData += " "

  convertData += strconv.Itoa(fieldData.Height)
  convertData += "\n"

  for i := 0; i < fieldData.Height; i++ {
    for j := 0; j < fieldData.Width; j++ {
      convertData += strconv.Itoa(fieldData.Points[i][j])
      if j != fieldData.Width - 1 {
        convertData += " "
      }
    }
    convertData += ";"
  }
  convertData += "\n"

  convertData += strconv.Itoa(fieldData.StartedAtUnixTime)
  convertData += "\n"

  convertData += strconv.Itoa(fieldData.Turn)
  convertData += "\n"

  for i := 0; i < fieldData.Height; i++ {
    for j := 0; j < fieldData.Width; j++ {
      convertData += strconv.Itoa(fieldData.Tiled[i][j])
      if j != fieldData.Width - 1 {
        convertData += " "
      }
    }
    convertData += ";"
  }
  convertData += "\n"

  convertData += strconv.Itoa(len(fieldData.Teams[0].Agents))
  convertData += "\n"

  if fieldData.Teams[0].TeamID == myTeamID {
    for i := 0; i < 2; i++ {
      convertData += strconv.Itoa(fieldData.Teams[i].TeamID)
      convertData += "\n"

      for j := 0; j < len(fieldData.Teams[i].Agents); j++ {
        convertData += strconv.Itoa(fieldData.Teams[i].Agents[j].AgentID)
        convertData += " "
        convertData += strconv.Itoa(fieldData.Teams[i].Agents[j].X)
        convertData += " "
        convertData += strconv.Itoa(fieldData.Teams[i].Agents[j].Y)
        convertData += ";"
      }
      convertData += "\n"

      convertData += strconv.Itoa(fieldData.Teams[i].TilePoint)
      convertData += " "
      convertData += strconv.Itoa(fieldData.Teams[i].AreaPoint)
      convertData += "\n"
    }
  } else {
    for i := 1; i >= 0; i-- {
      convertData += strconv.Itoa(fieldData.Teams[i].TeamID)
      convertData += "\n"

      for j := 0; j < len(fieldData.Teams[i].Agents); j++ {
        convertData += strconv.Itoa(fieldData.Teams[i].Agents[j].AgentID)
        convertData += " "
        convertData += strconv.Itoa(fieldData.Teams[i].Agents[j].X)
        convertData += " "
        convertData += strconv.Itoa(fieldData.Teams[i].Agents[j].Y)
        convertData += ";"
      }
      convertData += "\n"

      convertData += strconv.Itoa(fieldData.Teams[i].TilePoint)
      convertData += " "
      convertData += strconv.Itoa(fieldData.Teams[i].AreaPoint)
      convertData += "\n"
    }
  }
  convertData += maxTurn + "\n"

  return convertData
}
