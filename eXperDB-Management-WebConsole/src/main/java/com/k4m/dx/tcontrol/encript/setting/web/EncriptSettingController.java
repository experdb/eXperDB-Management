package com.k4m.dx.tcontrol.encript.setting.web;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

/**
 * Encript 설정 컨트롤러 클래스를 정의한다.
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
public class EncriptSettingController {

	/**
	 * Encript 보안정책 옵션 설정 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/securityPolicyOptionSet.do")
	public ModelAndView encriptAgentMonitoring(HttpServletRequest request, ModelMap model) {
		ModelAndView mv = new ModelAndView();
		try {
			mv.setViewName("encript/setting/securityPolicyOptionSet");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	/**
	 * 암호화 설정
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/securitySet.do")
	public ModelAndView securitySet(HttpServletRequest request, ModelMap model) {
		ModelAndView mv = new ModelAndView();
		try {
			mv.setViewName("encript/setting/securitySet");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
}
