package server;

import java.text.DecimalFormat;
import java.util.*;
import java.net.*;
import java.io.*;

/**
 * Connection that takes care about each client's connection
 * @author Aldrian Obaja
 *
 */
public class Connection implements Runnable{
	
	private String name;
	private ArrayList<Connection> connections;
	private BufferedInputStream reader;
	private DataOutputStream output;
	private Socket socket;
	private boolean closed;
	private boolean isValid = false;
	private final int SLEEP_TIME = 1000*60*5;
	private Thread checkAlive;
	private final String DELIMITER = "\1\0\n";
	private final int MOD = 65535;

	/**
	 * Receive connection socket from Server and maintain the connection, until "exit" command is invoked
	 * @param name The username for this connection
	 * @param connections The connections list, i.e. the list of users
	 * @param socket The socket used for this user
	 */
	public Connection(ArrayList<Connection> connections, Socket socket){
		this.connections = connections;
		this.socket = socket;
		try {
			reader = new BufferedInputStream(socket.getInputStream());
			Command command = new Command(readLine());
			if(command.isValid()){
				if(command.getCommand()==Command.CommandType.START){
					this.name = command.getParam()[0];
				}
			}
			output = new DataOutputStream(socket.getOutputStream());
		} catch (IOException e) {
		}
		if(this.name!=null){
			connections.add(this);
			isValid = true;
		}
	}
	
	/**
	 * Returns the success state for the settlement of this connection
	 * @return isValid - Whether the connection is successfully settled
	 */
	public boolean isValid(){
		return isValid;
	}

	/**
	 * Find a connection with the specified username, according to the list of connection
	 * @param name The username
	 * @return connection - The connection with the specified username, null if the specified username is not found
	 */
	private Connection find(String name){
		for(Connection con: connections){
			if(con.getUsername().equals(name)) return con;
		}
		return null;
	}

	/**
	 * Print to the standard output
	 * @param message The message to be printed
	 */
	private void print(String message){
		System.out.println(getTime()+this.name+"@"+socket.getInetAddress()+": "+message);
	}

	/**
	 * Read from the reader until a newline or end of stream is encountered
	 * @return
	 * @throws IOException
	 */
	public String readLine() throws IOException{
		int take = reader.read();
		String result = "";
		while(take!='\n' && take!='\r'){
			result+=(char)take;
			if(reader.available()>0){
				take = reader.read();
			} else {
				break;
			}
		}
		return result;
	}

	/**
	 * Get the BufferedReader object associated with this connection
	 * @return reader - The BufferedReader object associated with this connection
	 */
	public BufferedInputStream getReader(){
		return reader;
	}

	/**
	 * Get the DataOutputStream object associated with this connection
	 * @return output - The DataOutputStream object associated with this connection
	 */
	public DataOutputStream getOutput(){
		return output;
	}

	/**
	 * Get the username associated with this connection
	 * @return name - The username associated with this connection
	 */
	public String getUsername(){
		return name;
	}

	/**
	 * The main method running in the background listening for any input from this client
	 */
	public void run(){
		try{
			if(!isValid) return;
			checkAlive = new Thread(new Runnable(){
				public void run(){
					while(true){
						try{
							Thread.sleep(SLEEP_TIME);
							break;
						} catch (Exception e){
							continue;
						}
					}
					close();
				}
			});
			checkAlive.start();
			String input = readLine();
			closed = false;
			if(input==null) closed = true;
			print(input);
			Command command = null;
			if(!closed) command = new Command(input);
			while(!closed&&!command.isExit()){
				if(!command.isValid()){
					writeErr(ErrorCode.InvalidCommand);
					input = readLine();
					if(input==null) break;
					command = new Command(input);
					print(input);
					continue;
				}
				String[] param = command.getParam();
				switch(command.getCommand()){
				case HELLO:
					write("\"HELLO\"");
					checkAlive.interrupt();
					break;
				case ADDWORDLIST:
					String listName = param[0];
					int size = Integer.parseInt(param[1]);
					int check = Integer.parseInt(param[2]);
					byte[] data = new byte[size];
					for(int i=0; i<size; i++){
						data[i] = (byte)reader.read();
					}
					if(checkData(check,data)){
						WordList newWordList = new WordList(listName,data);
						Database.addWordList(newWordList);
						write("\"OK\"");
					}
					break;
				case GETWORDLIST:
					listName = param[0];
					WordList list = Database.getWordList(listName);
					if(list!=null){
						write("\"WORDLIST\" \""+list.name+"\" \""+list.data.length+"\"");
					} else {
						writeErr(ErrorCode.WordListNotFound);
						break;
					}
					output.write(list.data);
					break;
				case WORDLISTNAMES:
					ArrayList<WordList> wordListNames = Database.getListOfWordList();
					StringBuffer names = new StringBuffer("\"WORDLISTNAMES\" \""+wordListNames.size()+"\"");
					for(WordList wordList: wordListNames){
						names.append(" \""+wordList.name+"\"");
					}
					write(names.toString());
					break;
				case EXIT:
					write("\"EXIT\"");
					close();
					break;
				default:
					writeErr(ErrorCode.InvalidCommand);
					break;
				}
				input = readLine();
				if(input==null) break;
				command = new Command(input);
				print(input);
			}
		} catch (SocketException e){
			System.out.println(getTime()+"Client was disconnected unexpectedly");
		} catch (IOException e){
			System.out.println(getTime()+"Connection was closed unexpectedly");
		} catch (Exception e){
			e.printStackTrace();
		} finally {
			close();
		}
	}
	
	private boolean checkData(int check, byte[] data){
		int temp = 0;
		for(int i=0; i<data.length; i++){
			temp=(((temp+data[i])%MOD)+MOD)%MOD;
		}
		temp = (temp+MOD)%MOD;
		return temp==check;
	}
	
	/**
	 * Send message to this client
	 * @param message The message to be sent
	 * @throws IOException
	 */
	public void write(String message) throws IOException{
		try{
			output.writeBytes(message+DELIMITER);
			output.flush();
		} catch (SocketException e){
			close();
		}
	}

	/**
	 * Close the connection
	 */
	private void close(){
		if(closed) return;
		Database.save();
		closed = true;
		System.out.println(getTime()+"Connection to "+this.name+"@"+socket.getInetAddress()+" closed!");
		try {
			output.flush();
			output.close();
			socket.close();
		} catch (IOException e) {
		}
		Connection willBeRemoved = find(this.name);
		if(willBeRemoved!=null){
			connections.remove(find(this.name));
		}
	}
	
	/**
	 * Method to simplify writing error to the user
	 * @param errCode
	 * @throws IOException
	 */
	private void writeErr(ErrorCode errCode) throws IOException{
		write("\"ERR\" \""+errCode+"\"");
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
