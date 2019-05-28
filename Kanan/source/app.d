import std.stdio;
import Kanan.tile;
import Kanan.greedy;
import Kanan.color;

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

  foreach (i; 0 .. 5) {
    write("|");
    foreach (j; 0 .. 5) {
      dispTile(Field[i][j]);
      write("|");
    }
    writeln;
  }

  writeln(whichDir);
}

void dispTile(Tile tile) {
  if (tile.color == Color.White) {
    writef("\033[0;47m%3d\033[0;39m", tile.tilePoint);
  } else if (tile.color == Color.Red) {
    writef("\033[0;41m%3d\033[0;39m", tile.tilePoint);
  } else if (tile.color == Color.Blue) {
    writef("\033[0;44m%3d\033[0;39m", tile.tilePoint);
  }
}
