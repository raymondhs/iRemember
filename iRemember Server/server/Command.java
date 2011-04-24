package server;

/**
 * Provide authentication for the input command
 * @author Aldrian Obaja
 *
 */
public class Command {
	private static CommandType[] commands;
	private final static int numCommands;
	private CommandType command;
	private String[] param;
	
	/**
	 * Defines the set of commands that are available together with the specified parameter count and types.
	 * @author Aldrian Obaja
	 *
	 */
	protected enum CommandType{
		EXIT(0,new String[]{}),
		START(1,new String[]{"String username"}),
		OK(0,new String[]{}),
		HELLO(0,new String[]{}),
		ERR(2, new String[]{"int errNo","String errMsg"}),
		MESSAGE(1, new String[]{"String msg"}),
		ADDWORDLIST(3, new String[]{"String name","int size","int check"}),
		GETWORDLIST(1, new String[]{"String name"}),
		WORDLISTNAMES(0, new String[]{})
		;

		private int paramCount;
		private String[] paramType;
		
		private CommandType(int paramCount, String[] paramType){
			this.paramCount = paramCount;
			this.paramType = paramType;
		}
	}
	
	static{
		numCommands=CommandType.values().length;
		commands = CommandType.values();
	}
	
	/**
	 * Construct this object with specified command
	 * @param command The command to be set
	 */
	public Command(String command){
		setCommand(command);
	}
	
	/**
	 * To set a command in this Command object
	 * @param command The command to be set
	 */
	public void setCommand(String command){
		if(command==null){
			this.command = null;
			System.out.println("Null command");
			return;
		}
		String[] temp = parseParam(command);
		try{
			this.command = CommandType.valueOf(temp[0].toUpperCase());
			if(temp.length-1!=this.command.paramCount){
				throw new IllegalArgumentException("");
			}
			param = new String[this.command.paramCount];
			for(int i=0; i<param.length; i++){
				param[i] = temp[i+1];
			}
		} catch (Exception e){
			this.command = null;
		}
	}

	private String[] parseParam(String command) {
		String[] firstTemp = command.split(" ");
		int count=0;
		boolean isQuoted = false;
		StringBuffer quot = new StringBuffer();
		for(int i=0; i<firstTemp.length; i++){
			String cur = firstTemp[i];
			if(!isQuoted){
				quot = new StringBuffer();
				if(cur.length()>0&&cur.charAt(0)=='"'){
					if(cur.length()>1&&cur.charAt(cur.length()-1)=='"'){
						quot.append(cur.substring(1,cur.length()-1));
					} else {
						quot.append(cur.substring(1));
						isQuoted = true;
					}
				} else {
					quot.append(cur);
				}
			} else {
				if(cur.length()>0&&cur.charAt(cur.length()-1)=='"'){
					quot.append(" "+cur.substring(0,cur.length()-1));
					isQuoted = false;
				} else {
					quot.append(" "+cur);
				}
			}
			if(!isQuoted) firstTemp[count++] = quot.toString();
		}
		String[] temp = new String[count];
		for(int i=0; i<count; i++) temp[i] = firstTemp[i];
		return temp;
	}

	/**
	 * Return the command name for a command
	 * @return CommandType - the command as an enumeration object
	 */
	public CommandType getCommand(){
		return command;
	}

	/**
	 * Return the command parameters for a command
	 * @return String[] - the parameters of this command
	 */
	public String[] getParam(){
		return param;
	}
	
	/**
	 * Returns the list of available commands
	 * @return CommandType[] - the list of available commands
	 */
	public CommandType[] getCommandList(){
		return commands;
	}
	
	/**
	 * Returns the number of available commands
	 * @return int - total number of available commands
	 */
	public int getNumOfCommands(){
		return numCommands;
	}

	/**
	 * Returns true if this command is valid
	 * @return boolean
	 * @throws NumberFormatException
	 */
	public boolean isValid() throws NumberFormatException{
		if(command==null) return false;
		for(int i=0; i<command.paramCount; i++){
			if(command.paramType[i].split(" ")[0].equals("int")){
				int number = (int)Integer.parseInt(param[i]);
				if(number<0) throw new NumberFormatException();
			}
		}
		return true;
	}

	/**
	 * Returns true if this command is an exit command
	 * @return boolean
	 */
	public boolean isExit(){
		return command==CommandType.EXIT;
	}
	
}
