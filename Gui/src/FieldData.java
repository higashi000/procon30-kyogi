public class FieldData {

  FieldData(int width, int height, int agentNum) {
    this.width = width;
    this.height = height;
    this.points = new int[height][width];
    this.startedUnixTime = 0;
    this.color = new int[height][width];
    this.agentNum = agentNum;
    this.myTeamID = 0;
    this.myAgentData = new int[agentNum][3];
    this.myTilePoint = 0;
    this.myAreaPoint = 0;
    this.rivalTeamID = 0;
    this.rivalAgentData = new int[agentNum][3];
    this.rivalTilePoint = 0;
    this.rivalAreaPoint = 0;
    this.maxTurn = 0;
    this.turn = 0;
  }
  int width;
  int height;
  int[][] points;
  int startedUnixTime;
  int[][] color;
  int agentNum;
  int myTeamID;
  int[][] myAgentData;
  int myTilePoint;
  int myAreaPoint;
  int rivalTeamID;
  int[][] rivalAgentData;
  int rivalTilePoint;
  int rivalAreaPoint;
  int maxTurn;
  int turn;
}
