module Kanan.montecarlo;

import Kanan.field, Kanan.dispField;
import std.random, std.stdio, std.array;

alias MontecarloS = Array!(MontecarloNode*);

struct MontecarloNode {
  this(Field field, uint turn, int[] myMoveDir) {
    this.field = new Field(field, myMoveDir);
    this.turn = turn;
    this.evalValue = result();
  }

  Field field;
  uint turn;
  uint evalValue;

  int playOut(MontecarloNode nextNode, int maxTurn) {
    if (turn != maxTurn) {
      switch (field.agentNum) {
        case 2:
          playOut(Node(field, turn + 1, [uniform(0, 9), uniform(0, 9)]), maxTurn);
          break;
        case 3:
          playOut(Node(field, turn + 1, [uniform(0, 9), uniform(0, 9), uniform(0, 9)]), maxTurn);
          break;
        case 4:
          playOut(Node(field, turn + 1, [uniform(0, 9), uniform(0, 9), uniform(0, 9), uniform(0, 9)]), maxTurn);
          break;
        case 5:
          playOut(Node(field, turn + 1, [uniform(0, 9), uniform(0, 9), uniform(0, 9), uniform(0, 9), uniform(0, 9)]), maxTurn);
          break;
      }
    } else {
      return evalValue;
    }
  }

  int result()
  {
    int myPoint = field.myAreaPoint + field.myTilePoint;
    int rivalPoint = field.rivalAreaPoint + field.rivalTilePoint;

    return myPoint - rivalPoint;
  }
}

class Montecarlo {
}
