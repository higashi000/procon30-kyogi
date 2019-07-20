module Kanan.field;


struct Field {
  import Kanan.rsvData : rsvFieldData;
  import std.conv : to;
  import std.math : abs;

  this(rsvFieldData field) {
    this.width = field.width;
    this.height = field.height;
    this.point = field.point;
    this.startedAtUnixTime = field.startedAtUnixTime;
    this.turn = field.turn;
    this.color = field.color;
    this.agentNum = field.agentNum;
    this.myTeamID = field.myTeamID;
    this.myAgentData = field.myAgentData;
    this.myAreaPoint = field.myAreaPoint;
    this.myTilePoint = field.myTilePoint;
    this.rivalTeamID = field.rivalTeamID;
    this.rivalAgentData = field.rivalAgentData;
    this.rivalTilePoint = field.rivalTilePoint;
    this.rivalAreaPoint = field.rivalAreaPoint;
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

  void calcAreaPoint(int teamID)
  {
    int* areaPoint;
    if (teamID == myTeamID)
      areaPoint = &myAreaPoint;
    else if (teamID == rivalTeamID)
      areaPoint = &rivalAreaPoint;

    *areaPoint = 0;

    bool[][] areaFlg = new bool[][](height, width);
    foreach (i; 0 .. height) {
      foreach (j; 0 .. width) {
        areaFlg[i][j] = false;
      }
    }
    int[] dx = [-1, 0, 1, 0];
    int[] dy = [0, 1, 0, -1];

    foreach (i; 1 .. height - 1) {
      bool startArea = false;
      int startPos;
      foreach (j; 1 .. width - 1) {
        int myTile = 0;

        foreach (k; 0 .. 4) {
          if ((color[i + dy[k]][j + dx[k]] == teamID || areaFlg[i + dy[k]][j + dx[k]]))
            myTile += color[i][j] != teamID ? 1 : 0;
        }

        if (myTile > 1) {
          areaFlg[i][j] = true;
          if (!startArea) {
            startArea = true;
            startPos = to!int(j);
          }
        }

        if (color[i][j] == myTeamID && startArea) {
          startArea = false;
          startPos = to!int(j + 1);
        }

        if (myTile < 2 && startArea) {
          areaFlg[i][startPos .. j + 1] = false;
          startArea = false;
        }
      }
    }

    foreach_reverse (i; 1 .. height - 1) {
      foreach_reverse (j; 1 .. width - 1) {
        int myTile = 0;
        foreach (k; 0 .. 4) {
          if ((color[i + dy[k]][j + dx[k]] == teamID || areaFlg[i + dy[k]][j + dx[k]]))
            myTile += color[i][j] != teamID ? 1 : 0;
        }

        if (myTile < 4)
          areaFlg[i][j] = false;
      }
    }

    myAreaPoint = 0;

    foreach (i; 0 .. height) {
      foreach (j; 0 .. width) {
        if (areaFlg[i][j])
          *areaPoint += abs(point[i][j]);
      }
    }
  }
}
