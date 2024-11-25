package com.k4m.dx.tcontrol.socket.listener;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.k4m.dx.tcontrol.db.repository.service.ScaleServiceImpl;
import com.k4m.dx.tcontrol.db.repository.service.SystemServiceImpl;
import com.k4m.dx.tcontrol.db.repository.vo.DbServerInfoVO;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.util.FileUtil;
 
public class DXTcontrolScaleExecute extends SocketCtl implements Job {
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	private static ApplicationContext context;
	
    @Override
    public void execute(JobExecutionContext arg0) throws JobExecutionException {
    	socketLogger.info("Job Executed [" + new Date(System.currentTimeMillis()) + "]");

		context = new ClassPathXmlApplicationContext(new String[] {"context-tcontrol.xml"});
		SystemServiceImpl service = (SystemServiceImpl) context.getBean("SystemService");
		ScaleServiceImpl serviceScale = (ScaleServiceImpl) context.getBean("ScaleService");

    	Map<String, Object> loadParam = new HashMap<String, Object>();
    	Map<String, Object> usageMap = new HashMap<String, Object>();
    	Map<String, Object> chkParam = new HashMap<String, Object>();
   
    	DbServerInfoVO searchDbServerInfoVO = new DbServerInfoVO();
    	DbServerInfoVO dbServerInfo = null;
    	int iScaleExecute = 0;
    	int iSetCount = 0;

    	int db_svr_id = 1;
		String strIpadr = "";
		
		try {
			strIpadr = FileUtil.getPropertyValue("context.properties", "agent.install.ip");

			//서버정보 조회
			searchDbServerInfoVO.setIPADR(strIpadr);
			dbServerInfo = service.selectDatabaseConnInfo(searchDbServerInfoVO);
			
			if (dbServerInfo != null) {
				db_svr_id = dbServerInfo.getDB_SVR_ID();
			}
			
	    	//0. 선행조건 : scale load중인지 확인
			chkParam.put("db_svr_id", db_svr_id);
	    	iScaleExecute = serviceScale.scaleExecutionSearch(client, is, os, chkParam);
		} catch (Exception e) {
			errLogger.error("scale 실시간 데이터 체크 {}", e.toString());
			e.printStackTrace();
			return;
		}

		//auto setting count
		iSetCount = scaleAwsAutoSetChk();

    	//scale load중이면 auto-scale 실행x
    	//auto scale 설정이 있는 지 확인
    	if (iScaleExecute <= 0 && iSetCount > 0) {

    	   	//1. 모니터링에서 cpu데이터 조회
    		try {
    			loadParam.put("IPADR", strIpadr);
    			usageMap = serviceScale.selectMonitorInfo(loadParam);
    			socketLogger.info("usageMap: [" + usageMap + "]");

    			//사용량이 조회 될때만 처리함
    			if (usageMap != null) {
    				loadParam.put("db_svr_id", db_svr_id); //db서버
    				
    				if (usageMap.get("cpu_util_rate") != null) {
    					loadParam.put("policy_type", "TC003501");
    					loadParam.put("exenum", usageMap.get("cpu_util_rate").toString());
    					
    					serviceScale.insertScaleLoadLog_G(loadParam);
    				}

    				if (usageMap.get("mem_used_rate") != null) {
    					loadParam.put("policy_type", "TC003502");
    					loadParam.put("exenum", usageMap.get("mem_used_rate").toString());
    					
    					serviceScale.insertScaleLoadLog_G(loadParam);
    				}
    			}
    		} catch (Exception e) {
    			errLogger.error("scale load데이터 저장 중 오류가 발생하였습니다. {}", e.toString());
    			e.printStackTrace();
    			return;
    		}

    		//3. auto scale 실행
    		try {
    			serviceScale.autoScaleExecute(loadParam);
    		} catch (Exception e) {
    			errLogger.error("scale auto 설정 중 오류가 발생하였습니다. {}", e.toString());
    			e.printStackTrace();
    			return;
    		}
    	}
    }
    
    //scale auto 설정 확인
    public int scaleAwsAutoSetChk() {
    	int iCount = 0;
    	Map<String, Object> param = new HashMap<String, Object>();

		context = new ClassPathXmlApplicationContext(new String[] {"context-tcontrol.xml"});
		ScaleServiceImpl service = (ScaleServiceImpl) context.getBean("ScaleService");

    	try {
        	socketLogger.info("service.dbServerInfoSet() [" + service.dbServerInfoSet() + "]");
    		
	    	param.put("db_svr_id", service.dbServerInfoSet());
	    	iCount = service.selectScaleITotCnt(param);
			
	    } catch(Exception e) {
	        e.printStackTrace();
	    }  
    	
    	return iCount;
    }
}