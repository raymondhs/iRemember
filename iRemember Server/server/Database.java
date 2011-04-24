package server;

import java.io.BufferedInputStream;
import java.io.DataOutputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.concurrent.Semaphore;

public class Database {
	private static ArrayList<WordList> listOfWordList = new ArrayList<WordList>();
	private static final String FILE_NAME = "wordlists.dat";
	private static Semaphore readLock = new Semaphore(1,true);
	private static Semaphore writeLock = new Semaphore(1,true);
	private static BufferedInputStream reader;
	private static DataOutputStream output;
	
	public static void addWordList(WordList list){
		try {
			readLock.acquire();
			writeLock.acquire();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		WordList exist = null;
		for(WordList wordList:listOfWordList){
			if(wordList.name.equals(list.name)) exist = wordList;
		}
		if(exist!=null){
			listOfWordList.remove(exist);
		}
		listOfWordList.add(list);
		writeLock.release();
		readLock.release();
	}
	
	public static WordList getWordList(String name){
		try {
			readLock.acquire();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		WordList result = null;
		for(WordList list:listOfWordList){
			if(list.name.equals(name)) result = list;
		}
		readLock.release();
		return result;
	}
	
	public static ArrayList<WordList> getListOfWordList(){
		return listOfWordList;
	}
	
	public static void load(){
		try{
			writeLock.acquire();
			readLock.acquire();
			listOfWordList.clear();
			reader = new BufferedInputStream(new FileInputStream(FILE_NAME));
			WordList list = null;
			while((list = readWordList())!=null){
				System.out.println("Loaded: "+list.name);
				listOfWordList.add(list);
			}
			reader.close();
		} catch (Exception e){
			try { // Create the file
				new FileOutputStream(FILE_NAME).close();
			} catch (Exception e1) {
				e1.printStackTrace();
			}
		} finally{
			readLock.release();
			writeLock.release();
		}
	}

	public static void save(){
		try{
			readLock.acquire();
			output = new DataOutputStream(new FileOutputStream(FILE_NAME));
			for(WordList list: listOfWordList){
				output.writeBytes(list.name+"\t"+list.data.length+"\t");
				output.write(list.data);
			}
			output.close();
		} catch (Exception e){

		} finally {
			readLock.release();
		}
	}
	
	private static WordList readWordList(){
		try{
			String name = readToken();
			int len = Integer.parseInt(readToken());
			byte[] data = new byte[len];
			reader.read(data);
			return new WordList(name,data);
		} catch (Exception e){
			return null;
		}
	}
	
	private static String readToken(){
		try{
			if(reader.available()<=0) return null;
			int take = reader.read();
			String result = "";
			while(take!='\t' && take!=0){
				result+=(char)take;
				if(reader.available()>0){
					take = reader.read();
				} else {
					break;
				}
			}
			return result;
		} catch (Exception e){
			return null;
		}
	}

}
