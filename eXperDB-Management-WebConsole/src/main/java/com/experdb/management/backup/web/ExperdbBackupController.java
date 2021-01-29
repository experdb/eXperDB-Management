package com.experdb.management.backup.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.common.service.HistoryVO;


@Controller
public class ExperdbBackupController {

	
	/**
	 * 백업설정 View page
	 * @param WorkVO, historyVO, request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/experdb/backupSetting.do")
	public ModelAndView backupSetting(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {

		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("eXperDB_Backup/backupSetting");
		
		return mv;
	}
	
	
	
	/**
	 * 백업정책 등록 팝업창 호출
	 * @param WorkVO
	 * @return Map<String, Object>
	 */
	@RequestMapping(value = "/experdb/backupRegForm.do")
	@ResponseBody
	public List<Map<String, Object>> backupRegForm(HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) {
		List<Map<String, Object>> resultSet = null;

		try {

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return resultSet;	
	}
}
