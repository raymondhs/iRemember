package server;

import java.text.DecimalFormat;
import java.util.*;
import java.io.*;
import java.net.*;

/**
 * iRemember Server v1.0
 * @author Aldrian Obaja
 *
 */
public class Server {

	private ArrayList<Connection> connections;
	private static final int DEFAULT_PORT = 80;
	private static int port = DEFAULT_PORT;

	public static void main(String[] args){
		for(int i=0; i<args.length; i++){
			if(args[i].equals("-p")){
				port = Integer.parseInt(args[i+1]);
			}
		}
		new Server();
	}

	/**
	 * Creates the Server object
	 */
	public Server(){
		connections = new ArrayList<Connection>();
		ServerSocket serverSocket = null;
		try {
			serverSocket = new ServerSocket(port);
		} catch (IOException e) {
			e.printStackTrace();
		}
		Database.load();
		while(true){
			try{
				System.out.println("Waiting at port "+port+"...");
				Socket s = serverSocket.accept();
				System.out.println(getTime()+"Connection established from " + s.getInetAddress());
				System.out.println("Connection Definition " + s.toString());
				new Thread(new Connection(connections,s)).start();
			} catch (Exception e){
				e.printStackTrace();
				continue;
			}
		}
	}

	/**
	 * Get current time as formatted String
	 * @return time - Current time formatted as [HH:MM:SS]
	 */
	private String getTime(){
		String time = "[";
		DecimalFormat df = new DecimalFormat("00");
		Calendar calendar = Calendar.getInstance();
		time+=df.format(calendar.get(Calendar.HOUR_OF_DAY));
		time+=":";
		time+=df.format(calendar.get(Calendar.MINUTE));
		time+=":";
		time+=df.format(calendar.get(Calendar.SECOND));
		time+="]";
		return time;
	}

}