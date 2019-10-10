module Kanan.montecarlo;

import Kanan.field, Kanan.dispField, Kanan.sendData;
import std.stdio, std.range, std.algorithm, std.array, std.string, std.math, std.conv,
       std.container, std.bigint, std.ascii, std.typecons, std.format, std.random;

alias M = Array!(MontecarloNode*);
alias MCTSN = Array!(MCTSNode*);

// 原始モンテカルロ用のNode {{{
struct MontecarloNode {
  this(Field field, uint turn, int[] myMoveDir, uint nextNodeWidth) {
    this.nextNodeWidth = nextNodeWidth;
    this.field = Field(field, myMoveDir, turn % 2 != 0 ? true : false);
    this.turn = turn;
    this.evalValue = result();
    this.childEval = 0;
    this.evalSum = 0.0;
    this.cntplayOut = 0;
    this.myMoveDir = new int[field.agentNum];
    foreach (i; 0 .. field.agentNum) {
      this.myMoveDir[i] = myMoveDir[i];
    }
  }
  this(Field field, uint turn, uint nextNodeWidth) {
    this.nextNodeWidth = nextNodeWidth;
    this.field = Field(field, myMoveDir, turn % 2 != 0 ? true : false);
    this.field = Field(field);
    this.turn = turn;
    this.evalValue = result();
    this.childEval = 0;
    this.evalSum = 0.0;
    this.cntplayOut = 0;
  }


  Field field;
  uint turn;
  uint evalValue;
  double childEval;
  double evalSum;
  uint cntplayOut;
  int[] myMoveDir;
  uint nextNodeWidth;

  int playOut(MontecarloNode nextNode, int maxTurn) {
    if (nextNode.turn <= maxTurn) {
      int[] agentDir;
      foreach (i; 0 .. field.agentNum) {
        agentDir ~= uniform(0, 9);
      }
      playOut(MontecarloNode(nextNode.field, nextNode.turn + 1, agentDir, nextNodeWidth), maxTurn);
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
        ret ~= nextNodeMore6();
        break;
    }

    return ret;
  }

  M nextNode2() {
    M ret;
    MontecarloNode* tmp;

    foreach (i; 0 .. 9) {
      foreach (j; 0 .. 9) {
        tmp = new MontecarloNode(field, turn + 1, [i, j], nextNodeWidth);
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
          tmp = new MontecarloNode(field, turn + 1, [i, j, k], nextNodeWidth);
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
            tmp = new MontecarloNode(field, turn + 1, [i, j, k, l], nextNodeWidth);
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
              tmp = new MontecarloNode(field, turn + 1, [i, j, k, l, m], nextNodeWidth);
              ret ~= tmp;
            }
          }
        }
      }
    }

    return ret;
  }

  M nextNodeMore6() {
    M ret;
    MontecarloNode* tmp;

    foreach (i; 0 .. nextNodeWidth) {
      int[] tmpMoveDir;
      foreach (j; 0 .. field.agentNum) {
        tmpMoveDir ~= uniform(0, 9);
      }
      tmp = new MontecarloNode(field, turn + 1, tmpMoveDir, nextNodeWidth);
      ret ~= tmp;
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
// }}}

// MCTS用のNode {{{
struct MCTSNode {
  this(Field field, MCTSNode* parentNode, uint turn, int[] myMoveDir, uint nextNodeWidth) {
    this.parentNode = parentNode;
    this.turn = turn;
    this.cntPlayOut = 0;
    this.myMoveDir = new int[myMoveDir.length];
    foreach (i; 0 .. myMoveDir.length) {
      if (field.dx[myMoveDir[i]] + field.myAgentData[i][1] < 0 || field.width <= field.dx[myMoveDir[i]] + field.myAgentData[i][1])
        this.myMoveDir[i] = 0;
      else if (field.dy[myMoveDir[i]] + field.myAgentData[i][2] < 0 || field.height <= field.dy[myMoveDir[i]] + field.myAgentData[i][2])
        this.myMoveDir[i] = 0;
      else
        this.myMoveDir[i] = myMoveDir[i];
    }
    this.field = Field(field, this.myMoveDir, turn % 2 != 0 ? true : false);

    this.nextNodeWidth = nextNodeWidth;
    this.win = false;
    this.ucb = 0.0;
  }
  this(Field field, uint turn, uint nextNodeWidth) {
    this.nextNodeWidth = nextNodeWidth;
    this.field = Field(field);
    this.parentNode = null;
    this.turn = turn;
    this.cntPlayOut = 0;
    this.myMoveDir = [];
    this.winCnt = 0;
    this.win = false;
    this.getNextNode();
    this.ucb = 0.0;
  }

  Field field;
  MCTSNode* parentNode;
  MCTSNode*[] triedNode;
  MCTSNode*[] untriedNode;
  uint turn;
  uint cntPlayOut;
  int[] myMoveDir;
  uint nextNodeWidth;
  uint winCnt;
  double ucb;
  bool win;

  MCTSNode* playOut(MCTSNode nextNode, int maxTurn)
  {
    if (nextNode.turn <= maxTurn) {
      int[] agentDir;
      foreach (i; 0 .. field.agentNum)
        agentDir ~= uniform(1, 9);
      playOut(MCTSNode(nextNode.field, &this, nextNode.turn + 1, agentDir, nextNode.nextNodeWidth), maxTurn);
    }

    if ((nextNode.field.myAreaPoint + nextNode.field.myTilePoint) > (nextNode.field.rivalAreaPoint + nextNode.field.rivalTilePoint))
      nextNode.win = true;

    return &this;
  }

  void propagate(bool win, ref uint allPlayOutCnt)
  {
    int res = cast(int)win;

    auto i = &this;
    while (i != null) {
      allPlayOutCnt++;
      i.winCnt += res;
      i.cntPlayOut++;

      i = i.parentNode;
    }
  }

  // 子Nodeの生成 --- {{{
  void getNextNode() {
    switch(field.agentNum) {
      case 2 :
        untriedNode ~= nextNode2();
        break;
      case 3:
        untriedNode ~= nextNode3();
        break;
      case 4:
        untriedNode ~= nextNode4();
        break;
      case 5:
        untriedNode ~= nextNode5();
        break;
      default:
        untriedNode ~= nextNodeMore6();
        break;
    }
  }

  MCTSNode*[] nextNode2() {
    MCTSNode*[] ret;
    MCTSNode* tmp;

    foreach (i; 0 .. 9) {
      foreach (j; 0 .. 9) {
        tmp = new MCTSNode(field, &this, turn + 1, [i, j], nextNodeWidth);
        ret ~= tmp;
      }
    }
    return ret;
  }
  MCTSNode*[] nextNode3() {
    MCTSNode*[] ret;
    MCTSNode* tmp;

    foreach (i; 0 .. 9) {
      foreach (j; 0 .. 9) {
        foreach (k; 0 .. 9) {
          tmp = new MCTSNode(field, &this, turn + 1, [i, j, k], nextNodeWidth);
          ret ~= tmp;
        }
      }
    }

    return ret;
  }
  MCTSNode*[] nextNode4() {
    MCTSNode*[] ret;
    MCTSNode* tmp;

    foreach (i; 0 .. 9) {
      foreach (j; 0 .. 9) {
        foreach (k; 0 .. 9) {
          foreach (l; 0 .. 9) {
            tmp = new MCTSNode(field, &this, turn + 1, [i, j, k, l], nextNodeWidth);
            ret ~= tmp;
          }
        }
      }
    }

    return ret;
  }

  MCTSNode*[] nextNode5() {
    MCTSNode*[] ret;
    MCTSNode* tmp;

    foreach (i; 0 .. 9) {
      foreach (j; 0 .. 9) {
        foreach (k; 0 .. 9) {
          foreach (l; 0 .. 9) {
            foreach (m; 0 .. 9) {
              tmp = new MCTSNode(field, &this, turn + 1, [i, j, k, l, m], nextNodeWidth);
              ret ~= tmp;
            }
          }
        }
      }
    }

    return ret;
  }

  MCTSNode*[] nextNodeMore6() {
    MCTSNode*[] ret;
    MCTSNode* tmp;

    foreach (i; 0 .. nextNodeWidth) {
      int[] tmpMoveDir;
      foreach (j; 0 .. field.agentNum) {
        tmpMoveDir ~= uniform(0, 9);
      }
      tmp = new MCTSNode(field, &this, turn + 1, tmpMoveDir, nextNodeWidth);
      ret ~= tmp;
    }

    return ret;
  }
  // }}}
}
// }}}

// 原始モンテカルロ {{{
class Montecarlo {
  import Kanan.sendData;
  import std.datetime;
  import core.time;

  MontecarloNode originNode;
  M nextNode;
  uint turn;
  uint maxTurn;
  uint trialNum;
  uint thinkingTime;

  immutable int[] dx = [0, -1, -1, 0, 1, 1, 1, 0, -1];
  immutable int[] dy = [0, 0, -1, -1, -1, 0, 1, 1, 1];

  this(Field nowFieldState, uint turn, uint maxTurn, uint thinkingTime, uint nextNodeWidth) {
    this.originNode = MontecarloNode(nowFieldState, turn, nextNodeWidth);
    this.turn = turn;
    this.maxTurn = maxTurn;
    this.nextNode = this.originNode.getNextNode();
    this.thinkingTime = thinkingTime;
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

    auto st = Clock.currTime;

    while (Clock.currTime - st <= thinkingTime.msecs) {
      foreach (e; nextNode) {
        e.evalSum += e.playOut(*e, maxTurn);
        e.cntplayOut++;
      }
    }

    foreach (e; nextNode) {
      e.childEval = e.evalSum / e.cntplayOut;
    }

    auto top = maxElement!("a.childEval")(nextNode[]);

    return *top;
  }

  Actions[] bestAnswer()
  {
    Actions[] answer;
    auto topNode = playGame();

    foreach (i; 0 .. topNode.field.agentNum) {
      answer ~= Actions(topNode.field.myAgentData[i][0], "move", dx[topNode.myMoveDir[i]], dy[topNode.myMoveDir[i]]);
    }

    return answer;
  }
}
//}}}

// MCTS {{{
class MontecarloTreeSearch {
  this(Field field, uint turn, uint maxTurn, uint thinkingTime, uint nextNodeWidth) {
    this.allPlayOutCnt = 0;
    this.root = new MCTSNode(field, turn, nextNodeWidth);
    this.turn = turn;
    this.maxTurn = maxTurn;
    this.thinkingTime = thinkingTime;
    this.dx = [0, -1, -1, 0, 1, 1, 1, 0, -1];
    this.dy = [0, 0, -1, -1, -1, 0, 1, 1, 1];
  }

  MCTSNode *root;
  uint turn;
  uint maxTurn;
  uint allPlayOutCnt;
  uint thinkingTime;

  immutable int[] dx;
  immutable int[] dy;

  MCTSNode* selectNext(MCTSNode* node)
  {
    auto cn = root.triedNode;

    foreach (e; cn) {
      e.ucb = (e.winCnt / e.cntPlayOut) + (sqrt(2.0) * sqrt(cast(double)(log(allPlayOutCnt) / e.cntPlayOut)));
    }

    auto top = maxElement!("a.ucb")(cn);

    return top;
  }

  MCTSNode* expandNext(MCTSNode* node)
  {
    import std.array : popBack;
    if (node.untriedNode.length == 0)
      node.getNextNode();

    auto next = node.untriedNode.back;
    node.untriedNode.popBack;
    node.triedNode ~= next;

    return next;
  }

  Actions[] playGame()
  {
    import std.datetime;
    auto st = Clock.currTime;

    loop: while (Clock.currTime - st <= thinkingTime.msecs) {
      MCTSNode* node = root;

      while (node.untriedNode.length == 0 && node.triedNode.length != 0) {
        if (Clock.currTime - st >= thinkingTime.msecs)
          break loop;
        node = selectNext(node);
      }

      if (node.untriedNode.length != 0) {
        if (Clock.currTime - st >= thinkingTime.msecs)
          break loop;
        node = expandNext(node);
      }

      auto res = node.playOut(*node, maxTurn);
      res.propagate(res.win, allPlayOutCnt);
    }

    auto topNode = maxElement!("a.ucb")(root.triedNode);

    Actions[] answer;

    foreach (i; 0 .. topNode.field.agentNum) {
      writeln(topNode.myMoveDir);
      writeln(topNode.field.myAgentData[i][1] + dx[topNode.myMoveDir[i]]);
      writeln(topNode.field.myAgentData[i][2] + dy[topNode.myMoveDir[i]]);
      string movePattern = "move";
      if (topNode.field.color[topNode.field.myAgentData[i][2] + dy[topNode.myMoveDir[i]]][topNode.field.myAgentData[i][1] + dx[topNode.myMoveDir[i]]] == topNode.field.rivalTeamID)
        movePattern = "remove";
      else if ((topNode.field.myAgentData[i][2] + dy[topNode.myMoveDir[i]]) == (topNode.field.myAgentData[i][2]) &&
               (topNode.field.myAgentData[i][1] + dx[topNode.myMoveDir[i]]) == (topNode.field.myAgentData[i][1]))
        movePattern = "stay";
      else
        movePattern = "move";

      answer ~= Actions(topNode.field.myAgentData[i][0], movePattern, dx[topNode.myMoveDir[i]], dy[topNode.myMoveDir[i]]);
    }

    return answer;
  }
}
// }}}

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
