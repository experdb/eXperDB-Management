package com.k4m.dx.tcontrol.sample.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class DBserverBackupController {

	@RequestMapping(value = "/dbserverBackupList.do")
	public ModelAndView sampleBackup(@RequestParam("serverNm") String serverNm) {
		ModelAndView mv = new ModelAndView();
		mv.addObject("serverNm",serverNm);
		mv.setViewName("dbserver/backup");
		return mv;	
	}
	
}
