package com.k4m.dx.tcontrol.sample.web;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.sample.service.SampleTreeService;
import com.k4m.dx.tcontrol.sample.service.SampleTreeVO;

/**
 * SampleTree 컨트롤러 클래스를 정의한다.
 *
 * @author 변승우
 * @see <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.05.22   변승우 최초 생성
 * </pre>
 */

@Controller
public class SampleChartController {


	/**
	 * 샘플 차트 페이지를 보여준다.
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/sampleChart.do", method = RequestMethod.GET)
	public ModelAndView sampleChart( Model model) {
		ModelAndView mv = new ModelAndView();

		mv.setViewName("sample/sampleChart");
		return mv;	
	}
	
	


}
