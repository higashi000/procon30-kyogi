module Kanan.connector;

import Kanan.rsvData;
import Kanan.sendData;
import std.socket;
import std.conv;
import std.stdio;
import std.string : split;

class KananConnector {

  this(string ip, ushort port) {
    this.ip = ip;
    this.port = port;
  }

  this() {
    this.ip = "127.0.0.1";
    this.port = 8080;
  }

  private {
    string rsvFieldData;
    string ip;
    ushort port;
  }

  void getFieldData()
  {
    auto socket = new TcpSocket(new InternetAddress(ip, port));

    socket.send("1");

    ubyte[4018] rsvData;
    ulong size = socket.receive(rsvData);

    if (size > 0) {
      rsvFieldData = cast(string)rsvData[0 .. size];
    }

    writeln(rsvFieldData);

    socket.close();
  }

  void sendResult(Actions[] agentData)
  {
    auto socket = new TcpSocket(new InternetAddress(ip, port));

    socket.send("2");

    string sendData;

    foreach (i; 0 .. agentData.length) {
      sendData ~= agentData[i].agentID.to!string;
      sendData ~= " ";
      sendData ~= agentData[i].type;
      sendData ~= " ";
      sendData ~= agentData[i].dx.to!string;
      sendData ~= " ";
      sendData ~= agentData[i].dy.to!string;
      sendData ~= ";";
    }

    socket.send(sendData);
  }

  rsvMariData parseFieldData()
  {
    rsvMariData parseRsvData;
    auto parseData = rsvFieldData.split("\n");
    int dataPos = 0;

    rsvFieldData.writeln;

    parseRsvData.width = (parseData[0].split(" "))[0].to!int;
    parseRsvData.height = (parseData[0].split(" "))[1].to!int;

    parseRsvData.point = new int[][](parseRsvData.height, parseRsvData.width);
    foreach (i; 0 .. parseRsvData.height) {
      auto line = (parseData[1].split(";"))[i];
      foreach (j; 0 .. parseRsvData.width) {
        parseRsvData.point[i][j] = (line.split(" "))[j].to!int;
      }
    }

    parseRsvData.startedAtUnixTime = parseData[2].to!int;
    parseRsvData.turn = parseData[3].to!int;

    parseRsvData.color = new int[][](parseRsvData.height, parseRsvData.width);
    foreach (i; 0 .. parseRsvData.height) {
      auto line = (parseData[4].split(";"))[i];
      foreach (j; 0 .. parseRsvData.width) {
        parseRsvData.color[i][j] = (line.split(" "))[j].to!int;
      }
    }

    parseRsvData.agentNum = parseData[5].to!int;
    parseRsvData.myTeamID = parseData[6].to!int;
    parseRsvData.myAgentData = new int[][](parseRsvData.agentNum, 3);
    foreach (i; 0 .. parseRsvData.agentNum) {
      auto agentData = (parseData[7].split(";"))[i];
      parseRsvData.myAgentData[i][0] = (agentData.split)[0].to!int;
      parseRsvData.myAgentData[i][1] = (agentData.split)[1].to!int;
      parseRsvData.myAgentData[i][2] = (agentData.split)[2].to!int;
    }
    parseRsvData.myTilePoint = (parseData[8].split)[0].to!int;
    parseRsvData.myAreaPoint = (parseData[8].split)[1].to!int;

    parseRsvData.rivalTeamID = parseData[9].to!int;
    parseRsvData.rivalAgentData = new int[][](parseRsvData.agentNum, 3);
    foreach (i; 0 .. parseRsvData.agentNum) {
      auto agentData = (parseData[10].split(";"))[i];
      parseRsvData.rivalAgentData[i][0] = (agentData.split)[0].to!int;
      parseRsvData.rivalAgentData[i][1] = (agentData.split)[1].to!int;
      parseRsvData.rivalAgentData[i][2] = (agentData.split)[2].to!int;
    }
    parseRsvData.rivalTilePoint = (parseData[11].split)[0].to!int;
    parseRsvData.rivalAreaPoint = (parseData[11].split)[1].to!int;


    writeln(parseRsvData);
    return parseRsvData;
  }
}
