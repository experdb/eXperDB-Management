package com.k4m.dx.tcontrol.functions.schedule.web;


import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.quartz.Scheduler;
import org.quartz.impl.StdSchedulerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityService;
import com.k4m.dx.tcontrol.backup.service.BackupService;
import com.k4m.dx.tcontrol.backup.service.WorkVO;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.functions.schedule.ScheduleUtl;
import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleDtlVO;
import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleService;
import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleVO;
import com.k4m.dx.tcontrol.login.service.LoginVO;

/**
 * Schedule 컨트롤러 클래스를 정의한다.
 *
 * @author 변승우
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.07.03   변승우 최초 생성
 *      </pre>
 */
@Controller
public class ScheduleController {
	
	@Autowired
	private BackupService backupService;
	
	@Autowired
	private AccessHistoryService accessHistoryService;
	
	@Autowired

	private MenuAuthorityService menuAuthorityService;
	
	@Autowired
	private ScheduleService scheduleService;
	
	
	private List<Map<String, Object>> menuAut;


	/**
	 * Mybatis Transaction 
	 */
	@Autowired
	private PlatformTransactionManager txManager;
	
	@Resource(name="egovSchdulUtl")
	private ScheduleUtl scheduleUtl;
	
	/**
	 * 스케줄등록 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertScheduleView.do")
	public ModelAndView insertScheduleView(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		
		ModelAndView mv = new ModelAndView();
		
		try {
			//해당메뉴 권한 조회 (공통메소드호출)
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000101");	
		}catch (Exception e) {
			e.printStackTrace();
		}
	
		try {			
			//읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{				
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0042");
				historyVO.setMnu_id(2);
				accessHistoryService.insertHistory(historyVO);
				
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
				mv.setViewName("functions/scheduler/schedulerRegister");
			}			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
		
	/**
	 * 스케쥴 work 등록 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/scheduleRegForm.do")
	public ModelAndView scheduleRegForm(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		
		ModelAndView mv = new ModelAndView("jsonView");
	
		try {
			//해당메뉴 권한 조회 (공통메소드호출)
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000101");
		}catch (Exception e) {
			e.printStackTrace();
		}

		try {			
			//쓰기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if(menuAut.get(0).get("wrt_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{	
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0043");
				historyVO.setMnu_id(2);
				accessHistoryService.insertHistory(historyVO);
			}			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
		
		
	/**
	 *  work List팝업 work List를 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value = "/selectWorkList.do")
	@ResponseBody
	public List<WorkVO> selectWorkList(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("workVO") WorkVO workVO, HttpServletResponse response, HttpServletRequest request) {
	
		try {
			//해당메뉴 권한 조회 (공통메소드호출)
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000101");
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		List<WorkVO> resultSet = null;
		try {			
			//읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultSet;
			}else{		
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0043_01");
				historyVO.setMnu_id(3);
				accessHistoryService.insertHistory(historyVO);
				
				System.out.println("=======parameter=======");
				System.out.println("구분 : " + workVO.getBsn_dscd());
				System.out.println("워크명 : " + workVO.getWrk_nm());
				System.out.println("=====================");
				String locale_type = LocaleContextHolder.getLocale().getLanguage();
				
				resultSet = scheduleService.selectWorkList(workVO, locale_type);	
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
	
	
	/**
	 * 스케쥴 work List를 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectScheduleWorkList.do")
	@ResponseBody
	public List<Map<String, Object>> selectScheduleWorkList(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
		try {
			//해당메뉴 권한 조회 (공통메소드호출)
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000101");
		}catch (Exception e) {
			e.printStackTrace();
		}

		int cnt = Integer.parseInt(request.getParameter("tCnt"));

		List<Map<String, Object>> result = null;
		
		try {					
			//읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return result;
			}else{		
				String work_id = request.getParameter("work_id");

				String[] Param = work_id.toString().substring(1, work_id.length()-1 ).split(",");
				HashMap<String , Object> paramvalue = new HashMap<String, Object>();
				List<String> ids = new ArrayList<String>(); 
				String locale_type = LocaleContextHolder.getLocale().getLanguage();

				for(int i=0; i<Param.length; i++){
					ids.add(Param[i].toString()); 
				}
				paramvalue.put("work_id", ids);
				paramvalue.put("cnt", cnt);
				paramvalue.put("locale_type", locale_type);
				
				result = scheduleService.selectScheduleWorkList(paramvalue);

				return result;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	/**
	 * DB2PG 스케쥴 work List를 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectDb2pgScheduleWorkList.do")
	@ResponseBody
	public List<Map<String, Object>> selectDb2pgScheduleWorkList(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
	
		try {
			//해당메뉴 권한 조회 (공통메소드호출)
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000101");
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		List<Map<String, Object>> result = null;
		
		int cnt = Integer.parseInt(request.getParameter("tCnt"));
		
		try {					
			//읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return result;
			}else{		
				String work_id = request.getParameter("work_id");
				
				String[] Param = work_id.toString().substring(1, work_id.length()-1 ).split(",");
				HashMap<String , Object> paramvalue = new HashMap<String, Object>();
				List<String> ids = new ArrayList<String>(); 
				
				for(int i=0; i<Param.length; i++){
					ids.add(Param[i].toString()); 
				}
				
				paramvalue.put("work_id", ids);
				paramvalue.put("cnt", cnt);
				
				result = scheduleService.selectDb2pgScheduleWorkList(paramvalue);
				return result;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	
	/**
	 * 스케쥴을 등록한다.
	 * 
	 * @return 
	 * @throws Exception
	 */
	
	/*
	 * 1. 스케줄ID 시퀀스 조회
	 * 2. 스케줄 마스터 등록
	 * 3. 스케줄 상세정보 등록
	 */
	@RequestMapping(value = "/insertSchedule.do")
	@ResponseBody
	public String insertSchedule(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("scheduleVO") ScheduleVO scheduleVO,@ModelAttribute("scheduleDtlVO") ScheduleDtlVO scheduleDtlVO, HttpServletResponse response, HttpServletRequest request, @RequestParam Map<String,String> reqJson) throws Exception{
		
		try {
			//해당메뉴 권한 조회 (공통메소드호출)
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000101");
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		// Transaction 
		DefaultTransactionDefinition def  = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = txManager.getTransaction(def);
		
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		String usr_id = loginVo.getUsr_id();
		
		String mInsertResult = "S";
		String dInsertResult = "S";
			
		// scd_nm(스케줄명) 중복체크 flag 값
		String scdNmCk = "S";
					
		//쓰기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
		if(menuAut.get(0).get("wrt_aut_yn").equals("N")){
			response.sendRedirect("/autError.do");
		}else{		
			
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0042_01");
			historyVO.setMnu_id(2);
			accessHistoryService.insertHistory(historyVO);
			
			//스케줄명 중복체크
			try {
				String scd_nm = request.getParameter("scd_nm");
				int scdNmCheck = scheduleService.scd_nmCheck(scd_nm);
				if (scdNmCheck > 0) {
					// 중복값이 존재함.
					scdNmCk = "F";
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
						
			if(scdNmCk == "S"){
				// 1. 스케줄ID 시퀀스 조회
				try {							
					int scd_id = scheduleService.selectScd_id();
					System.out.println("스케줄ID 시퀀스 값 : " + scd_id );
					scheduleVO.setScd_id(scd_id);
					scheduleDtlVO.setScd_id(scd_id);
				} catch (Exception e) {
					e.printStackTrace();
				}
						
				
				// 1. 스케쥴 마스터 등록
				try {			
					SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");   
					
		            String exe_perd_cd =scheduleVO.getExe_perd_cd();
		            
		            // 매일
		            if(exe_perd_cd.equals("TC001601")){
		            	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		                Calendar cal = Calendar.getInstance();
		                String strToday = sdf.format(cal.getTime());
	
		                // 현재날짜 + 수행시간
		                String nextDay = strToday+" "+scheduleVO.getExe_h()+":"+scheduleVO.getExe_m()+":"+scheduleVO.getExe_s();
  
		                Date dt = transFormat.parse(nextDay);		                
		                cal.setTime(dt);
		                // 현재날짜+수행시간 + 1일
		                cal.add(Calendar.DATE, 1);
	            	
		            	scheduleVO.setNxt_exe_dtm(cal.getTime());
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
		            	String detail = scheduleVO.getExe_h()+":"+scheduleVO.getExe_m()+":"+scheduleVO.getExe_s();
		            	
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
		        	    for(int i=toDay; i<scheduleVO.getExe_dt().length(); i++){
		        	    	
		        	    	//4.1현재 오늘요일 체크(X)일때 날짜검색하여 업데이트
		        	    	if(String.valueOf(scheduleVO.getExe_dt().charAt(toDay)).equals("0")){
		        	    		if(strChecked == null) {
		        	    			if(String.valueOf(scheduleVO.getExe_dt().charAt(i)).equals("1")) {	    			
		        		    			strChecked = week[i];	
		        		    			System.out.println("오늘 날짜 체크가 안되있을때 오른쪽으로 = "+strChecked);
		        		    			String nextDay = weekDay[Integer.parseInt(strChecked)]+" "+detail;
		        			    		Date dt = transFormat.parse(nextDay);		                
		        		                cal.setTime(dt);
		             
		        		                scheduleVO.setNxt_exe_dtm(cal.getTime());
		        		    			intNextCnt ++;
		        		    		}	
		        	    		}
		        	    	//4.2 현재 오늘요일 체크(0)일때 날짜검색하여 업데이트
		        	    	}else{	    		
		            			if(String.valueOf(scheduleVO.getExe_dt().charAt(i)).equals("1")) {	    
		            				strFirstCheck  = week[toDay];
		            	    		if(intNextCnt == 1 && strFirstCheck != null) {
		            	    			strChecked = week[i]; 	    
		            	    			
		            	    			System.out.println("오늘 날짜 체크 되있을때 오른쪽으로 = "+strChecked);
		            	    			String nextDay = weekDay[Integer.parseInt(strChecked)]+" "+detail;
		            		    		Date dt = transFormat.parse(nextDay);		                
		            	                cal.setTime(dt);
		            	                           
		            	                scheduleVO.setNxt_exe_dtm(cal.getTime());
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
		        	    		if(String.valueOf(scheduleVO.getExe_dt().charAt(i)).equals("1")) {	    			
		        	    			strChecked = week[i];
		        	    			intPrevCnt ++;
		        	    			System.out.println("처음부터검색 ="+strChecked);
		        	    			String nextDay = weekDay[Integer.parseInt(strChecked)]+" "+detail;
		        		    		Date dt = transFormat.parse(nextDay);		                
		        	                cal.setTime(dt);
		        	                
		        	                // 현재날짜+수행시간 + 7일
		        	                cal.add(Calendar.DATE, 7);               
		        	                scheduleVO.setNxt_exe_dtm(cal.getTime());
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
		                        scheduleVO.setNxt_exe_dtm(cal.getTime());
		        	    	} 
		        	    }
			        // 매월
		            }else if(exe_perd_cd.equals("TC001603")){
		            	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
		                Calendar cal = Calendar.getInstance();
		                String strToday = sdf.format(cal.getTime());
		                
		                // 현재날짜 + 수행시간
		                String nextDay = strToday+"-"+scheduleVO.getExe_day()+" "+scheduleVO.getExe_h()+":"+scheduleVO.getExe_m()+":"+scheduleVO.getExe_s();
		                
		                Date dt = transFormat.parse(nextDay);		                
		                cal.setTime(dt);
		                // 현재날짜+수행시간 + 1월
		            	cal.add(Calendar.MONTH, 1); 
		            	scheduleVO.setNxt_exe_dtm(cal.getTime());
		            	
		            // 매년
		            }else if(exe_perd_cd.equals("TC001604")){
		            	SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
		                Calendar cal = Calendar.getInstance();
		                String strToday = sdf.format(cal.getTime());
		                
		                // 현재날짜 + 수행시간
		                String nextDay = strToday+"-"+scheduleVO.getExe_month()+"-"+scheduleVO.getExe_day()+" "+scheduleVO.getExe_h()+":"+scheduleVO.getExe_m()+":"+scheduleVO.getExe_s();
		                
		                Date dt = transFormat.parse(nextDay);		                
		                cal.setTime(dt);
		                // 현재날짜+수행시간 + 1년
		            	 cal.add(Calendar.YEAR, 1); 
		            	 scheduleVO.setNxt_exe_dtm(cal.getTime());
		            }
		            
					scheduleVO.setFrst_regr_id(usr_id);
						scheduleService.insertSchedule(scheduleVO);
				} catch (Exception e) {
					e.printStackTrace();
					mInsertResult = "F";
				}
								
				// 3. 스케쥴 상세정보 등록
				if(mInsertResult.equals("S")){
					try {
						String strRows = request.getParameter("sWork").toString().replaceAll("&quot;", "\"");
						JSONArray rows = (JSONArray) new JSONParser().parse(strRows);
		
						for (int i = 0; i < rows.size(); i++) {
							JSONObject jsrow = (JSONObject) rows.get(i);
							scheduleDtlVO.setWrk_id(Integer.parseInt(jsrow.get("wrk_id").toString()));  
							scheduleDtlVO.setExe_ord(Integer.parseInt(jsrow.get("index").toString()));
							scheduleDtlVO.setNxt_exe_yn(jsrow.get("nxt_exe_yn").toString());
							scheduleDtlVO.setFrst_regr_id(usr_id);
							scheduleService.insertScheduleDtl(scheduleDtlVO);			
						}
					} catch (Exception e) {
						e.printStackTrace();
						dInsertResult = "F";
					}
				}
				txManager.commit(status);
				
				if(dInsertResult.equals("S")){
					try{
						System.out.println(">>> Sehcdule Controller  - 스케줄 등록");
						scheduleUtl.insertSchdul(scheduleVO);			
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}else{
				return scdNmCk;
			}
		}
		return scdNmCk;
	}
	
	
	/**
	 * 스케줄 리스트 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectScheduleListView.do")
	public ModelAndView selectScheduleListView(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
			
		ModelAndView mv = new ModelAndView();
		
		try {
			//해당메뉴 권한 조회 (공통메소드호출)
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000102");	
		}catch (Exception e) {
			e.printStackTrace();
		}

		try {
			
			String scd_cndt = request.getParameter("scd_cndt");
			String scd_nm = request.getParameter("scd_nm");

			//읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{	
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0045");
				historyVO.setMnu_id(3);
				accessHistoryService.insertHistory(historyVO);
				
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
				if(scd_cndt != null){
					mv.addObject("scd_cndt", scd_cndt);
				}

				if(scd_nm != null){
					mv.addObject("scd_nm", scd_nm);
				}
				
				mv.setViewName("functions/scheduler/schedulerList");
			}	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	
	/**
	 * 스케쥴 List를 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("null")
	@RequestMapping(value = "/selectScheduleList.do")
	@ResponseBody
	public List<Map<String, Object>> selectScheduleList(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("scheduleVO") ScheduleVO scheduleVO, HttpServletRequest request, HttpServletResponse response) {

		try {
			//해당메뉴 권한 조회 (공통메소드호출)
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000102");	
		}catch (Exception e) {
			e.printStackTrace();
		}
				
		List<Map<String, Object>> resultSet = new ArrayList<Map<String, Object>>();
		
		try {
			//읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){	
				response.sendRedirect("/autError.do");
				return resultSet;
			}else{
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0045_01");
				historyVO.setMnu_id(3);
				accessHistoryService.insertHistory(historyVO);
				
				//현재 서비스 올라간 스케줄 그룹 정보
				Scheduler scheduler = new StdSchedulerFactory().getScheduler();   
				
				List<Map<String, Object>> result = scheduleService.selectScheduleList(scheduleVO);
					
				for(int i=0; i<result.size(); i++){				
					Map<String, Object> mp = new HashMap<String, Object>();
					mp.put("rownum", result.get(i).get("rownum"));
					mp.put("idx", result.get(i).get("idx"));
					mp.put("scd_id", result.get(i).get("scd_id"));
					mp.put("scd_nm", result.get(i).get("scd_nm"));
					mp.put("scd_cndt", result.get(i).get("scd_cndt"));
					mp.put("scd_exp", result.get(i).get("scd_exp"));
					mp.put("exe_perd_cd", result.get(i).get("exe_perd_cd"));			
					mp.put("exe_hms", result.get(i).get("exe_hms"));
					mp.put("prev_exe_dtm", result.get(i).get("prev_exe_dtm"));
					mp.put("nxt_exe_dtm", result.get(i).get("nxt_exe_dtm"));
					mp.put("frst_regr_id", result.get(i).get("frst_regr_id"));
					mp.put("frst_reg_dtm", result.get(i).get("frst_reg_dtm"));
					mp.put("lst_mdfr_id", result.get(i).get("lst_mdfr_id"));
					mp.put("lst_mdf_dtm", result.get(i).get("lst_mdf_dtm"));
					mp.put("wrk_cnt", result.get(i).get("wrk_cnt"));
					mp.put("db_svr_nm", result.get(i).get("db_svr_nm"));
					mp.put("exe_dt", result.get(i).get("exe_dt"));
					for(int j=0; j<scheduler.getJobGroupNames().size(); j++){	
						if(result.get(i).get("scd_id").toString().equals(scheduler.getJobGroupNames().get(j).toString())){	
							mp.put("status", "s");
						}			
					}		
					resultSet.add(mp);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
	
	
	/**
	 * 스케줄 정지 한다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/scheduleStop.do")
	@ResponseBody
	public boolean scheduleStop(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, @ModelAttribute("scheduleVO") ScheduleVO scheduleVO, HttpServletResponse response) {

		try {
			//해당메뉴 권한 조회 (공통메소드호출)
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000102");	
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		try {
			//쓰기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if(menuAut.get(0).get("wrt_aut_yn").equals("N")){	
				response.sendRedirect("/autError.do");
				return false;
			}else{
				//이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0050_04");
				historyVO.setMnu_id(23);
				accessHistoryService.insertHistory(historyVO);
				
				String scd_id = request.getParameter("scd_id").toString();	
		
				scheduleVO.setScd_id(Integer.parseInt(scd_id));
				scheduleVO.setScd_cndt("TC001803");
				
				scheduleService.updateScheduleStatus(scheduleVO);
				
				scheduleUtl.deleteSchdul(scd_id);		
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return true;
	}
	

	/**
	 * 스케줄 재실행 한다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/scheduleReStart.do")
	@ResponseBody
	public boolean scheduleReStart(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("scheduleVO") ScheduleVO scheduleVO, HttpServletRequest request, HttpServletResponse response) {
		
		try {
			//해당메뉴 권한 조회 (공통메소드호출)
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000102");	
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		try {
			//쓰기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if(menuAut.get(0).get("wrt_aut_yn").equals("N")){	
				response.sendRedirect("/autError.do");
			}else{
				//이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0050_03");
				historyVO.setMnu_id(23);
				accessHistoryService.insertHistory(historyVO);
				
//				String strRows = request.getParameter("sWork").toString().replaceAll("&quot;", "\"");
//				JSONObject rows = (JSONObject) new JSONParser().parse(strRows);
				
				scheduleVO.setScd_id(Integer.parseInt(request.getParameter("scd_id").toString()));
				scheduleVO.setScd_cndt("TC001801");
	
				scheduleService.updateScheduleStatus(scheduleVO);
				
				scheduleVO.setExe_perd_cd(request.getParameter("exe_perd_cd"));
				if(request.getParameter("exe_dt") != null){
					scheduleVO.setExe_dt(request.getParameter("exe_dt"));
				}
				if(request.getParameter("exe_month") != null){
					scheduleVO.setExe_month(request.getParameter("exe_month"));
				}
				if(request.getParameter("exe_day") != null){
					scheduleVO.setExe_day(request.getParameter("exe_day"));
				}
				scheduleVO.setExe_hms(request.getParameter("exe_hms"));
			
				scheduleUtl.insertSchdul(scheduleVO);		
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return true;
	}
	
	
	/**
	 * 스케줄 삭제
	 * 
	 * @param
	 * @return 
	 * @throws Exception
	 */
	@RequestMapping(value = "/deleteScheduleList.do")
	@ResponseBody	
	public void deleteScheduleList(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
		
		try {
			//해당메뉴 권한 조회 (공통메소드호출)
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000102");	
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		try {					
			//쓰기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if(menuAut.get(0).get("wrt_aut_yn").equals("N")){	
				response.sendRedirect("/autError.do");
			}else{
				//이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0050_02");
				historyVO.setMnu_id(23);
				accessHistoryService.insertHistory(historyVO);
				
				String strRows = request.getParameter("rowList").toString().replaceAll("&quot;", "\"");
				JSONArray rows = (JSONArray) new JSONParser().parse(strRows);		
				for(int i=0; i<rows.size(); i++){
					int scd_id = Integer.parseInt(rows.get(i).toString());
					scheduleService.deleteScheduleList(scd_id);
				}
			}				
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	/**
	 * 스케줄수정 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/modifyScheduleListVeiw.do")
	public ModelAndView modifyScheduleListVeiw(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
		try {
			//해당메뉴 권한 조회 (공통메소드호출)
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000102");	
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		ModelAndView mv = new ModelAndView();
		
		try {
			//쓰기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if(menuAut.get(0).get("wrt_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{	
				//화면접근이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0044");
				accessHistoryService.insertHistory(historyVO);
				
				String scd_id = request.getParameter("scd_id");
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
				mv.setViewName("functions/scheduler/schedulerModify");
				mv.addObject("scd_id", scd_id);
			}			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	/**
	 *  스케줄리스트 수정 정보 조회
	 * 
	 * @param
	 * @return 
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectModifyScheduleList.do")
	@ResponseBody
	public List<Map<String, Object>> selectModifyScheduleList(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
		
		try {
			//해당메뉴 권한 조회 (공통메소드호출)
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000102");	
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		List<Map<String, Object>> result = null;
		try {		
			//읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){	
				response.sendRedirect("/autError.do");
			}else{				
				int scd_id  = Integer.parseInt(request.getParameter("scd_id").toString());

				result = scheduleService.selectModifyScheduleList(scd_id);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;		
	}
	
	
	/**
	 * 스케쥴을 수정한다.
	 * 
	 * @return 
	 * @throws Exception
	 */
	
	/*
	 * 1. 스케줄ID 시퀀스 조회
	 * 2. 스케줄 마스터 등록
	 * 3. 스케줄 상세정보 등록
	 */
	@RequestMapping(value = "/updateSchedule.do")
	public void updateSchedule(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("scheduleVO") ScheduleVO scheduleVO,@ModelAttribute("scheduleDtlVO") ScheduleDtlVO scheduleDtlVO, HttpServletResponse response, HttpServletRequest request, @RequestParam Map<String,String> reqJson) throws Exception{
		
		try {
			//해당메뉴 권한 조회 (공통메소드호출)
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000102");	
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		// Transaction 
		DefaultTransactionDefinition def  = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = txManager.getTransaction(def);
		
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		String usr_id = loginVo.getUsr_id();
		
		String mUpdateResult = "S";
		String dUpdateResult = "S";
	
		//쓰기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
		if(menuAut.get(0).get("wrt_aut_yn").equals("N")){	
			response.sendRedirect("/autError.do");
		}else{

			//화면접근이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0044_01");
			accessHistoryService.insertHistory(historyVO);
			
			// 1. 스케줄 마스터 업데이트
			try {		
				SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");   
				
	            String exe_perd_cd =scheduleVO.getExe_perd_cd();
	            
	            // 매일
	            if(exe_perd_cd.equals("TC001601")){
	            	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	                Calendar cal = Calendar.getInstance();
	                String strToday = sdf.format(cal.getTime());

	                // 현재날짜 + 수행시간
	                String nextDay = strToday+" "+scheduleVO.getExe_h()+":"+scheduleVO.getExe_m()+":"+scheduleVO.getExe_s();

	                Date dt = transFormat.parse(nextDay);		                
	                cal.setTime(dt);
	                // 현재날짜+수행시간 + 1일
	                cal.add(Calendar.DATE, 1);
            	
	            	scheduleVO.setNxt_exe_dtm(cal.getTime());
	            	
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
	            	String detail = scheduleVO.getExe_h()+":"+scheduleVO.getExe_m()+":"+scheduleVO.getExe_s();
	            	
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
	        	    for(int i=toDay; i<scheduleVO.getExe_dt().length(); i++){
	        	    	
	        	    	//4.1현재 오늘요일 체크(X)일때 날짜검색하여 업데이트
	        	    	if(String.valueOf(scheduleVO.getExe_dt().charAt(toDay)).equals("0")){
	        	    		if(strChecked == null) {
	        	    			if(String.valueOf(scheduleVO.getExe_dt().charAt(i)).equals("1")) {	    			
	        		    			strChecked = week[i];	
	        		    			System.out.println("오늘 날짜 체크가 안되있을때 오른쪽으로 = "+strChecked);
	        		    			String nextDay = weekDay[Integer.parseInt(strChecked)]+" "+detail;
	        			    		Date dt = transFormat.parse(nextDay);		                
	        		                cal.setTime(dt);
	             
	        		                scheduleVO.setNxt_exe_dtm(cal.getTime());
	        		    			intNextCnt ++;
	        		    		}	
	        	    		}
	        	    	//4.2 현재 오늘요일 체크(0)일때 날짜검색하여 업데이트
	        	    	}else{	    		
	            			if(String.valueOf(scheduleVO.getExe_dt().charAt(i)).equals("1")) {	    
	            				strFirstCheck  = week[toDay];
	            	    		if(intNextCnt == 1 && strFirstCheck != null) {
	            	    			strChecked = week[i]; 	    
	            	    			
	            	    			System.out.println("오늘 날짜 체크 되있을때 오른쪽으로 = "+strChecked);
	            	    			String nextDay = weekDay[Integer.parseInt(strChecked)]+" "+detail;
	            		    		Date dt = transFormat.parse(nextDay);		                
	            	                cal.setTime(dt);
	            	                           
	            	                scheduleVO.setNxt_exe_dtm(cal.getTime());
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
	        	    		if(String.valueOf(scheduleVO.getExe_dt().charAt(i)).equals("1")) {	    			
	        	    			strChecked = week[i];
	        	    			intPrevCnt ++;
	        	    			System.out.println("처음부터검색 ="+strChecked);
	        	    			String nextDay = weekDay[Integer.parseInt(strChecked)]+" "+detail;
	        	    			System.out.println(nextDay);
	        		    		Date dt = transFormat.parse(nextDay);		                
	        	                cal.setTime(dt);
	        	                
	        	                // 현재날짜+수행시간 + 7일
	        	                cal.add(Calendar.DATE, 7);               
	        	                scheduleVO.setNxt_exe_dtm(cal.getTime());
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
	                        scheduleVO.setNxt_exe_dtm(cal.getTime());
	        	    	} 
	        	    }
		        // 매월
	            }else if(exe_perd_cd.equals("TC001603")){
	            	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
	                Calendar cal = Calendar.getInstance();
	                String strToday = sdf.format(cal.getTime());
	                
	                // 현재날짜 + 수행시간
	                String nextDay = strToday+"-"+scheduleVO.getExe_day()+" "+scheduleVO.getExe_h()+":"+scheduleVO.getExe_m()+":"+scheduleVO.getExe_s();
	                
	                Date dt = transFormat.parse(nextDay);		                
	                cal.setTime(dt);
	                // 현재날짜+수행시간 + 1월
	            	cal.add(Calendar.MONTH, 1); 
	            	scheduleVO.setNxt_exe_dtm(cal.getTime());
	            	
	            // 매년
	            }else if(exe_perd_cd.equals("TC001604")){
	            	SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
	                Calendar cal = Calendar.getInstance();
	                String strToday = sdf.format(cal.getTime());
	                
	                // 현재날짜 + 수행시간
	                String nextDay = strToday+"-"+scheduleVO.getExe_month()+"-"+scheduleVO.getExe_day()+" "+scheduleVO.getExe_h()+":"+scheduleVO.getExe_m()+":"+scheduleVO.getExe_s();
	                
	                Date dt = transFormat.parse(nextDay);		                
	                cal.setTime(dt);
	                // 현재날짜+수행시간 + 1년
	            	 cal.add(Calendar.YEAR, 1); 
	            	 scheduleVO.setNxt_exe_dtm(cal.getTime());
	            }
								
				scheduleVO.setFrst_regr_id(usr_id);
				scheduleService.updateSchedule(scheduleVO);
			} catch (Exception e) {
				e.printStackTrace();
				mUpdateResult = "F";
			}
						
			// 3. 스케쥴 상세정보 등록
			if(mUpdateResult.equals("S")){
				try {
					String strRows = request.getParameter("sWork").toString().replaceAll("&quot;", "\"");
					JSONArray rows = (JSONArray) new JSONParser().parse(strRows);
	
					scheduleService.deleteScheduleDtl(scheduleDtlVO);	
					
					for (int i = 0; i < rows.size(); i++) {						
						JSONObject jsrow = (JSONObject) rows.get(i);
						scheduleDtlVO.setWrk_id(Integer.parseInt(jsrow.get("wrk_id").toString()));  
						scheduleDtlVO.setExe_ord(Integer.parseInt(jsrow.get("index").toString()));
						scheduleDtlVO.setNxt_exe_yn(jsrow.get("nxt_exe_yn").toString());
						scheduleDtlVO.setFrst_regr_id(usr_id);					
						scheduleService.insertScheduleDtl(scheduleDtlVO);							
					}
				} catch (Exception e) {
					e.printStackTrace();
					dUpdateResult = "F";
				}
			}
			txManager.commit(status);
		}
	}
	
	
	/**
	 * 중복 스케줄명을 체크한다.
	 * 
	 * @param scd_nm
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/scd_nmCheck.do")
	public @ResponseBody String scd_nmCheck(@RequestParam("scd_nm") String scd_nm) {
		try {
			int resultSet = scheduleService.scd_nmCheck(scd_nm);
			if (resultSet > 0) {
				// 중복값이 존재함.
				return "false";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "true";
	}
	
	
	
	/**
	 * 스케줄 WRK 리스트 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/scheduleWrkListVeiw.do")
	public ModelAndView scheduleWrkListVeiw(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
		
		ModelAndView mv = new ModelAndView();
		
		try {
			//해당메뉴 권한 조회 (공통메소드호출)
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000102");	
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		try {
			//쓰기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if(menuAut.get(0).get("wrt_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{	
				//이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0039_03");
				accessHistoryService.insertHistory(historyVO);
				
				String scd_id = request.getParameter("scd_id");
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
				mv.setViewName("popup/scheduleWrkList");
				mv.addObject("scd_id", scd_id);
			}			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	
	/**
	 *  WRK 리스트 정보 조회
	 * 
	 * @param
	 * @return 
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectWrkScheduleList.do")
	@ResponseBody
	public List<Map<String, Object>> selectWrkScheduleList(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
		
		try {
			//해당메뉴 권한 조회 (공통메소드호출)
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000102");	
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		List<Map<String, Object>> result = null;
		try {		
			//읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){	
				response.sendRedirect("/autError.do");
			}else{
				int scd_id  = Integer.parseInt(request.getParameter("scd_id").toString());
				String locale_type = LocaleContextHolder.getLocale().getLanguage();
				result = scheduleService.selectWrkScheduleList(scd_id, locale_type);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;		
	}
	
	
	
	/**
	 * Work 구분 Select BOX 가져오기 
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value = "/selectWorkDivList.do")
	@ResponseBody
	public List<Map<String, Object>> selectWorkDivList(HttpServletRequest request) {
	
		List<Map<String, Object>> resultSet = null;
		try {			
			String locale_type = LocaleContextHolder.getLocale().getLanguage();
			resultSet = scheduleService.selectWorkDivList(locale_type);	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
	
	
	/**
	 * 백업 스케쥴을 간편등록 등록한다.
	 * 
	 * @return 
	 * @throws Exception
	 */
	
	/*
	 * 1. 스케줄ID 시퀀스 조회
	 * 2. 스케줄 마스터 등록
	 * 3. 스케줄 상세정보 등록
	 */
	@RequestMapping(value = "/insert_bckSchedule.do")
	public void insert_bckSchedule(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("scheduleVO") ScheduleVO scheduleVO,@ModelAttribute("scheduleDtlVO") ScheduleDtlVO scheduleDtlVO, HttpServletResponse response, HttpServletRequest request, @RequestParam Map<String,String> reqJson) throws Exception{
		
		WorkVO resultSet = null;
		
		try {
			//해당메뉴 권한 조회 (공통메소드호출)
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000101");	
		}catch (Exception e) {
			e.printStackTrace();
		}
			
		// Transaction 
		DefaultTransactionDefinition def  = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = txManager.getTransaction(def);
		
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		String usr_id = loginVo.getUsr_id();
		
		String mInsertResult = "S";
		String dInsertResult = "S";
								
		//쓰기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
		if(menuAut.get(0).get("wrt_aut_yn").equals("N")){
			response.sendRedirect("/autError.do");
		}else{		
			
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0042_01");
			historyVO.setMnu_id(2);
			accessHistoryService.insertHistory(historyVO);
			
			// 1. 스케줄ID 시퀀스 조회
			try {							
				int scd_id = scheduleService.selectScd_id();
				System.out.println("스케줄ID 시퀀스 값 : " + scd_id );
				scheduleVO.setScd_id(scd_id);
				scheduleDtlVO.setScd_id(scd_id);
			} catch (Exception e) {
				e.printStackTrace();
			}
					
			
			// 1. 스케쥴 마스터 등록
			try {			
				scheduleVO.setFrst_regr_id(usr_id);
					scheduleService.insertSchedule(scheduleVO);
			} catch (Exception e) {
				e.printStackTrace();
				mInsertResult = "F";
			}
							
			// 3. 스케쥴 상세정보 등록
			if(mInsertResult.equals("S")){
				try {
					resultSet = backupService.lastWorkId();
					
						scheduleDtlVO.setWrk_id(resultSet.getWrk_id());  
						scheduleDtlVO.setExe_ord(1);
						scheduleDtlVO.setNxt_exe_yn("N");
						scheduleDtlVO.setFrst_regr_id(usr_id);
						scheduleService.insertScheduleDtl(scheduleDtlVO);			
					
				} catch (Exception e) {
					e.printStackTrace();
					dInsertResult = "F";
				}
			}
			txManager.commit(status);
			
			if(dInsertResult.equals("S")){
				try{
					System.out.println(">>> Sehcdule Controller  - 스케줄 등록");
					scheduleUtl.insertSchdul(scheduleVO);			
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
	}	
	
	
	/**
	 * 조치결과 업데이트
	 * 
	 * @param
	 * @return 
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateFixRslt.do")
	@ResponseBody	
	public void updateFixRslt(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
		
		// Transaction 
		DefaultTransactionDefinition def  = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = txManager.getTransaction(def);
				
		try {					
			HashMap<String , Object> paramvalue = new HashMap<String, Object>();
			
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String usr_id = loginVo.getUsr_id();
			
			   int exe_sn = Integer.parseInt(request.getParameter("exe_sn").toString());
			   String fix_rsltcd = request.getParameter("fix_rsltcd");
			   String fix_rslt_msg = request.getParameter("fix_rslt_msg");
			   
			   paramvalue.put("exe_sn", exe_sn);
			   paramvalue.put("fix_rsltcd", fix_rsltcd);
			   paramvalue.put("fix_rslt_msg", fix_rslt_msg);
			   paramvalue.put("lst_mdfr_id", usr_id);
			   
				scheduleService.updateFixRslt(paramvalue);
						
		}catch(Exception e){
			e.printStackTrace();
			txManager.rollback(status);
		}finally{
			txManager.commit(status);
		}
	}
	
	
	/**
	 * 조치결과 정보
	 * @param 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/selectFixRsltMsg.do")
	@ResponseBody
	public List<Map<String, Object>> selectFixRsltMsg(HttpServletRequest request) {
		List<Map<String, Object>> result = null;
		
		try {
			int exe_sn = Integer.parseInt(request.getParameter("exe_sn"));			
			result = scheduleService.selectFixRsltMsg(exe_sn);	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
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
	

	/**
	 * DB2PG 스케쥴 work 등록 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/db2pgWorkRegForm.do")
	public ModelAndView db2pgWorkRegForm(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		
		ModelAndView mv = new ModelAndView("jsonView");
	
		try {
			//해당메뉴 권한 조회 (공통메소드호출)
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000101");
		}catch (Exception e) {
			e.printStackTrace();
		}

		try {			
			//쓰기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if(menuAut.get(0).get("wrt_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{	
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0043");
				historyVO.setMnu_id(2);
				accessHistoryService.insertHistory(historyVO);
				
			}			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
}
