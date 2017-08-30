package com.k4m.dx.tcontrol.functions.schedule;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
			
			System.out.println("▶▶▶ 이전 작업 수행시간 업데이트");
			scheduleService.updatePrevJobTime(hp);
		
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
			

			List<Map<String, Object>> result = scheduleService.selectModifyScheduleList(Integer.parseInt(scd_id));
			String exe_perd_cd = (String) result.get(0).get("exe_perd_cd");
			
			hp.put("scd_id", scd_id);

			Date nFireTime  = context.getNextFireTime();

		    Calendar cal = Calendar.getInstance();
		    
		    System.out.println(nFireTime);
		    
		    if(!exe_perd_cd.equals("TC001605")){
		    	cal.setTime(nFireTime);
		    }
			
			
			
			if(exe_perd_cd.equals("TC001601")){
				 cal.add(Calendar.DATE, 1); 
				 hp.put("nFireTime", cal.getTime());
				 System.out.println("▶▶▶ 다음 작업 수행시간 업데이트");
				scheduleService.updateNxtJobTime(hp);
			}else if(exe_perd_cd.equals("TC001602")){
				 cal.add(Calendar.DATE, 7); 
				 hp.put("nFireTime", cal.getTime());
				 System.out.println("▶▶▶ 다음 작업 수행시간 업데이트");
				scheduleService.updateNxtJobTime(hp);
			}else if(exe_perd_cd.equals("TC001603")){
				 cal.add(Calendar.MONTH, 1); 
				 hp.put("nFireTime", cal.getTime());
				 System.out.println("▶▶▶ 다음 작업 수행시간 업데이트");
				scheduleService.updateNxtJobTime(hp);
			}else if(exe_perd_cd.equals("TC001604")){
				 cal.add(Calendar.YEAR, 1); 
				 hp.put("nFireTime", cal.getTime());
				 System.out.println("▶▶▶ 다음 작업 수행시간 업데이트");
				 scheduleService.updateNxtJobTime(hp);
			}

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
