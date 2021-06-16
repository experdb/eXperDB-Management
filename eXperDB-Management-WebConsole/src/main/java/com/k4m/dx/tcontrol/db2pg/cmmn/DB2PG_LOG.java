package com.k4m.dx.tcontrol.db2pg.cmmn;

import java.io.BufferedReader;
import java.io.File;
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
import org.apache.commons.io.input.ReversedLinesFileReader;

public class DB2PG_LOG {
	

	public DB2PG_LOG(){}
	
	@SuppressWarnings("unchecked")
	public static Map<String, Object> db2pgFile(String logPath) throws Exception {
		Process process = null;
        Runtime runtime = Runtime.getRuntime();
        StringBuffer successOutput = new StringBuffer(); // 성공 스트링 버퍼
        StringBuffer errorOutput = new StringBuffer(); // 오류 스트링 버퍼
        BufferedReader successBufferReader = null; // 성공 버퍼
        BufferedReader errorBufferReader = null; // 오류 버퍼
        String msg = null; // 메시지

       JSONObject result = new JSONObject();
       String fileName = "";
		
		System.out.println( "/*****DB2PG  RESULT  ************************************************************/");
	
		String filePath =   logPath+"result";
		String path = logPath+"result;";
		
		System.out.println("Migration 수행결과 파일 경로 = "+path);
		
		File f = new File(filePath);
		File[] fList = f.listFiles();
		
		if(fList.length ==0){
			System.out.println("파일이 존재하지 않습니다.");
			return result;       			
		}

		
		String strCmd ="cd "+path+" ls -Art | tail -n 1";
		
		System.out.println("1. 파일 찾기 명령어 = "+strCmd);

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
            	fileName = successOutput.toString();
            	result = db2pgResult(path,fileName);
            } 

        } catch (IOException e) {
            e.printStackTrace();
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {      	
        	
        	System.out.println("결과 :" + result.get("RESULT") );
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

	public static JSONObject db2pgResult(String path, String fileName) {	
		Process process = null;
        Runtime runtime = Runtime.getRuntime();
        StringBuffer successOutput = new StringBuffer(); // 성공 스트링 버퍼
        StringBuffer errorOutput = new StringBuffer(); // 오류 스트링 버퍼
        BufferedReader successBufferReader = null; // 성공 버퍼
        BufferedReader errorBufferReader = null; // 오류 버퍼
        String msg = null; // 메시지
        
        JSONObject result = new JSONObject();
        
        
		String strCmd ="cd "+path+" cat "+fileName;
		
		System.out.println("2. 결과출력 명령어 = "+strCmd);

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
                result.put("RESULT", successOutput);
            }
        } catch (IOException e) {
            e.printStackTrace();
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {      	
        	System.out.println( "/*****DB2PG  RESULT ************************************************************/");
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
	
    public static List<String> readLastLine(File file, int numLastLineToRead) {
        List<String> result = new ArrayList<>();
        try (ReversedLinesFileReader reader = new ReversedLinesFileReader(file)) {
            String line = "";
            while ((line = reader.readLine()) != null && result.size() < numLastLineToRead) {
                result.add(line);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return result;
    }

}
