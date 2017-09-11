package com.k4m.dx.tcontrol.functions.schedule.web;

import java.io.IOException;
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
import org.json.simple.parser.ParseException;
import org.quartz.Scheduler;
import org.quartz.impl.StdSchedulerFactory;
import org.springframework.beans.factory.annotation.Autowired;
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
import com.k4m.dx.tcontrol.backup.service.WorkVO;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.functions.schedule.ScheduleUtl;
import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleDtlVO;
import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleService;
import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleVO;

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
		
		//해당메뉴 권한 조회 (공통메소드호출)
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000101");
		
		ModelAndView mv = new ModelAndView();
		try {			
			//읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{				
				//스케줄 등록 화면 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0040");
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
		
		//해당메뉴 권한 조회 (공통메소드호출)
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000101");
		
		ModelAndView mv = new ModelAndView();
		try {			
			//쓰기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if(menuAut.get(0).get("wrt_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{	
				//스케줄 등록 화면 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0041");
				accessHistoryService.insertHistory(historyVO);
				
				mv.setViewName("popup/scheduleRegForm");	
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
		
		//해당메뉴 권한 조회 (공통메소드호출)
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000101");
		
		List<WorkVO> resultSet = null;
		try {			
			//읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultSet;
			}else{		
				//스케줄 work 조회 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0040_01");
				accessHistoryService.insertHistory(historyVO);
				
				System.out.println("=======parameter=======");
				System.out.println("구분 : " + workVO.getBck_bsn_dscd());
				System.out.println("워크명 : " + workVO.getWrk_nm());
				System.out.println("=====================");
				
				resultSet = scheduleService.selectWorkList(workVO);	
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
	
		//해당메뉴 권한 조회 (공통메소드호출)
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000101");
		
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
				
				for(int i=0; i<Param.length; i++){
					ids.add(Param[i].toString()); 
				}
				paramvalue.put("work_id", ids);
				
				result = scheduleService.selectScheduleWorkList(paramvalue);
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
	public void insertSchedule(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("scheduleVO") ScheduleVO scheduleVO,@ModelAttribute("scheduleDtlVO") ScheduleDtlVO scheduleDtlVO, HttpServletResponse response, HttpServletRequest request, @RequestParam Map<String,String> reqJson) throws Exception{
		
		//해당메뉴 권한 조회 (공통메소드호출)
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000101");
		
		// Transaction 
		DefaultTransactionDefinition def  = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = txManager.getTransaction(def);
		
		HttpSession session = request.getSession();
		String usr_id = (String) session.getAttribute("usr_id");
		
		String mInsertResult = "S";
		String dInsertResult = "S";
								
		//쓰기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
		if(menuAut.get(0).get("wrt_aut_yn").equals("N")){
			response.sendRedirect("/autError.do");
		}else{		
			
			//스케줄 등록 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0040_01");
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
		}
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
		
		//해당메뉴 권한 조회 (공통메소드호출)
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000102");
		
		ModelAndView mv = new ModelAndView();
		try {
			
			String scd_cndt = request.getParameter("scd_cndt");

			//읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{				
				//이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0039");
				accessHistoryService.insertHistory(historyVO);
				
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
				if(scd_cndt != null){
					mv.addObject("scd_cndt", scd_cndt);
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
	
		//해당메뉴 권한 조회 (공통메소드호출)
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000102");
		
		List<Map<String, Object>> resultSet = new ArrayList<Map<String, Object>>();
		
		try {
			//읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){	
				response.sendRedirect("/autError.do");
				return resultSet;
			}else{
				//이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0039_01");
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
					mp.put("scd_exp", result.get(i).get("scd_exp"));
					mp.put("exe_perd_cd", result.get(i).get("exe_perd_cd"));			
					mp.put("exe_hms", result.get(i).get("exe_hms"));
					mp.put("prev_exe_dtm", result.get(i).get("prev_exe_dtm"));
					mp.put("nxt_exe_dtm", result.get(i).get("nxt_exe_dtm"));
					mp.put("frst_regr_id", result.get(i).get("frst_regr_id"));
					mp.put("frst_reg_dtm", result.get(i).get("frst_reg_dtm"));
					mp.put("lst_mdfr_id", result.get(i).get("lst_mdfr_id"));
					mp.put("lst_mdf_dtm", result.get(i).get("lst_mdfr_id"));
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
		
		//해당메뉴 권한 조회 (공통메소드호출)
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000102");		
		
		try {
			//쓰기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if(menuAut.get(0).get("wrt_aut_yn").equals("N")){	
				response.sendRedirect("/autError.do");
				return false;
			}else{
				//이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0039_05");
				accessHistoryService.insertHistory(historyVO);
				
				String scd_id = request.getParameter("scd_id").toString();	
		
				scheduleVO.setScd_id(Integer.parseInt(scd_id));
				scheduleVO.setScd_cndt("TC001802");
				
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
		
		//해당메뉴 권한 조회 (공통메소드호출)
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000102");	
		
		try {
			//쓰기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if(menuAut.get(0).get("wrt_aut_yn").equals("N")){	
				response.sendRedirect("/autError.do");
			}else{
				//이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0039_06");
				accessHistoryService.insertHistory(historyVO);
				
				String strRows = request.getParameter("sWork").toString().replaceAll("&quot;", "\"");
				JSONObject rows = (JSONObject) new JSONParser().parse(strRows);
				
				scheduleVO.setScd_id(Integer.parseInt(rows.get("scd_id").toString()));
				scheduleVO.setScd_cndt("TC001801");
	
				scheduleService.updateScheduleStatus(scheduleVO);
				
				scheduleVO.setExe_perd_cd(rows.get("exe_perd_cd").toString());
				if(rows.get("exe_dt") != null){
					scheduleVO.setExe_dt(rows.get("exe_dt").toString());
				}
				if(rows.get("exe_month") != null){
					scheduleVO.setExe_month(rows.get("exe_month").toString());
				}
				if(rows.get("exe_day") != null){
					scheduleVO.setExe_day(rows.get("exe_day").toString());
				}
				scheduleVO.setExe_hms(rows.get("exe_hms").toString());
			
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
		
		//해당메뉴 권한 조회 (공통메소드호출)
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000102");		
		
		try {					
			//쓰기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if(menuAut.get(0).get("wrt_aut_yn").equals("N")){	
				response.sendRedirect("/autError.do");
			}else{
				//이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0039_04");
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
		
		//해당메뉴 권한 조회 (공통메소드호출)
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000102");
		
		ModelAndView mv = new ModelAndView();
		
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
		
		//해당메뉴 권한 조회 (공통메소드호출)
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000102");
		
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
	@RequestMapping(value = "/updateSchedule.do")
	public void updateSchedule(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("scheduleVO") ScheduleVO scheduleVO,@ModelAttribute("scheduleDtlVO") ScheduleDtlVO scheduleDtlVO, HttpServletResponse response, HttpServletRequest request, @RequestParam Map<String,String> reqJson) throws Exception{
		
		//해당메뉴 권한 조회 (공통메소드호출)
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000102");
		
		// Transaction 
		DefaultTransactionDefinition def  = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = txManager.getTransaction(def);
		
		HttpSession session = request.getSession();
		String usr_id = (String) session.getAttribute("usr_id");
		
		String mUpdateResult = "S";
		String dUpdateResult = "S";
	
		//쓰기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
		if(menuAut.get(0).get("wrt_aut_yn").equals("N")){	
			response.sendRedirect("/autError.do");
		}else{

			//이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0039_02");
			accessHistoryService.insertHistory(historyVO);
			
			// 1. 스케줄 마스터 업데이트
			try {			
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
}
