package com.k4m.dx.tcontrol.functions.schedule.web;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

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

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
}
