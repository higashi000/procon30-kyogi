module Dia.GeneFieldNum;

void getFieldSize(ref int x, ref int y)
{
  import std.random;

  auto rnd = Random(unpredictableSeed);

  x = uniform(5, 10, rnd);
  y = uniform(5, 10, rnd);
}

int getFieldNum()
{
  import std.random;

  auto rnd = Random(unpredictableSeed);

  // -16から16のランダムな整数を返す
  return uniform(-16, 16, rnd);
}

void setFieldNum(ref int[][] field)
{
  import std.stdio, std.algorithm;

  int mapLenX;
  int mapLenY;

  getFieldSize(mapLenX, mapLenY);

  field = new int[][](mapLenY, mapLenX);

  foreach (col; 0 .. mapLenY) {
    foreach (line; 0 .. mapLenX) {
      field[col][line] = getFieldNum();
    }
  }

  auto fieldCopy = field;

  foreach (col; 0 .. mapLenY) {
    foreach_reverse (line; 0 .. mapLenX) {
      field[col] ~= fieldCopy[col][line];
    }
  }

  fieldCopy = field;

  foreach_reverse (col; 0 .. mapLenY) {
    field ~= fieldCopy[col];
  }

  foreach (col; 0 .. mapLenY * 2) {
    field[col].writeln;
  }
}
