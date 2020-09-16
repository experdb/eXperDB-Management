package com.k4m.dx.tcontrol.encrypt.auditlog.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityService;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.AuditLog;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.AuditLogSite;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.BackupLog;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.SystemUsage;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.encrypt.service.call.AuditLogServiceCall;
import com.k4m.dx.tcontrol.login.service.LoginVO;


@Controller
public class AuditLogController {

	@Autowired
	private AccessHistoryService accessHistoryService;
	
	@Autowired
	private MenuAuthorityService menuAuthorityService;
	
	private List<Map<String, Object>> menuAut;

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
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001201");	
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
				
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0110");
				historyVO.setMnu_id(28);
				accessHistoryService.insertHistory(historyVO);
				
				AuditLogServiceCall sic = new AuditLogServiceCall();
				JSONArray result = new JSONArray();
				
				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				String restIp = loginVo.getRestIp();
				int restPort = loginVo.getRestPort();
				String strTocken = loginVo.getTockenValue();
				String loginId = loginVo.getUsr_id();
				String entityId = loginVo.getEctityUid();			
				
				try{
					result = sic.selectEntityAgentList(restIp, restPort, strTocken, loginId ,entityId);
				}catch(Exception e){
					JSONObject jsonObj = new JSONObject();
					jsonObj.put("resultCode", "8000000002");
					result.add(jsonObj);
				}
				
				mv.setViewName("encrypt/auditLog/encodeDecodeAuditLog");
				mv.addObject("result",result);
			}
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
	public @ResponseBody JSONObject selectEncodeDecodeAuditLog(HttpServletRequest request,@ModelAttribute("historyVO") HistoryVO historyVO) {
		AuditLogServiceCall sic = new AuditLogServiceCall();
		JSONObject result = new JSONObject();
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0110_01");
			historyVO.setMnu_id(28);
			accessHistoryService.insertHistory(historyVO);
			
			String from = request.getParameter("from").replace("-", "");
			String to = request.getParameter("to").replace("-", "");
			
			String DateTimeFrom = from+"000000";
			String DateTimeTo = to+"240000";
			String agentUid = request.getParameter("agentUid");
			String searchFieldName= request.getParameter("searchFieldName");
			String searchOperator = request.getParameter("searchOperator");
			String searchFieldValueString = request.getParameter("searchFieldValueString");
			String successTrueFalse = request.getParameter("successTrueFalse");	
			
			AuditLogSite param = new AuditLogSite();
			param.setSearchAgentLogDateTimeFrom(DateTimeFrom); 
			param.setSearchAgentLogDateTimeTo(DateTimeTo);
			param.setAgentUid(agentUid);
			param.setSearchFieldName(searchFieldName);
			param.setSearchOperator(searchOperator);
			param.setSearchFieldValueString(searchFieldValueString);
			if(successTrueFalse.equals("true")){
				param.setSuccessTrueFalse(true);
			}else if(successTrueFalse.equals("false")){
				param.setSuccessTrueFalse(false);
			}
			
			param.setPageOffset(1);
			param.setPageSize(10001);
			param.setTotalCountLimit(10001);
			
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String restIp = loginVo.getRestIp();
			int restPort = loginVo.getRestPort();
			String strTocken = loginVo.getTockenValue();
			String loginId = loginVo.getUsr_id();
			String entityId = loginVo.getEctityUid();
			
			try{
				result = sic.selectAuditLogSiteList(restIp, restPort, strTocken, param, loginId ,entityId);
			}catch(Exception e){
				result.put("resultCode", "8000000002");
			}
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
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001202");	
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
				
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0111");
				historyVO.setMnu_id(29);
				accessHistoryService.insertHistory(historyVO);
				
				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				String restIp = loginVo.getRestIp();
				int restPort = loginVo.getRestPort();
				String strTocken = loginVo.getTockenValue();
				String loginId = loginVo.getUsr_id();
				String entityId = loginVo.getEctityUid();
			
				try{
					entityuid =sic.selectEntityList(restIp, restPort, strTocken, loginId ,entityId);
				}catch(Exception e){
					JSONObject jsonObj = new JSONObject();
					jsonObj.put("resultCode", "8000000002");
					entityuid.add(jsonObj);
				}
				
				mv.addObject("entityuid", entityuid);
				mv.setViewName("encrypt/auditLog/managementServerAuditLog");
			}	
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
	public @ResponseBody JSONObject selectManagementServerAuditLog(HttpServletRequest request,@ModelAttribute("historyVO") HistoryVO historyVO) {
		AuditLogServiceCall sic = new AuditLogServiceCall();
		JSONObject result = new JSONObject();
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0111_01");
			historyVO.setMnu_id(29);
			accessHistoryService.insertHistory(historyVO);
			
			String DateTimeFrom = request.getParameter("from")+" 00:00:00.000000";
			String DateTimeTo = request.getParameter("to")+" 23:59:59.999";
			String resultcode = request.getParameter("resultcode");
			String entityuid = request.getParameter("entityuid");
			
			AuditLog param = new AuditLog();
			param.setSearchLogDateTimeFrom(DateTimeFrom);
			param.setSearchLogDateTimeTo(DateTimeTo);
			param.setEntityUid(entityuid);
			param.setResultCode(resultcode);

			param.setPageOffset(1);
			param.setPageSize(10001);
			param.setTotalCountLimit(10001);

			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String restIp = loginVo.getRestIp();
			int restPort = loginVo.getRestPort();
			String strTocken = loginVo.getTockenValue();
			String loginId = loginVo.getUsr_id();
			String entityId = loginVo.getEctityUid();
		
			try{
				result = sic.selectAuditLogList(restIp, restPort, strTocken, loginId ,entityId, param);
			}catch(Exception e){
				result.put("resultCode", "8000000002");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * 관리서버 상세보기 화면을 보여준다
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/managementServerAuditLogDetail.do")
	public ModelAndView managementServerAuditLogDetail(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		
		ModelAndView mv = new ModelAndView("jsonView");
		
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0112");
			historyVO.setMnu_id(29);
			accessHistoryService.insertHistory(historyVO);

			String entityName = request.getParameter("entityName").equals("undefined")?"":request.getParameter("entityName");
			String logDateTime = request.getParameter("logDateTime").equals("undefined")?"":request.getParameter("logDateTime");
			String remoteAddress = request.getParameter("remoteAddress").equals("undefined")?"":request.getParameter("remoteAddress");
			String requestPath = request.getParameter("requestPath").equals("undefined")?"":request.getParameter("requestPath");
			String resultCode = request.getParameter("resultCode").equals("undefined")?"":request.getParameter("resultCode");
			String parameter = request.getParameter("parameter").equals("undefined")?"":request.getParameter("parameter");
			String resultMessage = request.getParameter("resultMessage").equals("undefined")?"":request.getParameter("resultMessage");

			mv.addObject("entityName", entityName);
			mv.addObject("logDateTime", logDateTime);
			mv.addObject("remoteAddress", remoteAddress);
			mv.addObject("requestPath", requestPath);
			mv.addObject("resultCode", resultCode);
			mv.addObject("parameter", parameter);
			mv.addObject("resultMessage", resultMessage);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * 암호화 키 감사로그 화면을 보여준다
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
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001203");	
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
				
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0113");
				historyVO.setMnu_id(30);
				accessHistoryService.insertHistory(historyVO);
				
				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				String restIp = loginVo.getRestIp();
				int restPort = loginVo.getRestPort();
				String strTocken = loginVo.getTockenValue();
				String loginId = loginVo.getUsr_id();
				String entityId = loginVo.getEctityUid();
				
				try{
					entityuid =sic.selectEntityList(restIp, restPort, strTocken, loginId ,entityId);
				}catch(Exception e){
					JSONObject jsonObj = new JSONObject();
					jsonObj.put("resultCode", "8000000002");
					entityuid.add(jsonObj);
				}
				mv.addObject("entityuid", entityuid);
				mv.setViewName("encrypt/auditLog/encodeDecodeKeyAuditLog");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	/**
	 * 암호화 키 감사로그 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectEncodeDecodeKeyAuditLog.do")
	public @ResponseBody JSONObject selectEncodeDecodeKeyAuditLog(HttpServletRequest request,@ModelAttribute("historyVO") HistoryVO historyVO) {
		AuditLogServiceCall sic = new AuditLogServiceCall();
		JSONObject result = new JSONObject();
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0113_01");
			historyVO.setMnu_id(30);
			accessHistoryService.insertHistory(historyVO);
			
			String DateTimeFrom = request.getParameter("from")+" 00:00:00.000000";
			String DateTimeTo = request.getParameter("to")+" 23:59:59.999";
			String resultcode = request.getParameter("resultcode");
			String entityuid = request.getParameter("entityuid");
			
			AuditLog param = new AuditLog();
			param.setKeyAccessOnly(true);
			param.setSearchLogDateTimeFrom(DateTimeFrom); 
			param.setSearchLogDateTimeTo(DateTimeTo);
			param.setEntityUid(entityuid);
			param.setResultCode(resultcode);

			param.setPageOffset(1);
			param.setPageSize(10001);
			param.setTotalCountLimit(10001);
			
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String restIp = loginVo.getRestIp();
			int restPort = loginVo.getRestPort();
			String strTocken = loginVo.getTockenValue();
			String loginId = loginVo.getUsr_id();
			String entityId = loginVo.getEctityUid();
			
			try{
				result = sic.selectAuditLogListKey(restIp, restPort, strTocken, loginId, entityId, param);
			}catch(Exception e){
				result.put("resultCode", "8000000002");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * 암호화 키 상세보기 화면을 보여준다
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/encodeDecodeKeyAuditLogDetail.do")
	public ModelAndView encodeDecodeKeyAuditLogDetail(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		
		ModelAndView mv = new ModelAndView("jsonView");
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0114");
			historyVO.setMnu_id(30);
			accessHistoryService.insertHistory(historyVO);

			String entityName = request.getParameter("entityName").equals("undefined")?"":request.getParameter("entityName");
			String logDateTime = request.getParameter("logDateTime").equals("undefined")?"":request.getParameter("logDateTime");
			String remoteAddress = request.getParameter("remoteAddress").equals("undefined")?"":request.getParameter("remoteAddress");
			String requestPath = request.getParameter("requestPath").equals("undefined")?"":request.getParameter("requestPath");
			String resultCode = request.getParameter("resultCode").equals("undefined")?"":request.getParameter("resultCode");
			String parameter = request.getParameter("parameter").equals("undefined")?"":request.getParameter("parameter");
			String resultMessage = request.getParameter("resultMessage").equals("undefined")?"":request.getParameter("resultMessage");

			mv.addObject("entityName", entityName);
			mv.addObject("logDateTime", logDateTime);
			mv.addObject("remoteAddress", remoteAddress);
			mv.addObject("requestPath", requestPath);
			mv.addObject("resultCode", resultCode);
			mv.addObject("parameter", parameter);
			mv.addObject("resultMessage", resultMessage);

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
		AuditLogServiceCall sic = new AuditLogServiceCall();
		JSONArray entityuid = new JSONArray();
		JSONArray result = new JSONArray();
		try {
			// 화면접근이력 이력 남기기
			/*CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0055");
			accessHistoryService.insertHistory(historyVO);*/
			
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String restIp = loginVo.getRestIp();
			int restPort = loginVo.getRestPort();
			String strTocken = loginVo.getTockenValue();
			String loginId = loginVo.getUsr_id();
			String entityId = loginVo.getEctityUid();
			
			entityuid =sic.selectEntityList(restIp, restPort, strTocken, loginId ,entityId);

			mv.addObject("entityuid", entityuid);
			
			mv.setViewName("encrypt/auditLog/backupRestoreAuditLog");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * 백업및복원 감사로그 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectBackupRestoreAuditLog.do")
	public @ResponseBody JSONObject selectBackupRestoreAuditLog(HttpServletRequest request) {
		AuditLogServiceCall sic = new AuditLogServiceCall();
		JSONObject result = new JSONObject();
		try {
			String DateTimeFrom = request.getParameter("from")+" 00:00:00.000000";
			String DateTimeTo = request.getParameter("to")+" 23:59:59.999";
			String worktype = request.getParameter("worktype");
			String entityuid = request.getParameter("entityuid");
			
			BackupLog param = new BackupLog();

			param.setBackupWorkType(worktype);
			param.setSearchLogDateTimeFrom(DateTimeFrom); 
			param.setSearchLogDateTimeTo(DateTimeTo);
			param.setEntityUid(entityuid);
			
			param.setPageOffset(1);
			param.setPageSize(10001);
			param.setTotalCountLimit(10001);
			
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String restIp = loginVo.getRestIp();
			int restPort = loginVo.getRestPort();
			String strTocken = loginVo.getTockenValue();
			String loginId = loginVo.getUsr_id();
			String entityId = loginVo.getEctityUid();
			
			result = sic.selectBackupLogList(restIp, restPort, strTocken, loginId ,entityId, param);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
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
		AuditLogServiceCall sic = new AuditLogServiceCall();
		JSONArray monitoreduid = new JSONArray();
		try {
			// 화면접근이력 이력 남기기
			/*CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0055");
			accessHistoryService.insertHistory(historyVO);*/
			
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String restIp = loginVo.getRestIp();
			int restPort = loginVo.getRestPort();
			String strTocken = loginVo.getTockenValue();
			String loginId = loginVo.getUsr_id();
			String entityId = loginVo.getEctityUid();
			
			monitoreduid =sic.selectEntityAgentList(restIp, restPort, strTocken, loginId ,entityId);
			mv.addObject("monitoreduid", monitoreduid);

			mv.setViewName("encrypt/auditLog/resourcesUseAuditLog");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * 자원사용 감사로그 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectResourcesUseAuditLog.do")
	public @ResponseBody JSONObject selectResourcesUseAuditLog(HttpServletRequest request) {
		AuditLogServiceCall sic = new AuditLogServiceCall();
		JSONObject result = new JSONObject();
		try {
			String DateTimeFrom = request.getParameter("from")+" 00:00:00.000000";
			String DateTimeTo = request.getParameter("to")+" 23:59:59.999";
			String monitoreduid = request.getParameter("monitoreduid");
			
			SystemUsage param = new SystemUsage();

			param.setSearchDateTimeFrom(DateTimeFrom); 
			param.setSearchDateTimeTo(DateTimeTo);
			param.setMonitoredUid(monitoreduid);
			
			param.setPageOffset(1);
			param.setPageSize(10001);
			
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String restIp = loginVo.getRestIp();
			int restPort = loginVo.getRestPort();
			String strTocken = loginVo.getTockenValue();
			String loginId = loginVo.getUsr_id();
			String entityId = loginVo.getEctityUid();
			
			result = sic.selectSystemUsageLogList(restIp, restPort, strTocken, loginId ,entityId, param);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	/**
	 * 암호화 agent리스트 조회
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectEncryptAgentList.do")
	public @ResponseBody JSONArray selectEncryptAgentList(HttpServletRequest request) {
			
		AuditLogServiceCall alsc= new AuditLogServiceCall();
		JSONArray result = new JSONArray();
		try {
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String restIp = loginVo.getRestIp();
			int restPort = loginVo.getRestPort();
			String strTocken = loginVo.getTockenValue();
			String loginId = loginVo.getUsr_id();
			String entityId = loginVo.getEctityUid();
			
			result = alsc.selectEntityAgentList(restIp, restPort, strTocken, loginId ,entityId);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}	
}
