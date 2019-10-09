import std.stdio;
import std.range;
import std.conv;

import sakura.guchoku_search;

void main()
{
  write ("Maxturn : ");
  int Maxturn = readln.split[0].to!(int);
  
  // oターン目
  guchoku_first_search();

  // nターン目
  string ans;
  for (int i = 0; i < Maxturn; i++){
    ans = guchoku_search();
    writefln ("%d-turn's ans : %s", i + 1, ans);
  }
}
