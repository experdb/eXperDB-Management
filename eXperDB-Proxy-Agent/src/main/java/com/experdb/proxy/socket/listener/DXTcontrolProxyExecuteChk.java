package com.experdb.proxy.socket.listener;

import static org.quartz.CronScheduleBuilder.cronSchedule;
import static org.quartz.JobBuilder.newJob;
import static org.quartz.TriggerBuilder.newTrigger;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.quartz.CronTrigger;
import org.quartz.Job;
import org.quartz.JobDetail;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.experdb.proxy.db.repository.service.ProxyServiceImpl;
import com.experdb.proxy.db.repository.vo.ProxyServerVO;
import com.experdb.proxy.socket.SocketCtl;
import com.experdb.proxy.util.FileUtil;
 
public class DXTcontrolProxyExecuteChk extends SocketCtl implements Job {
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	private static ApplicationContext context;
	
    @Override
    public void execute(JobExecutionContext arg0) throws JobExecutionException {
    	socketLogger.info("Job Executed15as1d51a5sd1a5sd15asd [" + new Date(System.currentTimeMillis()) + "]");
    	
    	String returnMsg = "";
    	context = new ClassPathXmlApplicationContext(new String[] {"context-tcontrol.xml"});
    	ProxyServiceImpl service = (ProxyServiceImpl) context.getBean("ProxyService");
    	
    	try {
    		//선행조건 설정
			String strIpadr = FileUtil.getPropertyValue("context.properties", "agent.install.ip");
			
			Map<String, Object> chkParam = new HashMap<String, Object>();
			chkParam.put("ipadr",strIpadr);
			
			//리스너 및  vip 상태 체크
			returnMsg = service.proxyStatusChk(chkParam); 	
        } catch(Exception e) {
            e.printStackTrace();
        }  
    }
}