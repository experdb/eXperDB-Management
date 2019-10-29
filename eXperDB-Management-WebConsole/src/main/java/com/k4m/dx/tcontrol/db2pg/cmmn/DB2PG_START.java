package com.k4m.dx.tcontrol.db2pg.cmmn;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Scanner;

import org.json.simple.JSONObject;
import org.springframework.util.ResourceUtils;

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
		
		
		System.out.println( "/************************************************************/");
		System.out.println( "DB2PG  START . . . ");
		
		Properties props = new Properties();
		props.load(new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));			
		
		String db2pg_path = props.get("db2pg_path").toString();
		String config_path = "config/"+obj.get("wrk_nm")+".config";
		String strCmd = db2pg_path+"/./db2pg.sh -c "+config_path;

		System.out.println(strCmd);
		
		String cmd = "/db2pg.sh -c "+config_path;
	
		String[] command = {"/bin/sh", "-c", db2pg_path+cmd};
		
        try {
        	
        	//System.out.println("cd "+db2pg_path+";" +cmd);
        	 
            // 명령어 실행
            process = runtime.exec("cd "+db2pg_path+";" +command);
 
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
                System.out.println("성공");
                System.out.println(successOutput.toString());
            } else {
                // shell 실행이 비정상 종료되었을 경우
                System.out.println("비정상 종료");
                System.out.println(successOutput.toString());
            }

        } catch (IOException e) {
            e.printStackTrace();
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {
    		System.out.println( "DB2PG  END . . . ");
    		System.out.println( "/************************************************************/");
            try {
                process.destroy();
                if (successBufferReader != null) successBufferReader.close();
                if (errorBufferReader != null) errorBufferReader.close();
            } catch (IOException e1) {
                e1.printStackTrace();
            }
        }

		return null;		
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
}
