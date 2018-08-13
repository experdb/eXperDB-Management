package com.k4m.dx.tcontrol.monitoring.schedule.runner;

import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Set;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.k4m.dx.tcontrol.util.RunCommandExec;

public class RunShell {
	
	private JSONObject getJSONObject(String jsonString) throws Exception{
	
		JSONParser parser = new JSONParser(); 
		Object obj = parser.parse( jsonString ); 
		
		JSONObject jsonObj = (JSONObject) obj;
		
		return jsonObj;
	}
	
	/**
	 * $0 FILE_NAME 
	 * $1 SERVER_URL
	 * $2 PORT
	 * $3 ROLE
	 * $4 DATABASE
	 * @param map
	 * @return
	 * @throws Exception
	 */
	private String makeShell(LinkedHashMap<String, String> map) throws Exception {
		
		String strShell = "";
		
		// ./find_dbname.sh 192.168.56.108 5433 experdb experdb
		
		Set<String> set = map.keySet();
		Iterator<String> iter = set.iterator();
		
		while(iter.hasNext()) {
			String key = ((String) iter.next());
			String value = map.get(key);
			
			strShell += value;
		}
		
		

		return strShell;
	}
	
	/**
	 * 
	 * @param map
	 * @throws Exception
	 */
	public JSONObject run(LinkedHashMap<String, String> map) throws Exception{
		
		String strShell = makeShell(map);
		
		String path = this.getClass().getResource("/").getPath();
		
		strShell = path + System.getProperty("file.separator") + "shell" + System.getProperty("file.separator") + strShell;
		
		RunCommandExec r = new RunCommandExec(strShell);
		r.start();
		try {
			r.join();
		} catch (InterruptedException ie) {
			ie.printStackTrace();
		}
		String retVal = r.call();
		String strResultMessge = r.getMessage();
		
		JSONObject jObj = getJSONObject(strResultMessge);
		
		return jObj;
	}

}
