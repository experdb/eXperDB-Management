package com.k4m.dx.tcontrol.socket.listener;

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
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.k4m.dx.tcontrol.db.repository.service.ScaleServiceImpl;
import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.util.FileUtil;
 
public class DXTcontrolScale extends SocketCtl {
	private SchedulerFactory schedulerFactory = null;
	private Scheduler scheduler = null;
	private static ApplicationContext context;
	
    public static void main(String[] args) {   
    	DXTcontrolScale dXTcontrolScale = new DXTcontrolScale();
    	dXTcontrolScale.start();
    }
    
    public DXTcontrolScale() {
        try {
	    	schedulerFactory = new StdSchedulerFactory();
	    	scheduler = schedulerFactory.getScheduler();
        } catch(Exception e) {
            e.printStackTrace();
        }
    }

    public void start() {
    	JSONObject jObjResult = null;
    	String scalejsonChk = "";
    	String awsServerChk = "";
    	int iSetCount = 0;

		context = new ClassPathXmlApplicationContext(new String[] {"context-tcontrol.xml"});
		ScaleServiceImpl service = (ScaleServiceImpl) context.getBean("ScaleService");
    	
    	try {
        	//선행조건 aws 설치 서버인지 확인 후 scale 관련 logic 실행
    		jObjResult = service.scaleAwsConnect(null, "scaleAwsChk", 0, client, is, os);
    		
			if (jObjResult != null) {
				String resultCode = (String)jObjResult.get(ProtocolID.RESULT_CODE);

				if (resultCode.equals("0")) {
					scalejsonChk = (String)jObjResult.get(ProtocolID.RESULT_SUB_DATA);
				}
			}
			
			if (scalejsonChk != null) {
				if (scalejsonChk.contains("no aws")) {
					awsServerChk = "N";
				} else {
					awsServerChk = "Y";
				}
			} else {
				awsServerChk = "N";
			}
			
			//auto setting count
			iSetCount = scaleAwsAutoSetChk();
			String strAutoScaleTime = "";

			//* AWS 서버 확인 - AWS 서버일경우만 스케줄러 실행
        	if ("Y".equals(awsServerChk)) {
        		//* auto 설정이 되어있는 경우만 실행
        		if (iSetCount > 0) {
    	        	//스케줄러 실행(load 데이터 삭제) - 주1회 월요일 오전 8시 일주일전 자료까지 삭제
        			strAutoScaleTime = FileUtil.getPropertyValue("context.properties", "agent.scale_auto_exe_time");
        			
    	        	JobDetail jobMons = newJob(DXTcontrolScaleChogihwa.class).withIdentity("jobName", "group1").build();
    	        	CronTrigger triggerMons = newTrigger().withIdentity("trggerName", "group1").withSchedule(cronSchedule(strAutoScaleTime)).build(); //매주 월요일 8시
    	        	scheduler.scheduleJob(jobMons, triggerMons);
    	        	scheduler.start();

    	        	//스케줄러 실행(load 데이터 등록)
        			strAutoScaleTime = FileUtil.getPropertyValue("context.properties", "agent.scale_auto_reset_time");

    	        	JobDetail jobScale = newJob(DXTcontrolScaleExecute.class).withIdentity("jobName", "group2").build();
    	        //	CronTrigger triggerScale = newTrigger().withIdentity("trggerName", "group2").withSchedule(cronSchedule("0 0/5 * 1/1 * ? *")).build(); //5분마다
    	        	CronTrigger triggerScale = newTrigger().withIdentity("trggerName", "group2").withSchedule(cronSchedule(strAutoScaleTime)).build(); //1분마다 테스트용 나중에 삭제
    	        	scheduler.scheduleJob(jobScale, triggerScale);
    	        	scheduler.start();
        		}
        	}
        } catch(Exception e) {
            e.printStackTrace();
        }  
    }

    //scale auto 설정 확인
    public int scaleAwsAutoSetChk() {
    	int iCount = 0;
    	Map<String, Object> param = new HashMap<String, Object>();

		context = new ClassPathXmlApplicationContext(new String[] {"context-tcontrol.xml"});
		ScaleServiceImpl service = (ScaleServiceImpl) context.getBean("ScaleService");

    	try {
	    	param.put("db_svr_id", service.dbServerInfoSet());
	    	iCount = service.selectScaleITotCnt(param);
			
	    } catch(Exception e) {
	        e.printStackTrace();
	    }  
    	
    	return iCount;
    }  
}