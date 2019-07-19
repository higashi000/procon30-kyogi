module Kanan.field;

import Kanan.rsvData;

struct Field {
  this(rsvFieldData field) {
  }

  public {
    int width;
    int height;
    int[][] point;
    int startedAtUnixTime;
    int turn;
    int[][] color;
    int agentNum;
    int myTeamID;
    int[][] myAgentData;
    int myTilePoint;
    int myAreaPoint;
    int rivalTeamID;
    int[][] rivalAgentData;
    int rivalTilePoint;
    int rivalAreaPoint;
  }

  void calcTilePoint()
  {
    myTilePoint = 0;
    rivalTilePoint = 0;
    foreach (i; 0 .. height) {
      foreach (j; 0 .. width) {
        if (color[i][j] == myTeamID) {
          myTilePoint += point[i][j];
        }
        if (color[i][j] == rivalTeamID) {
          rivalTilePoint += point[i][j];
        }
      }
    }
  }

  void calcAreaPoint()
  {

  }
}
