module Sakura.tile;

struct Tile {
  import Sakura.agent;
  import Sakura.color;

  Agent agent = Agent.Null;
  Color color = Color.White;
  int tilePoint;
}
