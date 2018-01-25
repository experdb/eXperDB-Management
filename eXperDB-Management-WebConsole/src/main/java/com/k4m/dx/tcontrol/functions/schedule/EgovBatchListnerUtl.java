package com.k4m.dx.tcontrol.functions.schedule;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
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
import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleVO;

public class EgovBatchListnerUtl implements JobListener {
	
	private ScheduleService scheduleService;
	Date beforeTime = null;
	/** Log Service */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovBatchListnerUtl.class);
	

	public void setScheduleService(ScheduleService scheduleService) {
		this.scheduleService = scheduleService;
	}
	
	@Resource(name="egovSchdulUtl")
	private ScheduleUtl scheduleUtl;

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

			beforeTime  = context.getNextFireTime();
			
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
			HashMap<String , Object> hp1 = new HashMap<String , Object>();
			HashMap<String , Object> hp2 = new HashMap<String , Object>();
			
			String scd_id = context.getJobDetail().getJobDataMap().getString("scd_id");
			
			List<Map<String, Object>> result = scheduleService.selectModifyScheduleList(Integer.parseInt(scd_id));
			hp1.put("scd_id", scd_id);
			hp2.put("scd_id", scd_id);
			
			String exe_perd_cd = (String) result.get(0).get("exe_perd_cd");
			
			Date nFireTime  = context.getNextFireTime();
		    Calendar cal = Calendar.getInstance();
		   		    
		    if(nFireTime != null){
		    	cal.setTime(nFireTime);
		    }
							
			if(exe_perd_cd.equals("TC001601")){
				 cal.add(Calendar.DATE, 1); 
				 ScheduleVO scheduleVO = new ScheduleVO();
				 scheduleVO.setScd_id(Integer.parseInt(scd_id));
				 scheduleVO.setScd_cndt("TC001801");
				 hp1.put("nFireTime", beforeTime);
				 hp2.put("nFireTime", cal.getTime());	
				 System.out.println("▶▶▶ 이전 작업 수행시간 업데이트");
				scheduleService.updatePrevJobTime(hp1);
				System.out.println("▶▶▶ 다음 작업 수행시간 업데이트");
				scheduleService.updateNxtJobTime(hp2);
				scheduleService.updateScheduleStatus(scheduleVO);
			}else if(exe_perd_cd.equals("TC001602")){
				 cal.add(Calendar.DATE, 7); 
				 ScheduleVO scheduleVO = new ScheduleVO();
				 scheduleVO.setScd_id(Integer.parseInt(scd_id));
				 scheduleVO.setScd_cndt("TC001801");
				 hp1.put("nFireTime", beforeTime);
				 hp2.put("nFireTime", cal.getTime());
				 System.out.println("▶▶▶ 이전 작업 수행시간 업데이트");
				scheduleService.updatePrevJobTime(hp1);
				System.out.println("▶▶▶ 다음 작업 수행시간 업데이트");
				scheduleService.updateNxtJobTime(hp2);
				scheduleService.updateScheduleStatus(scheduleVO);
			}else if(exe_perd_cd.equals("TC001603")){
				 cal.add(Calendar.MONTH, 1); 
				 ScheduleVO scheduleVO = new ScheduleVO();
				 scheduleVO.setScd_id(Integer.parseInt(scd_id));
				 scheduleVO.setScd_cndt("TC001801");
				 hp1.put("nFireTime", beforeTime);
				 hp2.put("nFireTime", cal.getTime());
				 System.out.println("▶▶▶ 이전 작업 수행시간 업데이트");
				scheduleService.updatePrevJobTime(hp1);
				System.out.println("▶▶▶ 다음 작업 수행시간 업데이트");
				scheduleService.updateNxtJobTime(hp2);
				scheduleService.updateScheduleStatus(scheduleVO);
			}else if(exe_perd_cd.equals("TC001604")){
				 cal.add(Calendar.YEAR, 1); 
				 ScheduleVO scheduleVO = new ScheduleVO();
				 scheduleVO.setScd_id(Integer.parseInt(scd_id));
				 scheduleVO.setScd_cndt("TC001801");	
				 hp1.put("nFireTime", beforeTime);
				 hp2.put("nFireTime", cal.getTime());
				 System.out.println("▶▶▶ 이전 작업 수행시간 업데이트");
				scheduleService.updatePrevJobTime(hp1);
				System.out.println("▶▶▶ 다음 작업 수행시간 업데이트");
				scheduleService.updateNxtJobTime(hp2);
				scheduleService.updateScheduleStatus(scheduleVO);
			}else{
				ScheduleVO scheduleVO = new ScheduleVO();
				scheduleVO.setScd_id(Integer.parseInt(scd_id));
				scheduleVO.setScd_cndt("TC001803");
				hp1.put("nFireTime", beforeTime);
				hp2.put("nFireTime", context.getScheduledFireTime());	
				 System.out.println("▶▶▶ 이전 작업 수행시간 업데이트");
				scheduleService.updatePrevJobTime(hp1);
				//1회수행은 끝나고 이전작업수행시간 업데이트
				System.out.println("▶▶▶ 이전 작업 수행시간 업데이트");
				scheduleService.updatePrevJobTime(hp2);
				scheduleService.updateScheduleStatus(scheduleVO);		
			}			
			System.out.println("================================================");		
		}
		catch(Exception e)
		{
			LOGGER.error(e.getMessage(), e);
		}
	}




}
