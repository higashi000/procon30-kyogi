module Kanan.field;

struct Field {
  import Kanan.rsvData : rsvFieldData;
  import std.conv : to;
  import std.math : abs;
  import std.stdio : writeln;
  import std.algorithm : copy;

  this(Field field, int[] myMoveDir) {
    this.myMoveDir = new int[myMoveDir.length];
    foreach (i; 0 .. myMoveDir.length) {
      this.myMoveDir[i] = myMoveDir[i];
    }
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
    myAgentData = new int[][](this.agentNum, 3);
    foreach (i; 0 .. agentNum) {
      this.myAgentData[i][0] = field.myAgentData[i][0];
      this.myAgentData[i][1] = field.myAgentData[i][1];
      this.myAgentData[i][2] = field.myAgentData[i][2];
    }
    rivalAgentData = new int[][](this.agentNum, 3);
    foreach (i; 0 .. agentNum) {
      this.rivalAgentData[i][0] = field.rivalAgentData[i][0];
      this.rivalAgentData[i][1] = field.rivalAgentData[i][1];
      this.rivalAgentData[i][2] = field.rivalAgentData[i][2];
    }
    this.rivalTeamID = field.rivalTeamID;

    moveAgent();
    calcTilePoint();
    calcAreaPoint(myTeamID);
    calcAreaPoint(rivalTeamID);
  }

  this(Field field) {
    this.width = field.width;
    this.height = field.height;
    this.point = field.point;
    this.startedAtUnixTime = field.startedAtUnixTime;
    this.color = new int[][](height, width);
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

  // 移動方向
  immutable int[] dx = [0, -1, -1, 0, 1, 1, 1, 0, -1];
  immutable int[] dy = [0, 0, -1, -1, -1, 0, 1, 1, 1];


// エージェントの移動 {{{
  void moveAgent()
  {
    import std.random : uniform;
    import std.stdio : writeln;
    int[][] tmpAgentPos = new int[][](agentNum * 2, 2);

    // 現時点での移動先設定
    foreach (i; 0 .. agentNum) {
      // 自分のエージェント
      tmpAgentPos[i][0] = myAgentData[i][1] + dx[myMoveDir[i]];
      tmpAgentPos[i][1] = myAgentData[i][2] + dy[myMoveDir[i]];
      if (color[tmpAgentPos[i][1]][tmpAgentPos[i][0]] == rivalTeamID) {
        int[] tmp = [myAgentData[i][1], myAgentData[i][2]];
        tmpAgentPos ~= tmp;
      }
      // 相手のエージェント
      tmpAgentPos[i + agentNum][0] = rivalAgentData[i][1] + dx[uniform(0, 9)];
      tmpAgentPos[i + agentNum][1] = rivalAgentData[i][2] + dx[uniform(0, 9)];
      if (color[tmpAgentPos[i + agentNum][1]][tmpAgentPos[i + agentNum][0]] == myTeamID) {
        int[] tmp = [rivalAgentData[i][1], rivalAgentData[i][2]];
        tmpAgentPos ~= tmp;
      }
    }

    checkDuplicate(true, tmpAgentPos);
    checkDuplicate(true, tmpAgentPos);
    checkDuplicate(false, tmpAgentPos);
    checkDuplicate(false, tmpAgentPos);

// エージェントがフィルード外に行かないようにする --- {{{
    foreach (i; 0 .. agentNum) {
      if ((tmpAgentPos[i][0] < 0) || (width <= tmpAgentPos[i][0])) {
        tmpAgentPos[i][0] = myAgentData[i][1];
        tmpAgentPos[i][1] = myAgentData[i][2];
      } else if ((tmpAgentPos[i][1] < 0) || (height <= tmpAgentPos[i][1])) {
        tmpAgentPos[i][0] = myAgentData[i][1];
        tmpAgentPos[i][1] = myAgentData[i][2];
      }
    }
    foreach (i; agentNum .. agentNum * 2) {
      if ((tmpAgentPos[i][0] < 0) || (width <= tmpAgentPos[i][0])) {
        tmpAgentPos[i][0] = rivalAgentData[i - agentNum][1];
        tmpAgentPos[i][1] = rivalAgentData[i - agentNum][2];
      } else if ((tmpAgentPos[i][1] < 0) || (height <= tmpAgentPos[i][1])) {
        tmpAgentPos[i][0] = rivalAgentData[i - agentNum][1];
        tmpAgentPos[i][1] = rivalAgentData[i - agentNum][2];
      }
    }
// }}}

    foreach (i; 0 .. agentNum) {
      if (color[tmpAgentPos[i][1]][tmpAgentPos[i][0]] == rivalTeamID) {
        color[tmpAgentPos[i][1]][tmpAgentPos[i][0]] = 0;
      } else {
        myAgentData[i][1] = tmpAgentPos[i][0];
        myAgentData[i][2] = tmpAgentPos[i][1];
        color[myAgentData[i][2]][myAgentData[i][1]] = myTeamID;
      }
    }
    foreach (i; 0 .. agentNum) {
      if (color[tmpAgentPos[i + agentNum][1]][tmpAgentPos[i + agentNum][0]] == myTeamID) {
        color[tmpAgentPos[i + agentNum][1]][tmpAgentPos[i + agentNum][0]] = 0;
      } else {
        rivalAgentData[i][1] = tmpAgentPos[i + agentNum][0];
        rivalAgentData[i][2] = tmpAgentPos[i + agentNum][1];
        color[rivalAgentData[i][2]][rivalAgentData[i][1]] = rivalTeamID;
      }
    }
  }

  // 移動先の重複確認
  // 重複があった場合は元の場所に戻す
  void checkDuplicate(bool whichTeam, ref int[][] tmpAgentPos) {
    if (whichTeam) {
      foreach (i; 0 .. agentNum) {
        foreach (j; 0 .. tmpAgentPos.length) {
          if (i != j && tmpAgentPos[i] == tmpAgentPos[j]) {
            tmpAgentPos[i][0] = myAgentData[i][1];
            tmpAgentPos[i][1] = myAgentData[i][2];

            if (j < agentNum) {
              tmpAgentPos[j][0] = myAgentData[j][1];
              tmpAgentPos[j][1] = myAgentData[j][2];
            } else if (agentNum <= j && j < agentNum * 2){
              tmpAgentPos[j][0] = rivalAgentData[j - agentNum][1];
              tmpAgentPos[j][1] = rivalAgentData[j - agentNum][2];
            }
          }
        }
      }
    } else {
      foreach (i; 0 .. agentNum) {
        foreach (j; 0 .. tmpAgentPos.length) {
          int nowTmpPos = i + agentNum;
          if ((nowTmpPos != j) && (tmpAgentPos[nowTmpPos] == tmpAgentPos[j])) {
            tmpAgentPos[nowTmpPos][0] = rivalAgentData[i][1];
            tmpAgentPos[nowTmpPos][1] = rivalAgentData[i][2];

            if (j < agentNum) {
              tmpAgentPos[j][0] = myAgentData[j][1];
              tmpAgentPos[j][1] = myAgentData[j][2];
            } else if (agentNum <= j && j < agentNum * 2){
              tmpAgentPos[j][0] = rivalAgentData[j - agentNum][1];
              tmpAgentPos[j][1] = rivalAgentData[j - agentNum][2];
            }
          }
        }
      }
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
    int areaPoint;
    areaPoint = 0;

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
          areaPoint += abs(point[i][j]);
      }
    }
    if (teamID == myTeamID)
      myAreaPoint = areaPoint;
    else if (teamID == rivalTeamID)
      rivalAreaPoint = areaPoint;
  }
  // }}}
  //}}}
}
