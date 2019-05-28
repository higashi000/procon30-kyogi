module Kanan.dispField;

import std.stdio;
import Kanan.color;
import Kanan.tile;

void disp(Tile[][] field) {
  foreach (i; 0 .. field.length) {
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
    writef("\033[0;41m%3d\033[0;39m", tile.tilePoint);
  } else if (tile.color == Color.Blue) {
    writef("\033[0;44m%3d\033[0;39m", tile.tilePoint);
  }
}
