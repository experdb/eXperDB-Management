package com.k4m.dx.tcontrol.cmmn.serviceproxy;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.codehaus.jackson.map.ObjectMapper;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;

import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.AdminServerPasswordRequest;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.AuditLog;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.AuditLogSite;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.BackupLog;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.CryptoKey;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.CryptoKeySymmetric;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.Profile;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.ProfileProtection;

public class ServiceCallTest {

	public static void main(String[] args) throws Exception {

		String restIp = "222.110.153.204";
		int restPort = 9443;
		
		restIp = "127.0.0.1";
		restPort = 8443;
		
		String strTocken = "fNUv+YglEU1BbUB5UJ6V8vm3oIaEX2cATRNCXN+S2RE=";

		ServiceCallTest test = new ServiceCallTest();
		
		//마스터키 로드
		//test.loadServerKey(restIp, restPort, strTocken);
		
		//서버상태
		//test.selectServerStatus(restIp, restPort, strTocken);
		
		//공통코드 리스트
		//test.selectSysCodeList(restIp, restPort, strTocken);

		//test.loginTest(restIp, restPort);

		//test.selectProfileProtectionVersion(restIp, restPort, strTocken);
		
		//감사로그 > 암복호화
		//test.selectAuditLogSiteList(restIp, restPort, strTocken);
		
		//감사로그 > 관리서버 감사로그
		//test.selectAuditLogList(restIp, restPort, strTocken);
		
		//감사로그 > 암호화 키 접근로그
		//test.selectAuditLogListKey(restIp, restPort, strTocken);
		
		//감사로그 > 백업/복원 감사로그
		//test.selectBackupLogList(restIp, restPort, strTocken);
		
		//보안정책 > 정책관리
		//test.selectProfileList(restIp, restPort, strTocken);
		
		//보안정책 > 보안정책 상세
		//test.selectProfileProtectionContents(restIp, restPort, strTocken);
		
		//암호화키 > 암호화키리스트
		test.selectCryptoKeyList(restIp, restPort, strTocken);
		
		//암호화키 > 암호화 키 등록
		//test.insertCryptoKeySymmetric(restIp, restPort, strTocken);
		

		
	}

	/**
	 * 보안정책 > 보안정책관리
	 * @param restIp
	 * @param restPort
	 * @throws Exception
	 */
	private void selectProfileList(String restIp, int restPort, String strTocken) throws Exception {

		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.POLICY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTPROFILELIST;

		Profile profile = new Profile();
		profile.setProfileTypeCode("PTPR");

		//JSONObject parameters = new JSONObject();
		//parameters.put("profile", vo);
		
		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(profile.getClass()), profile.toJSONString());

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
			
			ArrayList list = (ArrayList) resultJson.get("list");
			for (int j = 0; j < list.size(); j++) {
				JSONObject jsonObj = (JSONObject) list.get(j);

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
	
	
	private void selectProfileProtectionContents(String restIp, int restPort, String strTocken) throws Exception {

		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.POLICY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTPROFILEPROTECTIONCONTENTS;

		ProfileProtection profileProtection = new ProfileProtection();
		profileProtection.setProfileUid("57a20cfe-6e77-4a08-8e8f-4f328fa8a0e0");

		//JSONObject parameters = new JSONObject();
		//parameters.put("profile", vo);
		
		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(profileProtection.getClass()), profileProtection.toJSONString());

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

			JSONObject map = (JSONObject) resultJson.get("map");
			JSONObject jsonProfileProtection = (JSONObject) map.get("ProfileProtection");
			
			String createDateTime = (String) jsonProfileProtection.get("createDateTime");
			System.out.println(createDateTime);
			System.out.println((boolean) jsonProfileProtection.get("defaultAccessAllowTrueFalse")); //	기본접근허용
			
			long optionBits = 0L;
			optionBits= (long) jsonProfileProtection.get("optionBits");
			
			//optionBits = Long.parseLong(strOptionBit);
			
			boolean blnLoggingFail = !((optionBits & SystemCode.BitMask.POLICY_OPT_NO_AUDIT_LOG_ON_FAIL) == SystemCode.BitMask.POLICY_OPT_NO_AUDIT_LOG_ON_FAIL);
			
			boolean blnLoggingSuccess= !((optionBits & SystemCode.BitMask.POLICY_OPT_NO_AUDIT_LOG_ON_SUCCESS) == SystemCode.BitMask.POLICY_OPT_NO_AUDIT_LOG_ON_SUCCESS);
			
			boolean blnLogCompress = ((optionBits & SystemCode.BitMask.POLICY_OPT_COMPRESS_AUDIT_LOG) == SystemCode.BitMask.POLICY_OPT_COMPRESS_AUDIT_LOG);
			
			System.out.println(blnLoggingFail); //실패 로그 기록
			System.out.println(blnLoggingSuccess); //성공 로그 기록
			System.out.println(blnLogCompress); //로그 압축
			
			System.out.println((String) jsonProfileProtection.get("nullEncryptYesNo")); //nullEncryptYesNo	NULL 암호화
			System.out.println((String) jsonProfileProtection.get("preventDoubleYesNo")); //preventDoubleYesNo	이중 암호화 방지
			System.out.println((String) jsonProfileProtection.get("denyResultTypeCode")); //denyResultTypeCode	접근 거부시 처리
			System.out.println((String) jsonProfileProtection.get("dataTypeCode")); //dataTypeCode	데이터 타입

			
			
			JSONArray jsonProfileCipherSpec = (JSONArray) map.get("ProfileCipherSpec");
			
			
			
			JSONArray jsonProfileAclSpec = (JSONArray) map.get("ProfileAclSpec");


		} else {
			
		}

	}
	
	private void selectProfileProtectionVersion(String restIp, int restPort, String strTocken) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.POLICY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTPROFILEPROTECTIONVERSION;


		//JSONObject parameters = new JSONObject();
		
		ObjectMapper mapper = new ObjectMapper();
		String parameters = "";


		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, "admin");
		header.put(SystemCode.FieldName.ENTITY_UID, "00000000-0000-0000-0000-000000000001");
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);

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
	private void selectAuditLogSiteList(String restIp, int restPort, String strTocken) throws Exception {
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
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);

		JSONObject resultJson = api.callService(strService, strCommand, header, parameters.toString());
		
		Iterator<?> iter = resultJson.entrySet().iterator();
		while (iter.hasNext()) {
			Map.Entry entry = (Map.Entry) iter.next();

			System.out.println(String.valueOf(entry.getKey()) + " = " + String.valueOf(entry.getValue()));
		}
		

		String resultCode = (String) resultJson.get("resultCode");
		String resultMessage = (String) resultJson.get("resultMessage");
		
		//System.out.println("resultCode : " + resultCode + " resultMessage : " + resultMessage);
		
	}
	
	/**
	 * 관리서버 감사로그
	 * @param restIp
	 * @param restPort
	 * @throws Exception
	 */
	private void selectAuditLogList(String restIp, int restPort, String strTocken) throws Exception {
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
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);

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
	private void selectAuditLogListKey(String restIp, int restPort, String strTocken) throws Exception {
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
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);

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
	private void selectBackupLogList(String restIp, int restPort, String strTocken) throws Exception {
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
			
			//System.out.println("list Size : " + list.size());
			if(totalListCount > 0) {
				for(int i=0; i<list.size(); i++) {
					JSONObject log = (JSONObject) list.get(i);
					
					StringBuffer bf = new StringBuffer();
					
					//접근일시 createDateTime
					bf.append((i+1) + "작업일시 : " + log.get("createDateTime"));
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
	
	/**
	 * 마스터키 로드
	 * @param restIp
	 * @param restPort
	 * @throws Exception
	 */
	private void loadServerKey(String restIp, int restPort, String strTocken) throws Exception {

		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.SYSTEM_SERVICE;
		String strCommand = SystemCode.ServiceCommand.LOADSERVERKEY;
		
		String oldPassword = "password";

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


		} else {
			
		}

	}
	
	/**
	 * 서버상태
	 * @param restIp
	 * @param restPort
	 * @throws Exception
	 */
	private void selectServerStatus(String restIp, int restPort, String strTocken) throws Exception {

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

		boolean isServerKeyEmpty = (boolean) result.get("isServerKeyEmpty");
		boolean isServerPasswordEmpty = (boolean) result.get("isServerPasswordEmpty");
		
		System.out.println("resultCode : " + resultCode + " resultMessage : " + resultMessage);
		System.out.println("isServerKeyEmpty : " + isServerKeyEmpty + " isServerPasswordEmpty : " + isServerPasswordEmpty);
		
		if(resultCode.equals(SystemCode.ResultCode.SUCCESS)) {

		} else {
			
		}

	}
	
	/**
	 * 암호화키리스트
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @throws Exception
	 */
	private void selectCryptoKeyList(String restIp, int restPort, String strTocken) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.KEY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTCRYPTOKEYLIST;


		
		
		CryptoKey param = new CryptoKey();
		param.setKeyTypeCode(SystemCode.KeyTypeCode.SYMMETRIC);
		

		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());

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
			
			//System.out.println("list Size : " + list.size());
			if(totalListCount > 0) {
				for(int i=0; i<list.size(); i++) {
					JSONObject data = (JSONObject) list.get(i);
					
					StringBuffer bf = new StringBuffer();
					bf.append((i+1) + "키 식별자 : " + data.get("keyUid"));
					bf.append((i+1) + "키 이름 : " + data.get("resourceName"));
					bf.append((i+1) + "유형 코드 : " + data.get("resourceTypeCode"));
					bf.append((i+1) + "키 설명 : " + data.get("resourceNote"));
					bf.append((i+1) + "유형 : " + data.get("resourceTypeName"));
					bf.append((i+1) + "적용 알고리즘 : " + data.get("cipherAlgorithmName"));
					bf.append((i+1) + "작성 일시 : " + data.get("createDateTime"));
					bf.append((i+1) + "작성자 : " + new String(data.get("createName").toString().getBytes("iso-8859-1"),"UTF-8"));
					bf.append((i+1) + "변경 일시 : " + data.get("updateDateTime"));
					//bf.append((i+1) + "변경자 : " + new String(data.get("updateName").toString().getBytes("iso-8859-1"),"UTF-8"));

	
	
					System.out.println(bf.toString());
				
					
				}
			
			}
		}
		
	}
	
	/**
	 * 암호화 키 등록
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @throws Exception
	 */
	private void insertCryptoKeySymmetric(String restIp, int restPort, String strTocken) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.KEY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.INSERTCRYPTOKEYSYMMETRIC;


		
		
		CryptoKeySymmetric param = new CryptoKeySymmetric();
		param.setKeyUid("");
		param.setResourceUid("");
		param.setResourceName("test01");
		param.setCipherAlgorithmCode("CAD1");
		param.setResourceNote("testNote");
		param.setKeyStatusCode("KS50");
		

		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());

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
		
	}
	
	/**
	 * 공통코드리스트
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @throws Exception
	 */
	private void selectSysCodeList(String restIp, int restPort, String strTocken) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.SYSTEM_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTSYSCODELIST;


		

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
			
			//System.out.println("list Size : " + list.size());
			if(totalListCount > 0) {
				for(int i=0; i<list.size(); i++) {
					JSONObject data = (JSONObject) list.get(i);
					
					StringBuffer bf = new StringBuffer();
/*					bf.append((i+1) + "키 식별자 : " + data.get("keyUid"));
					bf.append((i+1) + "키 이름 : " + data.get("resourceName"));
					bf.append((i+1) + "유형 코드 : " + data.get("resourceTypeCode"));
					bf.append((i+1) + "키 설명 : " + data.get("resourceNote"));
					bf.append((i+1) + "유형 : " + data.get("resourceTypeName"));
					bf.append((i+1) + "적용 알고리즘 : " + data.get("cipherAlgorithmName"));
					bf.append((i+1) + "작성 일시 : " + data.get("createDateTime"));
					bf.append((i+1) + "작성자 : " + new String(data.get("createName").toString().getBytes("iso-8859-1"),"UTF-8"));
					bf.append((i+1) + "변경 일시 : " + data.get("updateDateTime"));
					//bf.append((i+1) + "변경자 : " + new String(data.get("updateName").toString().getBytes("iso-8859-1"),"UTF-8"));

	
	*/
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
