package com.k4m.dx.tcontrol.encrypt.agentmonitoring.web;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

/**
 * Encrypt Agent 모니터링 컨트롤러 클래스를 정의한다.
 *
 * @author 변승우
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2018.01.04   변승우 최초 생성
 *      </pre>
 */


@Controller
public class EncryptAgentMonitoringController {

	
	/**
	 * Encrypt Agent 모니터링 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/encryptAgentMonitoring.do")
	public ModelAndView encryptAgentMonitoring(HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			mv.setViewName("encrypt/agentMonitoring/agentMonitoring");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	
	/**
	 * Encrypt Agent 모니터링 수정 팝업을 보여준다.
	 * 
	 * agentMonitoring modify View
	 * @param 
	 * @return ModelAndView
	 */
	@RequestMapping(value = "/popup/agentMonitoringModifyForm.do")
	public ModelAndView rmanRegReForm(HttpServletRequest request)  {
		ModelAndView mv = new ModelAndView();
		try {
			mv.setViewName("encrypt/popup/agentMonitoringModifyForm");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;	
	}
	
}
