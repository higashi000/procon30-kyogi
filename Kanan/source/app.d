import std.stdio, std.conv, std.string, std.array;
import Kanan.field, Kanan.dispField, Kanan.montecarlo, Kanan.beamSearch, Kanan.connector, Kanan.sendData;
import core.thread;

// コマンドライン引数にMariのip,port,試合の最大ターン数をつけて
void main(string[] args)
{
  auto connector = new KananConnector(args[1], args[2].to!ushort);
  uint turn = 1;
  uint maxTurn = args[3].to!uint;


  while (turn <= maxTurn) {
    connector.getFieldData();
    auto field = connector.parseFieldData();
    writeln(turn);
    disp(field);
    writeln;
    field.calcTilePoint;
    field.calcMyAreaPoint;
    field.calcRivalAreaPoint;

    writeln(field.myTilePoint + field.myAreaPoint);
    writeln(field.rivalTilePoint + field.rivalAreaPoint);

    /* if (turn < maxTurn / 2) { */
    /*   auto beamSearch = new KananBeamSearch(field, turn, maxTurn, 20, 9 ^^ 3); */
    /*   beamSearch.searchAgentAction(); */
    /*   auto answer = beamSearch.bestAnswer(); */
    /*   connector.sendResult(answer); */
    /* } else { */


    // 人力卍 --- {{{
      Actions[] human;
      int[] dx = [0, -1, -1, 0, 1, 1, 1, 0, -1];
      int[] dy = [0, 0, -1, -1, -1, 0, 1, 1, 1];

      foreach (i; 0 .. field.agentNum) {
        int humanPower;
        int tmp;
        string humanMove;
        writef("エージェント方向 >> ");
        readf("%d\n", &humanPower);
        writef("エージェント動き (1: move, 2: stay, 3: remove)>> ");
        readf("%d\n", tmp);
        if (tmp == 1)
          humanMove = "move";
        else if (tmp == 2)
          humanMove = "stay";
        else
          humanMove = "remove";
        human ~= Actions(i + 4, humanMove, dx[humanPower], dy[humanPower]);
      }
  //}}}

      auto montecarlo = new MontecarloTreeSearch(field, turn, maxTurn, 4500, 20);
      auto answer = montecarlo.playGame();
      connector.sendResult(answer);
      Thread.sleep(dur!("seconds")(3));
      connector.sendHumanResult(human);
    /* } */


    turn++;
  }
  auto field = connector.parseFieldData();
  disp(field);
  writeln;
  field.calcTilePoint;
  field.calcMyAreaPoint;
  field.calcRivalAreaPoint;
}
