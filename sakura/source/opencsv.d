module sakura.opencsv;

import std.stdio;
import std.range;
import std.file;
import std.conv;

int range_begin = 0, range_end = 0;
int w, h;

int[20][20] opencsv(string file_head){

  range_begin = 0;
  range_end = 0;
  int[20][20] eval;
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
  return (eval);
}