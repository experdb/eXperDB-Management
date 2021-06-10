package com.experdb.management.recovery.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class ExperdbRecoveryController {
	
	
	/**
	 * 완전 복구 View page
	 * @param historyVO, request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/experdb/completeRecovery.do")
	public ModelAndView completeRecovery(){
		ModelAndView mv = new ModelAndView();
		
		
		mv.setViewName("/eXperDB_Recovery/completeRecovery");
		return mv;
	}
	
	

}
