module Dia.outputField;

import std.stdio;

void outputFieldDate(int[][] fieldDate)
{
  auto outputFile = File("Field.csv", "w");

  foreach (col; 0 .. fieldDate.length)
    outputFile.writeln(fieldDate[col]);

  outputFile.detach();
}
