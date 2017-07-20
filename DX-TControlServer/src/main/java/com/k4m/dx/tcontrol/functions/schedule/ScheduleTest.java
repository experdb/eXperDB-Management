package com.k4m.dx.tcontrol.functions.schedule;

import static org.quartz.CronScheduleBuilder.cronSchedule;
import static org.quartz.JobBuilder.newJob;
import static org.quartz.TriggerBuilder.newTrigger;

import org.quartz.CronTrigger;
import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.quartz.impl.StdSchedulerFactory;


public class ScheduleTest {
	
	/** QUARTZ Scheduler */
	private Scheduler scheduler;
	
	public static void main(String[] args) throws SchedulerException {
		
	    // 실행할 준비가 된 Scheduler 인스턴스를 리턴한다.
        Scheduler scheduler = new StdSchedulerFactory().getScheduler();   
       
        // 쿼츠에서 Scheduler 는 시작,정지,일시정지를 할수 있다.
        // Scheduler 가 시작되지 않거나 일시 정지상태이면 Trigger 를 발동시키지 않으므로 start()해준다.
        scheduler.start();

        
			JobDetail job = newJob(ScheduleQuartzJob.class)
			    .withIdentity("scd_id", "21")
			    .build();

			job.getJobDataMap().put("scd_id", "21");
			
			CronTrigger trigger = newTrigger()
			    .withIdentity("scd_id", "21")
			    .withSchedule(cronSchedule("0/05 * * * * ?"))
			    .build();

			System.out.println(job);
			System.out.println(trigger);
			
			scheduler.scheduleJob(job, trigger);
      }
	}

