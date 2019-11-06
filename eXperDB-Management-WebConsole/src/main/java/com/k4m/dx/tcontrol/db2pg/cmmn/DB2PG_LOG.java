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

public class DB2PG_LOG {
	

	public DB2PG_LOG(){}
	
	public static  Map<String, Object> db2pgLog(String logPath) throws Exception {
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
		
		System.out.println( "/*****DB2PG  LOG ************************************************************/");
	
		String path = logPath+"/result;";
		
		String strCmd ="cd "+path+" ls -Art | tail -n 1";
		
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
                result.put("RESULT_CODE", 0);
                result.put("RESULT", "SUCCESS");
            } else {
                // shell 실행이 비정상 종료되었을 경우
            	result.put("RESULT_MSG", successOutput.toString());
                result.put("RESULT_CODE", 1);
                result.put("RESULT", "FAIL");
            }

        } catch (IOException e) {
            e.printStackTrace();
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {      	

    		System.out.println("3. 결과 = "+result.get("RESULT"));
    		System.out.println("4. 에러 메세지 = "+result.get("RESULT_MSG"));

    		System.out.println( "/*****DB2PG  LOG ************************************************************/");
    		
    		
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
