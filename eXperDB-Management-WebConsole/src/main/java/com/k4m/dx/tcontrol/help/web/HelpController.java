package com.k4m.dx.tcontrol.help.web;

import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.ResourceUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.encrypt.service.call.AgentMonitoringServiceCall;
import com.k4m.dx.tcontrol.login.service.LoginVO;

/**
 * Help 컨트롤러 클래스를 정의한다.
 *
 * @author 김주영
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.08.18   김주영 최초 생성
 *      </pre>
 */

@Controller
public class HelpController {
	
	@Autowired
	private AccessHistoryService accessHistoryService;
	
	
	/**
	 * About Tcontrol 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/aboutExperdb.do")
	public ModelAndView aboutTcontrol(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0054");
			accessHistoryService.insertHistory(historyVO);
			
			mv.setViewName("help/aboutExperdb");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	@RequestMapping(value = "/encryptLicenseInfo.do")
	public @ResponseBody JSONObject getEncryptLicenseInfo(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request){
		JSONObject result = new JSONObject();
		JSONArray list = new JSONArray();
		List<Map<String, Object>> listResult = null;
		String license = null;
		
		try {
			HttpSession session = request.getSession();
			
			Properties props = new Properties();
			props.load(new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));			
			//props.load(new FileInputStream(ResourceUtils.getFile("C:\\Users\\yeeun\\git\\eXperDB-Management_2\\eXperDB-Management-WebConsole\\src\\main\\resources\\egovframework\\tcontrolProps\\globals.properties")));			
			String encrypt = props.get("encrypt.useyn").toString();
			
			if(encrypt.equals("Y")||encrypt.equals("y")){				
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				String restIp = loginVo.getRestIp();
				int restPort = loginVo.getRestPort();
				String strTocken = loginVo.getTockenValue();
				String loginId = loginVo.getUsr_id();
				String entityId = loginVo.getEctityUid();
				
				AgentMonitoringServiceCall amsc = new AgentMonitoringServiceCall();	
				list = amsc.selectSystemStatus(restIp, restPort, strTocken, loginId, entityId);
				listResult = (List<Map<String, Object>>) list;
				
				for(int i=0; i<listResult.size(); i++){
					if(listResult.get(i).get("status").equals("licenseCheck")){
						license = listResult.get(i).get("logMessage").toString();
						System.out.println(license);
						break;
					}
				}
				
				result.put("resultCode", 0);
				result.put("license", license);
			}else{
				result.put("resultCode", 1);
				
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}


}
