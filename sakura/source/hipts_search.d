module sakura.hipts_search;

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
}

void hipts_search(){

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
}