module Kanan.beamSearch;

import std.stdio, std.range, std.algorithm, std.array, std.string, std.math, std.conv,
       std.container, std.bigint, std.ascii, std.typecons, std.format;
import core.thread;
import Kanan.field;

alias S = Array!(Node*);

struct Node {
  import std.random : uniform;
  import Kanan.dispField;
  this(NowField field, uint turn, int[] myMoveDir) {
    this.field = Field(field, myMoveDir);
    this.turn = turn;
    this.evalValue = 0;
  }

  this(NowField field, uint turn) {
    this.field = Field(field);
    this.turn = turn;
    this.evalValue = 0;
  }

  S childNodes;

  int evalValue;
  uint turn;
  Field field;

  S getNextNodes() {
    import std.random : uniform;
    S ret;
    Node* tmp;

    foreach (i ; 0 .. 9) {
      foreach (j; 0 .. 9) {
        tmp = new Node(field.fieldState, turn + 1, [i, j]);
        tmp.field.moveAgent();
        tmp.field.disp;
        writeln;
        ret ~= tmp;
      }
    }

    return ret;
  }
}

class KananBeamSearch {
  import Kanan.dispField;
  import std.stdio : writeln;
  import core.thread;

  S childNodes;
  S grandChildNode;

  uint turn;
  Field nowFieldState;
  uint maxTurn;

  this(Field nowFieldState, uint turn, uint maxTurn) {
    this.childNodes = new Node(nowFieldState.fieldState, turn);
    this.turn = turn;
    this.maxTurn = maxTurn;
    this.nowFieldState = nowFieldState;
  }

  void searchAgentAction() {
    while (!childNodes.empty()) {
      Thread.sleep(dur!"seconds"(1));

      foreach (e; childNodes) {
        grandChildNode ~= e.getNextNodes;
      }

      /* foreach (e; grandChildNode) { */
      /*   e.field.num.writeln; */
      /* } */

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

  NowField field;
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
  field.maxTurn = 3;

  Field nowField = Field(field);

  auto search = new KananBeamSearch(nowField, 0, 2);
  search.searchAgentAction;

  /* foreach (i; 0 .. search.searchFinished.length) { */
  /*   disp(search.searchFinished[i].field); */
  /*   writef("%s", &search.searchFinished[i].field); */
  /*   writeln; */
  /* } */
}
