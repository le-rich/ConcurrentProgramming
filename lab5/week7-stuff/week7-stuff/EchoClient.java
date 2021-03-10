import java.net.*;
import java.io.*;

class EchoClient {
  public static void main(String... args) throws IOException {
    Socket s = null;
    try {
      s = new Socket("127.0.0.1", 3333);
      var in = new BufferedReader(new InputStreamReader(s.getInputStream()));
      var out = new PrintWriter(new OutputStreamWriter(s.getOutputStream()), true);
      var stdin = new BufferedReader(new InputStreamReader(System.in));

      String line, reply;
      while ((line = stdin.readLine()) != null) {
        out.println(line);
        if ((reply = in.readLine()) == null)
          break;
        System.out.println(reply);
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      if (s != null) {
        s.close();
      }
    }
  }
}
