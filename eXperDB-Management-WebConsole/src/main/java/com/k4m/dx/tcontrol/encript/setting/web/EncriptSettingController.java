package com.k4m.dx.tcontrol.encript.setting.web;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.encript.service.call.EncriptSettingServiceCall;

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
	String strTocken = "uq1b/dgOIzpzH+EAD9UOl5Iz26soa1H+hdbmD38noqs=";

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
			mv.setViewName("encript/setting/securityPolicyOptionSet");
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
			
		EncriptSettingServiceCall essc = new EncriptSettingServiceCall();
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
			
		EncriptSettingServiceCall essc = new EncriptSettingServiceCall();
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
				
			EncriptSettingServiceCall essc = new EncriptSettingServiceCall();
			
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
			mv.setViewName("encript/setting/securitySet");
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
	@RequestMapping(value = "/selectEncriptSet.do")
	public @ResponseBody JSONArray selectEncriptSet(HttpServletRequest request) {
			
		EncriptSettingServiceCall essc = new EncriptSettingServiceCall();
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
	@RequestMapping(value = "/saveEncriptSet.do")
	public @ResponseBody JSONObject saveEncriptSet(HttpServletRequest request) {
		JSONObject result = new JSONObject();

		try {		
			JSONObject obj = new JSONObject();					
				
			EncriptSettingServiceCall essc = new EncriptSettingServiceCall();
			
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
	 * 서버키설정 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/serverKeySet.do")
	public ModelAndView serverKeySet(HttpServletRequest request, ModelMap model) {
		ModelAndView mv = new ModelAndView();
		try {		
			mv.setViewName("encript/setting/serverKeySet");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
}
