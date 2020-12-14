package com.k4m.dx.tcontrol.mypage.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.quartz.Scheduler;
import org.quartz.impl.StdSchedulerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleVO;
import com.k4m.dx.tcontrol.login.service.LoginVO;
import com.k4m.dx.tcontrol.mypage.service.MyScheduleService;

/**
 * My스케줄 컨트롤러 클래스를 정의한다.
 *
 * @author 변승우
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.08.16   변승우 최초 생성
 *      </pre>
 */

@Controller
public class MyscheduleController {
	
	@Autowired
	private AccessHistoryService accessHistoryService;
	
	@Autowired
	private MyScheduleService mySscheduleService;
	
	/**
	 * My스케줄 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/myScheduleListView.do")
	public ModelAndView myScheduleListView(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0050");
			historyVO.setMnu_id(23);
			accessHistoryService.insertHistory(historyVO);
			mv.setViewName("mypage/mySchedulerList");
		} catch (Exception e) {
			request.getRequestDispatcher("/");
			e.printStackTrace();
		}
		return mv;
	}
	
	
	
	/**
	 * My스케쥴 List를 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("null")
	@RequestMapping(value = "/selectMyScheduleList.do")
	@ResponseBody
	public List<Map<String, Object>> selectMyScheduleList(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("scheduleVO") ScheduleVO scheduleVO, HttpServletRequest request) {
	
		List<Map<String, Object>> resultSet = new ArrayList<Map<String, Object>>();
		
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0050_01");
			historyVO.setMnu_id(23);
			accessHistoryService.insertHistory(historyVO);
		
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String usr_id = loginVo.getUsr_id();
			
			scheduleVO.setLst_mdfr_id(usr_id);
			
			//현재 서비스 올라간 스케줄 그룹 정보
			Scheduler scheduler = new StdSchedulerFactory().getScheduler();   

			List<Map<String, Object>> result = mySscheduleService.selectMyScheduleList(scheduleVO);
				
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
				mp.put("lst_mdf_dtm", result.get(i).get("lst_mdf_dtm"));
				mp.put("wrk_cnt", result.get(i).get("wrk_cnt"));
				mp.put("scd_cndt", result.get(i).get("scd_cndt"));
				for(int j=0; j<scheduler.getJobGroupNames().size(); j++){	
					if(result.get(i).get("scd_id").toString().equals(scheduler.getJobGroupNames().get(j).toString())){	
						mp.put("status", "s");
					}			
				}		
				resultSet.add(mp);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
}
