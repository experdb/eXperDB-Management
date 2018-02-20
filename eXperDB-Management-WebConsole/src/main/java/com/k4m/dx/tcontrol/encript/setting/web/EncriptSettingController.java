package com.k4m.dx.tcontrol.encript.setting.web;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.encript.service.call.EncriptSettingServiceCall;
import com.k4m.dx.tcontrol.encript.service.call.KeyManageServiceCall;

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
}
