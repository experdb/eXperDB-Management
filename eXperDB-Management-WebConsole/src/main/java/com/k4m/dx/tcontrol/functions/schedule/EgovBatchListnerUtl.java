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
import org.springframework.web.bind.annotation.ModelAttribute;

import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleService;
import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleVO;
import com.k4m.dx.tcontrol.login.service.LoginVO;

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
			
				System.out.println("----------------------->>>>>>> Schedule Pre ");
			
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
			System.out.println("----------------------->>>>>>> Schedule Job Fail ");
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
		
		System.out.println("----------------------->>>>>>> Schedule After ");
	
		if(context.getNextFireTime() != null ) {
			System.out.println("Next Time = "+context.getNextFireTime());
		}

		try
		{
			HashMap<String , Object> hp = new HashMap<String , Object>();
			
			String scd_id = context.getJobDetail().getJobDataMap().getString("scd_id");
			
			SimpleDateFormat sDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	
			hp.put("scd_id", scd_id);
			if(context.getNextFireTime() != null ) {
				String  nextTime = sDate.format(context.getNextFireTime());
				hp.put("nFireTime", nextTime);
				}else {
					hp.put("nFireTime", null);
				}
			scheduleService.updateNxtJobTime(hp);
			
			
			List<Map<String, Object>> result = scheduleService.selectModifyScheduleList(Integer.parseInt(scd_id));
			
			String exe_perd_cd = (String) result.get(0).get("exe_perd_cd");
			
			ScheduleVO scheduleVO = new ScheduleVO();
			scheduleVO.setScd_id(Integer.parseInt(scd_id));
		
			
			if(exe_perd_cd.equals("TC001605")) {
				scheduleVO.setScd_cndt("TC001803");
				scheduleService.updateScheduleStatus(scheduleVO);
			}

		}
		catch(Exception e)
		{
			LOGGER.error(e.getMessage(), e);
		}
	}
}
	
