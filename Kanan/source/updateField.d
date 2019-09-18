module Kanan.updateField;

import Kanan.tile;
import Kanan.agent;
import Kanan.color;
import Kanan.judgeTrueDir;
import std.stdio;

void updateAgentColor(ref Tile[][] Field, ref int[] whereAgent, int[] whichDir) {
  static immutable int[] dx = [-1, -1, 0, 1, 1, 1, 0, -1];
  static immutable int[] dy = [0, -1, -1, -1, 0, 1, 1, 1];

  int dir;
  foreach (i; 0 .. 8) {
    if (dx[i] == whichDir[0] && dy[i] == whichDir[1])
      dir = i;
  }

  if (!trueDir(whereAgent, Field[0].length, Field.length, dir)) {
    writeln("wrong direction");
    return;
  }

  Color* nowPosColor = &Field[whereAgent[1]][whereAgent[0]].color;
  Color* nextPosColor = &Field[whereAgent[1] + whichDir[1]][whereAgent[0] + whichDir[0]].color;
  Agent* nowPosAgent = &Field[whereAgent[1]][whereAgent[0]].agent;
  Agent* nextPosAgent = &Field[whereAgent[1] + whichDir[1]][whereAgent[0] + whichDir[0]].agent;

  *nextPosAgent = *nowPosAgent;
  *nowPosAgent = Agent.Null;
  whereAgent[0] += whichDir[0];
  whereAgent[1] += whichDir[1];

  if (*nextPosColor == Color.White) {
    *nextPosColor = *nowPosColor;
  }
  else if (*nextPosColor == Color.Blue) {
    if (*nowPosAgent == Agent.Red)
      *nextPosColor = Color.White;
  }
  else if (*nextPosColor == Color.Red) {
    if (*nowPosAgent == Agent.Blue)
      *nextPosColor = Color.White;
  }
}
