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
  Node[] searchFinished;

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
