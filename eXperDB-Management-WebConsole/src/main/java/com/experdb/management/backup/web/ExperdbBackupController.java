package com.experdb.management.backup.web;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.experdb.management.backup.service.ExperdbBackupService;
import com.experdb.management.backup.service.ServerInfoVO;
import com.k4m.dx.tcontrol.common.service.HistoryVO;


@Controller
public class ExperdbBackupController {
	
	@Autowired
	private ExperdbBackupService experdbBackupService;

	
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
	 * 백업설정신규 
	 * @param WorkVO, historyVO, request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/experdb/backupJob.do")
	public ModelAndView backupJob(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("eXperDB_Backup/backupJob");
		return mv;
	}
	
	/**
	 * 백업스토리지 View page
	 * @param historyVO, request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/experdb/backupStorage.do")
	public ModelAndView backupStorage(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("eXperDB_Backup/backupStorage");
		return mv;
	}

	/**
	 * 백업이력 View page
	 * @param historyVO, request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/experdb/backupHistory.do")
	public ModelAndView backupHistory(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("eXperDB_Backup/backupHistory");
		return mv;
	}
	
	/**
	 * 백업모니터링 View page
	 * @param historyVO, request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/experdb/backupMonitoring.do")
	public ModelAndView backupMonitoring(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("eXperDB_Backup/backupMonitoring");
		return mv;
	}

	/**
	 * 백업설정 server 정보 가져오기
	 * @param historyVO, request
	 * @return List<ServerInfoVO>
	 * @throws Exception
	 */
	@RequestMapping(value="/experdb/getServerInfo.do")
	public @ResponseBody List<ServerInfoVO> getServerInfo(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) throws Exception {
		return experdbBackupService.getServerInfo(request);
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
