import msgpack;
import msgpackrpc;
import Kanan.connector;

void main()
{
  auto connector = new TCPServer!(KananConnector)(new KananConnector);

  connector.listen(Endpoint(12345, "127.0.0.1"));
  connector.start();
}
