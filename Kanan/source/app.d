import std.stdio, std.conv;
import Kanan.field, Kanan.montecarlo, Kanan.beamSearch, Kanan.connector;

// コマンドライン引数にMariのip,port,試合の最大ターン数をつけて
void main(string[] args)
{
  auto connector = new KananConnector(args[1], args[2].to!ushort);
  uint turn = 1;
  uint maxTurn = args[3].to!uint;


  while (turn <= maxTurn) {
    auto field = connector.getFieldData().parseFieldData();

    if (turn < maxTurn / 2) {
      auto beamSearch = new KananBeamSearch(field, turn, maxTurn, 9 ^^ 3);
      auto answer = beamSearch.searchAgentAction().bestAnswer();
      connector.sendResult(answer);
    } else {
      auto montecarlo = new Montecarlo(field, turn, maxTurn, 1000);
      auto answer = montecarlo.bestAnswer();

      connector.sendResult(answer);
    }

    turn++;
  }
}
