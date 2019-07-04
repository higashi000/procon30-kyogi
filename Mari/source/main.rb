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
myAgentData = jsonData["teams"][0]["agents"][0].to_a
rivalAgentData = jsonData["teams"][1]["agents"]
