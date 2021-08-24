package com.k4m.dx.tcontrol.db2pg.cmmn;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

import org.json.simple.JSONObject;

public class DB2PG_STOP {
	
	
	public JSONObject db2pgStop(String wrkName) {
		System.out.println("##### DB2PG_STOP START #####");
		JSONObject result = new JSONObject();
		BufferedReader bufferReader = null;
		ProcessBuilder processBuilder = null;
		Process process = null;
		String msg = null;
		String[] cmdList = {"/bin/sh", "-c", "kill -9 $(ps -ef | pgrep -f config/" + wrkName + ".config)"};
		
		processBuilder = new ProcessBuilder(cmdList);
		
		try {
			process = processBuilder.start();
			bufferReader = new BufferedReader(new InputStreamReader(process.getInputStream()));
			while((msg = bufferReader.readLine()) != null){
				System.out.println(msg);
			}
			
			process.waitFor();
			
			result.put("RESULT_CODE", 0);
			result.put("RESULT", "SUCCESS");
			System.out.println("##### DB2PG_STOP END #####");
			
		} catch (IOException e) {

        	result.put("RESULT_MSG", "system error");
            result.put("RESULT_CODE", 1);
            result.put("RESULT", "FAIL2");
        } catch (InterruptedException e) {

        	result.put("RESULT_MSG", "system error");
            result.put("RESULT_CODE", 1);
            result.put("RESULT", "FAIL3");
		} finally {
			
			if(process != null) process.destroy();
			if(bufferReader != null){
				try {
					bufferReader.close();
				} catch (IOException e) {
				}
			}
				
		}
		
		return result;
	}
	
}
