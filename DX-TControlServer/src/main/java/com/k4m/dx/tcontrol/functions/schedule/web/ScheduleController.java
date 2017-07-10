package com.k4m.dx.tcontrol.functions.schedule.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.backup.service.WorkVO;
import com.k4m.dx.tcontrol.common.service.CmmnHistoryService;
import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleService;

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
}
