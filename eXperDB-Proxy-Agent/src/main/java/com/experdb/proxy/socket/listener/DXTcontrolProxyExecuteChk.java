package com.experdb.proxy.socket.listener;

import static org.quartz.CronScheduleBuilder.cronSchedule;
import static org.quartz.JobBuilder.newJob;
import static org.quartz.TriggerBuilder.newTrigger;

import java.util.HashMap;
import java.util.Map;

import org.json.simple.JSONObject;
import org.quartz.CronTrigger;
import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.SchedulerFactory;
import org.quartz.impl.StdSchedulerFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.experdb.proxy.db.repository.service.ProxyServiceImpl;
import com.experdb.proxy.db.repository.vo.ProxyServerVO;
import com.experdb.proxy.socket.SocketCtl;
import com.experdb.proxy.util.FileUtil;
 
public class DXTcontrolProxyExecuteChk extends SocketCtl {
	private SchedulerFactory schedulerFactory = null;
	private Scheduler scheduler = null;
	private static ApplicationContext context;
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
    public static void main(String[] args) {   
    	DXTcontrolProxyExecuteChk dXTcontrolScale = new DXTcontrolProxyExecuteChk();
    	dXTcontrolScale.start();
    }
    
    public DXTcontrolProxyExecuteChk() {
        try {
	    	schedulerFactory = new StdSchedulerFactory();
	    	scheduler = schedulerFactory.getScheduler();
        } catch(Exception e) {
            e.printStackTrace();
        }
    }

    public void start() {
    	JSONObject jObjResult = null;
    	String strProxyJobTime = "";
    	int iSetCount = 0;
    	Map<String, Object> scaleCommon = new HashMap<String, Object>();
    	Map<String, Object> param = new HashMap<String, Object>();

		context = new ClassPathXmlApplicationContext(new String[] {"context-tcontrol.xml"});
		ProxyServiceImpl service = (ProxyServiceImpl) context.getBean("ProxyService");
    	
    	try {
    		//선행조건 설정
    		//agent 가 설치되어있는지?
    		//keep, proxy가 설치되어있는지?
    		//실행되고 있는
			String strIpadr = FileUtil.getPropertyValue("context.properties", "agent.install.ip");
			String strPort = FileUtil.getPropertyValue("context.properties", "socket.server.port");
			String strVersion = FileUtil.getPropertyValue("context.properties", "agent.install.version");
			String proxySetYn = "";
			String proxySetStatus = "";
			String keepalivedSetStatus = "";
			
			ProxyServerVO searchProxyServerVO = new ProxyServerVO();
			searchProxyServerVO.setIpadr(strIpadr);

			//proxy 서버 등록 여부 확인
			ProxyServerVO proxyServerInfo = service.selectPrySvrInfo(searchProxyServerVO);

			//서버 미등록 일 경우 proxy 설치여부 및 keepalived 설치확인
			proxySetStatus = service.selectProxyTotServerChk("proxy_setting_tot");
			keepalivedSetStatus = service.selectProxyTotServerChk("keepalived_setting_tot");
			
			//서버 등록 시만  logic 실행
			if (proxyServerInfo != null) {
				proxySetYn = "true";
			}

			//proxy 설치되어 있는 경우 실행
			if (!"".equals(proxySetStatus) && !"not installed".equals(proxySetStatus)) {
				if ("true".equals(proxySetYn)) {
				}
			}
        } catch(Exception e) {
            e.printStackTrace();
        }  
    }
}