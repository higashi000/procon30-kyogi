module Kanan.field;

import std.stdio;


class Field {
  import Kanan.tile;
  import Kanan.color;
  import Kanan.agent;

  this(long fieldLenX, long fieldLenY, int agentNum, uint myTeamID, uint rivalTeamID) {
    this.fieldLenX = fieldLenX;
    this.fieldLenY = fieldLenY;
    this.agentNum = agentNum;
    this.myTeamID = myTeamID;
    this.rivalTeamID = rivalTeamID;
  }

  this() {
    this.fieldLenX = 0;
    this.fieldLenY = 0;
    this.agentNum = 0;
  }

  public {
    long fieldLenX;
    long fieldLenY;
    uint agentNum;
    uint myTeamID;
    uint rivalTeamID;
    uint[][] myAgentData;
    uint[][] rivalAgentData;
    Tile[][] tiles;
  }

  void initField(int[][] tilePoint, int[][] fieldColor, int[][] myAgentPosID, int[][] rivalAgentPosID)
  {
    foreach (i; 0 .. fieldLenY) {
      foreach (j; 0 .. fieldLenX) {
        tiles[i][j].tilePoint = tilePoint[i][j];
        setColor(tiles[i][j], fieldColor[i][j]);
      }
    }

    foreach (i; 0 .. agentNum) {
      tiles[myAgentPosID[i][1]][myAgentPosID[i][0]].agent = Agent.Red;
      tiles[rivalAgentPosID[i][1]][rivalAgentPosID[i][0]].agent = Agent.Blue;

      foreach (j; 0 .. 3) {
        myAgentData[i][j] = myAgentPosID[i][j];
        rivalAgentData[i][j] = rivalAgentPosID[i][j];
      }
    }
  }

  void setColor(ref Tile tile, int color)
  {
    if (color != 0) {
      tile.color = (color == myTeamID ? Color.Red : Color.Blue);
    } else {
      tile.color = Color.White;
    }
  }

  void setAgentDataLen()
  {
    uint len = 3;
    myAgentData = new uint[][](agentNum, len);
    rivalAgentData = new uint[][](agentNum, len);
  }

  void setFieldLen()
  {
    tiles = new Tile[][](fieldLenY, fieldLenX);
  }
}
