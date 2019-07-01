module Kanan.tile;

struct Tile {
  import Kanan.agent;
  import Kanan.color;

  Agent agent = Agent.Null;
  Color color = Color.White;
  int tilePoint;
}
