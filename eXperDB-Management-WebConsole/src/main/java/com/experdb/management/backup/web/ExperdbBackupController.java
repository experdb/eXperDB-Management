package com.experdb.management.backup.web;

import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.ResourceUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.experdb.management.backup.service.ExperdbBackupService;
import com.experdb.management.backup.service.ServerInfoVO;
import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityService;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.HistoryVO;


@Controller
public class ExperdbBackupController {
	
	@Autowired
	private ExperdbBackupService experdbBackupService;

	@Autowired
	private MenuAuthorityService menuAuthorityService;
	
	@Autowired
	private AccessHistoryService accessHistoryService;
	
	private List<Map<String, Object>> menuAut;
	
	/**
	 * 백업설정 View page
	 * @param WorkVO, historyVO, request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/experdb/backupSetting.do")
	public ModelAndView backupSetting(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		
		ModelAndView mv = new ModelAndView();
		
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN0002002");
			
			if (menuAut.get(0).get("read_aut_yn").equals("N")) {
				mv.setViewName("error/autError");
			}else{			
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0163");
				historyVO.setMnu_id(54);
				accessHistoryService.insertHistory(historyVO);
				mv.setViewName("eXperDB_Backup/backupSetting");
			}		
		} catch (Exception e) {
			e.printStackTrace();
		}	
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
		
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN0002001");
			
			if (menuAut.get(0).get("read_aut_yn").equals("N")) {
				mv.setViewName("error/autError");
			}else{			
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0162");
				historyVO.setMnu_id(53);
				accessHistoryService.insertHistory(historyVO);
				mv.setViewName("eXperDB_Backup/backupStorage");
			}		
		} catch (Exception e) {
			e.printStackTrace();
		}
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
		
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001902");
			
			if (menuAut.get(0).get("read_aut_yn").equals("N")) {
				mv.setViewName("error/autError");
			}else{			
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));

				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0164");
				historyVO.setMnu_id(50);
				accessHistoryService.insertHistory(historyVO);
				mv.setViewName("eXperDB_Backup/backupHistory");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}		
		return mv;
	}
	
	/**
	 * 복구이력 View page
	 * @param historyVO, request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/experdb/restoreHistory.do")
	public ModelAndView restoreHistory(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		
		ModelAndView mv = new ModelAndView();
		
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001903");
			
			if (menuAut.get(0).get("read_aut_yn").equals("N")) {
				mv.setViewName("error/autError");
			}else{			
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0165");
				historyVO.setMnu_id(51);
				accessHistoryService.insertHistory(historyVO);
				mv.setViewName("eXperDB_Backup/restoreHistory");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
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
		
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001901");
			
				if (menuAut.get(0).get("read_aut_yn").equals("N")) {
					mv.setViewName("error/autError");
				}else{
					mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
					mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
	
					// 화면접근이력 이력 남기기
					CmmnUtils.saveHistory(request, historyVO);
					historyVO.setExe_dtl_cd("DX-T0166");
					historyVO.setMnu_id(49);
					accessHistoryService.insertHistory(historyVO);
					
					mv.setViewName("eXperDB_Backup/backupMonitoring");
				}			
			} catch (Exception e) {
				e.printStackTrace();
			}
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
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/experdb/backupRegForm.do")
	@ResponseBody
	public JSONObject backupRegForm(HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) {
		List<Map<String, Object>> resultSet = new ArrayList<Map<String, Object>>();
		JSONObject result = new JSONObject();
		
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0162_01");
			accessHistoryService.insertHistory(historyVO);
			
			Properties props = new Properties();
			props.load(new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));			
			String backupUrl = props.get("backup.url").toString();	
			System.out.println("backupUrl : " + backupUrl);
			result.put("backupUrl", backupUrl);
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return result;	
	}
	
	
	
}
