package com.k4m.dx.tcontrol.functions.schedule;

import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.quartz.JobDataMap;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.quartz.JobKey;
import org.quartz.JobListener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleService;

public class EgovBatchListnerUtl implements JobListener {
	
	private ScheduleService scheduleService;
	
	/** Log Service */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovBatchListnerUtl.class);
	

	public void setScheduleService(ScheduleService scheduleService) {
		this.scheduleService = scheduleService;
	}

	/**
	 * Class Name 값을 리턴한다
	 * @return String
	 */
	public String getName() {
		return this.getClass().getName();
	}

	/**
	 * Job 시작 시 수행
	 */
	public void jobToBeExecuted(JobExecutionContext context)
	{	
		try
		{
			System.out.println("▶▶▶ JOB 시작 시 수행!!!");		
			
			HashMap<String , Object> hp = new HashMap<String , Object>();
			
			String scd_id = context.getJobDetail().getJobDataMap().getString("scd_id");
			Date nFireTime  = context.getNextFireTime();
			
			hp.put("scd_id", scd_id);
			hp.put("nFireTime", nFireTime);
			
			System.out.println("▶▶▶ 다음 작업 수행시간 업데이트");
			scheduleService.updateNxtJobTime(hp);
		
		}
		catch(Exception e)
		{
			LOGGER.error(e.getMessage(), e);
		}	
	}

	
	
	
	
	/**
	 * Job 호출 실패 시 수행
	 */
	public void jobExecutionVetoed(JobExecutionContext context) {
		
		try
		{
			System.out.println("▶▶▶ JOB 실패 시 수행!!!");
		}
		catch(Exception e)
		{
			LOGGER.error(e.getMessage(), e);
		}
	}

	
	
	
	
	
	/**
	 * Job 수행 완료 시 수행
	 */
	public void jobWasExecuted(JobExecutionContext context, JobExecutionException jobException)
	{
	
		try
		{
			LOGGER.debug("▶▶▶ JOB 수행 완료");
		
			HashMap<String , Object> hp = new HashMap<String , Object>();
			
			String scd_id = context.getJobDetail().getJobDataMap().getString("scd_id");
			Date nFireTime  = context.getNextFireTime();

			hp.put("scd_id", scd_id);
			hp.put("nFireTime", nFireTime);		
			scheduleService.updatePrevJobTime(hp);
				
	/*		JobKey job_key = context.getJobDetail().getKey();
			String job_name = context.getJobDetail().getKey().getName();
			String job_group= context.getJobDetail().getKey().getGroup();
	
			LOGGER.debug("▶▶▶ 수행완료된 JOB 삭제");
			ScheduleUtl sUtl = new ScheduleUtl();
			sUtl.deleteSchdul(job_key);*/
			
		}
		catch(Exception e)
		{
			LOGGER.error(e.getMessage(), e);
		}
	}




}
