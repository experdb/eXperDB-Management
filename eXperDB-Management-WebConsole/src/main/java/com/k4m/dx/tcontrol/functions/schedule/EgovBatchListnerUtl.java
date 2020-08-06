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
			
			String scd_id = context.getJobDetail().getJobDataMap().getString("scd_id");
			
			List<Map<String, Object>> result = scheduleService.selectModifyScheduleList(Integer.parseInt(scd_id));
			hp1.put("scd_id", scd_id);
	
			String exe_perd_cd = (String) result.get(0).get("exe_perd_cd");
			
			
		    if(exe_perd_cd.equals("TC001601")){
				 ScheduleVO scheduleVO = new ScheduleVO();
				 scheduleVO.setScd_id(Integer.parseInt(scd_id));
				 String scd_cndt = "TC001801";
				 hp1.put("nFireTime", beforeTime);			
				 LOGGER.debug("================= PrevJ obTime Update ");
				scheduleService.updatePrevJobTime(hp1);
				 LOGGER.debug("================= Next JobTime Update ");
				updateScheduleNextTime(scd_id, scd_cndt);
			}else if(exe_perd_cd.equals("TC001602")){
				 ScheduleVO scheduleVO = new ScheduleVO();
				 scheduleVO.setScd_id(Integer.parseInt(scd_id));
				 String scd_cndt = "TC001801";
				 hp1.put("nFireTime", beforeTime);
				 LOGGER.debug("================= PrevJ obTime Update ");
				scheduleService.updatePrevJobTime(hp1);
				LOGGER.debug("================= Next JobTime Update ");
				updateScheduleNextTime(scd_id, scd_cndt);
			}else if(exe_perd_cd.equals("TC001603")){
				 ScheduleVO scheduleVO = new ScheduleVO();
				 scheduleVO.setScd_id(Integer.parseInt(scd_id));
				 String scd_cndt = "TC001801";
				 hp1.put("nFireTime", beforeTime);
				 LOGGER.debug("================= PrevJ obTime Update ");
				scheduleService.updatePrevJobTime(hp1);
				LOGGER.debug("================= Next JobTime Update ");
				updateScheduleNextTime(scd_id, scd_cndt);
			}else if(exe_perd_cd.equals("TC001604")){	
				 ScheduleVO scheduleVO = new ScheduleVO();
				 scheduleVO.setScd_id(Integer.parseInt(scd_id));
				 String scd_cndt = "TC001801";
				 hp1.put("nFireTime", beforeTime);
				 LOGGER.debug("================= PrevJ obTime Update ");
				scheduleService.updatePrevJobTime(hp1);
				LOGGER.debug("================= Next JobTime Update ");
				updateScheduleNextTime(scd_id, scd_cndt);
			}else{				
				String scd_cndt = "TC001803";
				hp1.put("nFireTime", beforeTime);
				LOGGER.debug("================= PrevJ obTime Update ");
				scheduleService.updatePrevJobTime(hp1);
				//1회수행은 끝나고 이전작업수행시간 업데이트
				LOGGER.debug("================= Next JobTime Update ");
				updateScheduleNextTime(scd_id, scd_cndt);
			}
		}
		catch(Exception e)
		{
			LOGGER.error(e.getMessage(), e);
		}
	}

	
	public void updateScheduleNextTime(String scd_id, String scd_cndt){
		HashMap<String , Object> hp2 = new HashMap<String , Object>();
		ScheduleVO scheduleVO = new ScheduleVO();
		scheduleVO.setScd_id(Integer.parseInt(scd_id));
		scheduleVO.setScd_cndt(scd_cndt);
		
		List<Map<String, Object>> result = null;
		
		// 1. 스케줄 마스터 업데이트
		try {		
			result = scheduleService.selectModifyScheduleList(Integer.parseInt(scd_id));
			
			SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");   
			
            String exe_perd_cd =result.get(0).get("exe_perd_cd").toString();    
            String exehms = result.get(0).get("exe_hms").toString().substring(4, 6)+":"+result.get(0).get("exe_hms").toString().substring(2, 4)+":"+result.get(0).get("exe_hms").toString().substring(0, 2);
        
            // 매일
            if(exe_perd_cd.equals("TC001601")){
            	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Calendar cal = Calendar.getInstance();
                String strToday = sdf.format(cal.getTime());

                // 현재날짜 + 수행시간
                String nextDay = strToday+" "+exehms;

                Date dt = transFormat.parse(nextDay);		                
                cal.setTime(dt);
                // 현재날짜+수행시간 + 1일
                cal.add(Calendar.DATE, 1);        	
                hp2.put("nFireTime", cal.getTime());	
      
            	
        	// 매주
            /* 1. 요일 정의 week = { "0", "1", "2", "3", "4", "5", "6" } == { "일", "월", "화", "수", "목", "금", "토" }
             * 2. 오늘 날짜에 해당하는 그 주 날짜 가져옴
             * 3. 오늘의 요일 가져옴
             * 4. 오늘 요일로부터 next ---------------> 검색
             *    4.1현재 오늘요일 체크(X)일때 날짜검색하여 업데이트
             *    4.2 현재 오늘요일 체크(0)일때 날짜검색하여 업데이트
             * 5. 오늘 요일로부터 Prev <--------------- 검색
             *    5.1 처음부터 오늘요일 이전날짜 까지 검색하여 업데이트
             * 6. 현재오늘 요일만 체크되었을경우
             */
            }else if(exe_perd_cd.equals("TC001602")){
            	String detail = exehms;
            	
         	    int  intNextCnt = 0; //next match count
         	    int  intPrevCnt = 0; //prev match count
	       	    String strFirstCheck = null;
	    	    String strChecked = null;	
	    	    boolean prevCheck = false;
	    	    boolean finalCheck = false;	  	            	
            	
            	// 1. 요일 정의 week = { "0", "1", "2", "3", "4", "5", "6" } == { "일", "월", "화", "수", "목", "금", "토" }
            	final String[] week =      { "0", "1", "2", "3", "4", "5", "6" };
            	
        		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
                Calendar cal = Calendar.getInstance();
                String strToday = sdf.format(cal.getTime());
            		
                // 2. 오늘 날짜에 해당하는 그 주 날짜 가져옴
                final String[] weekDay = fn_weekDay(strToday);
            	
                // 3. 오늘의 요일 가져옴
         	    int toDay = Integer.parseInt(week[cal.get(Calendar.DAY_OF_WEEK) - 1]);
  	
         	    
         	    //4. 오늘 요일로부터 next ---------------> 검색
        	    for(int i=toDay; i<result.get(0).get("exe_dt").toString().length(); i++){
        	    	
        	    	//4.1현재 오늘요일 체크(X)일때 날짜검색하여 업데이트
        	    	if(String.valueOf(result.get(0).get("exe_dt").toString().charAt(toDay)).equals("0")){
        	    		if(strChecked == null) {
        	    			if(String.valueOf(result.get(0).get("exe_dt").toString().charAt(i)).equals("1")) {	    			
        		    			strChecked = week[i];	
        		    			System.out.println("오늘 날짜 체크가 안되있을때 오른쪽으로 = "+strChecked);
        		    			String nextDay = weekDay[Integer.parseInt(strChecked)]+" "+detail;
        			    		Date dt = transFormat.parse(nextDay);		                
        		                cal.setTime(dt);     
        		                hp2.put("nFireTime", cal.getTime());	
        		    			intNextCnt ++;
        		    		}	
        	    		}
        	    	//4.2 현재 오늘요일 체크(0)일때 날짜검색하여 업데이트
        	    	}else{	    		
            			if(String.valueOf(result.get(0).get("exe_dt").toString().charAt(i)).equals("1")) {	    
            				strFirstCheck  = week[toDay];
            	    		if(intNextCnt == 1 && strFirstCheck != null) {
            	    			strChecked = week[i]; 	    
            	    			
            	    			System.out.println("오늘 날짜 체크 되있을때 오른쪽으로 = "+strChecked);
            	    			String nextDay = weekDay[Integer.parseInt(strChecked)]+" "+detail;
            		    		Date dt = transFormat.parse(nextDay);		                
            	                cal.setTime(dt);            	                           
            	                hp2.put("nFireTime", cal.getTime());	
            	    		}	    			   	    		
        	    			intNextCnt ++;
        	    		}  	   			
        	    	}
            	}
        	    
        	    if(strChecked == null){
        			prevCheck = true;
        		}

        	    //5. 오늘 요일로부터 Prev <------------------------ 검색
        	    if(prevCheck == true) {
        	    	//5.1 처음부터 오늘요일 이전날짜 까지 검색하여 업데이트
        	    	for(int i=toDay; i>=0; i--){
        	    		if(String.valueOf(result.get(0).get("exe_dt").toString().charAt(i)).equals("1")) {	    			
        	    			strChecked = week[i];
        	    			intPrevCnt ++;
        	    			System.out.println("처음부터검색 ="+strChecked);
        	    			String nextDay = weekDay[Integer.parseInt(strChecked)]+" "+detail;
        		    		Date dt = transFormat.parse(nextDay);		                
        	                cal.setTime(dt);
        	                
        	                // 현재날짜+수행시간 + 7일
        	                cal.add(Calendar.DATE, 7);               
        	                hp2.put("nFireTime", cal.getTime());	
        	    		}
        	    	}	    
        	    } 
        	    
        	    if(strChecked == null){
        			finalCheck = true;
        		}
        	    
        	    //6. 현재오늘 요일만 체크되었을경우
        	    if(finalCheck == true){
        	    	if(intNextCnt==1 && intPrevCnt==0 && strFirstCheck != null) {
        	    		strChecked  = week[toDay];
        	    		System.out.println("오늘요일만 매주 ="+strChecked);
        	    		String nextDay = weekDay[Integer.parseInt(strChecked)]+" "+detail;
        	    		Date dt = transFormat.parse(nextDay);		                
                        cal.setTime(dt);
                        
                        // 현재날짜+수행시간 + 7일
                        cal.add(Calendar.DATE, 7);               
                        hp2.put("nFireTime", cal.getTime());	
        	    	} 
        	    }
	        // 매월
            }else if(exe_perd_cd.equals("TC001603")){
            	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
                Calendar cal = Calendar.getInstance();
                String strToday = sdf.format(cal.getTime());
                
                // 현재날짜 + 수행시간
                String nextDay = strToday+"-"+result.get(0).get("exe_day").toString()+" "+exehms;
                
                Date dt = transFormat.parse(nextDay);		                
                cal.setTime(dt);
                // 현재날짜+수행시간 + 1월
            	cal.add(Calendar.MONTH, 1); 
            	hp2.put("nFireTime", cal.getTime());	
            	
            // 매년
            }else if(exe_perd_cd.equals("TC001604")){
            	SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
                Calendar cal = Calendar.getInstance();
                String strToday = sdf.format(cal.getTime());
                
                // 현재날짜 + 수행시간
                String nextDay = strToday+"-"+result.get(0).get("exe_month").toString()+"-"+result.get(0).get("exe_day").toString()+" "+exehms;
                
                Date dt = transFormat.parse(nextDay);		                
                cal.setTime(dt);
                // 현재날짜+수행시간 + 1년
            	 cal.add(Calendar.YEAR, 1); 
            	 hp2.put("nFireTime", cal.getTime());	
            }else{
            	 //agent에서 스케줄 상태 업데이트
            	scheduleService.updateScheduleStatus(scheduleVO);
            }
            scheduleService.updateNxtJobTime(hp2);

            //agent에서 스케줄 상태 업데이트
			//scheduleService.updateScheduleStatus(scheduleVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
				
	}


	public static String[] fn_weekDay(String yyyymmdd) {
		  Calendar cal = Calendar.getInstance();
		  int toYear = 0;
		  int toMonth = 0;
		  int toDay = 0;
		  if(yyyymmdd == null || yyyymmdd.equals("")){   //파라메타값이 없을경우 오늘날짜
		   toYear = cal.get(cal.YEAR);  
		   toMonth = cal.get(cal.MONTH)+1;
		   toDay = cal.get(cal.DAY_OF_MONTH);
		   
		   int yoil = cal.get(cal.DAY_OF_WEEK); //요일나오게하기(숫자로)

		   if(yoil != 1){   //해당요일이 일요일이 아닌경우
		    yoil = yoil-2;
		   }else{           //해당요일이 일요일인경우
		    yoil = 7;
		   }
		   cal.set(toYear, toMonth-1, toDay-yoil);  //해당주월요일로 세팅
		  }else{
		   int yy =Integer.parseInt(yyyymmdd.substring(0, 4));
		   int mm =Integer.parseInt(yyyymmdd.substring(4, 6))-1;
		   int dd =Integer.parseInt(yyyymmdd.substring(6, 8));
		   cal.set(yy, mm,dd);
		  }
		  String[] arrYMD = new String[7];
		  
		  int inYear = cal.get(cal.YEAR);  
		  int inMonth = cal.get(cal.MONTH);
		  int inDay = cal.get(cal.DAY_OF_MONTH);
		  int yoil = cal.get(cal.DAY_OF_WEEK); //요일나오게하기(숫자로)
		  if(yoil != 1){   //해당요일이 일요일이 아닌경우
		      yoil = yoil-2;
		   }else{           //해당요일이 일요일인경우
		      yoil = 7;
		   }
		  inDay = inDay-yoil;
		  for(int i = 0; i < 7;i++){
		   cal.set(inYear, inMonth, inDay+i);  //
		   String y = Integer.toString(cal.get(cal.YEAR));  
		   String m = Integer.toString(cal.get(cal.MONTH)+1);
		   String d = Integer.toString(cal.get(cal.DAY_OF_MONTH)-1);
		   if(m.length() == 1) m = "0" + m; 
		   if(d.length() == 1) d = "0" + d; 
		   
		   arrYMD[i] = y+"-"+m+"-"+d;	   
		  }		  
		  return arrYMD;	
	}	
}
