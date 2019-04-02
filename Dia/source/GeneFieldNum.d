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

void setFieldNum()
{
  import std.stdio;

  int mapLenX;
  int mapLenY;

  getFieldSize(mapLenX, mapLenY);

  int[][] field = new int[][](mapLenY, mapLenX);

  foreach (col; 0 .. mapLenY) {
    foreach (line; 0 .. mapLenX) {
      field[col][line] = getFieldNum();
    }
  }


  foreach (col; 0 .. mapLenY) {
    foreach (line; 0 .. mapLenX) {
      write(field[col][line], " ");
    }
    writeln;
  }
}
