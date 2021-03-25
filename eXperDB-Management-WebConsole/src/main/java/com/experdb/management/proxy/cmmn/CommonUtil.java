package com.experdb.management.proxy.cmmn;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class CommonUtil {


	public static Map<String, Object> toMap(Object target){
		
		Map<String, Object> result = null;
		
		try{
			result = new HashMap<String, Object>();
			Object obj = target;
			for(Field field : obj.getClass().getDeclaredFields()){
				field.setAccessible(true);
				Object value = field.get(obj);
				result.put(field.getName(), value);
			}
		}catch(Exception e){
			e.printStackTrace();	
		}
		return result;
	}
	
	public static void printRequestParam(String start, String end, HttpServletRequest request){
		
		System.out.println(start);
		Set<String> keySet = request.getParameterMap().keySet();
		for(String key : keySet){
			System.out.println(key+": "+request.getParameter(key));
		}
		System.out.println(end);
	}

	public static int getJsonObjIntVal(Object obj){
		return Integer.parseInt(String.valueOf(obj));
	}
	
	public static String getJsonObjString(Object obj){
		return String.valueOf(obj);
	}

}

