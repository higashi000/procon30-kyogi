module Kanan.sendData;

struct Actions {
  this(int agentID, string type, int dx, int dy) {
    this.agentID = agentID;
    this.type = type;
    this.dx = dx;
    this.dy = dy;
  }
  int agentID;
  string type;
  int dx;
  int dy;
}
