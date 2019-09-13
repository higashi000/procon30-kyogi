module Kanan.montecarlo;

import Kanan.field, Kanan.dispField;
import std.random, std.stdio;

struct MontecarloNode {
  this(Field field, uint turn, int[] myMoveDir) {
    this.field = new Field(field, myMoveDir);
    this.turn = turn;
  }

  Field field;
  uint turn;
  uint evalValue;

  int playOut(MontecarloNode nextNode, int maxTurn) {
    if (turn == maxTurn)  {
      return evalValue;
    } else {
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
    }
  }
}

class Montecarlo {
}
