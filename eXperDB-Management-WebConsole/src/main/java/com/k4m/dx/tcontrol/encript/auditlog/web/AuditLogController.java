package com.k4m.dx.tcontrol.encript.auditlog.web;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.AuditLog;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.encript.service.call.AuditLogServiceCall;


@Controller
public class AuditLogController {

	String restIp = "127.0.0.1";
	int restPort = 8443;
	String strTocken = "burNXW4UXVz1CXoMiGDI8/3PISmBtZvF605GrumOn14=";
	
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
	 * 암복호화 감사로그 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectEncodeDecodeAuditLog.do")
	public @ResponseBody JSONObject selectEncodeDecodeAuditLog(HttpServletRequest request) {
		AuditLogServiceCall sic = new AuditLogServiceCall();
		JSONObject result = new JSONObject();
		try {
			result = sic.selectAuditLogSiteList(restIp, restPort, strTocken);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
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
		AuditLogServiceCall sic = new AuditLogServiceCall();
		JSONArray entityuid = new JSONArray();
		try {
			// 화면접근이력 이력 남기기
			/*CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0055");
			accessHistoryService.insertHistory(historyVO);*/
			
			entityuid =sic.selectEntityList(restIp, restPort, strTocken);
			mv.addObject("entityuid", entityuid);
			
			mv.setViewName("encript/auditLog/managementServerAuditLog");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	/**
	 * 관리서버 감사로그 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectManagementServerAuditLog.do")
	public @ResponseBody JSONObject selectManagementServerAuditLog(HttpServletRequest request) {
		AuditLogServiceCall sic = new AuditLogServiceCall();
		JSONObject result = new JSONObject();
		try {
			String DateTimeFrom = request.getParameter("from")+" 00:00:00.000000";
			String DateTimeTo = request.getParameter("to")+" 23:59:59.999999";
			String resultcode = request.getParameter("resultcode");
			String entityuid = request.getParameter("entityuid");
			
			AuditLog param = new AuditLog();
			param.setSearchLogDateTimeFrom(DateTimeFrom); 
			param.setSearchLogDateTimeTo(DateTimeTo);
			param.setEntityUid(entityuid);
			param.setResultCode(resultcode);

			param.setPageOffset(1);
			param.setPageSize(10);
			param.setTotalCountLimit(10001);
			
			result = sic.selectAuditLogList(restIp, restPort, strTocken, param);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	/**
	 * 암복호화키 감사로그 화면을 보여준다
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/encodeDecodeKeyAuditLog.do")
	public ModelAndView encodeDecodeKeyAuditLog(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		AuditLogServiceCall sic = new AuditLogServiceCall();
		JSONArray entityuid = new JSONArray();
		try {
			// 화면접근이력 이력 남기기
			/*CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0055");
			accessHistoryService.insertHistory(historyVO);*/
			
			entityuid =sic.selectEntityList(restIp, restPort, strTocken);
			mv.addObject("entityuid", entityuid);
			
			mv.setViewName("encript/auditLog/encodeDecodeKeyAuditLog");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	/**
	 * 암복호화키 감사로그 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectEncodeDecodeKeyAuditLog.do")
	public @ResponseBody JSONObject selectEncodeDecodeKeyAuditLog(HttpServletRequest request) {
		AuditLogServiceCall sic = new AuditLogServiceCall();
		JSONObject result = new JSONObject();
		try {
			String DateTimeFrom = request.getParameter("from")+" 00:00:00.000000";
			String DateTimeTo = request.getParameter("to")+" 23:59:59.999999";
			String resultcode = request.getParameter("resultcode");
			String entityuid = request.getParameter("entityuid");
			
			AuditLog param = new AuditLog();
			param.setKeyAccessOnly(true);
			param.setSearchLogDateTimeFrom(DateTimeFrom); 
			param.setSearchLogDateTimeTo(DateTimeTo);
			param.setEntityUid(entityuid);
			param.setResultCode(resultcode);

			param.setPageOffset(1);
			param.setPageSize(10);
			param.setTotalCountLimit(10001);
			
			result = sic.selectAuditLogListKey(restIp, restPort, strTocken , param);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
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
