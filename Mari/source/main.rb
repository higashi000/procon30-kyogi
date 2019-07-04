require 'json'
require 'msgpack/rpc'

jsonData = open("main.json") do |i|
  JSON.load(i)
end

connectGUI = MessagePack::RPC::Client.new('localhost', 8080)

fieldX = jsonData["width"]
fieldY = jsonData["height"]
fieldPoint = jsonData["points"]
fieldColor = jsonData["tiled"]

myTeamID = jsonData["teams"][0]["teamID"]
#myAgentData = jsonData["teams"][0]["agents"][0]

myAgentData = []
rivalAgentData = []

jsonData["teams"][0]["agents"].size.times do |i|
  myAgentData.push([])
  jsonData["teams"][0]["agents"][i].each_value do |j|
    myAgentData[i].push(j)
  end
end

jsonData["teams"][1]["agents"].size.times do |i|
  rivalAgentData.push([])
  jsonData["teams"][1]["agents"][i].each_value do |j|
    rivalAgentData[i].push(j)
  end
end


p myAgentData
p rivalAgentData
