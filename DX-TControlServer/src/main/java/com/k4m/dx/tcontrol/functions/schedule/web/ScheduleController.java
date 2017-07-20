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
	public ModelAndView transferSetting(HttpServletRequest request) {
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
			System.out.println(scheduleVO.getExe_dt());
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
				// TODO Auto-generated catch block
				e.printStackTrace();
				dInsertResult = "F";
			}
		}
		txManager.commit(status);
		
		if(dInsertResult.equals("S")){
			try{
				System.out.println(">>> Sehcdule Controller  - 스케쥴 등록");
				scheduleUtl.insertSchdul(scheduleVO);				
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
}
