module Kanan.dispField;

import std.stdio;
import Kanan.color;
import Kanan.agent;
import Kanan.tile;
import Kanan.field;

void disp(Field nowField) {
  foreach (i; 0 .. nowField.height) {
    write("+");
    foreach (j; 0 .. nowField.width) {
      write("---");
      write("+");
    }
    writeln;

    write("|");
    foreach (j; 0 .. nowField.height) {
      auto flg = false;
      myLoop : foreach (k; nowField.myAgentData) {
        if (i == k[2] && j == k[1]) {
          writef("\033[0;45m%3d\033[0;39m", k[0]);
          flg = true;
          break myLoop;
        }
      }
      rivalLoop : foreach (k; nowField.rivalAgentData) {
        if (i == k[2] && j == k[1]) {
          writef("\033[0;46m%3d\033[0;39m", k[0]);
          flg = true;
          break rivalLoop;
        }
      }
      if (!flg)
        dispTile(nowField.point[i][j], nowField.color[i][j], nowField.myTeamID);
      write("|");
    }
    writeln;
  }
}

void dispTile(int point, int color, int teamID) {
  if (color == 0) {
    writef("%3d", point);
  } else if (color == teamID) {
    writef("\033[0;41m%3d\033[0;39m", point);
  } else {
    writef("\033[0;44m%3d\033[0;39m", point);
  }
}
