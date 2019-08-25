module Kanan.field;

struct Field {
  import Kanan.rsvData : rsvFieldData;
  import std.conv : to;
  import std.math : abs;
  import std.stdio : writeln;
  import std.algorithm : copy;

  this(Field field, int[] myMoveDir, int num) {
    this.myMoveDir = myMoveDir;
    this.width = field.width;
    this.height = field.height;
    this.point = field.point;
    this.startedAtUnixTime = field.startedAtUnixTime;
    color = new int[][](this.height, this.width);
    foreach (i; 0 .. height) {
      foreach (j; 0 .. width) {
        this.color[i][j] = field.color[i][j];
      }
    }
    this.agentNum = field.agentNum;
    this.myTeamID = field.myTeamID;
    this.myAgentData = field.myAgentData;
    this.rivalTeamID = field.rivalTeamID;
    this.rivalAgentData = field.rivalAgentData;
    this.num = num;

    calcTilePoint();
    calcAreaPoint(myTeamID);
    calcAreaPoint(rivalTeamID);
  }

  this(Field field) {
    this.width = field.width;
    this.height = field.height;
    this.point = field.point;
    this.startedAtUnixTime = field.startedAtUnixTime;
    this.color = field.color;
    this.agentNum = field.agentNum;
    this.myTeamID = field.myTeamID;
    this.myAgentData = field.myAgentData;
    this.rivalTeamID = field.rivalTeamID;
    this.rivalAgentData = field.rivalAgentData;

    calcTilePoint();
    calcAreaPoint(myTeamID);
    calcAreaPoint(rivalTeamID);
  }

  int[] myMoveDir;
  int width;
  int height;
  int[][] point;
  int startedAtUnixTime;
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
  int maxTurn;
  int turn;
  int num;

  // 移動方向
  immutable int[] dx = [0, -1, -1, 0, 1, 1, 1, 0, -1];
  immutable int[] dy = [0, 0, -1, -1, -1, 0, 1, 1, 1];


  // エージェントの移動 {{{
  void moveAgent()
  {
    import std.random : uniform;
    import std.stdio : writeln;

    switch (uniform(0, 2)) {
      case 0:
        color[uniform(0, height)][uniform(0, width)] = myTeamID;
        break;
      case 1:
        color[uniform(0, height)][uniform(0, width)] = rivalTeamID;
        break;
      default:
    }
  }
  // }}}

  // ポイント関係 --- {{{
  // タイルポイント計算 {{{
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
  // }}}
  // 領域ポイント計算 {{{
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

    foreach (i; 1 .. height - 1) {
      bool startArea = false;
      int startPos;
      foreach (j; 1 .. width - 1) {
        int myTile = 0;

        for (int k = 0; k < 8; k += 2) {
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

        if (color[i][j] == teamID && startArea) {
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

        for (int k = 0; k < 8; k += 2) {
          if ((color[i + dy[k]][j + dx[k]] == teamID || areaFlg[i + dy[k]][j + dx[k]]))
            myTile += color[i][j] != teamID ? 1 : 0;
        }

        if (myTile < 4)
          areaFlg[i][j] = false;
      }
    }

    foreach (i; 0 .. height) {
      foreach (j; 0 .. width) {
        if (areaFlg[i][j])
          *areaPoint += abs(point[i][j]);
      }
    }
  }
  // }}}
  //}}}
}
