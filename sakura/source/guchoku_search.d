module sakura.guchoku_search;

import std.conv;
import std.range;
import std.stdio;
import std.file;
import std.container;

import sakura.opencsv;

int[20][20] eval;
string [20][20] colors;
int ageNum;
string way;

string guchoku_first_search(){
  way = null;
  eval = opencsv(readln.split[0].to!string);
  colors = opencolor();

  write ("ageNum : ");
  ageNum = readln.split[0].to!(int);
  int[10] age_x, age_y;
  int w = 10, h = 10;

  for (int i = 0; i < ageNum; i++){

    writef ("myAgent_%d_x : ", i + 1);
    age_x[i] = readln.split[0].to!(int);

    writef ("myAgent_%d_y : ", i + 1);
    age_y[i] = readln.split[0].to!(int);
  }

  for (int i = 0; i < 10; i++)
  {
    for (int j = 0; j < 10; j++)
    {
      switch (colors[i][j]){
        case "red":
          writef ("\x1b[30m");
          writef ("\x1b[41m");
          break;
        case "blue":
        writef ("\x1b[44m");
        writef ("\x1b[30m");
          break;
          default:
          writef ("\x1b[49m");
          writef ("\x1b[39m");
          break;
      }
      writef ("%3d", eval[i][j]);
      writef ("\x1b[49m");
      writef ("\x1b[39m");
    }
    writef ("|");
    writeln();
  }

  int[9] branch = 0;

  foreach(e;0..ageNum){
    int posi_w = age_x[e];
    int posi_h = age_y[e];

    for (int i = 0; i < 9; i++){
      switch (i){
        case 0:
        if (posi_w == 1 || posi_h == 1) branch[i] = -250;
        else branch[i] = eval[posi_h - 2][posi_w - 2];
        break;

        case 1:
        if (posi_h == 1) branch[i] = -250;
        else branch[i] = eval[posi_h - 2][posi_w - 1];
        break;

        case 2:
        if (posi_w == w || posi_h == 1) branch[i] = -250;
        else branch[i] = eval[posi_h - 2][posi_w];
        break;

        case 3:
        if (posi_w == 1) branch[i] = -250;
        else branch[i] = eval[posi_h - 1][posi_w - 2];
        break;

        case 4:
        branch[i] = -1000;
        break;

        case 5:
        if (posi_w == w) branch[i] = -250;
        else branch[i] = eval[posi_h - 1][posi_w];
        break;

        case 6:
        if (posi_w == 1 || posi_h == h) branch[i] = -250;
        else branch[i] = eval[posi_h][posi_w - 2];
        break;

        case 7:
        if (posi_h == h) branch[i] = -250;
        else branch[i] = eval[posi_h][posi_w - 1];
        break;

        case 8:
        if (posi_w == w || posi_h == h) branch[i] = -250;
        else branch[i] = eval[posi_h][posi_w];
        break;

        default:
      }
    }
    int answer = 4;
    foreach(j; 0..9) if (branch[j] > branch[answer]) answer = j;
    if (e != 0) way ~= ",";
    way ~="myAgent_" ~ (e + 1).to!string ~ "_" ~ (answer + 1).to!string;
  }
  return (way);
}