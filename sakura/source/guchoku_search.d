module guchoku_search;

import std.conv;
import std.range;
import std.stdio;
import std.file;
import std.algorithm;

int[20][20] points;

int guchokusearch(int posi_w, int posi_h);

void search(string[] s){
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
    int ans = guchokusearch(age_x[i], age_y[i]);
    way ~="myAgent_" ~ (i + 1).to!string ~ "_" ~ ans.to!string ~ ",";
  }
  writeln (way);
}

// 探索
int guchokusearch(int posi_w, int posi_h){
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
        branch[i] = 0;
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

  int answer = 4;

  for (int i = 0; i < 9; i++){
    if (branch[i] > branch[answer]){
      answer = i;
    }
  }
  return (++answer);
}
