package com.k4m.dx.tcontrol.functions.schedule;

import static org.quartz.CronScheduleBuilder.cronSchedule;
import static org.quartz.JobBuilder.newJob;
import static org.quartz.TriggerBuilder.newTrigger;

import org.quartz.CronTrigger;
import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.SchedulerFactory;
import org.quartz.impl.StdSchedulerFactory;

import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleVO;




public class ScheduleUtl {
	
	/** QUARTZ Scheduler */
	private Scheduler scheduler;
	
	
	/**
	 * EgovSchdulUtl Class 초기화 메소드
	 * @throws Exception
	 */
	public void init() throws Exception
	{

	    // 실행할 준비가 된 Scheduler 인스턴스를 리턴한다.
		SchedulerFactory schedulerFactory = new StdSchedulerFactory();
		scheduler = schedulerFactory.getScheduler();
       
        // 쿼츠에서 Scheduler 는 시작,정지,일시정지를 할수 있다.
        // Scheduler 가 시작되지 않거나 일시 정지상태이면 Trigger 를 발동시키지 않으므로 start()해준다.
        scheduler.start();

		/*
		 	STEP 2. Scheduler 생성
		 */
		//SchedulerFactory schedulerFactory = new StdSchedulerFactory();
		//scheduler = schedulerFactory.getScheduler();
		
	
		/*
		 	STEP 5. Scheduler 시작
		 */
		//scheduler.start();

	}
	
	/**
	 * EgovSchdulUtl Class Destroy 메소드
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
		String exe_h =  scheduleVO.getExe_h(); //시간
		String exe_m = scheduleVO.getExe_m(); //분
		String exe_s = scheduleVO.getExe_s(); //초
		String exe_hms = scheduleVO.getExe_hms();
		
		
		System.out.println(">>> SehecduleUtl 새로운 잡생성");
		JobDetail job = newJob(ScheduleQuartzJob.class)
			    .withIdentity(String.valueOf(scd_id))
			    .build();
		
		System.out.println("스케줄ID 담아 보냄!");
		job.getJobDataMap().put("scd_id", scd_id);
		
		System.out.println(">>> cronTrigger 생성");
		System.out.println("=========== PRAMETER ==========");
		System.out.println("실행주기 코드 : TC001601(매일), TC001602(매주), TC001603(매월), TC001604(매년), TC001605(1회실행) " );
		System.out.println("실행주기 : " + exe_perd_cd );
		System.out.println("실행일시 : " + exe_dt);
		System.out.println("실행시분초 : " + exe_hms);
		System.out.println("=============================");
		System.out.println(sce.getCronExpression(exe_perd_cd, exe_dt, exe_h, exe_m, exe_s));
		CronTrigger trigger = newTrigger()
		    .withIdentity(String.valueOf(scd_id))
		    .withSchedule(cronSchedule(sce.getCronExpression(exe_perd_cd, exe_dt, exe_h, exe_m, exe_s)))
		    .build();	
		try
		{
			System.out.println(">> 스케줄 등록");
			System.out.println(job);
			System.out.println(trigger);
			scheduler.scheduleJob(job, trigger);
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		
	}

}
