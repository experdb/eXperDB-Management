package com.k4m.dx.tcontrol.encrypt.setting.web;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.encrypt.service.call.CommonServiceCall;
import com.k4m.dx.tcontrol.encrypt.service.call.EncryptSettingServiceCall;

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
	
	String restIp = "127.0.0.1";
	int restPort = 8443;
	String strTocken = "msJQLg2XY2zdDJksz5HZKga/ZW7QVekKiymoPlPnWNg=";

	/**
	 * Encript 보안정책 옵션 설정 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/securityPolicyOptionSet.do")
	public ModelAndView encriptAgentMonitoring(HttpServletRequest request, ModelMap model) {
		ModelAndView mv = new ModelAndView();
		try {		
			mv.setViewName("encrypt/setting/securityPolicyOptionSet");
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
	public @ResponseBody JSONArray selectCryptoKeyList(HttpServletRequest request) {
			
		EncryptSettingServiceCall essc = new EncryptSettingServiceCall();
		JSONArray result = new JSONArray();
		try {
			result = essc.selectSysConfigListLike(restIp, restPort, strTocken);
		} catch (Exception e) {
			e.printStackTrace();
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
	public @ResponseBody JSONArray selectSysMultiValueConfigListLike(HttpServletRequest request) {
			
		EncryptSettingServiceCall essc = new EncryptSettingServiceCall();
		JSONArray result = new JSONArray();
		try {
			result = essc.selectSysMultiValueConfigListLike(restIp, restPort, strTocken);
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
	public @ResponseBody JSONObject sysConfigSave(HttpServletRequest request) {
		JSONObject result01 = new JSONObject();
		JSONObject result02 = new JSONObject();
		
		try {		
			JSONObject obj01 = new JSONObject();					
			JSONObject obj02 = new JSONObject();	
				
			EncryptSettingServiceCall essc = new EncryptSettingServiceCall();
			
			//옵션설정저장1
			String strRows01 = request.getParameter("arrmaps01").toString().replaceAll("&quot;", "\"");
			System.out.println(strRows01);
			JSONArray rows01 = (JSONArray) new JSONParser().parse(strRows01);
			for (int i = 0; i < rows01.size(); i++) {
				obj01 = (JSONObject) rows01.get(i);		
			}	
			result01 = essc.updateSysConfigList(restIp, restPort, strTocken, obj01);
					
			//옵션설정저장 1 성공!!
			if(result01.get("resultCode").equals("0000000000")){
				//옵션설정저장2
				String strRows02 = request.getParameter("arrmaps02").toString().replaceAll("&quot;", "\"");
				System.out.println(strRows02);
				JSONArray rows02 = (JSONArray) new JSONParser().parse(strRows02);
				for (int i = 0; i < rows02.size(); i++) {
					obj02 = (JSONObject) rows02.get(i);		
				}	
				
				JSONArray rows03 = (JSONArray) new JSONParser().parse(request.getParameter("dayWeek"));	
				result02 = essc.updateSysMultiValueConfigList(restIp, restPort, strTocken, obj02, rows03);
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
	public ModelAndView securitySet(HttpServletRequest request, ModelMap model) {
		ModelAndView mv = new ModelAndView();
		try {
			mv.setViewName("encrypt/setting/securitySet");
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
	public @ResponseBody JSONArray selectEncryptSet(HttpServletRequest request) {
			
		EncryptSettingServiceCall essc = new EncryptSettingServiceCall();
		JSONArray result = new JSONArray();
		try {
			result = essc.selectSysMultiValueConfigListLike2(restIp, restPort, strTocken);
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
	@RequestMapping(value = "/saveEncryptSet.do")
	public @ResponseBody JSONObject saveEncryptSet(HttpServletRequest request) {
		JSONObject result = new JSONObject();

		try {		
			JSONObject obj = new JSONObject();					
				
			EncryptSettingServiceCall essc = new EncryptSettingServiceCall();
			
			String strRows = request.getParameter("arrmaps").toString().replaceAll("&quot;", "\"");
			System.out.println(strRows);
			JSONArray rows = (JSONArray) new JSONParser().parse(strRows);
			for (int i = 0; i < rows.size(); i++) {
				obj = (JSONObject) rows.get(i);		
			}	
			result = essc.updateSysMultiValueConfigList2(restIp, restPort, strTocken, obj);
						
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
	public ModelAndView securityKeySet(HttpServletRequest request, ModelMap model) {
		ModelAndView mv = new ModelAndView();
		JSONObject result = new JSONObject();
		
		try {		
			CommonServiceCall csc = new CommonServiceCall();
			
			result = csc.selectServerStatus(restIp, restPort, strTocken);
			
			String isServerKeyEmpty = result.get("isServerKeyEmpty").toString();
			String isServerPasswordEmpty = result.get("isServerPasswordEmpty").toString();
			
			mv.addObject("isServerKeyEmpty",isServerKeyEmpty);
			mv.addObject("isServerPasswordEmpty",isServerPasswordEmpty);
			mv.setViewName("encrypt/setting/securityKeySet");
			
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
	public @ResponseBody JSONObject securityMasterKeySave01(MultipartHttpServletRequest multiRequest) throws FileNotFoundException {
		JSONObject result = new JSONObject();
		String encKey = null;
		try {		
			String filePath = multiRequest.getParameter("mstKeyPth");
			String passwordStr = multiRequest.getParameter("mstKeyPassword");

			System.out.println(filePath);
			System.out.println(passwordStr);
			
			File file = new File(filePath.replaceAll("\\\\", "\\\\\\\\"));
			
			FileReader filereader = new FileReader(file);
			BufferedReader bufReader = new BufferedReader(filereader);
			String fileRead = "";
			String loadStr ="";
			
			while((fileRead = bufReader.readLine()) != null){		
				loadStr = fileRead;
			}
			bufReader.close();
								
			EncryptSettingServiceCall essc = new EncryptSettingServiceCall();
			CommonServiceCall csc = new CommonServiceCall();
			
			System.out.println("loadStr = " + loadStr);
			
			encKey = essc.serverMasterKeyDecode(passwordStr, loadStr);
			result = csc.loadServerKey(restIp, restPort, strTocken, encKey);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}	
	
	
	/**
	 * 서버 마스터키 암호 설정 저장
	 * 화면(pnlOldPasswordView == true && mstKeyUseChk == false)
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/securityMasterKeySave02.do")
	public @ResponseBody JSONObject securityMasterKeySave02(HttpServletRequest request) throws FileNotFoundException {
		JSONObject result = new JSONObject();
		try {		
			String encKey = request.getParameter("mstKeyPassword");						
			CommonServiceCall csc = new CommonServiceCall();		
			csc.loadServerKey(restIp, restPort, strTocken, encKey);
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
	@RequestMapping(value = "/securityMasterKeySave03.do")
	public @ResponseBody JSONObject securityMasterKeySave03(HttpServletRequest request) throws FileNotFoundException {
		String encKey = null;
		
		JSONObject result = new JSONObject();
		try {		
			String mstKeyPassword = request.getParameter("mstKeyPassword");		
			String mstKeyRenewPassword = request.getParameter("mstKeyRenewPassword");
			String chk = request.getParameter("chk");
			String useYN = request.getParameter("useYN");
			String filePath = request.getParameter("mstKeyPth");
			
			if(chk.equals("true")){
				System.out.println("체크true");
				System.out.println(filePath);
				File file = new File(filePath.replaceAll("\\\\", "\\\\\\\\"));
				
				FileReader filereader = new FileReader(file);
				BufferedReader bufReader = new BufferedReader(filereader);
				String fileRead = "";
				String loadStr ="";
				
				while((fileRead = bufReader.readLine()) != null){		
					loadStr = fileRead;
				}
				bufReader.close();
									
				EncryptSettingServiceCall essc = new EncryptSettingServiceCall();
				CommonServiceCall csc = new CommonServiceCall();
				mstKeyPassword = essc.serverMasterKeyDecode(mstKeyPassword, loadStr);	
			}
			
			//암호화 키파일 생성
			System.out.println("키파일생성");
			EncryptSettingServiceCall essc = new EncryptSettingServiceCall();
			String masterKey = essc.encMasterkey(mstKeyRenewPassword);		
			System.out.println(masterKey);
			
			//새로운 마스터키파일 사용
			if(useYN.equals("y")){
				System.out.println("새로운 마스터키파일 사용");
				System.out.println("키 복호화 시작 ");
				encKey = essc.serverMasterKeyDecode(mstKeyRenewPassword, masterKey);		
				System.out.println(mstKeyPassword);
				System.out.println(encKey);
				result = essc.changeServerKey(restIp, restPort, strTocken,mstKeyPassword,encKey);
			//마스터키 파일 사용안함
			}else{
				System.out.println("마스터키사용안함");
				System.out.println(mstKeyPassword);
				System.out.println(encKey);
				result = essc.changeServerKey(restIp, restPort, strTocken,mstKeyPassword,mstKeyRenewPassword);
			}
		
			System.out.println("결과");
			System.out.println(result.get("resultCode"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}


}
