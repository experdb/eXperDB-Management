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
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.AutowireCapableBeanFactory;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.k4m.dx.tcontrol.admin.dbauthority.service.DbAuthorityService;
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityService;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleService;

public class CmmnUtils {
		
	
	//private ConfigurableApplicationContext context;
	
	public static void saveHistory(HttpServletRequest request,@ModelAttribute("historyVO") HistoryVO historyVO) {
		HttpSession session = request.getSession();
		String usr_id = (String) session.getAttribute("usr_id");
		String ip = (String) session.getAttribute("ip");
		historyVO.setUsr_id(usr_id);
		historyVO.setLgi_ipadr(ip);
	}
	
	//메뉴권한 조회
	public List<Map<String, Object>> selectMenuAut(MenuAuthorityService menuAuthorityService, String mnu_id) {
		
		List<Map<String, Object>> result = null;
		
		/*String xml[] = {
				"egovframework/spring/context-aspect.xml",
				"egovframework/spring/context-common.xml",
				"egovframework/spring/context-datasource.xml",
				"egovframework/spring/context-mapper.xml",
				"egovframework/spring/context-properties.xml",
				"egovframework/spring/context-transaction.xml"};
		
		context = new ClassPathXmlApplicationContext(xml);
		context.getAutowireCapableBeanFactory().autowireBeanProperties(this,
				AutowireCapableBeanFactory.AUTOWIRE_BY_TYPE, false);
		
		MenuAuthorityService menuAuthorityService = (MenuAuthorityService) context.getBean("menuAuthorityService");	*/	
		
		try{
			ServletRequestAttributes sra = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
			HttpServletRequest request = sra.getRequest();
			
			HttpSession session = request.getSession();
			String usr_id = (String) session.getAttribute("usr_id");
			
			Map<String,Object> param = new HashMap<String, Object>();
			param.put("usr_id", usr_id);
			param.put("mnu_id", mnu_id);
			
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
			String usr_id = (String) session.getAttribute("usr_id");
			
			result = dbAuthorityService.selectUsrDBAutInfo(usr_id);		
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
}
