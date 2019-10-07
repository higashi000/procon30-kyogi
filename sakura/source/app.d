import std.stdio;
import std.range;
import std.conv;

import sakura.guchoku_search;

void main()
{
  string ans = guchoku_first_search();
  write (ans);
}
