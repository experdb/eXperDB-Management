package com.k4m.dx.tcontrol.encrypt.service.call;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.google.gson.Gson;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.EncryptCommonService;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.SystemCode;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.TypeUtility;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.AdminServerPasswordRequest;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.SysCode;

public class CommonServiceCall {
	/**
	 * 적용알고리즘 공통코드 조회
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @return 
	 * @throws Exception
	 */
	public JSONArray selectSysCodeListExper(String restIp, int restPort, String strTocken) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);
		
		JSONArray jsonArray = new JSONArray();
		
		String strService = SystemCode.ServiceName.SYSTEM_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTCIPHERSYSCODELIST;

		SysCode param = new SysCode();
		//param.setCategoryKey(categoryKey);

		HashMap body = new HashMap();
		//body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());

		String parameters = TypeUtility.makeRequestBody(body);
		

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, "admin");
		header.put(SystemCode.FieldName.ENTITY_UID, "00000000-0000-0000-0000-000000000001");
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);

		JSONObject resultJson = api.callService(strService, strCommand, header, parameters.toString());
		
		Iterator<?> iter = resultJson.entrySet().iterator();
		while (iter.hasNext()) {
			Map.Entry entry = (Map.Entry) iter.next();

			System.out.println(String.valueOf(entry.getKey()) + " = " + String.valueOf(entry.getValue()));
		}
			
		String resultCode = (String) resultJson.get("resultCode");
		String resultMessage = (String) resultJson.get("resultMessage");
		long totalListCount = (long) resultJson.get("totalListCount");
			
		if(resultCode.equals("0000000000")) {
			ArrayList list = (ArrayList) resultJson.get("list");
			
			if(totalListCount > 0) {
				for(int i=0; i<list.size(); i++) {
					JSONObject data = (JSONObject) list.get(i);
					
					SysCode sysCode = new SysCode();
					Gson gson = new Gson();
					sysCode = gson.fromJson(data.toJSONString(), sysCode.getClass());
					
					JSONObject jsonObj = new JSONObject();
					
					jsonObj.put("sysCode", sysCode.getSysCode());
					jsonObj.put("sysCodeName", sysCode.getSysCodeName());
					jsonObj.put("SysCodeValue", sysCode.getSysCodeValue());
					
					//System.out.println("syscode : " + sysCode.getSysCode());
					//System.out.println("SysCodeName : " + sysCode.getSysCodeName());
					//System.out.println("SysCodeValue : " + sysCode.getSysCodeValue());	
					
					jsonArray.add(jsonObj);
				}	
			}
		}
		return jsonArray;
	}

	
	/**
	 * 서버상태 조회
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @return 
	 * @throws Exception
	 */
	public JSONObject selectServerStatus(String restIp, int restPort, String strTocken) throws Exception {
		
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.SYSTEM_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTSERVERSTATUS;
		
		String oldPassword = "password";

		AdminServerPasswordRequest adminServerPasswordRequest = new AdminServerPasswordRequest();


		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(adminServerPasswordRequest.getClass()), adminServerPasswordRequest.toJSONString());

		String parameters = TypeUtility.makeRequestBody(body);

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, "admin");
		header.put(SystemCode.FieldName.ENTITY_UID, "00000000-0000-0000-0000-000000000001");
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);

		JSONObject resultJson = api.callService(strService, strCommand, header, parameters);
		

		String resultCode = (String) resultJson.get("resultCode");
		String resultMessage = (String) resultJson.get("resultMessage");
		resultMessage = new String(resultMessage.getBytes("iso-8859-1"),"UTF-8"); 
		
		JSONObject result = (JSONObject) resultJson.get("object");

		JSONObject jsonObj = new JSONObject();
		
		boolean isServerKeyEmpty = (boolean) result.get("isServerKeyEmpty");
		boolean isServerPasswordEmpty = (boolean) result.get("isServerPasswordEmpty");
		
		jsonObj.put("isServerKeyEmpty", isServerKeyEmpty);
		jsonObj.put("isServerPasswordEmpty", isServerPasswordEmpty);
		
		
		
		System.out.println("resultCode : " + resultCode + " resultMessage : " + resultMessage);
		System.out.println("isServerKeyEmpty : " + isServerKeyEmpty + " isServerPasswordEmpty : " + isServerPasswordEmpty);
		
		if(resultCode.equals(SystemCode.ResultCode.SUCCESS)) {

		} else {
			
		}
		return jsonObj;
	}

	
	/**
	 * 마스터키 로드
	 * @param encKey 
	 * @param strTocken 
	 * @param restPort 
	 * @param restIp 
	 * @return 
	 * @throws Exception
	 */
	public JSONObject loadServerKey(String restIp, int restPort, String strTocken, String encKey) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.SYSTEM_SERVICE;
		String strCommand = SystemCode.ServiceCommand.LOADSERVERKEY;
		
		String oldPassword = encKey;

		AdminServerPasswordRequest adminServerPasswordRequest = new AdminServerPasswordRequest();
		adminServerPasswordRequest.setOldPassword(oldPassword);

		//JSONObject parameters = new JSONObject();
		//parameters.put("profile", vo);
		
		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(adminServerPasswordRequest.getClass()), adminServerPasswordRequest.toJSONString());

		String parameters = TypeUtility.makeRequestBody(body);

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, "admin");
		header.put(SystemCode.FieldName.ENTITY_UID, "00000000-0000-0000-0000-000000000001");
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);

		JSONObject resultJson = api.callService(strService, strCommand, header, parameters);
		

		String resultCode = (String) resultJson.get("resultCode");
		String resultMessage = (String) resultJson.get("resultMessage");
		resultMessage = new String(resultMessage.getBytes("iso-8859-1"),"UTF-8"); 
		
		System.out.println("resultCode : " + resultCode + " resultMessage : " + resultMessage);
		
		if(resultCode.equals(SystemCode.ResultCode.SUCCESS)) {
				return resultJson;
		} else {
			
		}
		return resultJson;
	}	
	
}
