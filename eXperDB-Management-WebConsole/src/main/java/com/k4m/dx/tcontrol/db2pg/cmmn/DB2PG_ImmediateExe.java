package com.k4m.dx.tcontrol.db2pg.cmmn;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.ResourceUtils;
import org.springframework.web.context.ContextLoader;
import org.springframework.web.context.WebApplicationContext;

import com.k4m.dx.tcontrol.cmmn.BeanUtils;
import com.k4m.dx.tcontrol.common.service.CmmnServerInfoService;
import com.k4m.dx.tcontrol.db2pg.history.service.Db2pgHistoryService;
import com.k4m.dx.tcontrol.db2pg.history.service.impl.Db2pgHistoryDAO;
import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleService;

public class DB2PG_ImmediateExe implements Runnable{
	
	private String wrk_id;
	private String wrk_nm;
	private String mig_dscd;
	private String id;
	private String gbn;
	private String save_pth;

	ScheduleService scheduleService = (ScheduleService) BeanUtils.getBean("scheduleService");		
	
	private DB2PG_ImmediateExe(String wrk_id, String wrk_nm, String mig_dscd, String id, String gbn, String save_pth) {
		this.wrk_id = wrk_id;
		this.wrk_nm = wrk_nm;
		this.mig_dscd = mig_dscd;
		this.id = id;
		this.gbn=gbn;
		this.save_pth=save_pth;
	}


	public static DB2PG_ImmediateExe getInstance(String wrk_id, String wrk_nm, String mig_dscd, String id, String gbn, String save_pth){	
		return new DB2PG_ImmediateExe(wrk_id, wrk_nm,mig_dscd, id, gbn, save_pth);
	}
	

	@Override
	public void run() {
		
		try{
			System.out.println( "/*****MIGRATION Generate Immediate Commands ***********************/");
			
			Properties props = new Properties();
			props.load(new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));			
			
			String db2pg_path = props.get("db2pg_path").toString();
			String config_path = "config/"+wrk_nm+".config";
			String cmd = "./db2pg.sh -c "+config_path;			
			String strCmd = "cd "+db2pg_path+";"+cmd;

			System.out.println("RUN Command = "+strCmd);
			
			List<String> cmdList = new ArrayList<String>(); 
			
			cmdList.add("/bin/sh"); 
			cmdList.add("-c");
			cmdList.add(strCmd); 

			String[] array = cmdList.toArray(new String[cmdList.size()]);
			System.out.println( "/*****MIGRATION  RUN Immediately  ********************************/");
			executeDDL(array, wrk_id, mig_dscd,  id, wrk_nm, save_pth);
			
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	
	
	public void executeDDL(String[] array, String wrk_id, String mig_dscd, String id, String wrk_nm, String save_pth) throws Exception {
		Process process = null;
        Runtime runtime = Runtime.getRuntime();
        StringBuffer successOutput = new StringBuffer(); // 성공 스트링 버퍼
        StringBuffer errorOutput = new StringBuffer(); // 오류 스트링 버퍼
        BufferedReader successBufferReader = null; // 성공 버퍼
        BufferedReader errorBufferReader = null; // 오류 버퍼
        String msg = null; // 메시지
        
        String startTime=null;
        String endTime=null;
        String exe_rslt_cd = "TC001703";
        
        try {       	
            // 명령어 실행
            process = runtime.exec(array);
            startTime = nowTime();
           
            System.out.println( "/*****MIGRATION Execution History INSERT  ************************************************************/");
            migExeInsert(wrk_id, mig_dscd, startTime, id, save_pth);
            
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
            	endTime = nowTime();
            	exe_rslt_cd = "TC001701";      
            	
            	System.out.println( "/*****MIGRATION Execution History UPDATE  ************************************************************/");
            	 migExeUpdate(wrk_id, exe_rslt_cd, endTime, id, startTime, msg);
            } else {
                // shell 실행이 비정상 종료되었을 경우
            	endTime = nowTime();
            	msg = successOutput.toString();
            	exe_rslt_cd = "TC001702";
            	
            	System.out.println( "/*****MIGRATION Execution History UPDATE  ************************************************************/");
            	 migExeUpdate(wrk_id, exe_rslt_cd, endTime, id, startTime, msg);
            }

        } catch (IOException e) {
            e.printStackTrace();
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {      	
    		System.out.println( "/*****MIGRATION  END ************************************************************/");
        	System.out.println("WORK명 = "+wrk_nm);
        	System.out.println("Start Time = "+startTime);
    		System.out.println("End Time = "+endTime);
    		if(exe_rslt_cd.equals("TC001701")){
    			System.out.println("3. Status = Success");
    		}else if (exe_rslt_cd.equals("TC001702")){
    			System.out.println("3. Status = Fail");
    		}else{
    			System.out.println("3. Status = Ing...");
    		}
            try {
                process.destroy();
                if (successBufferReader != null) successBufferReader.close();
                if (errorBufferReader != null) errorBufferReader.close();
            } catch (IOException e1) {
                e1.printStackTrace();
            }
        }	
	}

	
	
	
	public void migExeInsert(String wrk_id, String mig_dscd, String startTime, String id, String save_pth) {
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
            param.put("save_pth", save_pth);

            
            scheduleService.insertMigExe(param);

        }catch(Exception e){
        	e.printStackTrace();
        }
	}



	public void migExeUpdate(String wrk_id, String exe_rslt_cd, String endTime, String id, String startTime, String msg) {
		
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
