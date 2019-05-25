import std.stdio;
import Kanan.tile;
import Kanan.greedy;

void main()
{
  Tile[][] Field = new Tile[][](3, 3);

  foreach (i; 0 .. 3) {
    foreach (j; 0 .. 3) {
      Field[i][j].tilePoint = (i + 1) * (j + 1);
    }
  }

  Field[1][1].tilePoint = 1000;

  int[] whichDir = new int[2];
  int[] whichAgent = [0, 0];
  greedyAlgorithm(Field, whichAgent, whichDir);

  writeln(whichDir);
}
