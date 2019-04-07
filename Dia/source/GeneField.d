module Dia.GeneField;

void getFieldSize(ref int x, ref int y)
{
  import std.random;

  auto rnd = Random(unpredictableSeed);

  x = uniform(10, 20, rnd);
  y = uniform(10, 20, rnd);
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

  writeln(mapLenX, " ", mapLenY);

  field = new int[][](mapLenY / 2, mapLenX / 2);

  foreach (col; 0 .. mapLenY / 2) {
    foreach (line; 0 .. mapLenX / 2) {
      field[col][line] = getFieldNum();
    }
  }

  if ((mapLenX % 2) == 1) {
    auto fieldCopy = field;
    foreach (col; 0 .. mapLenY / 2) {
      field[col] ~= getFieldNum();
    }

    foreach (col; 0 .. (mapLenY / 2)) {
      foreach_reverse (line; 0 .. (mapLenX / 2)) {
        field[col] ~= fieldCopy[col][line];
      }
    }
  } else {
    auto fieldCopy = field;
    foreach (col; 0 .. (mapLenY / 2)) {
      foreach_reverse (line; 0 .. (mapLenX / 2)) {
        field[col] ~= fieldCopy[col][line];
      }
    }
  }

  if ((mapLenY % 2) == 1) {
    int[] addField;
    foreach (line; 0 .. (mapLenX / 2))
      addField ~= getFieldNum();

    if (mapLenX % 2 == 1)
      addField ~= getFieldNum();

    auto addFieldCopy = addField;
    foreach_reverse (line; 0 .. addFieldCopy.length - (mapLenX % 2))
      addField ~= addFieldCopy[line];
    field ~= addField;
    auto fieldCopy = field;

    foreach_reverse (col; 0 .. (mapLenY / 2))
      field ~= fieldCopy[col];

  } else {
    auto fieldCopy = field;

    foreach_reverse (col; 0 .. mapLenY / 2)
      field ~= fieldCopy[col];
  }

  foreach (i; 0 .. mapLenY)
    writeln(field[i]);
}
