package com.k4m.dx.tcontrol.functions.schedule.web;

import java.io.IOException;
import java.util.ArrayList;
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
import org.quartz.JobExecutionContext;
import org.quartz.JobKey;
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

import com.k4m.dx.tcontrol.backup.service.WorkVO;
import com.k4m.dx.tcontrol.common.service.CmmnHistoryService;
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
	private ScheduleService scheduleService;
	
	@Autowired
	private CmmnHistoryService cmmnHistoryService;
	
	/**
	 * Mybatis Transaction 
	 */
	@Autowired
	private PlatformTransactionManager txManager;
	
	@Resource(name="egovSchdulUtl")
	private ScheduleUtl scheduleUtl;
	
	/**
	 * 스케쥴등록 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertScheduleView.do")
	public ModelAndView insertScheduleView(HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			mv.setViewName("functions/scheduler/schedulerRegister");
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
	public ModelAndView scheduleRegForm(HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			mv.setViewName("popup/scheduleRegForm");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
		
		
	/**
	 * 스케쥴 work List를 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value = "/selectWorkList.do")
	@ResponseBody
	public List<WorkVO> selectWorkList(@ModelAttribute("workVO") WorkVO workVO) {
		List<WorkVO> resultSet = null;
		try {
			
			System.out.println("=======parameter=======");
			System.out.println("구분 : " + workVO.getBck_bsn_dscd());
			System.out.println("워크명 : " + workVO.getWrk_nm());
			System.out.println("=====================");
			
			resultSet = scheduleService.selectWorkList(workVO);
			
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
	public List<Map<String, Object>> selectScheduleWorkList(HttpServletRequest request) {
	
		List<Map<String, Object>> result = null;
		
		String work_id = request.getParameter("work_id");
		
		String[] Param = work_id.toString().substring(1, work_id.length()-1 ).split(",");
		HashMap<String , Object> paramvalue = new HashMap<String, Object>();
		List<String> ids = new ArrayList<String>(); 
		
		for(int i=0; i<Param.length; i++){
			ids.add(Param[i].toString()); 
		}
		paramvalue.put("work_id", ids);
	
		try {								
			result = scheduleService.selectScheduleWorkList(paramvalue);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	/**
	 * 스케쥴을 등록한다.
	 * 
	 * @return 
	 * @throws ParseException 
	 * @throws Exception
	 */
	
	/*
	 * 1. 스케줄ID 시퀀스 조회
	 * 2. 스케줄 마스터 등록
	 * 3. 스케줄 상세정보 등록
	 */
	@RequestMapping(value = "/insertSchedule.do")
	public void insertSchedule(@ModelAttribute("scheduleVO") ScheduleVO scheduleVO,@ModelAttribute("scheduleDtlVO") ScheduleDtlVO scheduleDtlVO, HttpServletResponse response, HttpServletRequest request, @RequestParam Map<String,String> reqJson) throws IOException, ParseException{
		
		// Transaction 
		DefaultTransactionDefinition def  = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = txManager.getTransaction(def);
		
		HttpSession session = request.getSession();
		String usr_id = (String) session.getAttribute("usr_id");
		
		String mInsertResult = "S";
		String dInsertResult = "S";
			
		
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
	
	
	/**
	 * 스케줄 리스트 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectScheduleListView.do")
	public ModelAndView selectScheduleListView(HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			mv.setViewName("functions/scheduler/schedulerList");
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
	public List<Map<String, Object>> selectScheduleList(@ModelAttribute("scheduleVO") ScheduleVO scheduleVO, HttpServletRequest request) {
	
		List<Map<String, Object>> resultSet = new ArrayList<Map<String, Object>>();
		
		try {
			
			//현재 서비스 올라간 스케줄 그룹 정보
			Scheduler scheduler = new StdSchedulerFactory().getScheduler();   
			System.out.println(scheduler.getJobGroupNames());
			
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
				mp.put("nxt_exe_dtm", result.get(i).get("prev_exe_dtm"));
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
			
		System.out.println(resultSet);
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
	public boolean scheduleStop(HttpServletRequest request) {

		try {
			String scd_id = request.getParameter("scd_id").toString();
			scheduleUtl.deleteSchdul(scd_id);			
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
	public boolean scheduleReStart(@ModelAttribute("scheduleVO") ScheduleVO scheduleVO, HttpServletRequest request) {

		try {
			String strRows = request.getParameter("sWork").toString().replaceAll("&quot;", "\"");
			JSONObject rows = (JSONObject) new JSONParser().parse(strRows);
			
			scheduleVO.setScd_id(Integer.parseInt(rows.get("scd_id").toString()));
			scheduleVO.setExe_perd_cd(rows.get("exe_perd_cd").toString());
			if(rows.get("exe_dt") != null){
				scheduleVO.setExe_dt(rows.get("exe_dt").toString());
			}
			scheduleVO.setExe_hms(rows.get("exe_hms").toString());
		
			scheduleUtl.insertSchdul(scheduleVO);					
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
	public void deleteScheduleList(HttpServletRequest request) {

		try {
			
			String strRows = request.getParameter("rowList").toString().replaceAll("&quot;", "\"");
			JSONArray rows = (JSONArray) new JSONParser().parse(strRows);
			
			for(int i=0; i<rows.size(); i++){
				int scd_id = Integer.parseInt(rows.get(i).toString());
				scheduleService.deleteScheduleList(scd_id);
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
	public ModelAndView modifyScheduleListVeiw(HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			String scd_id = request.getParameter("scd_id");
			
			mv.setViewName("functions/scheduler/schedulerModify");
			mv.addObject("scd_id", scd_id);
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
	public List<Map<String, Object>> selectModifyScheduleList(HttpServletRequest request) {
		List<Map<String, Object>> result = null;
		try {			
			int scd_id  = Integer.parseInt(request.getParameter("scd_id").toString());
			result = scheduleService.selectModifyScheduleList(scd_id);
		
			System.out.println(result);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;		
	}
	
	
	/**
	 * 스케쥴을 등록한다.
	 * 
	 * @return 
	 * @throws ParseException 
	 * @throws Exception
	 */
	
	/*
	 * 1. 스케줄ID 시퀀스 조회
	 * 2. 스케줄 마스터 등록
	 * 3. 스케줄 상세정보 등록
	 */
	@RequestMapping(value = "/updateSchedule.do")
	public void updateSchedule(@ModelAttribute("scheduleVO") ScheduleVO scheduleVO,@ModelAttribute("scheduleDtlVO") ScheduleDtlVO scheduleDtlVO, HttpServletResponse response, HttpServletRequest request, @RequestParam Map<String,String> reqJson) throws IOException, ParseException{
		
		// Transaction 
		DefaultTransactionDefinition def  = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = txManager.getTransaction(def);
		
		HttpSession session = request.getSession();
		String usr_id = (String) session.getAttribute("usr_id");
		
		String mUpdateResult = "S";
		String dUpdateResult = "S";
		
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
