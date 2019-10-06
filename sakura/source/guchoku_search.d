module sakura.guchoku_search;

import std.conv;
import std.range;
import std.stdio;
import std.file;
import std.container;

int range_begin = 0, range_end = 0;
int[20][20] eval;
int w, h;

void opencsv(){
  // ファイル名を拡張子無しで打ち込みひらく
  auto file_head = readln.split[0].to!string;
  string evl = readText(file_head ~ ".csv");

  // 仮にフィールドが width = 10 , hight = 10 とする
  w = 10;
  h = 10;

  // 評価値を配列に格納する
  for (int i = 0; i < w; i++){
    for (int j = 0; j < h; j++){
      while (evl[range_end] != ',') range_end++;
      eval[i][j] = to!(int)(evl[range_begin..range_end]);
      range_begin = ++range_end;
    }
  }

  for (int i = 0; i < w; i++){
    for (int j = 0; j < h; j++){
      writef ("%4d", eval[i][j]);
    }
    writeln();
  }
}

string guchoku_search(){

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
        if (posi_w == w || posi_h == 1) branch[i] = -250;
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