package com.k4m.dx.tcontrol.sample.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;


@Controller
public class SampleRowsShuffleController {
	
	
	@RequestMapping(value = "/sampleRowsShuffle")
	public ModelAndView sampleRowsShuffle() throws Exception {
		 ModelAndView mv = new ModelAndView();
			try {			
				mv.setViewName("sample/sampleRowsShuffle");
				return mv;		       
			} catch(Exception e) {
				e.printStackTrace();
			}
			 return mv;
	}
	
}
