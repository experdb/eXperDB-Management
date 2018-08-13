package com.k4m.dx.tcontrol.monitoring.schedule.listener;

import javax.annotation.Resource;

import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.quartz.JobListener;

import com.k4m.dx.tcontrol.monitoring.schedule.runner.ScheduleUtl;

/**
* @author 박태혁
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2018.06.28   박태혁 최초 생성
*      </pre>
*/
public class EgovBatchListner implements JobListener {
	
	

	
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
			
		}
		catch(Exception e)
		{
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

		}
	}

	
	
	
	
	
	/**
	 * Job 수행 완료 시 수행
	 */
	public void jobWasExecuted(JobExecutionContext context, JobExecutionException jobException)
	{

	}




}
