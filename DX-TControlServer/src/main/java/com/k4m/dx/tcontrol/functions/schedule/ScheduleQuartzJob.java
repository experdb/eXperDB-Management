package com.k4m.dx.tcontrol.functions.schedule;

import org.quartz.Job;
import org.quartz.JobDataMap;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ConfigurableApplicationContext;

import egovframework.rte.bat.core.launch.support.EgovBatchRunner;

public class ScheduleQuartzJob implements Job{

	@Autowired
	private EgovBatchRunner egovBatchRunner;
	private ConfigurableApplicationContext context;
	
	
	/**
	 * 1. 스케줄ID를 가져옴
	 * 2. 해당 스케줄ID에 해당하는 스케줄 상세정보 조회(work 정보)
	 * 3. work정보에 맞는 CMD 명령어 생성
	 * 4. 클라이언트 연결, 전송
	 */
	@Override
	public void execute(JobExecutionContext jobContext) throws JobExecutionException {
		
		 System.out.println(">>>>>>>>>>>>>>>> Schedule Start >>>>>>>>>>>>>");

		if(context != null && context.isActive())
		{	
			context.close();
		}
		
		JobDataMap dataMap = jobContext.getJobDetail().getJobDataMap();
	
		System.out.println(jobContext.getJobDetail().getKey().getName() +" , "+ dataMap.getString("scd_id"));
		
/*		String xml[] = {
				"egovframework/spring/context-batch-job-launcher.xml",
				"egovframework/spring/context-datasource.xml",
				"egovframework/spring/context-sqlMap.xml"};
		
		context = new ClassPathXmlApplicationContext(xml);
		context.getAutowireCapableBeanFactory().autowireBeanProperties(this,
				AutowireCapableBeanFactory.AUTOWIRE_BY_TYPE, false);
		
		long result = executeProgram2();

		// jobContext에 결과값을 저장한다.
		jobContext.setResult(result);*/
	}

	
	
/*	public long executeProgram2() {

		long result = 0;
		try
		{
			result = egovBatchRunner.start("", "");
		}
		catch (Exception e)
		{
			e.printStackTrace();
			result = -1;
		}		
		return result;
	}*/
}
