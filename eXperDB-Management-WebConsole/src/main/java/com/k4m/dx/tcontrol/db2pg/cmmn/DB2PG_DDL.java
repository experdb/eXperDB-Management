package com.k4m.dx.tcontrol.db2pg.cmmn;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.util.ResourceUtils;

public class DB2PG_DDL {

	public DB2PG_DDL(){}
	
	public static  Map<String, Object> db2pgDDL(JSONObject obj) throws Exception {
		Process process = null;
        Runtime runtime = Runtime.getRuntime();

        BufferedReader successBufferReader = null; // 성공 버퍼
        BufferedReader errorBufferReader = null; // 오류 버퍼
        String msg = null; // 메시지
        
        String startTime=null;
        String endTime=null;
        
        JSONArray jsonArray = new JSONArray(); 
        JSONObject result = new JSONObject();
		
		System.out.println( "/*****DB2PG  DDL  START************************************************************/");
		
		List<String> ddlList = new ArrayList<String>(); 
		ddlList.add("table");
		ddlList.add("constraints");
		ddlList.add("index");
		ddlList.add("sequence");
		
        try {       	
        	for(int i=0; i<ddlList.size(); i++){
                StringBuffer successOutput = new StringBuffer(); // 성공 스트링 버퍼
                StringBuffer errorOutput = new StringBuffer(); // 오류 스트링 버퍼
        		JSONObject jsonObj = new JSONObject();

	    		String ddl_path = obj.get("ddl_save_pth")+"/ddl";
	
	    		String cmd = "cat "+ obj.get("dtb_nm")+"_DB2PG_"+ddlList.get(i)+".sql";
	
	    		String strCmd = "cd "+ddl_path+";"+cmd;
	
	    		System.out.println("1. 명령어 = "+strCmd);
	
	    		List<String> cmdList = new ArrayList<String>(); 
	    		
	    		cmdList.add("/bin/sh"); 
	    		cmdList.add("-c");
	    		cmdList.add(strCmd); 
	
	    		String[] array = cmdList.toArray(new String[cmdList.size()]);
	    		
	            // 명령어 실행
	            process = runtime.exec(array);
	 
	            // shell 실행이 정상 동작했을 경우
	            successBufferReader = new BufferedReader(new InputStreamReader(process.getInputStream()));
	    		Calendar calendar = Calendar.getInstance();				
	            java.util.Date date = calendar.getTime();
	            String today = (new SimpleDateFormat("yyyyMMddHHmmss").format(date));
	            //startTime = nowTime();
	 
	            while ((msg = successBufferReader.readLine()) != null) {
	                successOutput.append(msg + System.getProperty("line.separator"));
	            }
	 
	            // shell 실행시 에러가 발생했을 경우
	            errorBufferReader = new BufferedReader(new InputStreamReader(process.getErrorStream()));
	            while ((msg = errorBufferReader.readLine()) != null) {
	                errorOutput.append(msg + System.getProperty("line.separator"));
	            }
	 
	            // 프로세스의 수행이 끝날때까지 대기
	            process.waitFor();
	 
	            // shell 실행이 정상 종료되었을 경우
	            if (process.exitValue() == 0) {
	            	//endTime = nowTime();
	            	jsonObj.put("RESULT_CODE", 0);
	            	jsonObj.put("RESULT", "SUCCESS");
	            	jsonObj.put("RESULT_MSG", successOutput.toString());
	            } else {
	                // shell 실행이 비정상 종료되었을 경우
	            	//endTime = nowTime();
	            	jsonObj.put("RESULT_MSG", errorOutput.toString());
	            	jsonObj.put("RESULT_CODE", 1);
	            	jsonObj.put("RESULT", "FAIL");
	            }	            
	            jsonArray.add(jsonObj);
        	}       	
        	result.put("data", jsonArray);
        } catch (IOException e) {
            e.printStackTrace();
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {      	
        	//result.put("RESULT_startTime", startTime);
        	//result.put("RESULT_endTime", endTime);
        	
        	//System.out.println("2. 시작시간 = "+result.get("RESULT_startTime"));
    		//System.out.println("3. 종료시간 = "+result.get("RESULT_endTime"));
      
    		//System.out.println("3. 결과 = "+result.get("RESULT"));
    		//System.out.println("4. 메세지 = "+result.get("RESULT_MSG"));
    		//System.out.println(result.get("data"));

    		System.out.println( "/*****DB2PG DDL END ************************************************************/");
    		
    		
            try {
                process.destroy();
                if (successBufferReader != null) successBufferReader.close();
                if (errorBufferReader != null) errorBufferReader.close();
            } catch (IOException e1) {
                e1.printStackTrace();
            }
        }

		return result;		
	}
	
	
}
