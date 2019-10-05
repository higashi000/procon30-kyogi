module sakura.hipts_search;

import std.conv;
import std.range;
import std.stdio;
import std.file;

int range_begin = 0, range_end = 0;
int[20][20] eval;
int w, h;

void opencsv(){
  auto file_head = readln.split[0].to!string;
  string evl = readText(file_head ~ ".csv");
  w = 10;
  h = 10;
  for (int i = 0; i < w; i++){
    for (int j = 0; j < h; j++){
      while (evl[range_end] != ',') range_end++;
      eval[i][j] = to!(int)(evl[range_begin..range_end]);
      range_begin = ++range_end;
    }
  }
}