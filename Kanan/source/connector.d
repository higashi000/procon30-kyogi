module Kanan.connector;

import Kanan.rsvData;
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

    socket.send("Solver");

    ubyte[4018] rsvData;
    ulong size = socket.receive(rsvData);

    if (size > 0) {
      rsvFieldData = cast(string)rsvData[0 .. size];
    }

    socket.close();
  }

  rsvMariData parseFieldData(int myTeamID)
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

    writeln(parseRsvData);
    return parseRsvData;
  }
}
