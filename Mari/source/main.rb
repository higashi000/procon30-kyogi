require 'json'
require 'msgpack/rpc'

connectGUI = MessagePack::RPC::Client.new('127.0.0.1', 12345)

#connectGUI.call(:getMariData, fieldColor, myAgentData, rivalAgentData)


def getJsonData
  jsonData = open("main.json") do |i|
    JSON.load(i)
  end

  return jsonData
end

def takeOutJsonData(jsonData)
  # 各データを格納する構造体
  fieldData = Struct.new(:fieldX, :fieldY, :fieldPoint, :fieldColor, :myTeamID, :myAgentData, :rivalAgentData)
  afterTakeOut = fieldData.new()

  # フィールドのサイズ取り出し
  afterTakeOut.fieldX = jsonData["width"]
  afterTakeOut.fieldY = jsonData["height"]
  # フィールドの色，ポイントの取り出し
  afterTakeOut.fieldPoint = jsonData["points"]
  afterTakeOut.fieldColor = jsonData["tiled"]
  # 自チームのID取り出し
  afterTakeOut.myTeamID = jsonData["teams"][0]["teamID"]

  afterTakeOut.myAgentData = []
  afterTakeOut.rivalAgentData = []

  # エージェントの座標とID取り出し
  jsonData["teams"][0]["agents"].size.times do |i|
    afterTakeOut.myAgentData.push([])
    afterTakeOut.rivalAgentData.push([])
    jsonData["teams"][0]["agents"][i].each_value do |j|
      afterTakeOut.myAgentData[i].push(j)
    end
    jsonData["teams"][1]["agents"][i].each_value do |j|
      afterTakeOut.rivalAgentData[i].push(j)
    end

  end
  return afterTakeOut
end


jsonData = getJsonData()
afterTakeOut = takeOutJsonData(jsonData)
