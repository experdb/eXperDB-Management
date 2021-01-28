package com.k4m.dx.tcontrol.arcbackup.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.script.service.ScriptVO;


@Controller
public class ArcBackupController {

	
	/**
	 * 백업설정 View page
	 * @param WorkVO, historyVO, request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/arcBackup/arcBackupSetting.do")
	public ModelAndView arcBackupSetting(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {

		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("arcBackup/backupSeetting");
		
		return mv;
	}
	
	
	
	/**
	 * 백업정책 등록 팝업창 호출
	 * @param WorkVO
	 * @return Map<String, Object>
	 */
	@RequestMapping(value = "/arcBackup/arcBackupRegForm.do")
	@ResponseBody
	public List<Map<String, Object>> arcBackupRegForm(HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) {
		List<Map<String, Object>> resultSet = null;

		try {

				System.out.println("@@@@@@@@@@@@@");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return resultSet;	
	}
}
