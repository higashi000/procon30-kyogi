module Kanan.field;

struct NowField {
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
  int maxTurn;
}

struct Field {
  import Kanan.rsvData : rsvFieldData;
  import std.conv : to;
  import std.math : abs;

  this(NowField fieldState) {
    this.fieldState = fieldState;
    this.myMoveDir[0 .. $] = 0;
  }

  this(NowField fieldState, int[] myMoveDir) {
    this.fieldState = fieldState;
    this.myMoveDir = myMoveDir;
    moveAgent;
    calcTilePoint();
    calcAreaPoint(fieldState.myTeamID);
    calcAreaPoint(fieldState.rivalTeamID);
  }

  NowField fieldState;
  int[] myMoveDir;

  // 移動方向
  immutable int[] dx = [0, -1, -1, 0, 1, 1, 1, 0, -1];
  immutable int[] dy = [0, 0, -1, -1, -1, 0, 1, 1, 1];


  // エージェントの移動 {{{
  void moveAgent()
  {
    import std.random : uniform;
    import std.stdio : writeln;
    foreach (i; 0 .. fieldState.agentNum) {
      if (fieldState.myAgentData[i][1] + dx[myMoveDir[i]] < 0 || fieldState.width <= fieldState.myAgentData[i][1] + dx[myMoveDir[i]])
        continue;
      if (fieldState.myAgentData[i][2] + dy[myMoveDir[i]] < 0 || fieldState.height <= fieldState.myAgentData[i][2] + dy[myMoveDir[i]])
        continue;
      fieldState.myAgentData[i][1] += dx[myMoveDir[i]];
      fieldState.myAgentData[i][2] += dy[myMoveDir[i]];
    }

    foreach (i; 0 .. fieldState.agentNum) {
      int moveDir = uniform(0, 9);
      if (fieldState.rivalAgentData[i][1] + dx[moveDir] < 0 || fieldState.width <= fieldState.rivalAgentData[i][1] + dx[moveDir])
        continue;
      if (fieldState.rivalAgentData[i][2] + dy[moveDir] < 0 || fieldState.height <= fieldState.rivalAgentData[i][2] + dy[moveDir])
        continue;
      fieldState.rivalAgentData[i][1] += dx[moveDir];
      fieldState.rivalAgentData[i][2] += dy[moveDir];
    }

    writeln(fieldState.myAgentData[0][1 .. $]);
  }
  // }}}

  // タイルポイント計算 {{{
  void calcTilePoint()
  {
    fieldState.myTilePoint = 0;
    fieldState.rivalTilePoint = 0;
    foreach (i; 0 .. fieldState.height) {
      foreach (j; 0 .. fieldState.width) {
        if (fieldState.color[i][j] == fieldState.myTeamID) {
          fieldState.myTilePoint += fieldState.point[i][j];
        }
        if (fieldState.color[i][j] == fieldState.rivalTeamID) {
          fieldState.rivalTilePoint += fieldState.point[i][j];
        }
      }
    }
  }
  // }}}

  // 領域ポイント計算 {{{
  void calcAreaPoint(int teamID)
  {
    int* areaPoint;
    if (teamID == fieldState.myTeamID)
      areaPoint = &fieldState.myAreaPoint;
    else if (teamID == fieldState.rivalTeamID)
      areaPoint = &fieldState.rivalAreaPoint;

    *areaPoint = 0;

    bool[][] areaFlg = new bool[][](fieldState.height, fieldState.width);
    foreach (i; 0 .. fieldState.height) {
      foreach (j; 0 .. fieldState.width) {
        areaFlg[i][j] = false;
      }
    }

    foreach (i; 1 .. fieldState.height - 1) {
      bool startArea = false;
      int startPos;
      foreach (j; 1 .. fieldState.width - 1) {
        int myTile = 0;

        for (int k = 0; k < 8; k += 2) {
          if ((fieldState.color[i + dy[k]][j + dx[k]] == teamID || areaFlg[i + dy[k]][j + dx[k]]))
            myTile += fieldState.color[i][j] != teamID ? 1 : 0;
        }

        if (myTile > 1) {
          areaFlg[i][j] = true;
          if (!startArea) {
            startArea = true;
            startPos = to!int(j);
          }
        }

        if (fieldState.color[i][j] == teamID && startArea) {
          startArea = false;
          startPos = to!int(j + 1);
        }

        if (myTile < 2 && startArea) {
          areaFlg[i][startPos .. j + 1] = false;
          startArea = false;
        }
      }
    }

    foreach_reverse (i; 1 .. fieldState.height - 1) {
      foreach_reverse (j; 1 .. fieldState.width - 1) {
        int myTile = 0;

        for (int k = 0; k < 8; k += 2) {
          if ((fieldState.color[i + dy[k]][j + dx[k]] == teamID || areaFlg[i + dy[k]][j + dx[k]]))
            myTile += fieldState.color[i][j] != teamID ? 1 : 0;
        }

        if (myTile < 4)
          areaFlg[i][j] = false;
      }
    }

    foreach (i; 0 .. fieldState.height) {
      foreach (j; 0 .. fieldState.width) {
        if (areaFlg[i][j])
          *areaPoint += abs(fieldState.point[i][j]);
      }
    }
  }
  // }}}
}
