import std.stdio;
import Kanan.tile;
import Kanan.greedy;
import Kanan.color;
import Kanan.agent;
import Kanan.dispField;
import Kanan.updateField;
import std.conv;
import std.string;

void main()
{
  Tile[][] Field = new Tile[][](8, 11);

  static immutable int[] dx = [-1, -1, 0, 1, 1, 1, 0, -1];
  static immutable int[] dy = [0, -1, -1, -1, 0, 1, 1, 1];


  auto num = [[-2, 1, 0, 0, 2, 0, 2, 1, 0, 1, -2],
  [1, 1, 2, -2, 0, 1, 0, -2, 2, 1, 1],
  [1, 3, 1, 1, 0, -2, 0, 1, 1, 3, 1],
  [2, 1, 1, 2, 2, 3, 2, 2, 1, 1, 2,],
  [2, 1, 1, 2, 2, 3, 2, 2, 1, 1, 2,],
  [1, 3, 1, 1, 0, -2, 0, 1, 1, 3, 1],
  [1, 1, 2, -2, 0, 1, 0, -2, 2, 1, 1],
  [-2, 1, 0, 0, 2, 0, 2, 1, 0, 1, -2],
  ];

  foreach (i; 0 .. 8) {
    foreach (j; 0 .. 11) {
      Field[i][j].tilePoint = num[i][j];
    }
  }

  int[] whichDirBlue1 = new int[2];
  int[] whichDirBlue2 = new int[2];
  int[] whichDirRed1 = new int[2];
  int[] whichDirRed2 = new int[2];

  int[] whereAgentBlue1 = [1, 1];
  int[] whereAgentBlue2 = [9, 6];
  int[] whereAgentRed1 = [9, 1];
  int[] whereAgentRed2 = [1, 6];

  Field[1][1].color = Color.Blue;
  Field[6][9].color = Color.Blue;
  Field[1][1].agent = Agent.Blue;
  Field[6][9].agent = Agent.Blue;

  Field[1][9].color = Color.Red;
  Field[6][1].color = Color.Red;
  Field[1][9].agent = Agent.Red;
  Field[6][1].agent = Agent.Red;

  disp(Field);
  writeln;
  foreach (i; 0 .. 20) {
    write("エージェント1 >> ");
    auto input = readln.split[0].to!int;
    whichDirRed1[0] = dx[input];
    whichDirRed1[1] = dy[input];

    write("エージェント2 >> ");
    input = readln.split[0].to!int;
    whichDirRed2[0] = dx[input];
    whichDirRed2[1] = dy[input];

    greedyAlgorithm(Field, whereAgentBlue1, whichDirBlue1);
    greedyAlgorithm(Field, whereAgentBlue2, whichDirBlue2);

    updateAgentColor(Field, whereAgentRed1, whichDirRed1);
    updateAgentColor(Field, whereAgentRed2, whichDirRed2);
    updateAgentColor(Field, whereAgentBlue1, whichDirBlue1);
    updateAgentColor(Field, whereAgentBlue2, whichDirBlue2);

    disp(Field);
    writeln;
  }
}
