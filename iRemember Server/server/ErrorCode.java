package server;

public enum ErrorCode {
	InvalidCommand(1,"Invalid command"),
	WordListNotFound(2,"No such word list")
	;
	
	final public int errNo;
	final public String message;
	
	private ErrorCode(int errNum, String msg){
		errNo = errNum;
		message = msg;
	}
	
	public static ErrorCode errorWithCode(int code){
		ErrorCode[] err = ErrorCode.values();
		for(int i=0; i<err.length; i++){
			if(err[i].errNo==code) return err[i];
		}
		return InvalidCommand;
	}
	
	public String toString(){
		return errNo+" \""+message+"\"";
	}
	
}
