package com.k4m.dx.tcontrol.monitoring.web;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.common.service.HistoryVO;

/**
 * 모니터링 컨트롤러 클래스를 정의한다.
 *
 * @author 변승우
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2018.06.25   변승우   최초 생성
 *      </pre>
 */


@Controller
public class MonitoringController {
	
	/**
	 * 모니터링 데시보드 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/monitoringDashboard.do")
	public ModelAndView monitoringDashboard(@ModelAttribute("historyVO") HistoryVO historyVO,HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			mv.setViewName("monitoring/mDashboard");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
}
