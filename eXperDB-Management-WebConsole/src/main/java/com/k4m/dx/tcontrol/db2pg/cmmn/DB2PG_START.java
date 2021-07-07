package com.k4m.dx.tcontrol.db2pg.cmmn;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.json.simple.JSONObject;
import org.springframework.util.ResourceUtils;

import com.k4m.dx.tcontrol.cmmn.BeanUtils;
import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleService;

public class DB2PG_START {
	
    static String saveTime = null;
    static String new_save_pth = null;
    static String old_save_pth = null;
    
	static ScheduleService scheduleService = (ScheduleService) BeanUtils.getBean("scheduleService");		
    
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
        String wrk_nm = obj.get("wrk_nm").toString();
        old_save_pth = obj.get("oldSavePath").toString();
        String wrk_id = obj.get("wrk_id").toString();
        String id = obj.get("lst_mdfr_id").toString();
        
        String changePath = "0000000000";
        
        JSONObject result = new JSONObject();
        
        
		System.out.println( " [ 0. DataMigration  ]  START ");
		
		
		
		Properties props = new Properties();
		props.load(new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));			
		
		String db2pg_path = props.get("db2pg_path").toString();
		String config_path = "config/"+wrk_nm+".config";
		String filePath = db2pg_path+"/config/"+wrk_nm+".config";
		String cmd = "./db2pg.sh -c "+config_path;
		String strCmd = "cd "+db2pg_path+";"+cmd;

		System.out.println(" [ 1. MIGRATION CMD ]  "+strCmd);

		List<String> cmdList = new ArrayList<String>(); 
		
		cmdList.add("/bin/sh"); 
		cmdList.add("-c");
		cmdList.add(strCmd); 

		String[] array = cmdList.toArray(new String[cmdList.size()]);
		
		
		
		// 저장 경로 변경
		try{
		System.out.println(" [ 2. Change the existing save path ]  ");
			db2pgSavePthChange(db2pg_path, filePath, wrk_nm, old_save_pth);			
		}catch (Exception e) {
			changePath = "8000000003";
            e.printStackTrace();
        } 
		
		
		
		if(changePath.equals("0000000000")){
	        try {       	
	            // 명령어 실행
	        	System.out.println(" [ 3. Command Execution ]  ");
	            process = runtime.exec(array);
	            
	            startTime = nowTime();
	            
	            System.out.println(" [ 3. MIGRATION Save execution history ]  ");
	            migExeInsert(wrk_id, "TC003202", startTime, id, new_save_pth);
	            
	 
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
	            	System.out.println(" [ 4. RESULT ]   SUCCESS ");
	            	
	            	endTime = nowTime();
	            	String exe_rslt_cd = "TC001701"; 
	            	
	            	 System.out.println(" [ 5. MIGRATION Update execution history ]  ");
	            	migExeUpdate(wrk_id, exe_rslt_cd, endTime, id, startTime, msg);
	            	 
	                result.put("RESULT_CODE", 0);
	                result.put("RESULT", "SUCCESS");
	            } else {
	                // shell 실행이 비정상 종료되었을 경우
	            	System.out.println(" [ [ 4. RESULT ]   FAIL  ");
	            	endTime = nowTime();
	            	String exe_rslt_cd = "TC001702"; 
	            	msg = successOutput.toString();
	            	
	            	System.out.println(" [ 5. MIGRATION Update execution history ]  ");
	            	migExeUpdate(wrk_id, exe_rslt_cd, endTime, id, startTime, msg);
	            	
	            	result.put("RESULT_MSG", successOutput.toString());
	                result.put("RESULT_CODE", 1);
	                result.put("RESULT", "FAIL");
	            }
	
	        } catch (IOException e) {
	            e.printStackTrace();

            	result.put("RESULT_MSG", "system error");
                result.put("RESULT_CODE", 1);
                result.put("RESULT", "FAIL");
	        } catch (InterruptedException e) {
	            e.printStackTrace();

            	result.put("RESULT_MSG", "system error");
                result.put("RESULT_CODE", 1);
                result.put("RESULT", "FAIL");
	        } finally {      	
	        	result.put("RESULT_startTime", startTime);
	        	result.put("RESULT_endTime", endTime);
	        	result.put("new_save_pth", new_save_pth);

	        	System.out.println(" [ 6. Old Save Path ] " +old_save_pth);
	        	System.out.println(" [ 7. New Save Path ] " +new_save_pth);
	        	System.out.println(" [ 8. Start Time ] " +result.get("RESULT_startTime"));
	        	System.out.println(" [ 9. End Time ] " +result.get("RESULT_endTime"));
	        	System.out.println(" [ 10. Err Massage ] "  +result.get("RESULT_MSG"));
	        	
	        	/*System.out.println("2. 시작시간 = "+result.get("RESULT_startTime"));
	    		System.out.println("3. 종료시간 = "+result.get("RESULT_endTime"));
	    		System.out.println("4. 에러 메세지 = "+result.get("RESULT_MSG"));*/
	
	    		
	    		System.out.println( " [ 11. Data Migration  ]  END");
	    		
	    		if (new_save_pth != null) {
		    		updateSavePth(wrk_id, new_save_pth);
	    		}

	    		//System.out.println( "/*****DB2PG  END ************************************************************/");
	    		
	    		
	            try {
	            	if (process != null) {
		                process.destroy();
	            	}

	                if (successBufferReader != null) successBufferReader.close();
	                if (errorBufferReader != null) errorBufferReader.close();
	            } catch (IOException e1) {
	                e1.printStackTrace();
	            }
	        }
		}
		
		return result;		
	}
	
	
	
	
	
	private static void updateSavePth(String wrk_id, String new_save_pth) {
		
		try{
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("wrk_id", wrk_id);
		param.put("save_pth", new_save_pth);
		
		System.out.println( " [ 12. Update Old Save Path  ] ");
		
		scheduleService.updateSavePth(param);
		
		  }catch(Exception e){
	        	e.printStackTrace();
	     }
			
	}

	private static void migExeUpdate(String wrk_id, String exe_rslt_cd, String endTime, String id, String startTime,
			String msg) {
		
        try{
            Map<String, Object> param = new HashMap<String, Object>();
            param.put("wrk_id", wrk_id);
            param.put("exe_rslt_cd", exe_rslt_cd);
            param.put("wrk_end_dtm", endTime);
            param.put("rslt_msg", msg);
            param.put("wrk_strt_dtm", startTime);
            param.put("lst_mdfr_id", id);
            
            scheduleService.updateMigExe(param);

        }catch(Exception e){
        	e.printStackTrace();
        }
		
	}

	private static void migExeInsert(String wrk_id, String mig_dscd, String startTime, String id, String new_save_pth) {
		
        try{        	
        	Map<String, Object> param = new HashMap<String, Object>();         
            param.put("wrk_id", wrk_id);
            param.put("mig_dscd", mig_dscd);
            param.put("wrk_strt_dtm", startTime);
            param.put("wrk_end_dtm", startTime);
            param.put("exe_rslt_cd", "TC001703");
            param.put("rslt_msg", "a");
            param.put("frst_regr_id", id);
            param.put("lst_mdfr_id", id);
            param.put("save_pth", new_save_pth);

            
            scheduleService.insertMigExe(param);

        }catch(Exception e){
        	e.printStackTrace();
        }
		
	}

	private static void db2pgSavePthChange(String db2pg_path, String filePath, String wrk_nm, String old_save_pth) {
		saveTime = nowTime();
		
		String resultCode = "0000000000";
		
		try {	
			File inputFile = new File(filePath);
			File outputFile = new File(filePath+"temp");
			FileInputStream fileInputStream = null;
			FileOutputStream fileOutputStream = null;
			
			fileInputStream = new  FileInputStream(inputFile);
			fileOutputStream = new FileOutputStream(outputFile);
							
			BufferedReader br = new BufferedReader(new InputStreamReader(fileInputStream));
			BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(fileOutputStream));
						
			new_save_pth = db2pg_path+"/trans/"+saveTime+"_"+wrk_nm;
				
			try{
		        String fileContent;
				while((fileContent = br.readLine()) != null) {
					fileContent = fileContent.replaceAll("SRC_FILE_OUTPUT_PATH="+old_save_pth, "SRC_FILE_OUTPUT_PATH="+new_save_pth);							
					bw.write(fileContent + "\r\n");
					bw.flush();
				}
				bw.close();
				br.close();

				resultCode = "0000000000";
			} catch (Exception e) {
				resultCode = "8000000003";
				e.printStackTrace();
			}	
			
			if(resultCode.equals("0000000000")){
				
			/*	Map<String, Object> param = new HashMap<String, Object>();
				
				param.put("wrk_id", wrk_id);
				param.put("save_pth", save_pth);
				
				//기존 저장경로 변경
				db2pgSettingService.updateDDLSavePth(param);*/
				
				inputFile.delete();
				outputFile.renameTo(new File(filePath));
			}
			
			
			
		}catch (Exception e) {
			e.printStackTrace();
		}

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
