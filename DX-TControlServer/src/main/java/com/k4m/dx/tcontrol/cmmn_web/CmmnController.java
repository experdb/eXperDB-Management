package com.k4m.dx.tcontrol.cmmn_web;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.HistoryVO;

/**
 * 공통 컨트롤러 클래스를 정의한다.
 *
 * @author 변승우
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.05.24   변승우 최초 생성
 *      </pre>
 */

@Controller
public class CmmnController {
	
	@Autowired
	private AccessHistoryService accessHistoryService;
	
	/**
	 * 메인(홈)을 보여준다.
	 * @return ModelAndView mv
	 */	
	@RequestMapping(value = "/index.do")
	public ModelAndView index(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) throws Exception {
		
		// 메인 이력 남기기
		CmmnUtils.saveHistory(request, historyVO);
		historyVO.setExe_dtl_cd("DX-T0004");
		accessHistoryService.insertHistory(historyVO);
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("view/index");
		return mv;	
	}

}
