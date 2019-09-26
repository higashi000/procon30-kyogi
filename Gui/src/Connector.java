import java.io.IOException;
import java.lang.reflect.Array;
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
      rsv.read(rsvData);
      rsv.close();

      socket.close();

      fieldStr = new String(rsvData, "UTF-8");
    } catch (IOException e) {
      e.printStackTrace();
    }

    System.out.println(fieldStr);
    return fieldStr;
  }


}