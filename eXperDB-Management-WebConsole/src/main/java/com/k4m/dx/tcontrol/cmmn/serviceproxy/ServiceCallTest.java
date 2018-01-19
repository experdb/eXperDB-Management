package com.k4m.dx.tcontrol.cmmn.serviceproxy;

import java.util.HashMap;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;

public class ServiceCallTest {

	public static void main(String[] args) throws Exception {
		
		String ip = "222.110.153.204";
		int port = 9443;
		
		ServiceCallTest test = new ServiceCallTest();

		test.loginTest(ip, port);
	}
	
	private void loginTest(String restIp, int restPort) throws Exception {
		
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		
		String strService = SystemCode.ServiceName.AUTH_SERVICE;
		String strCommand = SystemCode.ServiceCommand.LOGIN;
		
		JSONObject parameters = new JSONObject();
		//parameters.put("name", strName);
		//parameters.put("config", config)

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, "admin");
		header.put(SystemCode.FieldName.PASSWORD, "password");

		
		JSONObject configJsonObjectMap = null;
		ResponseEntity<String> loginEntity = api.callLoginService(strService, strCommand, header, parameters);
		
		if (loginEntity != null && loginEntity.getStatusCode().value() == 200) {
			
			//header setting 
			HttpHeaders headers = loginEntity.getHeaders();
			
			String ectityUid = headers.getFirst(SystemCode.FieldName.ENTITY_UID);
			String tockenValue = headers.getFirst(SystemCode.FieldName.TOKEN_VALUE);
			
			System.out.println("ectityUid : " + ectityUid + " tockenValue : " + tockenValue);
			
			String jsonString = loginEntity.getBody();
			
			JSONParser jsonParser = new JSONParser();

			configJsonObjectMap = (JSONObject) jsonParser.parse(jsonString);
			
			String resultCode = (String) configJsonObjectMap.get("resultCode");
			String resultMessage = (String) configJsonObjectMap.get("resultMessage");
			
			System.out.println("resultCode : " + resultCode + " resultMessage : " + resultMessage);
			
		}
	}
}
