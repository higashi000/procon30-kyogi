module Dia.outputField;

import std.stdio;

void outputFieldDate(int[][] fieldDate)
{
  auto outputFile = File("Field.csv", "w");

  foreach (col; 0 .. fieldDate.length) {
    foreach (line; 0 .. fieldDate[col].length) {
      outputFile.write(fieldDate[col][line]);
      if (line != fieldDate[col].length - 1)
        outputFile.write(" ");
    }
    outputFile.writeln;
  }

  outputFile.detach();
}
