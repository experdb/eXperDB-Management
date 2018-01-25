package com.k4m.dx.tcontrol.cmmn.serviceproxy;

import java.util.HashMap;

import org.json.simple.JSONObject;

import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.ProfileVO;

public class PolicyService {
	
	protected String restIp = "";
	protected int restPort = 0;
	
	public PolicyService(String restIp, int restPort) {
		this.restIp = restIp;
		this.restPort = restPort;
	}
	
	private JSONObject sendPolicyService(String serviceName, String serviceCommand, HashMap header, String parameters) throws Exception {
		
		
		ExperDBRestApiHandler handler = new ExperDBRestApiHandler(restIp, restPort);

		JSONObject resultList = handler.getRestRequest(serviceName, serviceCommand, header, parameters);
		
		return resultList;
	}
	
	public static void main(String[] args) throws Exception {
		
		String ip = "222.110.153.204";
		//ip = "222.110.153.211";
		//ip = "localhost";
		int port = 9443;
		//port = 8443;
		PolicyService entityService = new PolicyService(ip, port);
		
		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, "admin");
		header.put(SystemCode.FieldName.ENTITY_UID, "00000000-0000-0000-0000-000000000001");
		header.put(SystemCode.FieldName.TOKEN_VALUE, "4tUgdSF9uc2Z6CRQ1F86nYBYkq1F6knfA5U8NEf7L6k=");
		
		
		/*
		ProfileVO vo = new ProfileVO();
		vo.setProfileTypeCode("PTPR");
		
		JSONObject parameters = new JSONObject();
		parameters.put("profile", vo);
		//parameters.put("config", config)
		
		
		entityService.selectProfileList(header, parameters);
		
		  		for (int i = 0; i < resultList.size(); i++) {
			JSONArray data = (JSONArray) resultList.get("list");
			for (int j = 0; j < data.size(); j++) {
				JSONObject jsonObj = (JSONObject) data.get(j);
				
				String createDateTime = (String) jsonObj.get("createDateTime");
				String profileTypeName = (String) jsonObj.get("profileTypeName");
				String profileTypeCode = (String) jsonObj.get("profileTypeCode");
				String profileStatusCode = (String) jsonObj.get("profileStatusCode");
				String profileNote = (String) jsonObj.get("profileNote");
				String profileStatusName = (String) jsonObj.get("profileStatusName");
				String createName = (String) jsonObj.get("createName");
				String createUid = (String) jsonObj.get("createUid");
				String profileName = (String) jsonObj.get("profileName");
				String profileUid = (String) jsonObj.get("profileUid");

			}
		}
		 */
		
		ProfileVO vo1 = new ProfileVO();
		vo1.setProfileUid("045c13fb-9915-47b3-936d-c6116d91ed24");
		
		
		JSONObject parameters1 = new JSONObject();
		parameters1.put("ProfileProtection", vo1);
		
		//entityService.selectProfileProtectionContents();
	}

}
