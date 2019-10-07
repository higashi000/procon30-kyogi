module sakura.tile;

struct Tile {
  import Sakura.agent;
  import sakura.color;

  Agent agent = Agent.Null;
  Color color = Color.White;
  int tilePoint;
}
