package com.k4m.dx.tcontrol.cmmn.serviceproxy;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.codehaus.jackson.map.ObjectMapper;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;

import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.AuditLog;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.AuditLogSite;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.BackupLog;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.ProfileVO;

import net.sf.json.JSONArray;

public class ServiceCallTest {

	public static void main(String[] args) throws Exception {

		String restIp = "222.110.153.204";
		int restPort = 9443;
		
		restIp = "127.0.0.1";
		restPort = 8443;

		ServiceCallTest test = new ServiceCallTest();

		//test.loginTest(restIp, restPort);
		
		
		//policyService
		//test.selectProfileList(restIp, restPort);
		
		//test.selectProfileProtectionVersion(restIp, restPort);
		
		//감사로그 > 암복호화
		//test.selectAuditLogSiteList(restIp, restPort);
		
		//감사로그 > 관리서버 감사로그
		//test.selectAuditLogList(restIp, restPort);
		
		//암호화 키 접근로그
		//test.selectAuditLogListKey(restIp, restPort);
		
		//백업/복원 감사로그
		test.selectBackupLogList(restIp, restPort);

		
	}

	private void selectProfileList(String restIp, int restPort) throws Exception {

		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.POLICY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTPROFILELIST;

		ProfileVO vo = new ProfileVO();
		vo.setProfileTypeCode("PTPR");

		//JSONObject parameters = new JSONObject();
		//parameters.put("profile", vo);
		
		ObjectMapper mapper = new ObjectMapper();
		String parameters = mapper.writeValueAsString(vo);

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, "admin");
		header.put(SystemCode.FieldName.ENTITY_UID, "00000000-0000-0000-0000-000000000001");
		header.put(SystemCode.FieldName.TOKEN_VALUE, "i/FPZIY3KbFjjCJgaX6ratQqma73FNxNt5S/ekTY7ys=");

		JSONObject resultJson = api.callService(strService, strCommand, header, parameters);
		

		String resultCode = (String) resultJson.get("resultCode");
		String resultMessage = (String) resultJson.get("resultMessage");
		
		if(resultCode.equals(SystemCode.ResultCode.SUCCESS)) {
			
			JSONArray data = (JSONArray) resultJson.get("list");
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
				
				System.out.println("profileName : " + profileName + " profileUid : " + profileUid);

			}
			
		} else {
			
		}

	}
	
	private void selectProfileProtectionVersion(String restIp, int restPort) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.POLICY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTPROFILEPROTECTIONVERSION;


		//JSONObject parameters = new JSONObject();
		
		ObjectMapper mapper = new ObjectMapper();
		String parameters = "";


		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, "admin");
		header.put(SystemCode.FieldName.ENTITY_UID, "00000000-0000-0000-0000-000000000001");
		header.put(SystemCode.FieldName.TOKEN_VALUE, "iRcOV3j+IH3qmbsTR94fGVIlwPECoBqwDjwjseJupvw=");

		JSONObject resultJson = api.callService(strService, strCommand, header, parameters);
		

		String resultCode = (String) resultJson.get("resultCode");
		String resultMessage = (String) resultJson.get("resultMessage");
		
		HashMap result = (HashMap) resultJson.get("map");
		long selectProfileProtectionVersion = (long) result.get(SystemCode.FieldName.PROFILE_PROTECTION_VERSION);
		
		System.out.println("selectProfileProtectionVersion : " + selectProfileProtectionVersion);
		
	}

	/**
	 * 로그인
	 * @param restIp
	 * @param restPort
	 * @throws Exception
	 */
	private void loginTest(String restIp, int restPort) throws Exception {

		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.AUTH_SERVICE;
		String strCommand = SystemCode.ServiceCommand.LOGIN;

		//JSONObject parameters = new JSONObject();
		// parameters.put("name", strName);
		// parameters.put("config", config)
		String parameters = "";

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, "admin");
		header.put(SystemCode.FieldName.PASSWORD, "password");

		JSONObject configJsonObjectMap = null;
		ResponseEntity<String> loginEntity = api.callLoginService(strService, strCommand, header, parameters);

		if (loginEntity != null && loginEntity.getStatusCode().value() == 200) {

			// header setting
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
	
	/**
	 * 암복호화 감사로그
	 * @param restIp
	 * @param restPort
	 * @throws Exception
	 */
	private void selectAuditLogSiteList(String restIp, int restPort) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.LOG_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTAUDITLOGSITELIST;


		
		
		AuditLogSite auditLogSite = new AuditLogSite();
		auditLogSite.setSearchAgentLogDateTimeFrom("20180123000000"); 
		auditLogSite.setSearchAgentLogDateTimeTo("20180123240000");
		auditLogSite.setAgentUid("");
		auditLogSite.setSuccessTrueFalse(true);
		auditLogSite.setPageOffset(1);
		auditLogSite.setPageSize(10);
		auditLogSite.setTotalCountLimit(10001);
		
		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(auditLogSite.getClass()), auditLogSite.toJSONString());

		String parameters = TypeUtility.makeRequestBody(body);
		

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, "admin");
		header.put(SystemCode.FieldName.ENTITY_UID, "00000000-0000-0000-0000-000000000001");
		header.put(SystemCode.FieldName.TOKEN_VALUE, "7b7LmeDY5/6RdkNz1fISReCvP5eK9MV5vHudYoNaMfc=");

		JSONObject resultJson = api.callService(strService, strCommand, header, parameters.toString());
		
		Iterator<?> iter = resultJson.entrySet().iterator();
		while (iter.hasNext()) {
			Map.Entry entry = (Map.Entry) iter.next();

			System.out.println(String.valueOf(entry.getKey()) + " = " + String.valueOf(entry.getValue()));
		}
		

		String resultCode = (String) resultJson.get("resultCode");
		String resultMessage = (String) resultJson.get("resultMessage");
		
		System.out.println("resultCode : " + resultCode + " resultMessage : " + resultMessage);
		
	}
	
	/**
	 * 관리서버 감사로그
	 * @param restIp
	 * @param restPort
	 * @throws Exception
	 */
	private void selectAuditLogList(String restIp, int restPort) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.LOG_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTAUDITLOGLIST;


		
		
		AuditLog auditLog = new AuditLog();
		auditLog.setSearchLogDateTimeFrom("2018-01-24 00:00:00.000000"); 
		auditLog.setSearchLogDateTimeTo("2018-01-24 23:59:59.999999");
		auditLog.setEntityUid("");
		auditLog.setResultCode("");

		auditLog.setPageOffset(1);
		auditLog.setPageSize(10);
		auditLog.setTotalCountLimit(10001);
		
		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(auditLog.getClass()), auditLog.toJSONString());

		String parameters = TypeUtility.makeRequestBody(body);
		

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, "admin");
		header.put(SystemCode.FieldName.ENTITY_UID, "00000000-0000-0000-0000-000000000001");
		header.put(SystemCode.FieldName.TOKEN_VALUE, "5QDN5QdTIlRTOIP5qPd05jGkXp2cibUyxLnH147RbAM=");

		JSONObject resultJson = api.callService(strService, strCommand, header, parameters.toString());
		
		Iterator<?> iter = resultJson.entrySet().iterator();
		while (iter.hasNext()) {
			Map.Entry entry = (Map.Entry) iter.next();

			System.out.println(String.valueOf(entry.getKey()) + " = " + String.valueOf(entry.getValue()));
		}
		
		
		String resultCode = (String) resultJson.get("resultCode");
		String resultMessage = (String) resultJson.get("resultMessage");
		
		if(resultCode.equals("0000000000")) {
			ArrayList list = (ArrayList) resultJson.get("list");
			
			System.out.println("list Size : " + list.size());
			
			for(int i=0; i<list.size(); i++) {
				JSONObject log = (JSONObject) list.get(i);
				
				StringBuffer bf = new StringBuffer();
				
				//접근일시 createDateTime
				bf.append((i+1) + "접근일시 : " + log.get("createDateTime"));
				//접근자이름 entityName
				String strEntityName = (String) log.get("entityName");
				//strEntityName.getBytes("UTF-8");
				//System.out.println(new String(strEntityName, ));
				
				if(strEntityName != null) {
					strEntityName = new String(strEntityName.getBytes("iso-8859-1"),"UTF-8"); 
					
					bf.append("접근자이름 : " + strEntityName);
				}
				//checkChar(strEntityName);
			
				//접근자주소 remoteAddress
				bf.append(" 접근자주소 : " + log.get("remoteAddress"));
				//접근경로  requestPath
				bf.append(" 접근경로 : " + log.get("requestPath") );
				//본문 parameter
				bf.append(" 본문 : " + log.get("parameter") );
				//결과코드 resultCode
				bf.append(" 결과코드 : " + log.get("resultCode") );
				//결과메시지resultMessage
				bf.append(" 결과메시지 : " + log.get("resultMessage"));
				
				System.out.println(bf.toString());
			
				
			}
		
		}
		
	}
	
	/**
	 * 암호화 키 접근로그
	 * @param restIp
	 * @param restPort
	 * @throws Exception
	 */
	private void selectAuditLogListKey(String restIp, int restPort) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.LOG_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTAUDITLOGLIST;


		
		
		AuditLog auditLog = new AuditLog();
		auditLog.setKeyAccessOnly(true);
		auditLog.setSearchLogDateTimeFrom("2018-01-24 00:00:00.000000"); 
		auditLog.setSearchLogDateTimeTo("2018-01-24 23:59:59.999999");
		auditLog.setEntityUid("");
		auditLog.setResultCode("");

		auditLog.setPageOffset(1);
		auditLog.setPageSize(10);
		auditLog.setTotalCountLimit(10001);
		
		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(auditLog.getClass()), auditLog.toJSONString());

		String parameters = TypeUtility.makeRequestBody(body);
		

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, "admin");
		header.put(SystemCode.FieldName.ENTITY_UID, "00000000-0000-0000-0000-000000000001");
		header.put(SystemCode.FieldName.TOKEN_VALUE, "5QDN5QdTIlRTOIP5qPd05jGkXp2cibUyxLnH147RbAM=");

		JSONObject resultJson = api.callService(strService, strCommand, header, parameters.toString());
		
		Iterator<?> iter = resultJson.entrySet().iterator();
		while (iter.hasNext()) {
			Map.Entry entry = (Map.Entry) iter.next();

			System.out.println(String.valueOf(entry.getKey()) + " = " + String.valueOf(entry.getValue()));
		}
		
		
		String resultCode = (String) resultJson.get("resultCode");
		String resultMessage = (String) resultJson.get("resultMessage");
		
		if(resultCode.equals("0000000000")) {
			ArrayList list = (ArrayList) resultJson.get("list");
			
			System.out.println("list Size : " + list.size());
			
			for(int i=0; i<list.size(); i++) {
				JSONObject log = (JSONObject) list.get(i);
				
				StringBuffer bf = new StringBuffer();
				
				//접근일시 createDateTime
				bf.append((i+1) + "접근일시 : " + log.get("createDateTime"));
				//접근자이름 entityName
				String strEntityName = (String) log.get("entityName");
				//strEntityName.getBytes("UTF-8");
				//System.out.println(new String(strEntityName, ));
				
				if(strEntityName != null) {
					strEntityName = new String(strEntityName.getBytes("iso-8859-1"),"UTF-8"); 
					
					bf.append("접근자이름 : " + strEntityName);
				}
				//checkChar(strEntityName);
			
				//접근자주소 remoteAddress
				bf.append(" 접근자주소 : " + log.get("remoteAddress"));
				//접근경로  requestPath
				bf.append(" 접근경로 : " + log.get("requestPath") );
				//본문 parameter
				bf.append(" 본문 : " + log.get("parameter") );
				//결과코드 resultCode
				bf.append(" 결과코드 : " + log.get("resultCode") );
				//결과메시지resultMessage
				bf.append(" 결과메시지 : " + log.get("resultMessage"));
				
				System.out.println(bf.toString());
			
				
			}
		
		}
		
	}
	
	/**
	 * 백업/복원 감사로그
	 * @param restIp
	 * @param restPort
	 * @throws Exception
	 */
	private void selectBackupLogList(String restIp, int restPort) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.BACKUP_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTBACKUPLOGLIST;


		
		
		BackupLog backupLog = new BackupLog();

		backupLog.setBackupWorkType("");
		backupLog.setSearchLogDateTimeFrom("2018-01-24 00:00:00.000000"); 
		backupLog.setSearchLogDateTimeTo("2018-01-24 23:59:59.999999");
		backupLog.setEntityUid("");
		
		backupLog.setPageOffset(1);
		backupLog.setPageSize(10);
		backupLog.setTotalCountLimit(10001);
		
		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(backupLog.getClass()), backupLog.toJSONString());

		String parameters = TypeUtility.makeRequestBody(body);
		

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, "admin");
		header.put(SystemCode.FieldName.ENTITY_UID, "00000000-0000-0000-0000-000000000001");
		header.put(SystemCode.FieldName.TOKEN_VALUE, "lhccUgOVbeNdZ1dN50D0VbxFttKZSAHawD1BFnaGphI=");

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
			
			//System.out.println("list Size : " + list.size());
			if(totalListCount > 0) {
				for(int i=0; i<list.size(); i++) {
					JSONObject log = (JSONObject) list.get(i);
					
					StringBuffer bf = new StringBuffer();
					
					//접근일시 createDateTime
					bf.append((i+1) + "접근일시 : " + log.get("createDateTime"));
					//접근자이름 entityName
					String strEntityName = (String) log.get("entityName");
					//strEntityName.getBytes("UTF-8");
					//System.out.println(new String(strEntityName, ));
					
					if(strEntityName != null) {
						strEntityName = new String(strEntityName.getBytes("iso-8859-1"),"UTF-8"); 
						
						bf.append("접근자이름 : " + strEntityName);
					}
					//checkChar(strEntityName);
				
					//접근자주소 remoteAddress
					bf.append(" 접근자주소 : " + log.get("remoteAddress"));
					//접근경로  requestPath
					bf.append(" 접근경로 : " + log.get("requestPath") );
					//본문 parameter
					bf.append(" 본문 : " + log.get("parameter") );
					//결과코드 resultCode
					bf.append(" 결과코드 : " + log.get("resultCode") );
					//결과메시지resultMessage
					bf.append(" 결과메시지 : " + log.get("resultMessage"));
					
					System.out.println(bf.toString());
				
					
				}
			
			}
		}
		
	}
	
	private void checkChar(String originalStr) throws Exception {
		//String originalStr = "Å×½ºÆ®"; // 테스트 
		String [] charSet = {"utf-8","euc-kr","ksc5601","iso-8859-1","x-windows-949"};
		  
		for (int i=0; i<charSet.length; i++) {
		 for (int j=0; j<charSet.length; j++) {
		  try {
		   System.out.println("[" + charSet[i] +"," + charSet[j] +"] = " + new String(originalStr.getBytes(charSet[i]), charSet[j]));
		  } catch (UnsupportedEncodingException e) {
		   e.printStackTrace();
		  }
		 }
		}
	}
}
