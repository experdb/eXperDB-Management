package com.experdb.proxy.socket.listener;

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

import com.experdb.proxy.db.repository.service.ProxyServiceImpl;
import com.experdb.proxy.socket.SocketCtl;
import com.experdb.proxy.util.FileUtil;
 
public class DXTcontrolProxyExecuteDayChk extends SocketCtl implements Job {
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");

	private static ApplicationContext context;
	
    @Override
    public void execute(JobExecutionContext arg0) throws JobExecutionException {
    	socketLogger.info("Job DXTcontrolProxyExecuteDayChk [" + new Date(System.currentTimeMillis()) + "]");
    	
    	String returnMsg = "";
    	context = new ClassPathXmlApplicationContext(new String[] {"context-tcontrol.xml"});
    	ProxyServiceImpl service = (ProxyServiceImpl) context.getBean("ProxyService");
    	
    	try {
    		//선행조건 설정
			String strIpadr = FileUtil.getPropertyValue("context.properties", "agent.install.ip");
			String proxySetStatus = "";

			//roxy 설치여부 및 keepalived 설치확인
			proxySetStatus = service.selectProxyTotServerChk("proxy_setting_tot", "");

			Map<String, Object> chkParam = new HashMap<String, Object>();
			chkParam.put("ipadr",strIpadr);
			chkParam.put("proxySetStatus",proxySetStatus);
			chkParam.put("real_ins_gbn", "lsn_mon_real_ins");

			//실시간 등록
			returnMsg = service.proxyDbmsStatusChk(chkParam); 
			
			
			//실시간 통계 데이터 삭제
			returnMsg = service.proxyLsnScrStatusDel(chkParam); 
			
        } catch(Exception e) {
            e.printStackTrace();
        }  
    }
}