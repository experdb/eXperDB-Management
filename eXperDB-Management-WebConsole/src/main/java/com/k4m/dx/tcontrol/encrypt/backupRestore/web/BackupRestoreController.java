package com.k4m.dx.tcontrol.encrypt.backupRestore.web;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.experdb.management.backup.cmmn.CmmnUtil;
import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityService;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.cmmn.rest.RequestResult;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.SystemCode;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.encrypt.service.call.BackupServiceCall;
import com.k4m.dx.tcontrol.login.service.LoginVO;

@Controller
public class BackupRestoreController {
	
	@Autowired
	private AccessHistoryService accessHistoryService;
	
	@Autowired
	private MenuAuthorityService menuAuthorityService;
	
	private List<Map<String, Object>> menuAut;
	
	/**
	 * 암호화 백업 화면
	 * @param request
	 * @param historyVO
	 * @return ModelAndView
	 */
	@RequestMapping(value="/encryptBackup.do")
	public @ResponseBody ModelAndView encryptBackup(HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO){
		ModelAndView mv = new ModelAndView();
		
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN0002201");	
			// 메뉴 권한 내용 아직 수정하지 않아 일단 풀어둠
//			if(menuAut.get(0).get("read_aut_yn").equals("N")){
//				mv.setViewName("error/autError");
//			}else{
//				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
//				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
				
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0170");
				historyVO.setMnu_id(57);
				accessHistoryService.insertHistory(historyVO);
				
				mv.setViewName("encrypt/backupRestore/encryptBackup");
//			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
//		HttpSession session = request.getSession();
//		LoginVO loginVo = (LoginVO) session.getAttribute("session");
//		String restIp = loginVo.getRestIp();
//		int restPort = loginVo.getRestPort();
//		String strTocken = loginVo.getTockenValue();
//		String loginId = loginVo.getUsr_id();
//		String entityId = loginVo.getEctityUid();
		
//		System.out.println("++++++++++++++++++++++++++++++");
//		System.out.println("strTocken : " + strTocken);
//		System.out.println("restIp : " + restIp);
//		System.out.println("loginId : " + loginId);
//		System.out.println("entityId : " + entityId);
//		System.out.println("restPort : " + restPort);
//		System.out.println("++++++++++++++++++++++++++++++");
		

		return mv;
	}
	
	/**
	 * 암호화 복원 화면
	 * @param request
	 * @param historyVO
	 * @return ModelAndView
	 */
	@RequestMapping(value="/encryptRestore.do")
	public @ResponseBody ModelAndView encryptRestore(HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO){
		ModelAndView mv = new ModelAndView();
		
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN0002202");	
			// 메뉴 권한 내용 아직 수정하지 않아 일단 풀어둠
//			if(menuAut.get(0).get("read_aut_yn").equals("N")){
//				mv.setViewName("error/autError");
//			}else{
//				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
//				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
				
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0171");
				historyVO.setMnu_id(58);
				accessHistoryService.insertHistory(historyVO);
				
				mv.setViewName("encrypt/backupRestore/encryptRestore");
//			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return mv;
		
	}
	
	/**
	 * 암호화 백업 실행
	 * @param request
	 * @param response
	 * @param historyVO
	 * @return JSONObject result
	 */
	@RequestMapping(value="/encryptBackupRun.do")
	public @ResponseBody JSONObject encryptBackupRun(HttpServletRequest request, HttpServletResponse response, @ModelAttribute("historyVO") HistoryVO historyVO){
		BackupServiceCall bsc = new BackupServiceCall();
		JSONObject result = new JSONObject();
		
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0170_01");
			historyVO.setMnu_id(57);
			accessHistoryService.insertHistory(historyVO);
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		String restIp = loginVo.getRestIp();
		int restPort = loginVo.getRestPort();
		String strTocken = loginVo.getTockenValue();
		String loginId = loginVo.getUsr_id();
		String entityId = loginVo.getEctityUid();
		
		Boolean chkKey = Boolean.parseBoolean(request.getParameter("chkKey"));
		Boolean chkPolicy = Boolean.parseBoolean(request.getParameter("chkPolicy"));
		Boolean chkServer = Boolean.parseBoolean(request.getParameter("chkServer"));
		Boolean chkAdminUser = Boolean.parseBoolean(request.getParameter("chkAdminUser"));
		Boolean chkConfig = Boolean.parseBoolean(request.getParameter("chkConfig"));
		String password = request.getParameter("password");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		param.put("chkKey", chkKey);
		param.put("chkPolicy", chkPolicy);
		param.put("chkServer", chkServer);
		param.put("chkAdminUser", chkAdminUser);
		param.put("chkConfig", chkConfig);
		param.put("password", password);
		
		try {
			result = bsc.encryptBackup(restIp, restPort, strTocken, loginId, entityId, param);
		} catch (Exception e) {
			e.printStackTrace();
		}
	
		return result;
	}
	
	/**
	 * 암호화 백업 파일 다운로드
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/encryptBackupDownload.do")
	@ResponseBody
	public void encryptBackupDownload(HttpServletRequest request, HttpServletResponse response){
		DateFormat df = new SimpleDateFormat("yyyyMMdd");
		Date today = Calendar.getInstance().getTime();
		String backupDate = df.format(today);
		
		String fileName = "encryptBackup_"+backupDate+".edk";
		String backupContent = request.getParameter("encryptBackupFile").toString().replace("&quot;", "\"");
		
		String resClient = request.getHeader("User-Agent");
		
		if(resClient.indexOf("MSIE") != -1){
			response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
		}else{
			// 한글 파일명 처리
			try {
				fileName = new String(fileName.getBytes("utf-8"), "iso-8859-1");
				response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
				response.setHeader("Content-Type", "application/octet-stream; charset=utf-8");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
		}
		
		StringBuffer sb = new StringBuffer(backupContent);
		
		byte[] outputByte = new byte[4096];
		
		try {
			BufferedInputStream ins = new BufferedInputStream(new ByteArrayInputStream(sb.toString().getBytes("UTF-8")));
			BufferedOutputStream outs = new BufferedOutputStream(response.getOutputStream());
			int read = 0;
			
			while((read=ins.read(outputByte)) != -1){
				outs.write(outputByte, 0, read);
			}
			
			outs.flush();
			outs.close();
			ins.close();
		} catch (IOException e1) {
			e1.printStackTrace();
		} 
		
	}
	
	/**
	 * 암호화 복원 실행
	 * @param MultiRequest
	 * @param response
	 * @param request
	 * @param historyVO
	 * @return JSONObject result
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value="/encryptRestoreRun.do")
	public @ResponseBody JSONObject encryptRestoreRun(MultipartHttpServletRequest MultiRequest,  HttpServletResponse response, HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO){
		System.out.println("encryptRestoreRun CALLED");
		BackupServiceCall bsc = new BackupServiceCall();
		JSONObject result = new JSONObject();
		
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0171_01");
			historyVO.setMnu_id(58);
			accessHistoryService.insertHistory(historyVO);
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		HttpSession session = MultiRequest.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		String restIp = loginVo.getRestIp();
		int restPort = loginVo.getRestPort();
		String strTocken = loginVo.getTockenValue();
		String loginId = loginVo.getUsr_id();
		String entityId = loginVo.getEctityUid();
		
		Boolean chkKey = Boolean.parseBoolean(request.getParameter("chkKey"));
		Boolean chkPolicy = Boolean.parseBoolean(request.getParameter("chkPolicy"));
		Boolean chkServer = Boolean.parseBoolean(request.getParameter("chkServer"));
		Boolean chkAdminUser = Boolean.parseBoolean(request.getParameter("chkAdminUser"));
		Boolean chkConfig = Boolean.parseBoolean(request.getParameter("chkConfig"));
		String password = request.getParameter("password");
		
		MultipartFile mFile = MultiRequest.getFile("backupFile");
		
		HashMap param = new HashMap();
		
		param.put("chkKey", chkKey);
		param.put("chkPolicy", chkPolicy);
		param.put("chkServer", chkServer);
		param.put("chkAdminUser", chkAdminUser);
		param.put("chkConfig", chkConfig);
		param.put("password", password);
		
		try {
			RequestResult requestResult = bsc.encryptRestore(restIp, restPort, strTocken, loginId, entityId, param, mFile);
			result.put("RESULT_CODE", requestResult.getResultCode());
			result.put("RESULT_MESSAGE", requestResult.getResultMessage());
		} catch (Exception e) {
			e.printStackTrace();
		}
	
		return result;
	}
	
	/**
	 * 암호화 복원시 백업파일 유효성 확인
	 * @param request
	 * @param response
	 * @param historyVO
	 * @return JSONObject result
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/encryptFileValidation.do")
	public @ResponseBody JSONObject encryptFileValidation(MultipartHttpServletRequest request, HttpServletResponse response, @ModelAttribute("historyVO") HistoryVO historyVO){
		JSONObject result = new JSONObject();
		
		BackupServiceCall bsc = new BackupServiceCall();
		MultipartFile mFile = request.getFile("backupFile");
		
		Boolean chkKey = Boolean.parseBoolean(request.getParameter("chkKey"));
		Boolean chkPolicy = Boolean.parseBoolean(request.getParameter("chkPolicy"));
		Boolean chkServer = Boolean.parseBoolean(request.getParameter("chkServer"));
		Boolean chkAdminUser = Boolean.parseBoolean(request.getParameter("chkAdminUser"));
		Boolean chkConfig = Boolean.parseBoolean(request.getParameter("chkConfig"));
		String password = request.getParameter("password");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		param.put("chkKey", chkKey);
		param.put("chkPolicy", chkPolicy);
		param.put("chkServer", chkServer);
		param.put("chkAdminUser", chkAdminUser);
		param.put("chkConfig", chkConfig);
		param.put("password", password);
		
		try {
			result = bsc.validateBackupFile(mFile, param);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("RESULT_CODE", SystemCode.ResultCode.UNMANAGED_ERROR);
		}
		
		return result;
	}
	
}
