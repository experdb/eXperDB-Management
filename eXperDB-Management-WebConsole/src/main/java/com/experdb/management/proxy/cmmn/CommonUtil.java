package com.experdb.management.proxy.cmmn;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;

/**
* @author 김민정
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2021.02.24  	 김민정 최초 생성
*      </pre>
*/
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
	
	public static JSONObject toJSONObject(Object target){
		
		JSONObject result = null;
		
		try{
			result = new JSONObject();
			Object obj = target;
			for(Field field : obj.getClass().getDeclaredFields()){
				field.setAccessible(true);
				Object value = field.get(obj);
				result.put(field.getName(), value);
			}
		}catch(Exception e){
			System.out.println("toJSONObject error"+e.toString());
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
	
	/**
	 * 0 체크
	 * 
	 * @param JSONObject jobj, String key
	 * @return boolean
	 * @throws 
	 */
	public static boolean zeroCheckOfJsonObj(JSONObject jobj, String key){
		if(jobj.get(key) == null || Integer.parseInt(jobj.get(key).toString()) == 0 ){
			return true;
		}else{
			return false;
		}
	}
	
	/**
	 * null 체크
	 * 
	 * @param JSONObject jobj, String key
	 * @return boolean
	 * @throws 
	 */
	public static boolean nullCheckOfJsonObj(JSONObject jobj, String key){
		if(jobj.get(key) == null || "".equals(jobj.get(key))){
			return true;
		}else{
			return false;
		}
	}
	
	/**
	 * int 형변환 / null 처리
	 * 
	 * @param JSONObject jobj, String key
	 * @return integer
	 * @throws 
	 */
	public static int getIntOfJsonObj(JSONObject jobj, String key){
		if(jobj.get(key) == null){
			return 0;
		}else{
			return Integer.parseInt(jobj.get(key).toString());
		}
	}
	
	/**
	 * string 형변환
	 * 
	 * @param JSONObject jobj, String key
	 * @return String
	 * @throws 
	 */
	public static String getStringOfJsonObj(JSONObject jobj, String key){
		return String.valueOf(jobj.get(key));
	}
}