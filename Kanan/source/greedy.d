module Kanan.greedy;

import Kanan.tile : Tile;
import Kanan.color;
import Kanan.judgeTrueDir;

void greedyAlgorithm(Tile[][] Field, int[] whichAgent, ref int[] whichDir) {
  static immutable int[] dx = [-1, -1, 0, 1, 1, 1, 0, -1];
  static immutable int[] dy = [0, -1, -1, -1, 0, 1, 1, 1];
  int max = -17;

  foreach (i; 0 .. 8) {
    int nowPoint = Field[whichAgent[1]][whichAgent[0]].tilePoint;

    if (!trueDir(whichAgent, Field[0].length, Field.length, i))
      continue;

    if (Field[whichAgent[1]][whichAgent[0]].agent == Field[whichAgent[1] + dy[i]][whichAgent[0] + dx[i]].agent)
      continue;

    if (whichColor(Field[whichAgent[1]][whichAgent[0]], Field[whichAgent[1] + dy[i]][whichAgent[0] + dx[i]]))
      nowPoint += Field[whichAgent[1] + dy[i]][whichAgent[0] + dx[i]].tilePoint;

    if (Field[whichAgent[1] + dy[i]][whichAgent[0] + dx[i]].color != Color.White) {
      if (whichColor(Field[whichAgent[1]][whichAgent[0]], Field[whichAgent[1] + dy[i]][whichAgent[0] + dx[i]])) {
        updateMaxNum(whichDir, max, dx[i], dy[i], nowPoint);

        continue;
      }
    }

    foreach (j; 0 .. 8) {
      int[2] nowAgentPos = [whichAgent[0] + dx[i], whichAgent[1] + dy[i]];

      if (!trueDir(nowAgentPos, Field[0].length, Field.length, j))
        continue;

      if (whichColor(Field[nowAgentPos[1]][nowAgentPos[0]], Field[nowAgentPos[1] + dy[j]][nowAgentPos[0] + dx[j]]))
        nowPoint += Field[nowAgentPos[1] + dy[j]][nowAgentPos[0] + dx[j]].tilePoint;

      updateMaxNum(whichDir, max, dx[i], dy[i], nowPoint);

      if (whichColor(Field[nowAgentPos[1]][nowAgentPos[0]], Field[nowAgentPos[1] + dy[j]][nowAgentPos[0] + dx[j]]))
        nowPoint -= Field[nowAgentPos[1] + dy[j]][nowAgentPos[0] + dx[j]].tilePoint;
    }
  }
}

void updateMaxNum(ref int[] whichDir, ref int max, int dx, int dy, int nowPoint) {
  if (nowPoint > max) {
    whichDir[0] = dx;
    whichDir[1] = dy;
    max = nowPoint;
  }
}

bool whichColor(Tile nowTile, Tile nextTile) {
  if (nowTile.color == nextTile.color)
    return false;
  else
    return true;
}
