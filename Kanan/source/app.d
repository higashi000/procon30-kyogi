import std.stdio;
import Kanan.tile;
import Kanan.greedy;
import Kanan.color;
import Kanan.dispField;

void main()
{
  Tile[][] Field = new Tile[][](5, 5);

  foreach (i; 0 .. 5) {
    foreach (j; 0 .. 5) {
      Field[i][j].tilePoint = (i + 1) * (j + 1);
    }
  }

  int[] whichDir = new int[2];
  int[] whichAgent = [0, 0];
  greedyAlgorithm(Field, whichAgent, whichDir);

  Field[0][0].color = Color.Blue;

  disp(Field);

  writeln(whichDir);
}
