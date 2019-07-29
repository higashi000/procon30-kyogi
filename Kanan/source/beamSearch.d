module Kanan.beamSearch;

import Kanan.field;
import std.range;
import std.stdio;


struct Node {
  this(NowField field, uint turn, int[] myMoveDir) {
    this.field = Field(field, myMoveDir);
    this.turn = turn;
    this.evalValue = 0;
  }

  Node* previousNode;
  Node*[] childNodes;

  int evalValue;
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
    import std.range : front, popFront;
    import std.algorithm : swap;
    Node*[] grandChildNode;

    while (1) {
      while (childNodes.length > 0) {
        auto nowNode = childNodes.front;
        childNodes.popFront;

        if (maxTurn == nowNode.turn) {
          searchFinished ~= nowNode;
          continue;
        }

        grandChildNode ~= nowNode.getNextNodes();
      }
      if (grandChildNode.length == 0)
        break;
      else
        swap(childNodes, grandChildNode);
    }
  }
}

unittest {
  import Kanan.dispField : disp;
  import Kanan.connector : KananConnector;
  auto connector = new KananConnector("127.0.0.1", 8081);
  connector.getFieldData;
  auto field = connector.parseFieldData(2);

  Field nowField = Field(field);

  auto search = new KananBeamSearch(nowField, 1, 3);
  search.searchAgentAction;

  disp(search.searchFinished[0].field);
  disp(search.searchFinished[1].field);
  disp(search.searchFinished[2].field);
}
