module sakura.guchoku_search;

import std.conv;
import std.range;
import std.stdio;
import std.file;
import std.container;

import sakura.opencsv;

int[20][20] eval;
int[20][20] points;
string [20][20] colors =[["white","white","white","white","white","white","white","white","white","white"],
                          ["white","white","white","white","white","white","white","white","white","white"],
                          ["white","white","white","white","white","white","white","white","white","white"],
                          ["white","white","white","white","white","white","white","white","white","white"],
                          ["white","white","white","white","white","white","white","white","white","white"],
                          ["white","white","white","white","white","white","white","white","white","white"],
                          ["white","white","white","white","white","white","white","white","white","white"],
                          ["white","white","white","white","white","white","white","white","white","white"],
                          ["white","white","white","white","white","white","white","white","white","white"],
                          ["white","white","white","white","white","white","white","white","white","white"]];

int ageNum;
string way;

int[10] my_age_x = 0, my_age_y = 0;
int[10] teki_age_x  = 0, teki_age_y = 0;
int w = 10, h = 10;
int[10] ans = 11;

void guchoku_first_search()
{
  way = null;
  write ("eval_head : ");
  eval = evalcsv(readln.split[0].to!string);
  writeln();

  write ("points_head : ");
  points = pointscsv(readln.split[0].to!string);
  writeln();

  write ("ageNum : ");
  ageNum = readln.split[0].to!(int);
  writeln();

  for (int i = 0; i < ageNum; i++)
  {
    writef ("myAgent_%d_x : ", i + 1);
    my_age_x[i] = readln.split[0].to!(int);

    writef ("myAgent_%d_y : ", i + 1);
    my_age_y[i] = readln.split[0].to!(int);

    colors[my_age_y[i] - 1][my_age_x[i] - 1] = "blue";
  }

  writeln();

  for (int i = 0; i < ageNum; i++){

    writef ("tekiAgent_%d_x : ", i + 1);
    teki_age_x[i] = readln.split[0].to!(int);

    writef ("tekiAgent_%d_y : ", i + 1);
    teki_age_y[i] = readln.split[0].to!(int);

    colors[teki_age_y[i] - 1][teki_age_x[i] - 1] = "red";
  }

  writeln();

  for (int i = 0; i < w; i++)
  {
    for (int j = 0; j < h; j++)
    {
      switch (colors[i][j])
      {

        case "red":
        writef ("\x1b[30m"); // 黒字
        writef ("\x1b[41m"); // 赤背景
        break;

        case "blue":
        writef ("\x1b[44m"); // 青背景
        writef ("\x1b[30m"); // 黒字
        break;

        default:
        writef ("\x1b[49m");
        writef ("\x1b[39m");
        break;
      }
      writef ("%3d", points[i][j]);
      writef ("\x1b[49m");
      writef ("\x1b[39m");
    }
    writeln();
  }
}

void change_color(){
  for (int i = 0; i < w; i++)
  {
    for (int j = 0; j < h; j++)
    {
      if (colors[i][j] == "blue")
      {
        colors[i][j] = "cyan";
      }
      if (colors[i][j] == "red")
      {
        colors[i][j] = "magenta";
      }
    }
  }
}

void teki_way(){
  for (int i = 0; i < ageNum; i++)
  {
    writef ("teki_ans[%d] : ", i + 1);
    int teki_ans = readln.split[0].to!(int);

    switch (teki_ans)
    {
      case 1:
        --teki_age_x[i];
        --teki_age_y[i];
        break;

      case 2:
        --teki_age_y[i];
        break;

      case 3:
        ++teki_age_x[i];
        --teki_age_y[i];
        break;

      case 4:
        --teki_age_x[i];
        break;

      case 6:
        ++teki_age_x[i];
        break;

      case 7:
        --teki_age_x[i];
        ++teki_age_y[i];
        break;

      case 8:
        ++teki_age_y[i];
        break;

      case 9:
        ++teki_age_x[i];
        ++teki_age_y[i];
        break;

      default:
      break;
    }
    colors[teki_age_y[i] - 1][teki_age_x[i] - 1] = "red";
    writefln ("teki_age_x[%d] : %d", i + 1, teki_age_x[i]);
    writefln ("teki_age_y[%d] : %d", i + 1, teki_age_y[i]);
  }
}

string guchoku_search(){
  way = null;

  change_color();
  teki_way();
  writeln();

  int[9] branch = 0;

  foreach(e;0..ageNum)
  {
    int posi_w = my_age_x[e];
    int posi_h = my_age_y[e];

    for (int i = 0; i < 9; i++)
    {
      switch (i)
      {
        case 0:
        if (posi_w == 1 || posi_h == 1) branch[i] = -2000;
        else if (ans[i] == 9 || colors[posi_h - 2][posi_w - 2] == "cyan") branch[i] = -250;
        else branch[i] = eval[posi_h - 2][posi_w - 2];
        break;

        case 1:
        if (posi_h == 1) branch[i] = -2000;
        else if (ans[i] == 8 || colors[posi_h - 2][posi_w - 1] == "cyan")  branch[i] = -250;
        else branch[i] = eval[posi_h - 2][posi_w - 1];
        break;

        case 2:
        if (posi_w == w || posi_h == 1)  branch[i] = -2000;
        else if (ans[i] == 7 || colors[posi_h - 2][posi_w] == "cyan")branch[i] = -250;
        else branch[i] = eval[posi_h - 2][posi_w];
        break;

        case 3:
        if (posi_w == 1) branch[i] = -2000;
        else if (ans[i] == 6 || colors[posi_h - 1][posi_w - 2] == "cyan") branch[i] = -250;
        else branch[i] = eval[posi_h - 1][posi_w - 2];
        break;

        case 4:
        branch[i] = -100;
        break;

        case 5:
        if (posi_w == w) branch[i] = -2000;
        else if (ans[i] == 4 || colors[posi_h - 1][posi_w] == "cyan")  branch[i] = -250;
        else branch[i] = eval[posi_h - 1][posi_w];
        break;

        case 6:
        if (posi_w == 1 || posi_h == h) branch[i] = -2000;
        else if (ans[i] == 3 || colors[posi_h][posi_w - 2] == "cyan") branch[i] = -2000;
        else branch[i] = eval[posi_h][posi_w - 2];
        break;

        case 7:
        if (posi_h == h) branch[i] = -2000;
        else if (ans[i] == 2 || colors[posi_h][posi_w - 1] == "cyan") branch[i] = -250;
        else branch[i] = eval[posi_h][posi_w - 1];
        break;

        case 8:
        if (posi_w == w || posi_h == h) branch[i] = -2000;
        else if (ans[i] == 1 || colors[posi_h][posi_w] == "cyan") branch[i] = -250;
        else branch[i] = eval[posi_h][posi_w];
        break;

        default:
      }
    }

    int answer = 4;
    foreach(j; 0..9)
    {
      if (branch[j] > branch[answer])
      {
        answer = j;
      }
    }
    if (e != 0)
    {
      way ~= ",";
    }

    way ~="myAgent_" ~ (e + 1).to!string ~ "_" ~ (answer + 1).to!string;
    ans[e] = answer + 1;

    switch (answer + 1)
    {
      case 1:
        my_age_x[e]--;
        my_age_y[e]--;
        break;

      case 2:
        my_age_y[e]--;
        break;

      case 3:
        my_age_x[e]++;
        my_age_y[e]--;
        break;

      case 4:
        my_age_x[e]--;
        break;

      case 5:
        break;

      case 6:
        my_age_x[e]++;
        break;

      case 7:
        my_age_y[e]++;
        my_age_x[e]--;
        break;

      case 8:
        my_age_y[e]++;
        break;

      case 9:
        my_age_y[e]++;
        my_age_x[e]++;
        break;

      default:
      break;
    }

    colors[my_age_y[e] - 1][my_age_x[e] - 1] = "blue";

    if (e == ageNum - 1)
    {
      for (int i = 0; i < w; i++)
      {
        for (int j = 0; j < h; j++)
        {
          switch (colors[i][j])
          {
            case "red":
            writef ("\x1b[30m"); // 黒字
            writef ("\x1b[41m"); // 赤背景
            break;

            case "blue":
            writef ("\x1b[44m"); // 青背景
            writef ("\x1b[30m"); // 黒字
            break;

            case "cyan":
            writef ("\x1b[39m"); // デフォルト字
            writef ("\x1b[46m"); // シアン背景
            break;

            case "magenta":
            writef ("\x1b[39m"); // デフォルト字
            writef ("\x1b[45m"); // 赤背景
            break;

            default:
            writef ("\x1b[49m");
            writef ("\x1b[39m");
            break;
          }
          writef ("%3d", points[i][j]);
          writef ("\x1b[49m");
          writef ("\x1b[39m");
        }
        writeln();
      }
    }
  }
  writeln();
  return (way);
}