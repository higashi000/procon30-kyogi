import std.stdio;
import Kanan.tile;
import Kanan.greedy;
import Kanan.color;
import Kanan.agent;
import Kanan.dispField;
import Kanan.updateField;

void main()
{
  Tile[][] Field = new Tile[][](4, 6);


  auto num = [[2, -4, 0, 0, -4, 2],
  [5, -1, 1, 1, -1, 5],
  [5, -1, 1, 1, -1, 5],
  [2, -4, 0, 0, -4, 2]];

  foreach (i; 0 .. 4) {
    foreach (j; 0 .. 6) {
      Field[i][j].tilePoint = (i + 1) * (j + 1);
    }
  }

  int[] whichDir = new int[2];
  int[] whereAgent = [2, 2];

  Field[2][2].color = Color.Blue;
  Field[2][2].agent = Agent.Blue;

  greedyAlgorithm(Field, whereAgent, whichDir);
  updateAgentColor(Field, whereAgent, whichDir);
  disp(Field);
}
