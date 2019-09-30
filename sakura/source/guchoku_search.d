module guchoku_search;

import std.conv;
import std.range;
import std.stdio;
import std.file;
import std.algorithm;

int[20][20] points;
int w;
int h;

void opencsv();
int beamsearch(int posi_w, int posi_h);

void main(string[] s){
  auto file_head = s[1]; // readln.split[0].to!(string);
  opencsv(file_head);

  write ("ageNum : ");
  auto ageNum = readln.split[0].to!(int);
  string way;
  int[10] age_x;
  int[10] age_y;

  for (int i = 0; i < ageNum; i++){
    writef ("myAgent_%d_x : ", i + 1);
    age_x[i] = readln.split[0].to!(int);

    writef ("myAgent_%d_y : ", i + 1);
    age_y[i] = readln.split[0].to!(int);
  }

  for (int i = 0; i < ageNum; i++){
    int ans = beamsearch(age_x[i], age_y[i]);
    way ~="myAgent_" ~ (i + 1).to!string ~ "_" ~ ans.to!string ~ ",";
  }
  writeln (way);
}

// csvを読み込むところ
void opencsv(string s){
  int range_begin = 0, range_end = 0;

  auto pts = readText(s ~ ".csv");

  write ("f_x : ");
  w = readln.split[0].to!(int);

  write ("f_y : ");
  h = readln.split[0].to!(int);

  for (int i = 0; i < w; i++){
    for (int j = 0; j < h; j++){
      while (pts[range_end] != ',') range_end++;
      points[i][j] = to!(int)(pts[range_begin..range_end]);
      range_begin = ++range_end;
    }
  }
}

// 探索
int beamsearch(int posi_w, int posi_h){
  // 枝の配列
  int[9] branch = 0;

  // 1手先
  for (int i = 0; i < 9; i++){
    switch (i){
      case 0:
        if (posi_w == 1 || posi_h == 1) branch[i] = -250;
        else branch[i] = points[posi_h - 2][posi_w - 2];
        break;

      case 1:
        if (posi_h == 1) branch[i] = -250;
        else branch[i] = points[posi_h - 2][posi_w - 1];
        break;

      case 2:
        if (posi_w == w || posi_h == 1) branch[i] = -250;
        else branch[i] = points[posi_h - 2][posi_w];
        break;

      case 3:
        if (posi_w == 1) branch[i] = -250;
        else branch[i] = points[posi_h - 1][posi_w - 2];
        break;

      case 4:
        branch[i] = -500;
        break;

      case 5:
        if (posi_w == w) branch[i] = -250;
        else branch[i] = points[posi_h - 1][posi_w];
        break;

      case 6:
        if (posi_w == 1 || posi_h == h) branch[i] = -250;
        else branch[i] = points[posi_h][posi_w - 2];
        break;

      case 7:
        if (posi_h == h) branch[i] = -250;
        else branch[i] = points[posi_h][posi_w - 1];
        break;

      case 8:
        if (posi_w == w || posi_h == h) branch[i] = -250;
        else branch[i] = points[posi_h][posi_w];
        break;

      default:
    }
  }

  int first_branch = 4;

  for (int i = 0; i < 9; i++){
    if (branch[i] > branch[first_branch]){
      first_branch = i;
    }
  }

  // 2手先以降

  /*
  for (int hoge = 0; hoge < 3; hoge++){
    switch(first_branch){
      case 0:
        posi_w += -1;
        posi_h += -1;
        break;

      case 1:
        posi_h += -1;
        break;

      case 2:
        posi_w += 1;
        posi_h += -1;
        break;

      case 3:
        posi_h += -1;
        break;

      case 5:
        posi_h += 1;
        break;

      case 6:
        posi_w += -1;
        posi_h += 1;
        break;

      case 7:
        posi_h += 1;
        break;

      case 8:
        posi_w += 1;
        posi_h += 1;
        break;

      default:
    }

    for (int i = 0; i < 9; i++){
      switch (i){
        case 0:
          if (posi_w == 1 || posi_h == 1 || first_branch == 8) branch[i] = -250;
          else branch[i] = points[posi_h - 2][posi_w - 2];
          break;

        case 1:
          if (posi_h == 1 || first_branch == 7) branch[i] = -250;
          else branch[i] = points[posi_h - 2][posi_w - 1];
          break;

        case 2:
          if (posi_w == w || posi_h == 1 || first_branch == 6) branch[i] = -250;
          else branch[i] = points[posi_h - 2][posi_w];
          break;

        case 3:
          if (posi_w == 1 || first_branch == 5) branch[i] = -250;
          else branch[i] = points[posi_h - 1][posi_w - 2];
          break;

        case 4:
          branch[i] = -500;
          break;

        case 5:
          if (posi_w == w || first_branch == 3) branch[i] = -250;
          else branch[i] = points[posi_h - 1][posi_w];
          break;

        case 6:
          if (posi_w == 1 || posi_h == h || first_branch == 2) branch[i] = -250;
          else branch[i] = points[posi_h][posi_w - 2];
          break;

        case 7:
          if (posi_h == h || first_branch == 1) branch[i] = -250;
          else branch[i] = points[posi_h][posi_w - 1];
          break;

        case 8:
          if (posi_w == w || posi_h == h || first_branch == 0) branch[i] = -250;
          else branch[i] = points[posi_h][posi_w];
          break;

        default:
      }
    }

    first_branch = 4;

    for (int i = 0; i < 9; i++) if (branch[i] > branch[first_branch]) first_branch = i;
  }
  */

  return (++first_branch);
}
