module Kanan.connector;

import Kanan.rsvData;
import std.socket;
import std.conv;
import std.stdio;

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

    write(rsvFieldData);

    socket.close();
  }

}
