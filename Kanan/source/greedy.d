module Kanan.greedy;

import Kanan.tile : Tile;

void greedyAlgorithm(Tile[][] Field, int[] whichAgent, ref int[] whichDir) {
  import std.range : zip;
  import std.algorithm : sort;
  static immutable int[] dx = [-1, -1, 0, 1, 1, 1, 0, -1];
  static immutable int[] dy = [0, -1, -1, -1, 0, 1, 1, 1];
  int[] dir = [0, 1, 2, 3, 4, 5, 6, 7];
  int[] point = new int[8];
  int max = -17;

  foreach (i; 0 .. 8) {
    int nowPoint = Field[whichAgent[0]][whichAgent[1]].tilePoint;
    if (!trueDir(whichAgent, Field[0].length, Field.length, i))
      continue;
    nowPoint += Field[whichAgent[0] + dx[i]][whichAgent[1] + dy[i]].tilePoint;
    foreach (j; 0 .. 8) {
      int[2] nowAgentPos = [whichAgent[0] + dx[i], whichAgent[1] + dy[i]];
      if (!trueDir(nowAgentPos, Field[0].length, Field.length, j))
        continue;
      nowPoint += Field[whichAgent[0] + dx[i] + dx[j]][whichAgent[1] + dy[i] + dy[j]].tilePoint;
      if (nowPoint > max) {
        whichDir[0] = dx[i];
        whichDir[1] = dy[i];
        max = nowPoint;
      }
    }
  }
}

bool trueDir(int[] whichAgent, ulong fieldX, ulong fieldY, int dir) {
  static immutable int[] dx = [-2, -1, 0, 1, 1, 1, 0, -1];
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
