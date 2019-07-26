module Kanan.beamSearch;

import Kanan.connector;
import Kanan.agent;
import Kanan.color;
import Kanan.field;
import Kanan.judgeTrueDir;
import Kanan.rsvData;
import Kanan.sendData;
import Kanan.tile;
import std.range;
import std.stdio;


struct Node {
  this(NowField field, uint turn, int[] myMoveDir) {
    this.field = Field(field, myMoveDir);
    this.turn = turn;
  }

  Node* previousNode;
  Node*[] childNodes;

  uint turn;
  Field field;

  Node*[] getNextNodes() {
    Node*[] ret;

    foreach (i ; 0 .. 9) {
      foreach (j; 0 .. 9) {
        ret ~= new Node(field.fieldState, turn + 1, [i, j]);
      }
    }

    return ret;
  }
}

class KananBeamSearch {
  Node* previousNode;
  Node*[] childNodes;
  Node*[] searchFinished;

  uint turn;
  Field nowFieldState;
  uint maxTurn;

  this(Field nowFieldState, uint turn, uint maxTurn) {
    this.previousNode = new Node(nowFieldState.fieldState, turn, [0, 0]);
    this.childNodes = previousNode.getNextNodes();
    this.turn = turn;
    this.maxTurn = maxTurn;
    this.nowFieldState = nowFieldState;
  }

  void searchAgentAction() {
    import std.datetime : StopWatch;
    import std.range : front, popFront;

    while (childNodes.length > 0) {
      auto nowNode = childNodes.front;
      childNodes.popFront;

      if (maxTurn == nowNode.turn) {
        searchFinished ~= nowNode;
        continue;
      }


      auto grandChildNode = nowNode.getNextNodes();

      childNodes ~= grandChildNode;
    }
  }
}
