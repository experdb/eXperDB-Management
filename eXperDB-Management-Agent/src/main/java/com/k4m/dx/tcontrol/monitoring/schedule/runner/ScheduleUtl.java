package com.k4m.dx.tcontrol.monitoring.schedule.runner;

import static org.quartz.CronScheduleBuilder.cronSchedule;
import static org.quartz.JobBuilder.newJob;
import static org.quartz.TriggerBuilder.newTrigger;

import java.util.ArrayList;
import java.util.List;

import org.quartz.CronTrigger;
import org.quartz.JobDetail;
import org.quartz.JobKey;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.quartz.SchedulerFactory;
import org.quartz.impl.StdSchedulerFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.k4m.dx.tcontrol.monitoring.schedule.listener.EgovBatchListner;
import com.k4m.dx.tcontrol.monitoring.schedule.service.vo.ScheduleVO;


public class ScheduleUtl {
	
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	/** QUARTZ Scheduler */
	private Scheduler scheduler;


	/** Log Service */
	private static final Logger LOGGER = LoggerFactory.getLogger(ScheduleUtl.class);
	
	/**
	 * EgovSchdulUtl Class 초기화 메소드
	 * @throws Exception
	 */
	@SuppressWarnings("null")
	public void init() throws Exception
	{

		/*
	 	 	STEP 1. 스케줄 List 조회
		*/
		List<ScheduleVO> result = new ArrayList<ScheduleVO>();
		//ScheduleVO scheduleVO = null;
		
		//result = scheduleService.selectInitScheduleList();
		
		ScheduleVO scheduleVO = new ScheduleVO();

		SchedulerFactory schedulerFactory = new StdSchedulerFactory();
		scheduler = schedulerFactory.getScheduler();
		
		
		EgovBatchListner egovBatchListenerUtl = new EgovBatchListner();					
		scheduler.getListenerManager().addJobListener(egovBatchListenerUtl);
		
		
		
		String scd_nm = "";
		String scd_cmd = "";
		String scd_code = "";
		String scd_H = "";
		String scd_M = "";
		String scd_S = "";
		
		scheduleVO.setScd_id(1);
		scheduleVO.setScd_nm(scd_nm);
		scheduleVO.setScd_cmd(scd_cmd);
		scheduleVO.setScd_code(scd_code);
		scheduleVO.setScd_H(scd_H);
		scheduleVO.setScd_M(scd_M);
		scheduleVO.setScd_S(scd_S);
		
		
		result.add(scheduleVO);
		

		if(result != null) {
			for(int i=0; i<result.size(); i++){
				insertSchdul(result.get(i));
			}
		}
		
		
		/*
		 	STEP 5. Scheduler 시작
		 */
		scheduler.start();
 
	}
	
	/**
	 * ScheduleUtl Class Destroy 메소드
	 * @throws Exception
	 */
	public void destroy() throws Exception
	{
		if (scheduler != null)
		{
			scheduler.shutdown();
		}
	}
	
	/**
	 * Scheduler 에 일정 등록
	 * @param ScheduleVO schduleVO
	 * @throws Exception
	 */
	public void insertSchdul(ScheduleVO scheduleVO) throws Exception
	{
		ScheduleCronExpression sce = new ScheduleCronExpression();
		
		int scd_id = scheduleVO.getScd_id(); //스케줄ID
		String scd_nm = scheduleVO.getScd_nm();
		String scd_cmd = scheduleVO.getScd_cmd();
		String scd_code = scheduleVO.getScd_code();
		String scd_H =  scheduleVO.getScd_H();
		String scd_M = scheduleVO.getScd_M();
		String scd_S = scheduleVO.getScd_S();
		
		//시 , 분 , 초
		try
		{
			scd_id = 1;
			scd_cmd = "*/5 * * * * ?";  //초
			scd_cmd = "* */5 * * * ?"; //분
			scd_cmd = "* * */5 * * ?"; //시
			
			JobDetail job = newJob(ScheduleQuartzJob.class)
				    .withIdentity("MonitoringSehedule_"+String.valueOf(scd_id),String.valueOf(scd_id))
				    .build();
	
			job.getJobDataMap().put("scd_id", String.valueOf(scd_id));
			
			
			CronTrigger trigger = newTrigger()
			    .withIdentity("scd_id", String.valueOf(scd_id))
			    .withSchedule(cronSchedule(scd_cmd))
			    .build();	

			scheduler.scheduleJob(job, trigger);
		}
		catch (Exception e)
		{
			e.printStackTrace();
			errLogger.error("insertSchdul {} ", e.toString());
		}
		
	}
	
	
	
	/**
	 * Scheduler 에서 일정 삭제
	 * @param job_group 
	 * @param schdulVO SchdulVO
	 * @throws Exception
	 */
	public void deleteSchdul(String scd_id) throws Exception
	{	
		/*------------------------------ logic ------------------------------ logic ------------------------------*/
		/*
		 	STEP 1. Scheduler 에 등록된 일정 삭제(KeyValue=schdulNo)
		 */
		/*------------------------------ logic ------------------------------ logic ------------------------------*/
		
		try
		{
			/*
			 	STEP 1. Scheduler에 등록된 일정 삭제
			 */		
			String name = "BackupSehedule_"+String.valueOf(scd_id);

			
			scheduler.deleteJob(JobKey.jobKey(name, scd_id));
			
			LOGGER.debug("▶▶▶deleteSchdul.registedScheduleList[{}]", scheduler.getJobGroupNames());
		}
		catch(SchedulerException e)
		{
			errLogger.error("deleteSchdul {} ", e.toString());
		}

		/*------------------------------ logic ------------------------------ logic ------------------------------*/
	}


	


}
