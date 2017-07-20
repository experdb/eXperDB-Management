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

import com.k4m.dx.tcontrol.common.service.HistoryVO;

public class CmmnUtils {
	
	public static void saveHistory(HttpServletRequest request,@ModelAttribute("historyVO") HistoryVO historyVO) {
		HttpSession session = request.getSession();
		String usr_id = (String) session.getAttribute("usr_id");
		String ip = (String) session.getAttribute("ip");
		historyVO.setUsr_id(usr_id);
		historyVO.setLgi_ipadr(ip);
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
