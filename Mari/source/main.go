package main

import (
	"fmt"
  "net"
	"encoding/json"
	"io/ioutil"
	"log"
  "strconv"
  "net/http"
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

func main() {
  listener, err := net.Listen("tcp", "127.0.0.1:8081")

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
  fmt.Println("connect", string(rsvData[:n]))

  conn.Write([]byte(convertJsonToSendData()))
}

func requestFieldData(matchID string, port string, rsvData *[]byte) {
  proocon30RequestUrl := "http://localhost:" + port + "/matches/"  + matchID
  procon30Token := "procon30_example_token"

  req, err := http.NewRequest("GET", proocon30RequestUrl, nil)
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
  for i := 0; i < 2; i++ {
    convertData += strconv.Itoa(fieldData.Teams[i].TeamID)
    convertData += "\n"

    for j := 0; j < len(fieldData.Teams[i].Agents); j++ {
      convertData += strconv.Itoa(fieldData.Teams[i].Agents[j].AgentID)
      convertData += " "
      convertData += strconv.Itoa(fieldData.Teams[i].Agents[j].X)
      convertData += " "
      convertData += strconv.Itoa(fieldData.Teams[i].Agents[j].Y)
      convertData += "\n"
    }

    convertData += strconv.Itoa(fieldData.Teams[i].TilePoint)
    convertData += " "
    convertData += strconv.Itoa(fieldData.Teams[i].AreaPoint)
    convertData += "\n"
  }

  return convertData
}
