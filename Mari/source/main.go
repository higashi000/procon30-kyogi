package main

import (
	"fmt"
	"encoding/json"
	"io/ioutil"
	"log"
  "strconv"
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
  convertData := convertJsonToSendData()

  fmt.Println(convertData)
}

func getFieldData() {
  // サーバーにリクエスト送るやつ
  // そのうち書く
}

func sendAgentActions() {
  // エージェントの行動送るやつ
  // そのうち書く
}

func convertJsonToSendData() string {
  var fieldData FieldData

  bytes, err := ioutil.ReadFile("main.json")
  if err != nil {
    log.Fatal(err)
  }

  if err := json.Unmarshal(bytes, &fieldData); err != nil {
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
    convertData += "\n"
  }

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
    convertData += "\n"
  }

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
