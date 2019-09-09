module Kanan.beamSearch;

import std.stdio, std.range, std.algorithm, std.array, std.string, std.math, std.conv,
       std.container, std.bigint, std.ascii, std.typecons, std.format;
import core.thread;
import Kanan.field;

alias S = Array!(Node*);

struct Node {
  import std.random : uniform;
  import Kanan.dispField;
  this(Field field, uint turn, int[] myMoveDir, int[] originMoveDir) {
    this.field = Field(field, myMoveDir);
    this.turn = turn;
    this.evalValue = 0;
    this.originMoveDir = new int[originMoveDir.length];
    foreach (i; 0 .. originMoveDir.length) {
      this.originMoveDir[i] = originMoveDir[i];
    }
  }

  this(Field field, uint turn) {
    this.field = Field(field);
    this.turn = turn;
    this.evalValue = 0;
  }

  S childNodes;
  int[] originMoveDir;

  int evalValue;
  uint turn;
  Field field;

  S getNextNodes(int originalTurn) {
    S ret;

    if (originalTurn == turn) {
      switch (field.agentNum) {
        case 2:
          ret ~= nextNode2(true);
          break;
        case 3:
          ret ~= nextNode3(true);
          break;
        case 4:
          ret ~= nextNode4(true);
          break;
        case 5:
          ret ~= nextNode5(true);
          break;
          // エージェントの人数が6人以上の場合，探索幅が大きすぎるので別途実装が必要
          /* case 6: */
          /*   ret ~= nextNode6(); */
          /*   break; */
          /* case 7: */
          /*   ret ~= nextNode7(); */
          /*   break; */
          /* case 8: */
          /*   ret ~= nextNode8(); */
          /*   break; */
        default:
          break;
      }
    } else {
      switch (field.agentNum) {
        case 2:
          ret ~= nextNode2(false);
          break;
        case 3:
          ret ~= nextNode3(false);
          break;
        case 4:
          ret ~= nextNode4(false);
          break;
        case 5:
          ret ~= nextNode5(false);
          break;
          // エージェントの人数が6人以上の場合，探索幅が大きすぎるので別途実装が必要
          /* case 6: */
          /*   ret ~= nextNode6(); */
          /*   break; */
          /* case 7: */
          /*   ret ~= nextNode7(); */
          /*   break; */
          /* case 8: */
          /*   ret ~= nextNode8(); */
          /*   break; */
        default:
          break;
      }
    }
    return ret;
  }

  S nextNode2(bool originalTurn) {
    S ret;
    Node* tmp;

    foreach (i; 0 .. 9) {
      foreach (j; 0 .. 9) {
        if (originalTurn)
          tmp = new Node(field, turn + 1, [i, j], [i, j]);
        else
          tmp = new Node(field, turn + 1, [i, j], originMoveDir);
        ret ~= tmp;
      }
    }
    return ret;
  }
  S nextNode3(bool originalTurn) {
    S ret;
    Node* tmp;

    foreach (i; 0 .. 9) {
      foreach (j; 0 .. 9) {
        foreach (k; 0 .. 9) {
          if (originalTurn)
            tmp = new Node(field, turn + 1, [i, j, k], [i, j, k]);
          else
            tmp = new Node(field, turn + 1, [i, j, k], originMoveDir);
          ret ~= tmp;
        }
      }
    }
    return ret;
  }
  S nextNode4(bool originalTurn) {
    S ret;

    Node* tmp;
    foreach (i; 0 .. 9) {
      foreach (j; 0 .. 9) {
        foreach (k; 0 .. 9) {
          foreach (l; 0 .. 9) {
            if (originalTurn)
              tmp = new Node(field, turn + 1, [i, j, k, l], [i, j, k, l]);
            else
              tmp = new Node(field, turn + 1, [i, j, k, l], originMoveDir);
            tmp.field.moveAgent();
            ret ~= tmp;
          }
        }
      }
    }
    return ret;
  }
  S nextNode5(bool originalTurn) {
    S ret;

    Node* tmp;
    foreach (i; 0 .. 9) {
      foreach (j; 0 .. 9) {
        foreach (k; 0 .. 9) {
          foreach (l; 0 .. 9) {
            foreach (m; 0 .. 9) {
              if (originalTurn)
                tmp = new Node(field, turn + 1, [i, j, k, l, m], [i, j, k, l, m]);
              else
                tmp = new Node(field, turn + 1, [i, j, k, l, m], originMoveDir);
              tmp.field.moveAgent();
              ret ~= tmp;
            }
          }
        }
      }
    }
    return ret;
  }
}

class KananBeamSearch {
  import Kanan.dispField;
  import std.stdio;
  import std.range : front, popFront;
  import std.algorithm : copy;

  S childNodes;
  Node[] searchFinished;

  uint turn;
  Field nowFieldState;
  uint maxTurn;

  this(Field nowFieldState, uint turn, uint maxTurn) {
    this.childNodes = new Node(nowFieldState, turn);
    this.turn = turn;
    this.maxTurn = maxTurn;
    this.nowFieldState = nowFieldState;
  }

  void searchAgentAction() {
    S grandChildNode;

    while(!childNodes.empty()) {
      Thread.sleep(dur!"seconds"(1));
      grandChildNode.clear();

      foreach (e; childNodes) {
        if (e.turn == maxTurn) {
          searchFinished ~= *e;
        } else {
          grandChildNode ~= e.getNextNodes(turn);
        }
      }

      childNodes.clear();
      childNodes.reserve(grandChildNode.length);

      foreach (e; grandChildNode) {
        childNodes ~= e;
      }
    }
  }
}

unittest {
  import Kanan.dispField : disp;

  Field field;
  field.width = 6;
  field.height = 6;
  field.point = new int[][](6, 6);
  field.color = new int[][](6, 6);
  field.myAgentData = new int[][](2, 3);
  field.rivalAgentData = new int[][](2, 3);
  foreach (i; 0 .. 6) {
    foreach (j; 0 .. 6) {
      field.point[i][j] = i + j;
      field.color[i][j] = 0;
    }
  }

  field.color[2][2] = 1;
  field.color[3][3] = 1;
  field.color[2][3] = 2;
  field.color[3][2] = 2;

  field.color[2][4] = 1;
  field.color[1][3] = 1;

  field.agentNum = 2;
  field.myTeamID = 1;
  field.rivalTeamID = 2;
  field.myAgentData[0][0] = 5;
  field.myAgentData[0][1] = 2;
  field.myAgentData[0][2] = 2;
  field.myAgentData[1][0] = 6;
  field.myAgentData[1][1] = 3;
  field.myAgentData[1][2] = 3;
  field.rivalAgentData[0][0] = 7;
  field.rivalAgentData[0][1] = 3;
  field.rivalAgentData[0][2] = 2;
  field.rivalAgentData[1][0] = 8;
  field.rivalAgentData[1][1] = 2;
  field.rivalAgentData[1][2] = 3;

  field.myTilePoint = 0;
  field.myAreaPoint = 0;
  field.rivalTilePoint = 0;
  field.rivalAreaPoint = 0;
  field.maxTurn = 2;
  field.calcTilePoint;
  field.calcAreaPoint(field.myTeamID);
  field.calcAreaPoint(field.rivalTeamID);
  field.disp;

  writeln(field.myAreaPoint);

  auto search = new KananBeamSearch(field, 1, 3);
  search.searchAgentAction;

  /* foreach (e; search.searchFinished) { */
  /*   e.field.disp; */
  /*   e.field.myAreaPoint.writeln; */
  /* } */
}
