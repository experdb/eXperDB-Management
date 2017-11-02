package com.k4m.dx.tcontrol.cmmn.serviceproxy;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.ProfileVO;

public class PolicyService {
	
	protected String restIp = "";
	protected int restPort = 0;
	
	public PolicyService(String restIp, int restPort) {
		this.restIp = restIp;
		this.restPort = restPort;
	}
	
	public static void main(String[] args) throws Exception {
		
		String ip = "222.110.153.204";
		int port = 9443;
		
		PolicyService entityService = new PolicyService(ip, port);
		entityService.selectProfileListTest();
	}
	
	private void selectProfileListTest() throws Exception {
		
		PolicyService api = new PolicyService(restIp, restPort);

		
		String strService = "policyService";
		String strCommand = "selectProfileList";
		
		ProfileVO vo = new ProfileVO();
		vo.setProfileTypeCode("PTPR");
		
		JSONObject parameters = new JSONObject();
		parameters.put("profile", vo);
		//parameters.put("config", config)

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, "admin");
		header.put(SystemCode.FieldName.ENTITY_UID, "00000000-0000-0000-0000-000000000001");
		header.put(SystemCode.FieldName.PASSWORD, "password");
		header.put(SystemCode.FieldName.TOKEN_VALUE, "13HhTVDF0R7KoD2+ScNnAHM2HrAhtIk8sAZzYtvAOKI=");
		header.put(SystemCode.FieldName.ADDRESS, "");
		
		JSONObject resultList = api.selectProfileList(strService, strCommand, header, parameters);
		
		String resultCode = resultList.get("resultCode").toString();
		String totalListCount = resultList.get("totalListCount").toString();
		String resultUid = resultList.get("resultUid").toString();
		String resultMessage = resultList.get("resultMessage").toString();

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
	}
	
	/**
	 * /policyService/selectProfileList
	 * input :
	 * 
	 * 
	 * output :
	 * resultUid = null
	 * totalListCount = 2
	 * resultCode = 0000000000
	 * list = [{"createDateTime":"2017-10-11 13:54:59.751","profileTypeName":"PROTECTION","profileTypeCode":"PTPR","profileStatusCode":"PS50","profileNote":"","profileStatusName":"ACTIVE","createName":"ê¸°ë³¸ê´\u0080ë¦¬ì\u009E\u0090","createUid":"00000000-0000-0000-0000-000000000001","profileName":"1212","profileUid":"7819aa5f-20a6-4405-b15c-50e30c2dcd6a"},{"createDateTime":"2017-09-15 11:13:11.947","profileTypeCode":"PTPR","profileNote":"55435435","createName":"ê¸°ë³¸ê´\u0080ë¦¬ì\u009E\u0090","profileTypeName":"PROTECTION","updateName":"ê¸°ë³¸ê´\u0080ë¦¬ì\u009E\u0090","profileStatusCode":"PS50","updateUid":"00000000-0000-0000-0000-000000000001","profileStatusName":"ACTIVE","profileName":"AES256","updateDateTime":"2017-10-11 13:53:14.254","createUid":"00000000-0000-0000-0000-000000000001","profileUid":"045c13fb-9915-47b3-936d-c6116d91ed24"}]
	 * resultMessage = SUCCESS

	 * 
	 * @throws Exception
	 */
	private JSONObject selectProfileList(String strService, String strCommand, HashMap header, JSONObject parameters) throws Exception {
		
		JSONObject resultJsonObjectMap = null;
		
		ExperDBRestApi api = new ExperDBRestApi(restIp, restPort);

		resultJsonObjectMap = api.restRequest(strService, strCommand, header, parameters);
		
		return resultJsonObjectMap;

	}
}
