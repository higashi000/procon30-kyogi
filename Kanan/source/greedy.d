module Kanan.greedy;

import Kanan.tile : Tile;
import std.stdio;

void greedyAlgorithm(Tile[][] Field, int[] whichAgent, ref int[] whichDir) {
  import std.range : zip;
  import std.algorithm : sort;
  static immutable int[] dx = [-1, -1, 0, 1, 1, 1, 0, -1];
  static immutable int[] dy = [0, -1, -1, -1, 0, 1, 1, 1];
  int max = -17;

  foreach (i; 0 .. 8) {
    int nowPoint = Field[whichAgent[1]][whichAgent[0]].tilePoint;

    if (!trueDir(whichAgent, Field[0].length, Field.length, i))
      continue;

    if (whichColor(Field[whichAgent[1]][whichAgent[0]], Field[whichAgent[1] + dy[i]][whichAgent[0] + dx[i]]))
      nowPoint += Field[whichAgent[1] + dy[i]][whichAgent[0] + dx[i]].tilePoint;

    foreach (j; 0 .. 8) {
      int[2] nowAgentPos = [whichAgent[0] + dx[i], whichAgent[1] + dy[i]];

      if (!trueDir(nowAgentPos, Field[0].length, Field.length, j))
        continue;

      if (whichColor(Field[nowAgentPos[1]][nowAgentPos[0]], Field[nowAgentPos[1] + dy[j]][nowAgentPos[0] + dx[j]]))
        nowPoint += Field[nowAgentPos[1] + dy[j]][nowAgentPos[0] + dx[j]].tilePoint;

      if (nowPoint > max) {
        whichDir[0] = dx[i];
        whichDir[1] = dy[i];
        max = nowPoint;
      }
      if (whichColor(Field[nowAgentPos[1]][nowAgentPos[0]], Field[nowAgentPos[1] + dy[j]][nowAgentPos[0] + dx[j]]))
        nowPoint -= Field[nowAgentPos[1] + dy[j]][nowAgentPos[0] + dx[j]].tilePoint;
    }
  }
}

bool whichColor(Tile nowTile, Tile nextTile) {
  if (nowTile.color == nextTile.color)
    return false;
  else
    return true;
}

bool trueDir(int[] whichAgent, ulong fieldX, ulong fieldY, int dir) {
  static immutable int[] dx = [-1, -1, 0, 1, 1, 1, 0, -1];
  static immutable int[] dy = [0, -1, -1, -1, 0, 1, 1, 1];

  if (whichAgent[0] + dx[dir] < 0)
    return false;
  else if (fieldX <= whichAgent[0] + dx[dir])
    return false;
  else if (whichAgent[1] + dy[dir] < 0)
    return false;
  else if (fieldY <= whichAgent[1] + dy[dir])
    return false;

  return true;
}
