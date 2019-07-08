import std.stdio;
import Kanan.tile;
import Kanan.field;
import Kanan.greedy;
import Kanan.color;
import Kanan.agent;
import Kanan.dispField;
import Kanan.updateField;
import Kanan.connector;
import Kanan.rsvData;
import msgpack;
import msgpackrpc;

void main()
{
  auto connector = new TCPServer!(KananConnector)(new KananConnector);

  connector.listen(Endpoint(12345, "127.0.0.1"));
  connector.start();
}
