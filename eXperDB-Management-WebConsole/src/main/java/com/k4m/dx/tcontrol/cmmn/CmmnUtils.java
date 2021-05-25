package com.k4m.dx.tcontrol.cmmn;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.k4m.dx.tcontrol.admin.dbauthority.service.DbAuthorityService;
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityService;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.login.service.LoginVO;

/**
* @author 박태혁
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2018.04.23   박태혁 최초 생성
*      </pre>
*/

public class CmmnUtils {
		
	
	//private ConfigurableApplicationContext context;
	
	public static boolean saveHistory(HttpServletRequest request,@ModelAttribute("historyVO") HistoryVO historyVO) {
		HttpSession session = request.getSession();
		if(session==null){
			return false;
		}else{
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String usr_id = loginVo.getUsr_id();
			String ip = loginVo.getIp();
			historyVO.setUsr_id(usr_id);
			historyVO.setLgi_ipadr(ip);
			return true;
		}
	}
	
	public static boolean saveHistoryLogin(LoginVO loginVo, String login_chk, String id, HttpServletRequest request,@ModelAttribute("historyVO") HistoryVO historyVO) {
		HttpSession session = request.getSession(true);

		if(session==null){
			return false;
		}else{
			session.setAttribute("session", loginVo);

			// 사용자의 로그인 유지 여부를 null 체크로 확인 
			if (login_chk != null) { // 체크한 경우
				if ("Y".equals(login_chk)) {
					session.setAttribute("loginChkId", id);
				}
			}
			
			LoginVO loginVoNew = (LoginVO) session.getAttribute("session");
			String usr_id = loginVoNew.getUsr_id();
			String ip = loginVoNew.getIp();
			historyVO.setUsr_id(usr_id);
			historyVO.setLgi_ipadr(ip);
			return true;
		}
	}
	
	//메뉴권한 조회
	public List<Map<String, Object>> selectMenuAut(MenuAuthorityService menuAuthorityService, String mnu_cd) {
		
		List<Map<String, Object>> result = null;
		
		try{
			ServletRequestAttributes sra = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
			HttpServletRequest request = sra.getRequest();
			
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String usr_id = loginVo.getUsr_id();
			
			Map<String,Object> param = new HashMap<String, Object>();
			param.put("usr_id", usr_id);
			param.put("mnu_cd", mnu_cd);
			
			result = menuAuthorityService.selectMenuAut(param);
					
		}catch(Exception e){
			e.printStackTrace();
		}		
		return result;
	}
	
	
	
	//디비권한 조회
	public List<Map<String, Object>> selectUserDBAutList(DbAuthorityService dbAuthorityService) {		
		
		List<Map<String, Object>> result = null;		
		
		try{
			ServletRequestAttributes sra = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
			HttpServletRequest request = sra.getRequest();
			
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String usr_id = loginVo.getUsr_id();
			
			result = dbAuthorityService.selectUsrDBAutInfo(usr_id);		
		}catch(Exception e){
			e.printStackTrace();
		}		
		return result;
	}
	
	
	//유저디비서버권한 조회
	public List<Map<String, Object>> selectUserDBSvrAutList(DbAuthorityService dbAuthorityService,int db_svr_id) {		
		
		List<Map<String, Object>> result = null;		
		
		try{
			ServletRequestAttributes sra = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
			HttpServletRequest request = sra.getRequest();
			
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String usr_id = loginVo.getUsr_id();
			
			HashMap<String, Object> param = new HashMap<String, Object>();
			param.put("usr_id", usr_id);
			param.put("db_svr_id",db_svr_id);
			
			result = dbAuthorityService.selectUserDBSvrAutList(param);		
		}catch(Exception e){
			e.printStackTrace();
		}		
		return result;
	}
	
	
	// 단건 
	public static Map<String, Object> getParam(Map<String, String> reqJson) {
		
		JSONObject jsonObj = null;
		Map<String, Object> map = new HashMap<String, Object>();
		
		try {
			
			jsonObj = (JSONObject) new JSONParser().parse(reqJson.get("_JSON"));
			
			Iterator<?> keysItr =jsonObj.keySet().iterator();
			while (keysItr.hasNext()) {
				String key = (String) keysItr.next();
				Object value = jsonObj.get(key);
				
				map.put(key, value);
			}
			
		} catch (ParseException e) {
			e.printStackTrace();
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		
		return map;
	}
	
	// 다건
	@SuppressWarnings("rawtypes")
	public static List getParams(Map<String, String> reqJson) {
		
		JSONArray jsonObj;
		List<Object> list = new ArrayList<Object>();
		
		try {
			
			jsonObj = (JSONArray) new JSONParser().parse(reqJson.get("_JSON"));
			
			for (int i = 0; i < jsonObj.size(); i++) {
				JSONObject value = (JSONObject) jsonObj.get(i);
				CmmnUtils.toMap(value);
				
				list.add(value);
			}
			
		} catch (ParseException e) {
			e.printStackTrace();
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		
        return list;
    }
   
	@SuppressWarnings("rawtypes")
    private static Map toMap(JSONObject json) {
		Map<String, Object> map = new HashMap<String, Object>();

        @SuppressWarnings("unchecked")
        Set<String> keySet = json.keySet();
	    for(String key : keySet) {
	        Object value = json.get(key);
	        map.put(key, value);
	    }
	    
		return map;
	}
	
	
	/**
	 * 파일크기 추출
	 * @param filesize
	 * @param type
	 * @return
	 */
	public static String getFileSize(long filesize, int Cutlength) {
		String size = "";

		if (filesize < 1024)
			size = filesize + " Byte";
		else if (filesize > 1024 && filesize < (1024 * 1024)) {
			double longtemp = filesize / (double) 1024;
			int len = Double.toString(longtemp).indexOf(".");
			size = Double.toString(longtemp).substring(0, len + Cutlength) + " Kb";
		} else if (filesize > (1024 * 1024)) {
			double longtemp = filesize / ((double) 1024 * 1024);
			int len = Double.toString(longtemp).indexOf(".");
			size = Double.toString(longtemp).substring(0, len + Cutlength) + " Mb";
		}
		return size;
	}
	/**
	 * Object null 처리
	 * @param Object
	 * @return
	 */
	public String getStringWithoutNull(Object obj){
		if(obj == null){
			return "";
		}else{
			return obj.toString();
		}
	}
}
