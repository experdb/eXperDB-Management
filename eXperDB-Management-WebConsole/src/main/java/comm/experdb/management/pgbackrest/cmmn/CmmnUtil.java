package comm.experdb.management.pgbackrest.cmmn;

import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class CmmnUtil {


	public static void main(String[] args) {

			int intStart = 1678183917;
			int intStop = 1678186831;
		
			System.out.println("org_start : 2023-03-07 19:11:57");
	        System.out.println("org_stop : 2023-03-07 20:00:31");

	        
	        try {
				String start = getIntegertoDate(intStart);
				String stop = getIntegertoDate(intStop);
				System.out.println("start : "+start);
		        System.out.println("stop : "+stop);
			} catch (UnsupportedEncodingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	        
	        
	        String backupSzie =getDataSize(111766820974L);
	        
	}
	
	
	/**
	 * Integer to Date java
	 * 
	 * @return String
	 * @throws UnsupportedEncodingException  
	 */
	public static String getIntegertoDate(int realTime) throws UnsupportedEncodingException {
		
		String date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date(realTime * 1000L));
		
		return date;
	}

	
	
	/**
	 * Integer to Date java
	 * 
	 * @return String
	 * @throws UnsupportedEncodingException  
	 */
	public static String getDataSize(double size_bytes)  {
		
		String realSize;
		
		double size_kb = size_bytes /1024;
		double size_mb = size_kb / 1024;
		double size_gb = size_mb / 1024 ;
		double size_tb =  size_gb / 1024 ;
		

		if(Math.round(size_tb) > 0) {
			 realSize = Math.round(size_tb) + " TB";
		  } else if(Math.round(size_gb) > 0){
			   realSize = Math.round(size_gb) + " GB";
	        }else if(Math.round(size_mb) > 0){
	        	realSize = Math.round(size_mb) + " MB";
	        }else{
	        	realSize = Math.round(size_kb) + " KB";
	        }	     
		System.out.println("Converted Size: " + realSize);
		
		return realSize;
	}


	
}
