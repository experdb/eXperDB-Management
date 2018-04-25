package com.k4m.dx.tcontrol.encrypt.statistics.web;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.common.service.HistoryVO;

@Controller
public class EncryptStatisticsController {
	
	
	/**
	 * 암호화 통계 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/securityStatistics.do")
	public ModelAndView securityStatistics(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			// 화면접근이력 이력 남기기
			/*CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0118");
			historyVO.setMnu_id(36);
			accessHistoryService.insertHistory(historyVO);*/
											
			mv.setViewName("encrypt/statistics/securityStatistics");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
}
