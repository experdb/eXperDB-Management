package com.experdb.management.recovery.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;


import com.experdb.management.recovery.service.ExperdbRecoveryService;

@Controller
public class ExperdbRecoveryController {
	
	@Autowired
	private ExperdbRecoveryService experdbRecoveryService;
	
	
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
	
	
	@RequestMapping(value = "/experdb/nodeInfoList.do")
	public @ResponseBody JSONObject getNodeInfoList(){
		JSONObject result = new JSONObject();
		
		result = experdbRecoveryService.getNodeInfoList();
		return result;
	}
	
	
	@RequestMapping(value = "/experdb/recStorageList.do")
	public @ResponseBody JSONObject getStorageList(HttpServletRequest request){
		System.out.println("####### getStorageList CONTROLLER #######");
		JSONObject result = new JSONObject();
		
		result = experdbRecoveryService.getStorageList(request);
		
		return result;
	}
	

}
