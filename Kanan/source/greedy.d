module Kanan.greedy;

import Kanan.tile;

int[] dx = [-1, -1, 0, 1, 1, 1, 0, -1];
int[] dy = [0, -1, -1, -1, 0, 1, 1, 1];

void greedyAlgorithm(Tile[][] Field, int[] whichAgent, ref int[] whichDir) {
  int max = -17;
  foreach (i; 0 .. 8) {
    if (!trueDir(whichAgent, Field[0].length, Field.length, i))
      continue;
    if (Field[whichAgent[0] + dx[i]][whichAgent[1] + dy[i]].tilePoint > max) {
      max = Field[whichAgent[0] + dx[i]][whichAgent[1] + dy[i]].tilePoint;
      whichDir[0] = whichAgent[0] + dx[i];
      whichDir[1] = whichAgent[1] + dy[i];
    }
  }
}

bool trueDir(int[] whichAgent, ulong fieldX, ulong fieldY, int dir) {
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
