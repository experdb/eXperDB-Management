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
import java.util.Scanner;

import org.json.simple.JSONObject;
import org.springframework.util.ResourceUtils;

import com.k4m.dx.tcontrol.db2pg.setting.web.Db2pgSettingController;

public class DB2PG_START {
	

	public DB2PG_START(){}
	
	public static  Map<String, Object> db2pgStart(JSONObject obj) throws Exception {
		Process process = null;
        Runtime runtime = Runtime.getRuntime();
        StringBuffer successOutput = new StringBuffer(); // 성공 스트링 버퍼
        StringBuffer errorOutput = new StringBuffer(); // 오류 스트링 버퍼
        BufferedReader successBufferReader = null; // 성공 버퍼
        BufferedReader errorBufferReader = null; // 오류 버퍼
        String msg = null; // 메시지
        
        String startTime=null;
        String endTime=null;
        
        JSONObject result = new JSONObject();
		
		System.out.println( "/*****DB2PG  START ************************************************************/");
		
		Properties props = new Properties();
		props.load(new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));			
		
		String db2pg_path = props.get("db2pg_path").toString();
		String config_path = "config/"+obj.get("wrk_nm")+".config";
		String cmd = "./db2pg.sh -c "+config_path;
		
		String strCmd = "cd "+db2pg_path+";"+cmd;

		System.out.println("1. 명령어 = "+strCmd);

		List<String> cmdList = new ArrayList<String>(); 
		
		cmdList.add("/bin/sh"); 
		cmdList.add("-c");
		cmdList.add(strCmd); 

		String[] array = cmdList.toArray(new String[cmdList.size()]);

        try {       	
            // 명령어 실행
            process = runtime.exec(array);
 
            // shell 실행이 정상 동작했을 경우
            successBufferReader = new BufferedReader(new InputStreamReader(process.getInputStream()));
    		Calendar calendar = Calendar.getInstance();				
            java.util.Date date = calendar.getTime();
            String today = (new SimpleDateFormat("yyyyMMddHHmmss").format(date));
            startTime = nowTime();
 
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
            	endTime = nowTime();
                result.put("RESULT_CODE", 0);
                result.put("RESULT", "SUCCESS");
            } else {
                // shell 실행이 비정상 종료되었을 경우
            	endTime = nowTime();
            	result.put("RESULT_MSG", successOutput.toString());
                result.put("RESULT_CODE", 1);
                result.put("RESULT", "FAIL");
            }

        } catch (IOException e) {
            e.printStackTrace();
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {      	
        	result.put("RESULT_startTime", startTime);
        	result.put("RESULT_endTime", endTime);
        	
        	System.out.println("2. 시작시간 = "+result.get("RESULT_startTime"));
    		System.out.println("3. 종료시간 = "+result.get("RESULT_endTime"));
    		System.out.println("3. 결과 = "+result.get("RESULT"));
    		System.out.println("4. 에러 메세지 = "+result.get("RESULT_MSG"));

    		System.out.println( "/*****DB2PG  END ************************************************************/");
    		
    		
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
	
	
	
	
	
	@SuppressWarnings("unchecked")
	public static void main(String args[]) {
		
		JSONObject obj = new JSONObject();
		obj.put("wrk_nm", "test");		
		
		try {
			Map<String, Object> result  = db2pgStart(obj);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	
	/**
	 * 현재시간 조회
	 * 
	 * @return String
	 * @throws Exception
	 */
	public static String nowTime(){
		Calendar calendar = Calendar.getInstance();				
        java.util.Date date = calendar.getTime();
        String today = (new SimpleDateFormat("yyyyMMddHHmmss").format(date));
		return today;
	}
}
