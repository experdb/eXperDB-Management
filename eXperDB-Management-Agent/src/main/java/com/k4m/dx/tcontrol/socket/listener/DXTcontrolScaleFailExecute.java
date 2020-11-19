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
 
public class DXTcontrolScaleFailExecute extends SocketCtl implements Job {
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

    	int iScaleExecute = 0;

    	//0. 선행조건 : scale load중인지 확인
    	iScaleExecute = serviceScale.scaleExecutionSearch(client, is, os);

    	//scale load중이면 auto-scale 실행x
    	if (iScaleExecute <= 0) {
			String strIpadr = "";

    	   	//. 에이전트 비정상 종료 조회 및 처리
    		try {
    			strIpadr = FileUtil.getPropertyValue("context.properties", "agent.install.ip");
    			
    			loadParam.put("IPADR", strIpadr);
    			usageMap = serviceScale.selectConnectionFailure(loadParam);

    			//바정상 종료 조회시
    			if (usageMap != null) {

    				if (!"".equals(usageMap.get("server_ip").toString())) {
    					//스케일 인 넣어주면됨
    	    			serviceScale.failedScaleExecute(loadParam);
    				}
    			}
    		} catch (Exception e) {
    			errLogger.error("에이전트 비정상 종료 처리중 오류가 발생하였습니다. {}", e.toString());
    			e.printStackTrace();
    			return;
    		}
    	}
    }
}