package com.k4m.dx.tcontrol.encrypt.setting.web;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.IOUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityService;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.encrypt.service.call.CommonServiceCall;
import com.k4m.dx.tcontrol.encrypt.service.call.EncryptSettingServiceCall;
import com.k4m.dx.tcontrol.login.service.LoginVO;

/**
 * Encript 설정 컨트롤러 클래스를 정의한다.
 *
 * @author 변승우
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2018.01.04   변승우 최초 생성
 *      </pre>
 */


@Controller
public class EncriptSettingController {
	
	@Autowired
	private AccessHistoryService accessHistoryService;
	
	@Autowired
	private MenuAuthorityService menuAuthorityService;
	
	private List<Map<String, Object>> menuAut;

	/**
	 * Encript 보안정책 옵션 설정 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/securityPolicyOptionSet.do")
	public ModelAndView encriptAgentMonitoring(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, ModelMap model) {
		ModelAndView mv = new ModelAndView();
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001301");	
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
				
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0115");
				historyVO.setMnu_id(33);
				accessHistoryService.insertHistory(historyVO);
				
				mv.setViewName("encrypt/setting/securityPolicyOptionSet");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	/**
	 * 보안정책 옵션 설정 조회1
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectSysConfigListLike.do")
	public @ResponseBody JSONObject selectCryptoKeyList(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		
		JSONObject result = new JSONObject();
		
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		String restIp = loginVo.getRestIp();
		int restPort = loginVo.getRestPort();
		String strTocken = loginVo.getTockenValue();
		String loginId = loginVo.getUsr_id();
		String entityId = loginVo.getEctityUid();
				
		EncryptSettingServiceCall essc = new EncryptSettingServiceCall();
		
		try {						
			result = essc.selectSysConfigListLike(restIp, restPort, strTocken, loginId, entityId);
		} catch (Exception e) {
			result.put("resultCode", "8000000002");
		}
		return result;
	}
	

	/**
	 * 보안정책 옵션 설정 조회2
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectSysMultiValueConfigListLike.do")
	public @ResponseBody JSONObject selectSysMultiValueConfigListLike(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
			
		JSONObject result = new JSONObject();
		
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		String restIp = loginVo.getRestIp();
		int restPort = loginVo.getRestPort();
		String strTocken = loginVo.getTockenValue();
		String loginId = loginVo.getUsr_id();
		String entityId = loginVo.getEctityUid();	
		
		EncryptSettingServiceCall essc = new EncryptSettingServiceCall();
		
		try {
			result = essc.selectSysMultiValueConfigListLike(restIp, restPort, strTocken, loginId, entityId);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	/**
	 * 보안정책 옵션 설정 저장
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/sysConfigSave.do")
	public @ResponseBody JSONObject sysConfigSave(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		String restIp = loginVo.getRestIp();
		int restPort = loginVo.getRestPort();
		String strTocken = loginVo.getTockenValue();
		String loginId = loginVo.getUsr_id();
		String entityId = loginVo.getEctityUid();
		
		JSONObject result01 = new JSONObject();
		JSONObject result02 = new JSONObject();
		
		try {		
			
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0115_01");
			historyVO.setMnu_id(33);
			accessHistoryService.insertHistory(historyVO);
						
			JSONObject obj01 = new JSONObject();					
			JSONObject obj02 = new JSONObject();	
				
			EncryptSettingServiceCall essc = new EncryptSettingServiceCall();
			
			//옵션설정저장1
			String strRows01 = request.getParameter("arrmaps01").toString().replaceAll("&quot;", "\"");

			JSONArray rows01 = (JSONArray) new JSONParser().parse(strRows01);
			for (int i = 0; i < rows01.size(); i++) {
				obj01 = (JSONObject) rows01.get(i);		
			}	
			result01 = essc.updateSysConfigList(restIp, restPort, strTocken, obj01, loginId, entityId);
					
			//옵션설정저장 1 성공!!
			if(result01.get("resultCode").equals("0000000000")){
				//옵션설정저장2
				String strRows02 = request.getParameter("arrmaps02").toString().replaceAll("&quot;", "\"");
				JSONArray rows02 = (JSONArray) new JSONParser().parse(strRows02);

				for (int i = 0; i < rows02.size(); i++) {
					obj02 = (JSONObject) rows02.get(i);		
				}	
				
				JSONArray rows03 = (JSONArray) new JSONParser().parse(request.getParameter("dayWeek"));	
				result02 = essc.updateSysMultiValueConfigList(restIp, restPort, strTocken, obj02, rows03, loginId, entityId);
			}else{
				return result01;
			}
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result02;
	}
	
	
	/**
	 * 암호화 설정
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/securitySet.do")
	public ModelAndView securitySet(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, ModelMap model) {
	
		ModelAndView mv = new ModelAndView();
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001302");	
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
				
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0117");
				historyVO.setMnu_id(34);
				accessHistoryService.insertHistory(historyVO);
							
				mv.setViewName("encrypt/setting/securitySet");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	/**
	 * 암호화설정 조회
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectEncryptSet.do")
	public @ResponseBody JSONObject selectEncryptSet(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		
		JSONObject result = new JSONObject();
		
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		String restIp = loginVo.getRestIp();
		int restPort = loginVo.getRestPort();
		String strTocken = loginVo.getTockenValue();
		String loginId = loginVo.getUsr_id();
		String entityId = loginVo.getEctityUid();
			
		EncryptSettingServiceCall essc = new EncryptSettingServiceCall();

		try {
			result = essc.selectSysMultiValueConfigListLike2(restIp, restPort, strTocken, loginId, entityId);
		} catch (Exception e) {
			result.put("resultCode", "8000000002");
		}
		return result;
	}
	
	
	/**
	 * 보안정책 옵션 설정 저장
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveEncryptSet.do")
	public @ResponseBody JSONObject saveEncryptSet(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		JSONObject result = new JSONObject();
		
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		String restIp = loginVo.getRestIp();
		int restPort = loginVo.getRestPort();
		String strTocken = loginVo.getTockenValue();
		String loginId = loginVo.getUsr_id();
		String entityId = loginVo.getEctityUid();
		

		try {		
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0117_01");
			historyVO.setMnu_id(34);
			accessHistoryService.insertHistory(historyVO);
						
			JSONObject obj = new JSONObject();					
				
			EncryptSettingServiceCall essc = new EncryptSettingServiceCall();
			
			String strRows = request.getParameter("arrmaps").toString().replaceAll("&quot;", "\"");
			System.out.println(strRows);
			JSONArray rows = (JSONArray) new JSONParser().parse(strRows);
			for (int i = 0; i < rows.size(); i++) {
				obj = (JSONObject) rows.get(i);		
			}
			
			try{
				result = essc.updateSysMultiValueConfigList2(restIp, restPort, strTocken, obj, loginId, entityId);
			}catch(Exception e){
				result.put("resultCode", "8000000002");
			}
						
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}	
	
	
	/**
	 * 서버 마스터키 암호 설정 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/securityKeySet.do")
	public ModelAndView securityKeySet(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, ModelMap model) {
		ModelAndView mv = new ModelAndView();
		JSONObject result = new JSONObject();
		
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		String restIp = loginVo.getRestIp();
		int restPort = loginVo.getRestPort();
		String strTocken = loginVo.getTockenValue();
		String loginId = loginVo.getUsr_id();
		String entityId = loginVo.getEctityUid();	
		
		try {		
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001303");	
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
				
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0121");
				historyVO.setMnu_id(35);
				accessHistoryService.insertHistory(historyVO);
							
				CommonServiceCall csc = new CommonServiceCall();
				
				try{
					result = csc.selectServerStatus(restIp, restPort, strTocken, loginId, entityId);
					String isServerKeyEmpty = result.get("isServerKeyEmpty").toString();
					String isServerPasswordEmpty = result.get("isServerPasswordEmpty").toString();
					mv.addObject("isServerKeyEmpty",isServerKeyEmpty);
					mv.addObject("isServerPasswordEmpty",isServerPasswordEmpty);
				}catch(Exception e){
					mv.addObject("resultCode","8000000002");
				}
				mv.setViewName("encrypt/setting/securityKeySet");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	/**
	 * 서버 마스터키 암호 설정 저장
	 * 화면(pnlOldPasswordView == true && mstKeyUseChk == true)
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/securityMasterKeySave01.do")
	public @ResponseBody JSONObject securityMasterKeySave01(@ModelAttribute("historyVO") HistoryVO historyVO, MultipartHttpServletRequest multiRequest, HttpServletResponse response, HttpServletRequest request) throws FileNotFoundException {
	
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		String restIp = loginVo.getRestIp();
		int restPort = loginVo.getRestPort();
		String strTocken = loginVo.getTockenValue();
		String loginId = loginVo.getUsr_id();
		String entityId = loginVo.getEctityUid();	
		
		JSONObject result = new JSONObject();
		String encKey = null;
		try {		
			
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0121_01");
			historyVO.setMnu_id(35);
			accessHistoryService.insertHistory(historyVO);
						
			MultipartFile keyFile = multiRequest.getFile("keyFile");		
			//String keyFile = multiRequest.getParameter("keyFile");
			String passwordStr = multiRequest.getParameter("mstKeyPassword");

			byte [] byteArr=keyFile.getBytes();
			InputStream inputStream = new ByteArrayInputStream(byteArr);

			StringWriter writer = new StringWriter();
			IOUtils.copy(inputStream, writer, "UTF-8");
			String loadStr = writer.toString();
								
			EncryptSettingServiceCall essc = new EncryptSettingServiceCall();
			CommonServiceCall csc = new CommonServiceCall();
			
			System.out.println("loadStr = " + loadStr);
			
			encKey = essc.serverMasterKeyDecode(passwordStr, loadStr, loginId, entityId);
			result = csc.loadServerKey(restIp, restPort, strTocken, encKey, loginId, entityId);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}	
	
	
	@RequestMapping(value = "/keyDownload.do")
	public @ResponseBody void keyDownload(HttpServletRequest request, HttpServletResponse response) throws IOException {
		DateFormat df = new SimpleDateFormat("yyyyMMdd");
		Date today = Calendar.getInstance().getTime();
		String reportDate = df.format(today);
		
		String fileName = "experDB_MasterKey_"+reportDate+".emk";
		String masterKey = request.getParameter("mstKey").toString().replace("&quot;", "\"");
		
		String resCLient = request.getHeader("User-Agent");
		

		if (resCLient.indexOf("MSIE") != -1) {
			response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
		} else {
			// 한글 파일명 처리
			fileName = new String(fileName.getBytes("utf-8"), "iso-8859-1");

			response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
			response.setHeader("Content-Type", "application/octet-stream; charset=utf-8");

		}
			
		StringBuffer sb = new StringBuffer(masterKey);
		
		byte[] outputByte = new byte[4096];
		
		BufferedInputStream ins = new BufferedInputStream(new ByteArrayInputStream(sb.toString().getBytes("UTF-8")));
		
		BufferedOutputStream outs = new BufferedOutputStream(response.getOutputStream());
		
		int read =0;
		
		//copy binary contect to output stream
		while((read=ins.read(outputByte))  != -1){
			outs.write(outputByte,0,read);
		}

		outs.flush();
		outs.close();
		ins.close();
	}
	



	/**
	 * 서버 마스터키 암호 설정 저장
	 * 화면(pnlOldPasswordView == true && mstKeyUseChk == false)
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/securityMasterKeySave02.do")
	public @ResponseBody JSONObject securityMasterKeySave02(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) throws FileNotFoundException {
		
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		String restIp = loginVo.getRestIp();
		int restPort = loginVo.getRestPort();
		String strTocken = loginVo.getTockenValue();
		String loginId = loginVo.getUsr_id();
		String entityId = loginVo.getEctityUid();	
		
		JSONObject result = new JSONObject();
		try {		
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0121_01");
			historyVO.setMnu_id(35);
			accessHistoryService.insertHistory(historyVO);
						
			String encKey = request.getParameter("mstKeyPassword");						
			CommonServiceCall csc = new CommonServiceCall();		
			result = csc.loadServerKey(restIp, restPort, strTocken, encKey, loginId, entityId);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}	
	
	/**
	 * 서버 마스터키 암호 설정 저장
	 * 화면(pnlOldPasswordView == true &&  mstKeyRenewChk == true && pnlNewPasswordView == true)
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/securityMasterKeySave03.do")
	public @ResponseBody JSONObject securityMasterKeySave03(@ModelAttribute("historyVO") HistoryVO historyVO, MultipartHttpServletRequest multiRequest, HttpServletRequest request) throws FileNotFoundException {
		
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		String restIp = loginVo.getRestIp();
		int restPort = loginVo.getRestPort();
		String strTocken = loginVo.getTockenValue();
		String loginId = loginVo.getUsr_id();
		String entityId = loginVo.getEctityUid();
		
		String encKey = null;
		
		JSONObject result = new JSONObject();
		try {		
			
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0121_01");
			historyVO.setMnu_id(35);
			accessHistoryService.insertHistory(historyVO);
												
			String mstKeyPassword = multiRequest.getParameter("mstKeyPassword");		
			String mstKeyRenewPassword = multiRequest.getParameter("mstKeyRenewPassword");
			String chk = multiRequest.getParameter("chk");
			String useYN = multiRequest.getParameter("useYN");
			String initKey = multiRequest.getParameter("initKey");
			MultipartFile keyFile = multiRequest.getFile("keyFile");	
			
			if(chk.equals("true")){
				byte [] byteArr=keyFile.getBytes();
				InputStream inputStream = new ByteArrayInputStream(byteArr);

				StringWriter writer = new StringWriter();
				IOUtils.copy(inputStream, writer, "UTF-8");
				String loadStr = writer.toString();
									
				EncryptSettingServiceCall essc = new EncryptSettingServiceCall();
				mstKeyPassword = essc.serverMasterKeyDecode(mstKeyPassword, loadStr, loginId, entityId);	
			}
			
			//암호화 키파일 생성
			//System.out.println("키파일생성");
			EncryptSettingServiceCall essc = new EncryptSettingServiceCall();
			CommonServiceCall csc = new CommonServiceCall();
			//String masterKey = essc.encMasterkey(mstKeyRenewPassword, loginId, entityId);		
			//System.out.println(masterKey);
			
			//새로운 마스터키파일 사용
			if(useYN.equals("y")){
				
				System.out.println("키파일생성");
				String masterKey = essc.encMasterkey(mstKeyRenewPassword, loginId, entityId);		
				System.out.println(masterKey);
				
				System.out.println("새로운 마스터키파일 사용");
				System.out.println("키 복호화 시작 ");
				encKey = essc.serverMasterKeyDecode(mstKeyRenewPassword, masterKey, loginId, entityId);		
				System.out.println(mstKeyPassword);
				System.out.println(encKey);
				
				
				if(initKey.equals("true")){
					//서버 시작 후 초기 마스터키등록
					result = csc.loadServerKey(restIp, restPort, strTocken, encKey, loginId, entityId);
				}else{
					//기존 마스터키 변경
					result = essc.changeServerKey(restIp, restPort, strTocken,mstKeyPassword,encKey, loginId, entityId);
				}

				if(result.get("resultCode").equals("0000000000")){
					result.put("masterKey", masterKey);
					result.put("keyYN", "Y");
				}	
				
			//마스터키 파일 사용안함
			}else{
				System.out.println("마스터키사용안함");
				System.out.println(mstKeyPassword);
				if(initKey.equals("true")){
					result = csc.loadServerKey(restIp, restPort, strTocken, mstKeyRenewPassword, loginId, entityId);
				}else{
					result = essc.changeServerKey(restIp, restPort, strTocken,mstKeyPassword,mstKeyRenewPassword, loginId, entityId);
				}
				if(result.get("resultCode").equals("0000000000")){
					result.put("keyYN", "N");
				}	
			}
			
			/*if(result.get("resultCode").equals("0000000000")){
				result.put("masterKey", masterKey);
			}*/	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	
	/**
	 * Encrypt Agent 모니터링 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/securityAgentMonitoring.do")
	public ModelAndView securityAgentMonitoring(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request,HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001304");
			if (menuAut.get(0).get("read_aut_yn").equals("N")) {
				mv.setViewName("error/autError");
			} else {
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
				
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0118");
				historyVO.setMnu_id(36);
				accessHistoryService.insertHistory(historyVO);
												
				mv.setViewName("encrypt/setting/agentMonitoring");
			}
				
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	
	/**
	 * Encrypt Agent 모니터링 수정 팝업을 보여준다.
	 * 
	 * agentMonitoring modify View
	 * @param 
	 * @return ModelAndView
	 */
	@RequestMapping(value = "/popup/agentMonitoringModifyForm.do")
	public ModelAndView agentMonitoringModifyForm(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request)  {
		
		ModelAndView mv = new ModelAndView("jsonView");

		JSONArray result = new JSONArray();

		Map hp = new HashMap();
		List<String> key = new ArrayList<String>();
		List<String> value = new ArrayList<String>();
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001304");	
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
				
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0119");
				historyVO.setMnu_id(36);
				accessHistoryService.insertHistory(historyVO);
							
				String entityName = request.getParameter("entityName");
				String entityStatusCode = request.getParameter("entityStatusCode");
				String latestAddress = request.getParameter("latestAddress");
				String latestDateTime = request.getParameter("latestDateTime");
				String extendedField = request.getParameter("extendedField").toString().replaceAll("&quot;", "\"");
				String entityUid = request.getParameter("entityUid");

				System.out.println("확장팩 ="+ extendedField);
			
				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				String restIp = loginVo.getRestIp();
				int restPort = loginVo.getRestPort();
				String strTocken = loginVo.getTockenValue();
				String loginId = loginVo.getUsr_id();
				String entityId = loginVo.getEctityUid();
				
				EncryptSettingServiceCall essc = new EncryptSettingServiceCall();
				result = essc.selectParamSysCodeList( restIp, restPort, strTocken, loginId, entityId);
				
				mv.addObject("result",result);
				mv.addObject("entityUid",entityUid);
				mv.addObject("entityName",entityName);
				mv.addObject("entityStatusCode",entityStatusCode);
				mv.addObject("latestAddress",latestAddress);
				mv.addObject("latestDateTime",latestDateTime);
				//mv.addObject("resultKey",key);
				//mv.addObject("resultValue",value);
				mv.addObject("extendedField",extendedField);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;	
	}

	
	/**
	 * agentMonitoring조회
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectAgentMonitoring.do")
	public @ResponseBody JSONObject selectAgentMonitoring(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		JSONObject result = new JSONObject();
		
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		String restIp = loginVo.getRestIp();
		int restPort = loginVo.getRestPort();
		String strTocken = loginVo.getTockenValue();
		String loginId = loginVo.getUsr_id();
		String entityId = loginVo.getEctityUid();	
					
		EncryptSettingServiceCall essc = new EncryptSettingServiceCall();

		try {
			result = essc.selectAgentMonitoring(restIp, restPort, strTocken, loginId, entityId);
		} catch (Exception e) {
			result.put("resultCode", "8000000002");
		}
		return result;
	}
	
	
	
	/**
	 * agentMonitoring 상태 저장
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/agentStatusSave.do")
	public @ResponseBody JSONObject agentStatusSave(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletResponse response, HttpServletRequest request) {

		JSONObject result = new JSONObject();
		
		String entityName = request.getParameter("entityName");
		String entityUid = request.getParameter("entityUid");
		String entityStatusCode = request.getParameter("entityStatusCode");
		
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		String restIp = loginVo.getRestIp();
		int restPort = loginVo.getRestPort();
		String strTocken = loginVo.getTockenValue();
		String loginId = loginVo.getUsr_id();
		String entityId = loginVo.getEctityUid();
		
		try {	
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0119_01");
			historyVO.setMnu_id(36);
			accessHistoryService.insertHistory(historyVO);
						
			EncryptSettingServiceCall essc = new EncryptSettingServiceCall();
			try{
				result = essc.updateEntity(restIp, restPort, strTocken, loginId, entityId, entityName, entityUid, entityStatusCode);
			}catch(Exception e){
			result.put("resultCode", "8000000002");
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
}
