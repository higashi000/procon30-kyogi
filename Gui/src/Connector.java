import java.awt.print.PrinterGraphics;
import java.io.IOException;
import java.lang.reflect.Array;
import java.lang.reflect.Field;
import java.net.Socket;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.channels.SocketChannel;
import java.util.ArrayList;
import java.util.List;

public class Connector {

  static short port;
  static String ip;

  Connector(String ip, short port) {
    this.ip = ip;
    this.port = port;
  }

  public static String getFieldData() {
    String fieldStr = "";
    try {
      Socket socket = new Socket(ip, port);
      InputStream rsv = socket.getInputStream();
      OutputStream send = socket.getOutputStream();
      byte[] rsvData = new byte[1000];

      send.write("1".getBytes("UTF-8"));
      var dataLen = rsv.read(rsvData);
      rsv.close();

      socket.close();

      byte[] necessaryBytes = new byte[dataLen];

      for (int i = 0; i < dataLen; ++i) {
        necessaryBytes[i] = rsvData[i];
      }

      fieldStr = new String(necessaryBytes, "UTF-8");
    } catch (IOException e) {
      e.printStackTrace();
    }

    System.out.println(fieldStr);
    return fieldStr;
  }

  public  static FieldData parseRsvData() {
    var parseStr = getFieldData().split("\n", 0);

    var tmpParseData = parseStr[0].split(" ", 0);
    FieldData afterParse = new FieldData(Integer.parseInt(tmpParseData[0]),
                                         Integer.parseInt(tmpParseData[1]),
                                         Integer.parseInt(parseStr[5]));

    tmpParseData = parseStr[1].split(";", 0);
    for (int i = 0; i < afterParse.height; ++i) {
      var tmp = tmpParseData[i].split(" ", 0);
      for (int j = 0; j < afterParse.width; ++j) {
        afterParse.points[i][j] = Integer.parseInt((tmp[j]));
      }
    }

    afterParse.startedUnixTime = Integer.parseInt(parseStr[2]);
    afterParse.turn = Integer.parseInt(parseStr[3]);

    tmpParseData = parseStr[4].split(";", 0);
    for (int i = 0; i < afterParse.height; ++i) {
      var tmp = tmpParseData[i].split(" ", 0);
      for (int j = 0; j < afterParse.width; ++j) {
        afterParse.color[i][j] = Integer.parseInt((tmp[j]));
      }
    }

    afterParse.myTeamID = Integer.parseInt(parseStr[6]);

    tmpParseData = parseStr[7].split(";", 0);
    for (int i = 0; i < afterParse.agentNum; ++i) {
      var tmp = tmpParseData[i].split(" ", 0);
      afterParse.myAgentData[i][0] = Integer.parseInt(tmp[0]);
      afterParse.myAgentData[i][1] = Integer.parseInt(tmp[1]);
      afterParse.myAgentData[i][2] = Integer.parseInt(tmp[2]);
    }

    tmpParseData = parseStr[8].split(" ", 0);
    afterParse.myTilePoint = Integer.parseInt(tmpParseData[0]);
    afterParse.myAreaPoint = Integer.parseInt(tmpParseData[1]);

    afterParse.rivalTeamID = Integer.parseInt(parseStr[9]);

    tmpParseData = parseStr[10].split(";", 0);
    for (int i = 0; i < afterParse.agentNum; ++i) {
      var tmp = tmpParseData[i].split(" ", 0);
      afterParse.rivalAgentData[i][0] = Integer.parseInt(tmp[0]);
      afterParse.rivalAgentData[i][1] = Integer.parseInt(tmp[1]);
      afterParse.rivalAgentData[i][2] = Integer.parseInt(tmp[2]);
    }

    tmpParseData = parseStr[11].split(" ", 0);
    afterParse.rivalTilePoint = Integer.parseInt(tmpParseData[0]);
    afterParse.rivalAreaPoint = Integer.parseInt(tmpParseData[1]);

    afterParse.maxTurn = Integer.parseInt(parseStr[12]);

    return afterParse;
  }
}