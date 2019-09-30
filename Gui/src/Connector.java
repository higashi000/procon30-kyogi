import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;

public class Connector {

  static short port;
  static String ip;

  Connector(String ip, short port) {
    this.ip = ip;
    this.port = port;
  }

  public static FieldData getFieldData() {
    String fieldStr = "";
    try {
      // ローカルサーバーに接続
      Socket socket = new Socket(ip, port);
      // 受取用の変数と送信用の変数の確保
      InputStream rsv = socket.getInputStream();
      OutputStream send = socket.getOutputStream();

      // 受取先byte配列(ひとまず1000確保しとく)
      byte[] rsvData = new byte[1000];

      // ローカルサーバーにフィールドデータの要求
      send.write("1f".getBytes("UTF-8"));

      // フィールドデータのbyte配列の受取とその長さの受取
      var dataLen = rsv.read(rsvData);
      // 受取用ストリームを閉じる
      rsv.close();

      // ソケットを閉じる
      socket.close();

      byte[] necessaryBytes = new byte[dataLen];

      // rsvDataの後ろについてる何も入ってない部分の削除
      for (int i = 0; i < dataLen; ++i) {
        necessaryBytes[i] = rsvData[i];
      }

      // 文字列に変換
      fieldStr = new String(necessaryBytes, "UTF-8");
    } catch (IOException e) {
      e.printStackTrace();
    }

    return parseRsvData(fieldStr);
  }

  public static  void sendResult(Action[] actions) {
    try {
      // ローカルサーバーに接続する用
      Socket socket = new Socket(ip, port);

      // 受取，送信用のストリーム
      InputStream rsv = socket.getInputStream();
      OutputStream send = socket.getOutputStream();

      // 送信用文字列
      String sendData = "2g ";
      for (int i = 0; i < actions.length; ++i) {
        sendData += String.valueOf(actions[i].agentID);
        sendData += " ";
        sendData += actions[i].type;
        sendData += " ";
        sendData += String.valueOf(actions[i].dx);
        sendData += " ";
        sendData += String.valueOf(actions[i].dy);
        sendData += ";";
      }

      // 回答を送信
      send.write(sendData.getBytes("UTF-8"));
      socket.close();
    } catch (IOException e) {
      e.printStackTrace();
    }
  }

  // 受け取ったデータをparseしてFieldDataに格納して返す
  public  static FieldData parseRsvData(String fieldStr) {

    var parseStr = fieldStr.split("\n", 0);

    var tmpParseData = parseStr[0].split(" ", 0);

    // width, height, agentNumをFieldDataに入れる
    FieldData afterParse = new FieldData(Integer.parseInt(tmpParseData[0]),
        Integer.parseInt(tmpParseData[1]),
        Integer.parseInt(parseStr[5]));

    // フィールドのポイント
    tmpParseData = parseStr[1].split(";", 0);
    for (int i = 0; i < afterParse.height; ++i) {
      var tmp = tmpParseData[i].split(" ", 0);
      for (int j = 0; j < afterParse.width; ++j) {
        afterParse.points[i][j] = Integer.parseInt((tmp[j]));
      }
    }

    // スタート時刻と現在のターン
    afterParse.startedUnixTime = Integer.parseInt(parseStr[2]);
    afterParse.turn = Integer.parseInt(parseStr[3]);

    // フィールドの現在の色
    tmpParseData = parseStr[4].split(";", 0);
    for (int i = 0; i < afterParse.height; ++i) {
      var tmp = tmpParseData[i].split(" ", 0);
      for (int j = 0; j < afterParse.width; ++j) {
        afterParse.color[i][j] = Integer.parseInt((tmp[j]));
      }
    }

    // 自チームの情報
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


    // 相手チームの情報
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

    // 最大ターン数
    afterParse.maxTurn = Integer.parseInt(parseStr[12]);

    return afterParse;
  }
}