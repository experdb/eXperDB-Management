package com.k4m.dx.tcontrol.functions.schedule;

import static org.quartz.CronScheduleBuilder.cronSchedule;
import static org.quartz.JobBuilder.newJob;
import static org.quartz.TriggerBuilder.newTrigger;

import java.util.List;

import org.json.simple.JSONArray;
import org.quartz.CronTrigger;
import org.quartz.JobDetail;
import org.quartz.JobKey;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.quartz.SchedulerFactory;
import org.quartz.impl.StdSchedulerFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleService;
import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleVO;

public class ScheduleUtl {
	
	/** QUARTZ Scheduler */
	private Scheduler scheduler;

	private ScheduleService scheduleService;

	/** Log Service */
	private static final Logger LOGGER = LoggerFactory.getLogger(ScheduleUtl.class);
	
	public void setScheduleService(ScheduleService scheduleService) {
		this.scheduleService = scheduleService;
	}

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
		List<ScheduleVO> result = null;
		ScheduleVO scheduleVO = null;
		
		result = scheduleService.selectInitScheduleList();
		
		
		/*
		 	STEP 2. Scheduler 생성
		 */
		SchedulerFactory schedulerFactory = new StdSchedulerFactory();
		scheduler = schedulerFactory.getScheduler();
		
		
		/*
		 	STEP 3. JobListener 생성
		 	    - STEP 3.1. JobListener Class 생성
		 	    - STEP 3.2. SchdulService 설정
		 	    - STEP 3.3. SchdulResultService 설정
		 	    - STEP 3.4. Scheduler 객체에 JobListener 설정
		 */
		EgovBatchListnerUtl egovBatchListenerUtl = new EgovBatchListnerUtl();					// STEP 3.1. JobListener Class 생성
		egovBatchListenerUtl.setScheduleService(scheduleService);									// STEP 3.3. SchdulResultService 설정
		scheduler.getListenerManager().addJobListener(egovBatchListenerUtl);						// STEP 3.7. Scheduler 객체에 JobListener 설정
		
		
		/*
	 		STEP 4. Schedule 등록 (LOOP - 스케줄 List)
		 */
		for(int i=0; i<result.size(); i++){
			insertSchdul(result.get(i));
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
		String exe_perd_cd =scheduleVO.getExe_perd_cd(); //실행주기코드
		String exe_dt =  scheduleVO.getExe_dt(); //실행일시
		String exe_month = scheduleVO.getExe_month();
		String exe_day = scheduleVO.getExe_day();
		String exe_s =  scheduleVO.getExe_hms().substring(0, 2);
		String exe_m = scheduleVO.getExe_hms().substring(2, 4);
		String exe_h = scheduleVO.getExe_hms().substring(4, 6);
		String exe_hms = scheduleVO.getExe_hms();
		
		
		//System.out.println(">>>>>>>>>>>>>> SehecduleUtl 새로운 잡생성");
		LOGGER.debug("▶▶▶▶▶▶▶▶▶SehecduleUtl 새로운 잡생성");
		JobDetail job = newJob(ScheduleQuartzJob.class)
			    .withIdentity("BackupSehedule_"+String.valueOf(scd_id),String.valueOf(scd_id))
			    .build();

		job.getJobDataMap().put("scd_id", String.valueOf(scd_id));
		
		//System.out.println(">>> cronTrigger 생성");
		LOGGER.debug("▶▶▶▶▶▶▶▶▶cronTrigger 생성");
		System.out.println("=========== PRAMETER ==========");
		System.out.println("실행주기 코드 : TC001601(매일), TC001602(매주), TC001603(매월), TC001604(매년), TC001605(1회실행) " );
		System.out.println("실행주기 : " + exe_perd_cd );
		System.out.println("실행일시 : " + exe_dt);
		System.out.println("실행시분초 : " + exe_hms);
		System.out.println("=============================");
		System.out.println(sce.getCronExpression(exe_perd_cd, exe_dt, exe_h, exe_m, exe_s, exe_month, exe_day));
		
		CronTrigger trigger = newTrigger()
		    .withIdentity("scd_id", String.valueOf(scd_id))
		    .withSchedule(cronSchedule(sce.getCronExpression(exe_perd_cd, exe_dt, exe_h, exe_m, exe_s, exe_month, exe_day)))
		    .build();	
		try
		{
			LOGGER.debug("▶▶▶▶▶▶▶▶▶스케줄 등록");
			scheduler.scheduleJob(job, trigger);
		}
		catch (Exception e)
		{
			e.printStackTrace();
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
			LOGGER.error("▶▶▶deleteSchdul[스케줄러 삭제 중 에러 발생. (schdulNo={}, batchId={}]", scd_id);
			LOGGER.error("▶▶▶{}", e.getMessage());
		}

		/*------------------------------ logic ------------------------------ logic ------------------------------*/
	}


	


}
