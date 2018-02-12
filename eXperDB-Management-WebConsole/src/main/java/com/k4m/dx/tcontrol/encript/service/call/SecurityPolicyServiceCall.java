package com.k4m.dx.tcontrol.encript.service.call;

import java.util.ArrayList;
import java.util.HashMap;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.google.gson.Gson;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.EncryptCommonService;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.SystemCode;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.TypeUtility;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.Profile;

public class SecurityPolicyServiceCall {
	
	
	/**
	 * 보안정책 > 보안정책관리
	 * @param restIp
	 * @param restPort
	 * @return 
	 * @throws Exception
	 */
	public JSONObject selectProfileList(String restIp, int restPort, String strTocken) throws Exception {
		JSONArray jsonArray = new JSONArray();
		JSONObject result = new JSONObject();

		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.POLICY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTPROFILELIST;

		Profile param = new Profile();
		param.setProfileTypeCode("PTPR");
		
		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());

		String parameters = TypeUtility.makeRequestBody(body);

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, "admin");
		header.put(SystemCode.FieldName.ENTITY_UID, "00000000-0000-0000-0000-000000000001");
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);

		JSONObject resultJson = api.callService(strService, strCommand, header, parameters);
		
		String resultCode = (String) resultJson.get("resultCode");
		String resultMessage = (String) resultJson.get("resultMessage");
		resultMessage = new String(resultMessage.getBytes("iso-8859-1"),"UTF-8"); 
		
		if(resultCode.equals(SystemCode.ResultCode.SUCCESS)) {
			
			ArrayList list = (ArrayList) resultJson.get("list");
			for (int j = 0; j < list.size(); j++) {
				JSONObject jsonObj = (JSONObject) list.get(j);

				Gson gson = new Gson();
				Profile profile = new Profile();
				profile = gson.fromJson(jsonObj.toJSONString(), profile.getClass());

				String createDateTime = profile.getCreateDateTime();
				String profileTypeName = profile.getProfileTypeName();
				String profileTypeCode = profile.getProfileTypeCode();
				String profileStatusCode = profile.getProfileStatusCode();
				String profileNote = profile.getProfileNote();
				String profileStatusName =  profile.getProfileStatusName();
				String createName = profile.getCreateName();
				String createUid = profile.getCreateUid();
				String profileName = profile.getProfileName();
				String profileUid = profile.getProfileUid();
				
				jsonObj.put("rnum", j+1);
				jsonObj.put("profileName", profileName);
				jsonObj.put("profileNote", profileNote);
				jsonObj.put("profileStatusName", profileStatusName);
				jsonObj.put("createDateTime", createDateTime);
				jsonObj.put("createName", createName);
				jsonObj.put("updateDateTime", "");
				jsonObj.put("updateName", "");
				
				jsonArray.add(jsonObj);
			}
			result.put("data", jsonArray);
			System.out.println(result);
		} else {
			
		}
		return result;
	}
	
}
