package com.experdb.proxy.socket.listener;

import static org.quartz.CronScheduleBuilder.cronSchedule;
import static org.quartz.JobBuilder.newJob;
import static org.quartz.TriggerBuilder.newTrigger;

import java.util.Date;

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
 
public class DXTcontrolProxyExecute extends SocketCtl {
	private SchedulerFactory schedulerFactory = null;
	private Scheduler scheduler = null;
	private static ApplicationContext context;
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
    public static void main(String[] args) {   
    	DXTcontrolProxyExecute dXTcontrolScale = new DXTcontrolProxyExecute();
    	dXTcontrolScale.start();
    }
    
    public DXTcontrolProxyExecute() {
        try {
	    	schedulerFactory = new StdSchedulerFactory();
	    	scheduler = schedulerFactory.getScheduler();
        } catch(Exception e) {
            e.printStackTrace();
        }
    }

    public void start() {
    	String strProxyJobTime = "";
    	String strProxyMonJobTime = "";
   
		context = new ClassPathXmlApplicationContext(new String[] {"context-tcontrol.xml"});
		ProxyServiceImpl service = (ProxyServiceImpl) context.getBean("ProxyService");
    	
    	try {
    		//선행조건 설정
    		//agent 가 설치되어있는지?
    		//keep, proxy가 설치되어있는지?
			String strIpadr = FileUtil.getPropertyValue("context.properties", "agent.install.ip");

			String proxySetYn = "";
			String proxySetStatus = "";

			ProxyServerVO searchProxyServerVO = new ProxyServerVO();
			searchProxyServerVO.setIpadr(strIpadr);

			//proxy 서버 등록 여부 확인
			ProxyServerVO proxyServerInfo = service.selectPrySvrInfo(searchProxyServerVO);

			//서버 미등록 일 경우 proxy 설치여부 및 keepalived 설치확인
			proxySetStatus = service.selectProxyTotServerChk("proxy_setting_tot", "");

			//서버 등록 시만  logic 실행
			if (proxyServerInfo != null) {
				proxySetYn = "true";
			}

			//proxy 설치되어 있는 경우 실행
			if (!"".equals(proxySetStatus) && !"not installed".equals(proxySetStatus)) {
				if ("true".equals(proxySetYn)) {
					//스케줄러 실행(proxy 리스너 통계 저장) - 매일 5분에 1번씩 실행
					strProxyJobTime = "0 0/5 * 1/1 * ? *";

					JobDetail jobProxy = newJob(DXTcontrolProxyExecuteChk.class).withIdentity("jobName", "group1").build();
    	        	CronTrigger triggerProxy = newTrigger().withIdentity("trggerName", "group1").withSchedule(cronSchedule(strProxyJobTime)).build(); //5분마다 설정

    	        	scheduler.scheduleJob(jobProxy, triggerProxy);
    	        	scheduler.start();

    	        	//스케줄러 실행(proxy 리스너 통계 저장 및 데이터 삭제) - 매일 00시 삭제
    	        	strProxyMonJobTime = "0 50 23 1/1 * ? *";
    	        	JobDetail jobProxyDay = newJob(DXTcontrolProxyExecuteDayChk.class).withIdentity("jobName", "group2").build();
    	        	CronTrigger triggerMons = newTrigger().withIdentity("trggerName", "group2").withSchedule(cronSchedule(strProxyMonJobTime)).build(); //매주 월요일 8시
    	        	scheduler.scheduleJob(jobProxyDay, triggerMons);
    	        	scheduler.start();
				}
			}        	
        } catch(Exception e) {
            e.printStackTrace();
        }  
    }
}