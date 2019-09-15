module Kanan.montecarlo;

import Kanan.field, Kanan.dispField;
import std.stdio, std.range, std.algorithm, std.array, std.string, std.math, std.conv,
       std.container, std.bigint, std.ascii, std.typecons, std.format, std.random;

alias M = Array!(MontecarloNode*);

struct MontecarloNode {
  this(Field field, uint turn, int[] myMoveDir) {
    this.field = Field(field, myMoveDir);
    this.turn = turn;
    this.evalValue = result();
    this.childEval = 0;
  }
  this(Field field, uint turn) {
    this.field = Field(field);
    this.turn = turn;
    this.evalValue = result();
    this.childEval = 0;
  }


  Field field;
  uint turn;
  uint evalValue;
  uint childEval;

  int playOut(MontecarloNode nextNode, int maxTurn) {
    if (nextNode.turn <= maxTurn) {
      switch (field.agentNum) {
        case 2:
          playOut(MontecarloNode(nextNode.field, nextNode.turn + 1, [uniform(0, 9), uniform(0, 9)]), maxTurn);
          break;
        case 3:
          playOut(MontecarloNode(nextNode.field, nextNode.turn + 1, [uniform(0, 9), uniform(0, 9), uniform(0, 9)]), maxTurn);
          break;
        case 4:
          playOut(MontecarloNode(nextNode.field, nextNode.turn + 1, [uniform(0, 9), uniform(0, 9), uniform(0, 9), uniform(0, 9)]), maxTurn);
          break;
        case 5:
          playOut(MontecarloNode(nextNode.field, nextNode.turn + 1, [uniform(0, 9), uniform(0, 9), uniform(0, 9), uniform(0, 9), uniform(0, 9)]), maxTurn);
          break;
        default:
          break;
      }
    }
    return nextNode.evalValue;
  }

  // 子Nodeの生成 --- {{{
  M getNextNode() {
    M ret;
    switch(field.agentNum) {
      case 2 :
        ret ~= nextNode2();
        break;
      case 3:
        ret ~= nextNode3();
        break;
      case 4:
        ret ~= nextNode4();
        break;
      case 5:
        ret ~= nextNode5();
        break;
      default:
        break;
    }

    return ret;
  }

  M nextNode2() {
    M ret;
    MontecarloNode* tmp;

    foreach (i; 0 .. 9) {
      foreach (j; 0 .. 9) {
        tmp = new MontecarloNode(field, turn + 1, [i, j]);
        ret ~= tmp;
      }
    }

    return ret;
  }
  M nextNode3() {
    M ret;
    MontecarloNode* tmp;

    foreach (i; 0 .. 9) {
      foreach (j; 0 .. 9) {
        foreach (k; 0 .. 9) {
          tmp = new MontecarloNode(field, turn + 1, [i, j, k]);
          ret ~= tmp;
        }
      }
    }

    return ret;
  }
  M nextNode4() {
    M ret;
    MontecarloNode* tmp;

    foreach (i; 0 .. 9) {
      foreach (j; 0 .. 9) {
        foreach (k; 0 .. 9) {
          foreach (l; 0 .. 9) {
            tmp = new MontecarloNode(field, turn + 1, [i, j, k, l]);
            ret ~= tmp;
          }
        }
      }
    }

    return ret;
  }

  M nextNode5() {
    M ret;
    MontecarloNode* tmp;

    foreach (i; 0 .. 9) {
      foreach (j; 0 .. 9) {
        foreach (k; 0 .. 9) {
          foreach (l; 0 .. 9) {
            foreach (m; 0 .. 9) {
              tmp = new MontecarloNode(field, turn + 1, [i, j, k, l, m]);
              ret ~= tmp;
            }
          }
        }
      }
    }

    return ret;
  }
  // }}}

  int result()
  {
    int myPoint = field.myAreaPoint + field.myTilePoint;
    int rivalPoint = field.rivalAreaPoint + field.rivalTilePoint;

    return myPoint - rivalPoint;
  }
}

class Montecarlo {
  MontecarloNode originNode;
  M nextNode;
  uint turn;
  uint maxTurn;
  uint trialNum;

  this(Field nowFieldState, uint turn, uint maxTurn, uint trialNum) {
    this.originNode = MontecarloNode(nowFieldState, turn);
    this.turn = turn;
    this.maxTurn = maxTurn;
    this.nextNode = this.originNode.getNextNode();
    this.trialNum = trialNum;
  }

  int playNode(MontecarloNode node)
  {
    int resSum = 0;
    foreach (i; 0 .. trialNum) {
      node.playOut(node, maxTurn);
      resSum += node.evalValue;
    }

    return resSum;
  }

  MontecarloNode playGame()
  {
    int[] result;
    foreach (e; nextNode) {
      e.childEval = playNode(*e);
    }

    auto top = maxElement!("a.childEval")(nextNode[]);

    return *top;
  }
}

// unittest {{{
unittest {
  import std.datetime;
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
  field.calcMyAreaPoint();
  field.calcRivalAreaPoint();

  uint turn = 1;
  uint maxTurn = 10;
  uint trial = 1000;

  StopWatch sw;
  sw.start();
  auto search = new Montecarlo(field, turn, maxTurn, trial);
  auto topNode = search.playGame();
  topNode.childEval.writeln;
  sw.stop();
  sw.peek.msecs.writeln;
}
//}}}
