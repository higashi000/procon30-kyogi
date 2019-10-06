module sakura.guchoku_search;

import std.conv;
import std.range;
import std.stdio;
import std.file;
import std.container;

string guchoku_search(int[20][20] eval){

  write ("ageNum : ");
  auto ageNum = readln.split[0].to!(int);
  string way;
  int[10] age_x;
  int[10] age_y;

  for (int i = 0; i < ageNum; i++){
    writef ("myAgent_%d_x : ", i + 1);
    age_x[i] = readln.split[0].to!(int);

    writef ("myAgent_%d_y : ", i + 1);
    age_y[i] = readln.split[0].to!(int);
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
        if (posi_w == 10 || posi_h == 1) branch[i] = -250;
        else branch[i] = eval[posi_h - 2][posi_w];
        break;

        case 3:
        if (posi_w == 1) branch[i] = -250;
        else branch[i] = eval[posi_h - 1][posi_w - 2];
        break;

        case 4:
        branch[i] = 0;
        break;

        case 5:
        if (posi_w == 10) branch[i] = -250;
        else branch[i] = eval[posi_h - 1][posi_w];
        break;

        case 6:
        if (posi_w == 1 || posi_h == 10) branch[i] = -250;
        else branch[i] = eval[posi_h][posi_w - 2];
        break;

        case 7:
        if (posi_h == 10) branch[i] = -250;
        else branch[i] = eval[posi_h][posi_w - 1];
        break;

        case 8:
        if (posi_w == 10 || posi_h == 10) branch[i] = -250;
        else branch[i] = eval[posi_h][posi_w];
        break;

        default:
      }
    }
  }

  foreach (e;0..ageNum){
    int answer = 4;
    for (int i = 0; i < 9; i++){
      if (branch[i] > branch[answer]){
        answer = i;
      }
    }
    if (e != 0) way ~= ",";
    way ~="myAgent_" ~ (e + 1).to!string ~ "_" ~ (answer + 1).to!string;
  }
  return (way);
}