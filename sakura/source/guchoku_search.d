module sakura.guchoku_search;

import std.conv;
import std.range;
import std.stdio;
import std.file;
import std.container;

import sakura.opencsv;

int[20][20] eval;
string [20][20] colors = [["white","white","white","white","white","white","white","white","white","white"],["white","white","white","white","white","white","white","white","white","white"],["white","white","white","white","white","white","white","white","white","white"],["white","white","white","white","white","white","white","white","white","white"],["white","white","white","white","white","white","white","white","white","white"],["white","white","white","white","white","white","white","white","white","white"],["white","white","white","white","white","white","white","white","white","white"],["white","white","white","white","white","white","white","white","white","white"],["white","white","white","white","white","white","white","white","white","white"],["white","white","white","white","white","white","white","white","white","white"]];

int ageNum;
string way;

int[10] my_age_x, my_age_y;
int[10] teki_age_x, teki_age_y;
int w = 10, h = 10;

void guchoku_first_search(){
  way = null;
  write ("file_head : ");
  eval = opencsv(readln.split[0].to!string);
  writeln();

  write ("ageNum : ");
  ageNum = readln.split[0].to!(int);
  writeln();

  for (int i = 0; i < ageNum; i++){

    writef ("myAgent_%d_x : ", i + 1);
    my_age_x[i] = readln.split[0].to!(int);

    writef ("myAgent_%d_y : ", i + 1);
    my_age_y[i] = readln.split[0].to!(int);

    colors[my_age_y[i] - 1][my_age_x[i] - 1] = "blue";
  }

  writeln();

  for (int i = 0; i < ageNum; i++){

    writef ("tekiAgent_%d_x : ", i + 1);
    teki_age_x[i] = readln.split[0].to!(int);

    writef ("tekiAgent_%d_y : ", i + 1);
    teki_age_y[i] = readln.split[0].to!(int);

    colors[teki_age_y[i] - 1][teki_age_x[i] - 1] = "red";
  }

  writeln();

  for (int i = 0; i < w; i++)
  {
    for (int j = 0; j < h; j++)
    {
      switch (colors[i][j]){

        case "red":
          writef ("\x1b[30m"); // 黒字
          writef ("\x1b[41m"); // 赤背景
          break;

        case "blue":
          writef ("\x1b[44m"); // 青背景
          writef ("\x1b[30m"); // 黒字
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
    writeln();
  }
}

string guchoku_search(){
  way = null;

  for (int i = 0; i < w; i++){
    for (int j = 0; j < h; j++){
      if (colors[i][j] == "cyan") colors[i][j] = "blue";
      if (colors[i][j] == "red") colors[i][j] = "magenta";
    }
  }
  writeln();
  for (int i = 0; i < ageNum; i++){
    writef ("teki_ans[%d] : ", i + 1);
    int teki_ans = readln.split[0].to!(int);

    switch (teki_ans){

      case 1:
        teki_age_x[i]--;
        teki_age_y[i]--;
        break;

      case 2:
        teki_age_x[i]--;
        break;

      case 3:
        teki_age_x[i]--;
        teki_age_y[i]++;
        break;

      case 4:
        teki_age_y[i]--;
        break;

      case 6:
        teki_age_y[i]++;
        break;

      case 7:
        teki_age_x[i]++;
        teki_age_y[i]--;
        break;

      case 8:
        teki_age_x[i]++;
        break;

      case 9:
        teki_age_x[i]++;
        teki_age_y[i]++;
        break;

      default:
      break;
    }
    colors[teki_age_y[i] - 1][teki_age_x[i] - 1] = "red";
  }

  int[9] branch = 0;

  foreach(e;0..ageNum){
    int posi_w = my_age_x[e];
    int posi_h = my_age_y[e];

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

    if (e == ageNum - 1){
      for (int i = 0; i < w; i++){
      for (int j = 0; j < h; j++){
        switch (colors[j][i]){

        case "red":
          writef ("\x1b[30m"); // 黒字
          writef ("\x1b[41m"); // 赤背景
          break;

        case "cyan":
          writef ("\x1b[44m"); // 青背景
          writef ("\x1b[30m"); // 黒字
          break;

        case "blue":
          writef ("\x1b[39m"); // デフォルト字
          writef ("\x1b[46m"); // シアン背景
          break;

         case "magenta":
          writef ("\x1b[39m"); // デフォルト字
          writef ("\x1b[45m"); // 赤背景
          break;

        default:
          writef ("\x1b[49m");
          writef ("\x1b[39m");
          break;
      }
      writef ("%3d", eval[j][i]);
      writef ("\x1b[49m");
      writef ("\x1b[39m");
    }
    writeln();
  }
    }

    int answer = 4;
    foreach(j; 0..9) if (branch[j] > branch[answer]) answer = j;
    if (e != 0) way ~= ",";
    way ~="myAgent_" ~ (e + 1).to!string ~ "_" ~ (answer + 1).to!string;
    switch (answer + 1){

      case 1:
        my_age_x[e]--;
        my_age_y[e]--;
        break;

      case 2:
        my_age_x[e]--;
        break;

      case 3:
        my_age_x[e]--;
        my_age_y[e]++;
        break;

      case 4:
        my_age_y[e]--;
        break;

      case 6:
        my_age_y[e]++;
        break;

      case 7:
        my_age_x[e]++;
        teki_age_y[e]--;
        break;

      case 8:
        my_age_x[e]++;
        break;

      case 9:
        my_age_x[e]++;
        my_age_y[e]++;
        break;

      default:
      break;
    }
    colors[my_age_y[e] - 1][my_age_x[e] - 1] = "blue";
  }
  writeln();
  return (way);
}