package com.k4m.dx.tcontrol.cmmn_web;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class ErrorSettingController {

	
	@RequestMapping(value = "/error/400")
	public ModelAndView error400(HttpServletRequest request, ModelMap model) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("error/400Error");
		return mv;	
	}
	
	@RequestMapping(value = "/error/401")
	public ModelAndView error401(HttpServletRequest request, ModelMap model) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("error/401Error");
		return mv;
	}
	
	@RequestMapping(value = "/error/403")
	public ModelAndView error403(HttpServletRequest request, ModelMap model) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("error/403Error");
		return mv;	
	}
	
	@RequestMapping(value = "/error/404")
	public ModelAndView error404(HttpServletRequest request, ModelMap model) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("error/404Error");
		return mv;	
	}
	
	@RequestMapping(value = "/error/500")
	public ModelAndView error500(HttpServletRequest request, ModelMap model) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("error/500Error");
		return mv;	
	}
	

}