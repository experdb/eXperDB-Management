package com.k4m.dx.tcontrol.cmmn.serviceproxy;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

public class AuthService {
	
	protected String restIp = "";
	protected int restPort = 0;
	
	public AuthService(String restIp, int restPort) {
		this.restIp = restIp;
		this.restPort = restPort;
	}
	
	
	private JSONObject sendAuthService(String serviceName, String serviceCommand, HashMap header, JSONObject parameters) throws Exception {
		
		
		ExperDBRestApiHandler handler = new ExperDBRestApiHandler(restIp, restPort);

		JSONObject resultList = handler.getRestRequest(serviceName, serviceCommand, header, parameters);
		
		return resultList;
	}
	
	public static void main(String[] args) throws Exception {
		
		String ip = "222.110.153.204";
		int port = 9443;
		
		AuthService authService = new AuthService(ip, port);
		authService.loginTest();
	}
	
	private void loginTest() throws Exception {
		
		AuthService api = new AuthService(restIp, restPort);

		
		String strService = "authService";
		String strCommand = "login";
		
		JSONObject parameters = new JSONObject();
		//parameters.put("name", strName);
		//parameters.put("config", config)

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, "admin");
		header.put(SystemCode.FieldName.ENTITY_UID, "00000000-0000-0000-0000-000000000001");
		header.put(SystemCode.FieldName.PASSWORD, "password");
		header.put(SystemCode.FieldName.TOKEN_VALUE, "kL0hQcOPxh0ND+VXdFjHqzudLe9dZoU+aLBJ5ldqZfo=");
		header.put(SystemCode.FieldName.ADDRESS, "");
		
		api.login(strService, strCommand, header, parameters);
	}
	
	/**
	 * /authService/login
	 * input :
	 * 
	 * 
	 * output :
	 * resultUid = null
	 * resultCode = 0000000000
	 * resultMessage = SUCCESS
	 * 
	 * @throws Exception
	 */
	private Map<String, Object> login(String strService, String strCommand, HashMap header, JSONObject parameters) throws Exception {
		
		Map<String, Object> resultJsonObjectMap = null;
		

		ExperDBRestApiHandler api = new ExperDBRestApiHandler(restIp, restPort);

		resultJsonObjectMap = api.getRestRequest(strService, strCommand, header, parameters);
		
		JSONParser jsonParser = new JSONParser();
		
		Iterator<?> iter = resultJsonObjectMap.entrySet().iterator();
		while (iter.hasNext()) {
			Map.Entry entry = (Map.Entry) iter.next();

			System.out.println(String.valueOf(entry.getKey()) + " = " + String.valueOf(entry.getValue()));
		}
		
		
		return resultJsonObjectMap;

	}
}
