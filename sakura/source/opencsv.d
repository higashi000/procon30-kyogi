module opencsv;

import std.conv;
import std.range;
import std.stdio;
import std.file;

void opencsv(string[] hoge)
{
  int range_begin = 0, range_end = 0;
  int[20][20] eval_value = 0;
  auto evl = readText(hoge[1] ~ ".csv");
  auto wh = hoge[2].to!(int);

  for (int i = 0; i < wh; i++){
    for (int j = 0; j < wh; j++){
      while (evl[range_end] != ',') range_end++;
      eval_value[i][j] = to!(int)(evl[range_begin..range_end]);
      range_begin = ++range_end;
    }
  }
  return (eval_value);
}
