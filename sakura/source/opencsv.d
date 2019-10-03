module opencsv;

import std.conv;
import std.range;
import std.stdio;
import std.file;

void opencsv(string s, string file_head, int w, int h)
{
  int range_begin = 0, range_end = 0;
  int[20][20] eval_value = 0;
  auto evl = readText(file_head ~ ".csv");

  for (int i = 0; i < w; i++){
    for (int j = 0; j < h; j++){
      while (evl[range_end] != ',') range_end++;
      eval_value[i][j] = to!(int)(evl[range_begin..range_end]);
      range_begin = ++range_end;
    }
  }
}
