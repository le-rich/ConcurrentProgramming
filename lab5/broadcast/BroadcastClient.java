import java.net.*;
import java.io.*;

class SendThread extends Thread{

	public void run(){
		try {
			Socket s = new Socket("127.0.0.1", 3333);
			PrintWriter out = new PrintWriter(new OutputStreamWriter(s.getOutputStream()), true);
			BufferedReader stdin = new BufferedReader(new InputStreamReader(System.in));
			String line;
			while (true) {
				if ((line = stdin.readLine()) != null){
					out.println(line);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}

class ReceiveThread extends Thread{
	public void run(){
		try {
			Socket s = new Socket("127.0.0.1", 3333);
			System.out.println(s);
			BufferedReader in = new BufferedReader(new InputStreamReader(s.getInputStream()));
			String message = "AYAYA";
			while (true) {
				
				if ((message = in.readLine()) == null){
					break;
				}

				System.out.println(message);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}

class BroadcastClient {
	public static void main(String...args) throws IOException {
			ReceiveThread rt = new ReceiveThread();
			SendThread st = new SendThread();

			rt.start();
			st.start();
	}
}
