module Kanan.field;

struct Field {
  import Kanan.rsvData : rsvFieldData;
  import std.conv : to;
  import std.math : abs;
  import std.stdio : writeln;
  import std.algorithm : copy;

  this(Field field, int[] myMoveDir, bool whichTeam) {
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
    this.moveType = new string[field.agentNum];

//   moveAgent(myMoveDir, whichTeam);
    calcTilePoint();
    calcMyAreaPoint();
    calcRivalAreaPoint();
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
    this.moveType = new string[field.agentNum];

    calcTilePoint();
    calcMyAreaPoint();
    calcRivalAreaPoint();
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
  bool[][] myAreaPointFlg;
  bool[][] rivalAreaPointFlg;
  string[] moveType;

  // 移動方向
  int[] dx = [0, -1, -1, 0, 1, 1, 1, 0, -1];
  int[] dy = [0, 0, -1, -1, -1, 0, 1, 1, 1];


// エージェントの移動 {{{
  void moveAgent(int[] dir, bool whichTeam)
  {
    if (whichTeam) {
      int[][] tmpAgentPos = new int[][](agentNum, 2);

      foreach (i; 0 .. agentNum) {
        tmpAgentPos[i][0] = myAgentData[i][1] + dx[dir[i]];
        tmpAgentPos[i][1] = myAgentData[i][2] + dy[dir[i]];

        if (tmpAgentPos[i][0] < 0 || width <= tmpAgentPos[i][0]) {
          tmpAgentPos[i][0] = myAgentData[i][1];
          tmpAgentPos[i][1] = myAgentData[i][2];
        } else if (tmpAgentPos[i][1] < 0 || height <= tmpAgentPos[i][1]) {
          tmpAgentPos[i][0] = myAgentData[i][1];
          tmpAgentPos[i][1] = myAgentData[i][2];
        }

        if (color[tmpAgentPos[i][1]][tmpAgentPos[i][0]] == rivalTeamID)
          tmpAgentPos ~= [myAgentData[i][1], myAgentData[i][2]];
      }

      checkDuplicate(true, tmpAgentPos);
      checkDuplicate(true, tmpAgentPos);

      foreach (i; 0 .. agentNum) {
        if (color[tmpAgentPos[i][1]][tmpAgentPos[i][0]] == rivalTeamID) {
          moveType[i] = "remove";
        } else {
          moveType[i] = "move";
        }
      }

      foreach (i; 0 .. agentNum) {
        if (color[tmpAgentPos[i][1]][tmpAgentPos[i][0]] == rivalTeamID) {
          color[tmpAgentPos[i][1]][tmpAgentPos[i][0]] = 0;
        } else {
          myAgentData[i][1] = tmpAgentPos[i][0];
          myAgentData[i][2] = tmpAgentPos[i][1];
          color[myAgentData[i][2]][myAgentData[i][1]] = myTeamID;
        }
      }
    } else {
      int[][] tmpAgentPos = new int[][](agentNum, 2);

      foreach (i; 0 .. agentNum) {
        tmpAgentPos[i][0] = rivalAgentData[i][1] + dx[dir[i]];
        tmpAgentPos[i][1] = rivalAgentData[i][2] + dy[dir[i]];

        if (tmpAgentPos[i][0] < 0 || width <= tmpAgentPos[i][0]) {
          tmpAgentPos[i][0] = myAgentData[i][1];
          tmpAgentPos[i][1] = myAgentData[i][2];
        } else if (tmpAgentPos[i][1] < 0 || height <= tmpAgentPos[i][1]) {
          tmpAgentPos[i][0] = myAgentData[i][1];
          tmpAgentPos[i][1] = myAgentData[i][2];
        }

        if (color[tmpAgentPos[i][1]][tmpAgentPos[i][0]] == myTeamID)
          tmpAgentPos ~= [rivalAgentData[i][1], rivalAgentData[i][2]];
      }

      checkDuplicate(false, tmpAgentPos);
      checkDuplicate(false, tmpAgentPos);

      foreach (i; 0 .. agentNum) {
        if (color[tmpAgentPos[i][1]][tmpAgentPos[i][0]] == myTeamID) {
          color[tmpAgentPos[i][1]][tmpAgentPos[i][0]] = 0;
        } else {
          rivalAgentData[i][1] = tmpAgentPos[i][0];
          rivalAgentData[i][2] = tmpAgentPos[i][1];
          color[rivalAgentData[i][2]][rivalAgentData[i][1]] = rivalTeamID;
        }
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
            }
          }
        }
      }
    } else {
      foreach (i; 0 .. agentNum) {
        foreach (j; 0 .. tmpAgentPos.length) {
          if ((i != j) && (tmpAgentPos[i] == tmpAgentPos[j])) {
            tmpAgentPos[i][0] = rivalAgentData[i][1];
            tmpAgentPos[i][1] = rivalAgentData[i][2];

            if (j < agentNum) {
              tmpAgentPos[j][0] = rivalAgentData[j][1];
              tmpAgentPos[j][1] = rivalAgentData[j][2];
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
  void calcMyAreaPoint()
  {
    int areaPoint;
    int teamID = myTeamID;

    myAreaPointFlg = new bool[][](height, width);

    foreach (i; 0 .. height) {
      foreach (j; 0 .. width) {
        myAreaPointFlg[i][j] = false;
      }
    }

    foreach (i; 1 .. height - 1) {
      bool startArea = false;
      int startPos;
      foreach (j; 1 .. width - 1) {
        int myTile = 0;

        for (int k = 1; k < 9; k += 2) {
          if ((color[i + dy[k]][j + dx[k]] == teamID || myAreaPointFlg[i + dy[k]][j + dx[k]]))
            myTile += color[i][j] != teamID ? 1 : 0;
        }

        if (myTile > 1) {
          myAreaPointFlg[i][j] = true;
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
          myAreaPointFlg[i][startPos .. j + 1] = false;
          startArea = false;
        }
      }
    }

    foreach_reverse (i; 1 .. height - 1) {
      foreach_reverse (j; 1 .. width - 1) {
        int myTile = 0;

        for (int k = 1; k < 9; k += 2) {
          if ((color[i + dy[k]][j + dx[k]] == teamID || myAreaPointFlg[i + dy[k]][j + dx[k]]))
            myTile += color[i][j] != teamID ? 1 : 0;
        }

        if (myTile < 4)
          myAreaPointFlg[i][j] = false;
      }
    }

    foreach (i; 0 .. height) {
      foreach (j; 0 .. width) {
        if (myAreaPointFlg[i][j])
          areaPoint += abs(point[i][j]);
      }
    }
    myAreaPoint = areaPoint;
  }

  void calcRivalAreaPoint()
  {
    int areaPoint;
    int teamID = rivalTeamID;

    rivalAreaPointFlg = new bool[][](height, width);

    foreach (i; 0 .. height) {
      foreach (j; 0 .. width) {
        rivalAreaPointFlg[i][j] = false;
      }
    }

    foreach (i; 1 .. height - 1) {
      bool startArea = false;
      int startPos;
      foreach (j; 1 .. width - 1) {
        int myTile = 0;

        for (int k = 1; k < 9; k += 2) {
          if ((color[i + dy[k]][j + dx[k]] == teamID || rivalAreaPointFlg[i + dy[k]][j + dx[k]]))
            myTile += color[i][j] != teamID ? 1 : 0;
        }

        if (myTile > 1) {
          rivalAreaPointFlg[i][j] = true;
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
          rivalAreaPointFlg[i][startPos .. j + 1] = false;
          startArea = false;
        }
      }
    }

    foreach_reverse (i; 1 .. height - 1) {
      foreach_reverse (j; 1 .. width - 1) {
        int myTile = 0;

        for (int k = 1; k < 9; k += 2) {
          if ((color[i + dy[k]][j + dx[k]] == teamID || rivalAreaPointFlg[i + dy[k]][j + dx[k]]))
            myTile += color[i][j] != teamID ? 1 : 0;
        }

        if (myTile < 4)
          rivalAreaPointFlg[i][j] = false;
      }
    }

    foreach (i; 0 .. height) {
      foreach (j; 0 .. width) {
        if (rivalAreaPointFlg[i][j])
          areaPoint += abs(point[i][j]);
      }
    }
    rivalAreaPoint = areaPoint;
  }

  // }}}
  //}}}
}
