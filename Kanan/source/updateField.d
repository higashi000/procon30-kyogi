module Kanan.updateField;

import Kanan.tile;
import Kanan.agent;
import Kanan.color;
import Kanan.judgeTrueDir;
import std.stdio;

void updateAgentColor(ref Tile[][] Field, ref int[] whereAgent, int[] whichDir) {
  Color* nowPosColor = &Field[whereAgent[1]][whereAgent[0]].color;
  Color* nextPosColor = &Field[whereAgent[1] + whichDir[1]][whereAgent[0] + whichDir[0]].color;
  Agent* nowPosAgent = &Field[whereAgent[1]][whereAgent[0]].agent;
  Agent* nextPosAgent = &Field[whereAgent[1] + whichDir[1]][whereAgent[0] + whichDir[0]].agent;

  if (!trueDir(whereAgent, Field[0].length, Field.length, whichDir)) {
    writeln("bad choice");
    return;
  }

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
