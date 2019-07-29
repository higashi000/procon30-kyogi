module Kanan.dispField;

import std.stdio;
import Kanan.color;
import Kanan.agent;
import Kanan.tile;
import Kanan.field;

void disp(Field nowField) {
  foreach (i; 0 .. nowField.fieldState.height) {
    write("+");
    foreach (j; 0 .. nowField.fieldState.width) {
      write("---");
      write("+");
    }
    writeln;

    write("|");
    foreach (j; 0 .. nowField.fieldState.height) {
      dispTile(nowField.fieldState.point[i][j], nowField.fieldState.color[i][j], nowField.fieldState.myTeamID);
      write("|");
    }
    writeln;
  }
}

void dispTile(int point, int color, int teamID) {
  if (color == 0) {
    writef("\033[0;47m%3d\033[0;39m", point);
  } else if (color == teamID) {
    writef("\033[0;41m%3d\033[0;39m", point);
  } else if (color != teamID) {
    writef("\033[0;44m%3d\033[0;39m", point);
  }
}
