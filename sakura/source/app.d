import std.stdio;
import std.range;
import std.conv;

import sakura.guchoku_search;
import sakura.opencsv;

void main()
{
  int[20][20] eval = opencsv(readln.split[0].to!string);
  string ans = guchoku_search(eval);
  write (ans);
}
