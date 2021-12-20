package com.k4m.dx.tcontrol.encrypt.service.call;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;

import com.google.gson.Gson;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.EncryptCommonService;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.SystemCode;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.TypeUtility;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.AuthCredentialToken;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.Entity;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.EntityPermission;

public class UserManagerServiceCall {
	
	/**
	 * 사용자 등록
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @throws Exception
	 */
	public JSONObject insertEntityWithPermission(String restIp, int restPort, String strTocken, String loginId, String entityId,String strUserId,String password,String entityname) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.ENTITY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.INSERTENTITYWITHPERMISSION;
		
		Entity param1 = new Entity();

		param1.setEntityName(entityname);
		param1.setContainerTypeCode(SystemCode.ContainerTypeCode.ELEMENT);
		param1.setEntityTypeCode(SystemCode.EntityTypeCode.ADMIN_USER);
		param1.setEntityStatusCode("ES50");
		param1.setCreateUid(loginId);
		
		JSONObject jsonExtended = new JSONObject();
		jsonExtended.put(SystemCode.ExtendedFieldKey.PHONE, "");
		jsonExtended.put(SystemCode.ExtendedFieldKey.EMAIL, "");
		
		param1.setExtendedField(jsonExtended.toJSONString());
		
		List param2 = new ArrayList();
		
		for(int i=0; i<6; i++) {
			EntityPermission p = new EntityPermission();
			
			String permissionKey = "";

			if(i == 0) {
				permissionKey = "ADMIN_USER_PERMISSION";
			} else if(i == 1) {
				permissionKey = "CRYPTO_KEY_PERMISSION";
			} else if(i == 2) {
				permissionKey = "ENVIRONMENT_PERMISSION";
			} else if(i == 3) {
				permissionKey = "MONITORING_PERMISSION";
			} else if(i == 4) {
				permissionKey = "POLICY_PERMISSION";
			} else if(i == 5) {
				permissionKey = "SITE_PERMISSION";
			}
			
			p.setPermissionKey(permissionKey);
			p.setEditPermissionTrueFalse(true);
			p.setExportPermissionTrueFalse(true);
			p.setViewPermissionTrueFalse(true);
			
			
			param2.add(p.toJSONString());
		}
		
		AuthCredentialToken param3 = new AuthCredentialToken();
		param3.setLoginId(strUserId);
		param3.setPassword(password);

		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(param1.getClass()), param1.toJSONString());
		
		Gson param2Gson = new Gson();
		
		body.put("EntityPermission", param2);
		body.put(TypeUtility.getJustClassName(param3.getClass()), param3.toJSONString());
		
		String parameters = TypeUtility.makeRequestBody(body);
		
//		System.out.println(parameters);

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);

		JSONObject resultJson = api.callService(strService, strCommand, header, parameters.toString());
		
		Iterator<?> iter = resultJson.entrySet().iterator();
		while (iter.hasNext()) {
			Map.Entry entry = (Map.Entry) iter.next();

//			System.out.println(String.valueOf(entry.getKey()) + " = " + String.valueOf(entry.getValue()));
		}
		
		String resultCode = (String) resultJson.get("resultCode");
		String resultMessage = new String(resultJson.get("resultMessage").toString().getBytes("iso-8859-1"),"UTF-8");
		//long totalListCount = (long) resultJson.get("totalListCount");
		
		JSONObject result = new JSONObject();
		result.put("resultCode", resultCode);
		result.put("resultMessage", resultMessage);
		return result;
	}
	
	/**
	 * entity_uid 검색
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @param loginId
	 * @param entityId
	 * @param userId
	 * @return 
	 * @throws Exception
	 */
	public JSONObject selectEntityUid(String restIp, int restPort, String strTocken, String loginId, String entityId, String userId) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.ENTITY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTENTITYUID;
		
		AuthCredentialToken param = new AuthCredentialToken();
		
		param.setLoginId(userId);
		
		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());
		
		String parameters = TypeUtility.makeRequestBody(body);

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);

		JSONObject resultJson1 = api.callService(strService, strCommand, header, parameters.toString());
		
		Iterator<?> iter1 = resultJson1.entrySet().iterator();
		while (iter1.hasNext()) {
			Map.Entry entry = (Map.Entry) iter1.next();

//			System.out.println(String.valueOf(entry.getKey()) + " = " + String.valueOf(entry.getValue()));
		}

		String resultCode = (String) resultJson1.get("resultCode");
		String resultMessage = new String(resultJson1.get("resultMessage").toString().getBytes("iso-8859-1"),"UTF-8");
		
		System.out.println(resultMessage);
		
		return resultJson1;
	}
	
	/**
	 * 사용자 삭제
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @throws Exception
	 */
	public JSONObject deleteEntity(String restIp, int restPort, String strTocken, String loginId, String entityId, String entityUid) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.ENTITY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.DELETEENTITY;

		Entity param1 = new Entity();

		param1.setEntityUid(entityUid);

		if (entityUid.startsWith("00000000-0000-0000-0000-"))
		{
			throw new Exception ("기본 관리자는 삭제할 수 없습니다.");
		}
		
	
		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(param1.getClass()), param1.toJSONString());
		
	
		String parameters = TypeUtility.makeRequestBody(body);
		
//		System.out.println(parameters);

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);

		JSONObject resultJson = api.callService(strService, strCommand, header, parameters.toString());
		
		Iterator<?> iter = resultJson.entrySet().iterator();
		while (iter.hasNext()) {
			Map.Entry entry = (Map.Entry) iter.next();

//			System.out.println(String.valueOf(entry.getKey()) + " = " + String.valueOf(entry.getValue()));
		}
		
		
		String resultCode = (String) resultJson.get("resultCode");
		String resultMessage = new String(resultJson.get("resultMessage").toString().getBytes("iso-8859-1"),"UTF-8");
		//long totalListCount = (long) resultJson.get("totalListCount");
		
		JSONObject result = new JSONObject();
		result.put("resultCode", resultCode);
		result.put("resultMessage", resultMessage);
		return result;
	}
	
	
	/**
	 * 비밀번호 변경
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @param loginId
	 * @param entityId
	 * @throws Exception
	 */
	public JSONObject updatePassword(String restIp, int restPort, String strTocken, String loginId, String entityId, String password) throws Exception {
		JSONObject result = new JSONObject();
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.AUTH_SERVICE;
		String strCommand = SystemCode.ServiceCommand.UPDATEPASSWORD;

		String strEntityUid = entityId;
		String strUpdateUid = entityId;

		
		AuthCredentialToken param = new AuthCredentialToken();
		param.setEntityUid(entityId);
		param.setPassword(password);
		param.setUpdateUid(strUpdateUid);

		HashMap body = new HashMap();

		body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());
		
		String parameters = TypeUtility.makeRequestBody(body);
		
//		System.out.println(parameters);

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);

		JSONObject resultJson = api.callService(strService, strCommand, header, parameters.toString());
		
		Iterator<?> iter = resultJson.entrySet().iterator();
		while (iter.hasNext()) {
			Map.Entry entry = (Map.Entry) iter.next();

//			System.out.println(String.valueOf(entry.getKey()) + " = " + String.valueOf(entry.getValue()));
		}
		
		
		String resultCode = (String) resultJson.get("resultCode");
		String resultMessage = (String) resultJson.get("resultMessage");
		resultMessage = new String(resultMessage.getBytes("iso-8859-1"),"UTF-8"); 
		
		result.put("resultCode", resultCode);
		result.put("resultMessage", resultMessage);
		return result;
	}
}
