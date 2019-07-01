module Kanan.dispField;

import std.stdio;
import Kanan.color;
import Kanan.agent;
import Kanan.tile;

void disp(Tile[][] field) {
  foreach (i; 0 .. field.length) {
    write("+");
    foreach (j; 0 .. field[0].length) {
      write("---");
      write("+");
    }
    writeln;

    write("|");
    foreach (j; 0 .. field[0].length) {
      dispTile(field[i][j]);
      write("|");
    }
    writeln;
  }
}

void dispTile(Tile tile) {
  if (tile.color == Color.White) {
    writef("\033[0;47m%3d\033[0;39m", tile.tilePoint);
  } else if (tile.color == Color.Red) {
    if (tile.agent == Agent.Red)
      writef("\033[0;31;1m%3d\033[0;39m", tile.tilePoint);
    else
      writef("\033[0;41m%3d\033[0;39m", tile.tilePoint);
  } else if (tile.color == Color.Blue) {
    if (tile.agent == Agent.Blue)
      writef("\033[0;34;1m%3d\033[0;39m", tile.tilePoint);
    else
      writef("\033[0;44m%3d\033[0;39m", tile.tilePoint);
  }
}
