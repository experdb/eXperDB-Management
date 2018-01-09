package com.k4m.dx.tcontrol.encript.auditlog.web;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.HistoryVO;

@Controller
public class AuditLogController {

	/**
	 * 암복호화 감사로그 화면을 보여준다
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/encodeDecodeAuditLog.do")
	public ModelAndView encodeDecodeAuditLog(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			// 화면접근이력 이력 남기기
			/*CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0055");
			accessHistoryService.insertHistory(historyVO);*/

			mv.setViewName("encript/auditLog/encodeDecodeAuditLog");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * 관리서버 감사로그 화면을 보여준다
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/managementServerAuditLog.do")
	public ModelAndView managementServerAuditLog(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			// 화면접근이력 이력 남기기
			/*CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0055");
			accessHistoryService.insertHistory(historyVO);*/

			mv.setViewName("encript/auditLog/managementServerAuditLog");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * 암복호화키 감사로그 화면을 보여준다
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/securityPolicy.do")
	public ModelAndView encodeDecodeKeyAuditLog(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			// 화면접근이력 이력 남기기
			/*CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0055");
			accessHistoryService.insertHistory(historyVO);*/

			mv.setViewName("encript/auditLog/encodeDecodeKeyAuditLog");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * 백업및복원 감사로그 화면을 보여준다
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/backupRestoreAuditLog.do")
	public ModelAndView backupRestoreAuditLog(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			// 화면접근이력 이력 남기기
			/*CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0055");
			accessHistoryService.insertHistory(historyVO);*/

			mv.setViewName("encript/auditLog/backupRestoreAuditLog");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * 자원사용 감사로그 화면을 보여준다
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/resourcesUseAuditLog.do")
	public ModelAndView resourcesUseAuditLog(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			// 화면접근이력 이력 남기기
			/*CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0055");
			accessHistoryService.insertHistory(historyVO);*/

			mv.setViewName("encript/auditLog/resourcesUseAuditLog");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
}
