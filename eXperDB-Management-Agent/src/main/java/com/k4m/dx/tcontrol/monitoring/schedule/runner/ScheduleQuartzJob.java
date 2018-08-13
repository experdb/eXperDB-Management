package com.k4m.dx.tcontrol.monitoring.schedule.runner;

import java.util.LinkedHashMap;

import org.quartz.Job;
import org.quartz.JobDataMap;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ConfigurableApplicationContext;

import com.k4m.dx.tcontrol.DaemonStart;
import com.k4m.dx.tcontrol.db.repository.service.SystemService;
import com.k4m.dx.tcontrol.db.repository.service.SystemServiceImpl;

/**
* @author 박태혁
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2018.06.28   박태혁 최초 생성
*      </pre>
*/
public class ScheduleQuartzJob implements Job{

	

	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	//private ConfigurableApplicationContext context;                                                                                                   
	
	
	@Override
	public void execute(JobExecutionContext jobContext) throws JobExecutionException {

/*		if(context != null && context.isActive())
		{	
			context.close();
		}*/
		try {
			SystemServiceImpl systemService = (SystemServiceImpl) DaemonStart.getContext().getBean("SystemService");

			JobDataMap dataMap = jobContext.getJobDetail().getJobDataMap();
			
			String scd_id= dataMap.getString("scd_id");
			
			int intTest = systemService.selectQ_WRKEXE_G_01_SEQ();
			
			System.out.println("@@@@@@@@@@@@@@@ intTest : " + intTest);
			
			LinkedHashMap<String,String> map = new LinkedHashMap<String,String>();
			
			//$0 FILE_NAME $1 SERVER_URL $2 PORT $3 ROLE $4 DATABASE
			//./find_dbname.sh 192.168.56.108 5433 experdb experdb
			String FILE_NAME = "find_dbname.sh";
			String SERVER_URL = "192.168.56.108";
			String PORT = "5433";
			String ROLE = "experdb";
			String DATABASE = "experdb";
			
			map.put("FILE_NAME", FILE_NAME);
			map.put("SERVER_URL", SERVER_URL);
			map.put("PORT", PORT);
			map.put("ROLE", ROLE);
			map.put("DATABASE", DATABASE);

			execShell(map);
		} catch (Exception e) {
			errLogger.error("ScheduleQuartzJob execute {}", e.toString());
			e.printStackTrace();
		}
		
	}
	
	private void execShell(LinkedHashMap<String,String> map) throws Exception {
		try {
			RunShell runShell = new RunShell();
			
			
			runShell.run(map);
		} catch (Exception e) {
			e.printStackTrace();
			errLogger.error("ScheduleQuartzJob execShell {}", e.toString());
		}
	}

}
