module Kanan.connector;

import Kanan.rsvData;
import std.stdio;

class KananConnector {
  rsvClientData rsvTemp;

  void getMariData(int[][] fieldColor, int[][] myAgentData, int[][] rivalAgentData)
  {
    rsvTemp.fieldColor = fieldColor;
    rsvTemp.myAgentData = myAgentData;
    rsvTemp.rivalAgentData = rivalAgentData;

    foreach (i; 0 .. rsvTemp.fieldColor.length) {
      foreach (j; 0 .. rsvTemp.fieldColor[0].length) {
        write(rsvTemp.fieldColor[i][j], " ");
      }
      writeln;
    }
  }
}
