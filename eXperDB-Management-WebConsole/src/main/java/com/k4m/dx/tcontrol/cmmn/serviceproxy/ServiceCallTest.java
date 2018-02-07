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

import com.google.gson.Gson;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.AdminServerPasswordRequest;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.AuditLog;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.AuditLogSite;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.BackupLog;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.CryptoKey;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.CryptoKeySymmetric;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.Entity;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.Profile;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.ProfileAclSpec;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.ProfileCipherSpec;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.ProfileProtection;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.SysCode;

public class ServiceCallTest {

	public static void main(String[] args) throws Exception {

		String restIp = "222.110.153.204";
		int restPort = 9443;
		
		restIp = "127.0.0.1";
		restPort = 8443;
		
		String strTocken = "rweQbkFSIluD4V8OkqpY7kBYmFx2eVeinLEaHHg7s58=";

		ServiceCallTest test = new ServiceCallTest();
	
		//test.loginTest(restIp, restPort);
		
		//마스터키 로드
		//test.loadServerKey(restIp, restPort, strTocken);
		
		//서버상태
		//test.selectServerStatus(restIp, restPort, strTocken);
		
		//공통코드 리스트
		//test.selectSysCodeList(restIp, restPort, strTocken);
		
		//적용알고리즘 공통코드
		//test.selectSysCodeListExper(restIp, restPort, strTocken);
		
		//일반공통코드 리스트
		//test.selectParamSysCodeList(restIp, restPort, strTocken);
		
		//접근자리스트
		test.selectEntityList(restIp, restPort, strTocken);


		//test.selectProfileProtectionVersion(restIp, restPort, strTocken);
		
		//감사로그 > 암복호화로그
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
		//test.selectCryptoKeyList(restIp, restPort, strTocken);
		
		//암호화키 > 암호화 키 등록
		//test.insertCryptoKeySymmetric(restIp, restPort, strTocken);
		
		//암호화키 > 암호화 키 수정
		//test.updateCryptoKeySymmetric(restIp, restPort, strTocken);
		

		
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

		Profile param = new Profile();
		param.setProfileTypeCode("PTPR");

		//JSONObject parameters = new JSONObject();
		//parameters.put("profile", vo);
		
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
		
		System.out.println("resultCode : " + resultCode + " resultMessage : " + resultMessage);
		
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
				
				System.out.println("profileName : " + profileName + " profileUid : " + profileUid);

			}
			
		} else {
			
		}

	}
	
	/**
	 * 보안정책상세
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @throws Exception
	 */
	private void selectProfileProtectionContents(String restIp, int restPort, String strTocken) throws Exception {

		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.POLICY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTPROFILEPROTECTIONCONTENTS;

		ProfileProtection param = new ProfileProtection();
		param.setProfileUid("57a20cfe-6e77-4a08-8e8f-4f328fa8a0e0");

		//JSONObject parameters = new JSONObject();
		//parameters.put("profile", vo);
		
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
		
		System.out.println("resultCode : " + resultCode + " resultMessage : " + resultMessage);
		
		if(resultCode.equals(SystemCode.ResultCode.SUCCESS)) {

			JSONObject map = (JSONObject) resultJson.get("map");
			JSONObject jsonProfileProtection = (JSONObject) map.get("ProfileProtection");
			
			Gson gson = new Gson();
			ProfileProtection profileProtection = new ProfileProtection();
			profileProtection = gson.fromJson(jsonProfileProtection.toJSONString(), profileProtection.getClass());
			
			System.out.println("보호 정책 이름 : " + profileProtection.getProfileName());
			System.out.println("보호 정책 설명 : " + profileProtection.getProfileNote());

			System.out.println(profileProtection.getCreateDateTime());
			System.out.println((boolean) profileProtection.getDefaultAccessAllowTrueFalse()); //	기본접근허용
			
			long optionBits = 0L;
			optionBits= (long) profileProtection.getOptionBits();
			
			//optionBits = Long.parseLong(strOptionBit);
			
			boolean blnLoggingFail = !((optionBits & SystemCode.BitMask.POLICY_OPT_NO_AUDIT_LOG_ON_FAIL) == SystemCode.BitMask.POLICY_OPT_NO_AUDIT_LOG_ON_FAIL);
			
			boolean blnLoggingSuccess= !((optionBits & SystemCode.BitMask.POLICY_OPT_NO_AUDIT_LOG_ON_SUCCESS) == SystemCode.BitMask.POLICY_OPT_NO_AUDIT_LOG_ON_SUCCESS);
			
			boolean blnLogCompress = ((optionBits & SystemCode.BitMask.POLICY_OPT_COMPRESS_AUDIT_LOG) == SystemCode.BitMask.POLICY_OPT_COMPRESS_AUDIT_LOG);
			
			System.out.println(blnLoggingFail); //실패 로그 기록
			System.out.println(blnLoggingSuccess); //성공 로그 기록
			System.out.println(blnLogCompress); //로그 압축
			
			System.out.println(profileProtection.getNullEncryptYesNo()); //nullEncryptYesNo	NULL 암호화
			System.out.println(profileProtection.getPreventDoubleYesNo()); //preventDoubleYesNo	이중 암호화 방지
			System.out.println(profileProtection.getDenyResultTypeCode()); //denyResultTypeCode	접근 거부시 처리
			System.out.println(profileProtection.getDataTypeCode()); //dataTypeCode	데이터 타입

			
			
			JSONArray arrProfileCipherSpec = (JSONArray) map.get("ProfileCipherSpec");
			
			System.out.println(" ################# ProfileCipherSpec ################### ");
			
			if(arrProfileCipherSpec.size()>0) {
				for(int i=0; i<arrProfileCipherSpec.size(); i++) {
					JSONObject json = (JSONObject) arrProfileCipherSpec.get(i);
					
					ProfileCipherSpec profileCipherSpec = new ProfileCipherSpec();
					Gson gsonProfileCipherSpec = new Gson();
					profileCipherSpec = gsonProfileCipherSpec.fromJson(json.toJSONString(), profileCipherSpec.getClass());
					
					System.out.println(" specIndex : " + profileCipherSpec.getSpecIndex());
					System.out.println(" profileUid : " + profileCipherSpec.getProfileUid());
					System.out.println(" CipherAlgorithmCode : " + profileCipherSpec.getCipherAlgorithmCode());
					System.out.println(" CipherAlgorithmName : " + profileCipherSpec.getCipherAlgorithmName());
				}
			}
			

			
			
			JSONArray arrProfileAclSpec = (JSONArray) map.get("ProfileAclSpec");
			
			System.out.println(" ################# ProfileAclSpec ################### ");
			
			if(arrProfileAclSpec.size()>0) {
				for(int i=0; i<arrProfileAclSpec.size(); i++) {
					JSONObject json = (JSONObject) arrProfileAclSpec.get(i);
					
					ProfileAclSpec profileAclSpec = new ProfileAclSpec();
					Gson gsonProfileAclSpec = new Gson();
					profileAclSpec = gsonProfileAclSpec.fromJson(json.toJSONString(), profileAclSpec.getClass());

					System.out.println(" AclSpecSequence : " + profileAclSpec.getAclSpecSequence());
					System.out.println(" SpecOrder : " + profileAclSpec.getSpecOrder());
					System.out.println(" SpecName : " + profileAclSpec.getSpecName());
				}
			}
			

		} else {
			
		}

	}
	
	/**
	 * 보안정책 등록
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @throws Exception
	 */
	private void insertProfileProtection(String restIp, int restPort, String strTocken) throws Exception {

		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.POLICY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.INSERTPROFILEPROTECTION;

		ProfileProtection param1 = new ProfileProtection();
		param1.setProfileUid("57a20cfe-6e77-4a08-8e8f-4f328fa8a0e0");

		//JSONObject parameters = new JSONObject();
		//parameters.put("profile", vo);
		
		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(param1.getClass()), param1.toJSONString());

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
			
			Gson gson = new Gson();
			ProfileProtection profileProtection = new ProfileProtection();
			profileProtection = gson.fromJson(jsonProfileProtection.toJSONString(), profileProtection.getClass());
			
			System.out.println("보호 정책 이름 : " + profileProtection.getProfileName());
			System.out.println("보호 정책 설명 : " + profileProtection.getProfileNote());

			System.out.println(profileProtection.getCreateDateTime());
			System.out.println((boolean) profileProtection.getDefaultAccessAllowTrueFalse()); //	기본접근허용
			
			long optionBits = 0L;
			optionBits= (long) profileProtection.getOptionBits();
			
			//optionBits = Long.parseLong(strOptionBit);
			
			boolean blnLoggingFail = !((optionBits & SystemCode.BitMask.POLICY_OPT_NO_AUDIT_LOG_ON_FAIL) == SystemCode.BitMask.POLICY_OPT_NO_AUDIT_LOG_ON_FAIL);
			
			boolean blnLoggingSuccess= !((optionBits & SystemCode.BitMask.POLICY_OPT_NO_AUDIT_LOG_ON_SUCCESS) == SystemCode.BitMask.POLICY_OPT_NO_AUDIT_LOG_ON_SUCCESS);
			
			boolean blnLogCompress = ((optionBits & SystemCode.BitMask.POLICY_OPT_COMPRESS_AUDIT_LOG) == SystemCode.BitMask.POLICY_OPT_COMPRESS_AUDIT_LOG);
			
			System.out.println(blnLoggingFail); //실패 로그 기록
			System.out.println(blnLoggingSuccess); //성공 로그 기록
			System.out.println(blnLogCompress); //로그 압축
			
			System.out.println(profileProtection.getNullEncryptYesNo()); //nullEncryptYesNo	NULL 암호화
			System.out.println(profileProtection.getPreventDoubleYesNo()); //preventDoubleYesNo	이중 암호화 방지
			System.out.println(profileProtection.getDenyResultTypeCode()); //denyResultTypeCode	접근 거부시 처리
			System.out.println(profileProtection.getDataTypeCode()); //dataTypeCode	데이터 타입

			
			
			JSONArray arrProfileCipherSpec = (JSONArray) map.get("ProfileCipherSpec");
			
			System.out.println(" ################# ProfileCipherSpec ################### ");
			
			if(arrProfileCipherSpec.size()>0) {
				for(int i=0; i<arrProfileCipherSpec.size(); i++) {
					JSONObject json = (JSONObject) arrProfileCipherSpec.get(i);
					
					ProfileCipherSpec profileCipherSpec = new ProfileCipherSpec();
					Gson gsonProfileCipherSpec = new Gson();
					profileCipherSpec = gsonProfileCipherSpec.fromJson(json.toJSONString(), profileCipherSpec.getClass());
					
					System.out.println(" specIndex : " + profileCipherSpec.getSpecIndex());
					System.out.println(" profileUid : " + profileCipherSpec.getProfileUid());
					System.out.println(" CipherAlgorithmCode : " + profileCipherSpec.getCipherAlgorithmCode());
					System.out.println(" CipherAlgorithmName : " + profileCipherSpec.getCipherAlgorithmName());
				}
			}
			

			
			
			JSONArray arrProfileAclSpec = (JSONArray) map.get("ProfileAclSpec");
			
			System.out.println(" ################# ProfileAclSpec ################### ");
			
			if(arrProfileAclSpec.size()>0) {
				for(int i=0; i<arrProfileAclSpec.size(); i++) {
					JSONObject json = (JSONObject) arrProfileAclSpec.get(i);
					
					ProfileAclSpec profileAclSpec = new ProfileAclSpec();
					Gson gsonProfileAclSpec = new Gson();
					profileAclSpec = gsonProfileAclSpec.fromJson(json.toJSONString(), profileAclSpec.getClass());

					System.out.println(" AclSpecSequence : " + profileAclSpec.getAclSpecSequence());
					System.out.println(" SpecOrder : " + profileAclSpec.getSpecOrder());
					System.out.println(" SpecName : " + profileAclSpec.getSpecName());
				}
			}
			

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


		
		
		AuditLogSite param = new AuditLogSite();
		param.setSearchAgentLogDateTimeFrom("20180123000000"); 
		param.setSearchAgentLogDateTimeTo("20180123240000");
		param.setAgentUid("");
		param.setSuccessTrueFalse(true);
		param.setPageOffset(1);
		param.setPageSize(10);
		param.setTotalCountLimit(10001);
		
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


		
		
		AuditLog param = new AuditLog();
		param.setSearchLogDateTimeFrom("2018-01-24 00:00:00.000000"); 
		param.setSearchLogDateTimeTo("2018-01-24 23:59:59.999999");
		param.setEntityUid("");
		param.setResultCode("");

		param.setPageOffset(1);
		param.setPageSize(10);
		param.setTotalCountLimit(10001);
		
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
		
		if(resultCode.equals("0000000000")) {
			ArrayList list = (ArrayList) resultJson.get("list");
			
			System.out.println("list Size : " + list.size());
			
			for(int i=0; i<list.size(); i++) {
				JSONObject log = (JSONObject) list.get(i);
				
				Gson gson = new Gson();
				AuditLog auditLog = new AuditLog();
				auditLog = gson.fromJson(log.toJSONString(), auditLog.getClass());
				
				StringBuffer bf = new StringBuffer();
				
				//접근일시 createDateTime
				bf.append((i+1) + "접근일시 : " + auditLog.getCreateDateTime());
				//접근자이름 entityName
				String strEntityName = auditLog.getEntityName();
				//strEntityName.getBytes("UTF-8");
				//System.out.println(new String(strEntityName, ));
				
				if(strEntityName != null) {
					strEntityName = new String(strEntityName.getBytes("iso-8859-1"),"UTF-8"); 
					
					bf.append("접근자이름 : " + strEntityName);
				}
				//checkChar(strEntityName);
			
				//접근자주소 remoteAddress
				bf.append(" 접근자주소 : " + auditLog.getRemoteAddress());
				//접근경로  requestPath
				bf.append(" 접근경로 : " + auditLog.getRequestPath() );
				//본문 parameter
				bf.append(" 본문 : " + auditLog.getParameter() );
				//결과코드 resultCode
				bf.append(" 결과코드 : " + auditLog.getResultCode() );
				//결과메시지resultMessage
				bf.append(" 결과메시지 : " + auditLog.getResultMessage() );
				
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


		
		
		AuditLog param = new AuditLog();
		param.setKeyAccessOnly(true);
		param.setSearchLogDateTimeFrom("2018-01-24 00:00:00.000000"); 
		param.setSearchLogDateTimeTo("2018-01-24 23:59:59.999999");
		param.setEntityUid("");
		param.setResultCode("");

		param.setPageOffset(1);
		param.setPageSize(10);
		param.setTotalCountLimit(10001);
		
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
		
		resultMessage = new String(resultMessage.getBytes("iso-8859-1"),"UTF-8"); 
		
		System.out.println(resultMessage);
		
		if(resultCode.equals("0000000000")) {
			ArrayList list = (ArrayList) resultJson.get("list");
			
			System.out.println("list Size : " + list.size());
			
			for(int i=0; i<list.size(); i++) {
				JSONObject log = (JSONObject) list.get(i);
				
				Gson gson = new Gson();
				AuditLog auditLog = new AuditLog();
				auditLog = gson.fromJson(log.toJSONString(), auditLog.getClass());
				
				StringBuffer bf = new StringBuffer();
				
				//접근일시 createDateTime
				bf.append((i+1) + "접근일시 : " + auditLog.getCreateDateTime());
				//접근자이름 entityName
				String strEntityName = auditLog.getEntityName();
				//strEntityName.getBytes("UTF-8");
				//System.out.println(new String(strEntityName, ));
				
				if(strEntityName != null) {
					strEntityName = new String(strEntityName.getBytes("iso-8859-1"),"UTF-8"); 
					
					bf.append("접근자이름 : " + strEntityName);
				}
				//checkChar(strEntityName);
			
				//접근자주소 remoteAddress
				bf.append(" 접근자주소 : " + auditLog.getRemoteAddress());
				//접근경로  requestPath
				bf.append(" 접근경로 : " + auditLog.getRequestPath() );
				//본문 parameter
				bf.append(" 본문 : " + auditLog.getParameter() );
				//결과코드 resultCode
				bf.append(" 결과코드 : " + auditLog.getResultCode() );
				//결과메시지resultMessage
				bf.append(" 결과메시지 : " + auditLog.getResultMessage() );
				
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


		
		
		BackupLog param = new BackupLog();

		param.setBackupWorkType("");
		param.setSearchLogDateTimeFrom("2018-01-24 00:00:00.000000"); 
		param.setSearchLogDateTimeTo("2018-01-24 23:59:59.999999");
		param.setEntityUid("");
		
		param.setPageOffset(1);
		param.setPageSize(10);
		param.setTotalCountLimit(10001);
		
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
					JSONObject log = (JSONObject) list.get(i);
					
					Gson gson = new Gson();
					BackupLog backupLog = new BackupLog();
					backupLog = gson.fromJson(log.toJSONString(), backupLog.getClass());
					
					
					
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
					
					Gson gson = new Gson();
					CryptoKey cryptoKey = new CryptoKey();
					cryptoKey = gson.fromJson(data.toJSONString(), cryptoKey.getClass());

					StringBuffer bf = new StringBuffer();
					bf.append((i+1) + "키 식별자 : " + cryptoKey.getKeyUid());
					bf.append((i+1) + "키 이름 : " + cryptoKey.getResourceName());
					bf.append((i+1) + "ResourceUid : " + cryptoKey.getResourceUid());
					bf.append((i+1) + "유형 코드 : " + cryptoKey.getResourceTypeCode());
					bf.append((i+1) + "키 설명 : " + cryptoKey.getResourceNote());
					bf.append((i+1) + "유형 : " + cryptoKey.getResourceTypeName());
					bf.append((i+1) + "적용 알고리즘 : " + cryptoKey.getCipherAlgorithmName());
					bf.append((i+1) + "작성 일시 : " + cryptoKey.getCreateDateTime() );
					bf.append((i+1) + "작성자 : " + new String(cryptoKey.getCreateName().toString().getBytes("iso-8859-1"),"UTF-8"));
					bf.append((i+1) + "변경 일시 : " + cryptoKey.getUpdateDateTime());
					
					if(cryptoKey.getUpdateName() != null) {
					bf.append((i+1) + "변경 일시 : " + new String(cryptoKey.getUpdateName().toString().getBytes("iso-8859-1"),"UTF-8")); 
					}
					
					//CryptoKey data2 = (CryptoKey) list.get(i);
					
					//System.out.println(data2.getKeyUid());
					
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
		String resultMessage = new String(resultJson.get("resultMessage").toString().getBytes("iso-8859-1"),"UTF-8");
		
		System.out.println(resultMessage);
		
	}
	
	private void updateCryptoKeySymmetric(String restIp, int restPort, String strTocken) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.KEY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.UPDATECRYPTOKEYSYMMETRIC;


		CryptoKeySymmetric param = new CryptoKeySymmetric();
		param.setKeyUid("d66ebb08-4f76-4ddb-a193-c615a9ad9fb0");
		param.setResourceUid("d66ebb08-4f76-4ddb-a193-c615a9ad9fb0");
		param.setResourceName("ar");
		param.setCipherAlgorithmCode("CAR3");
		param.setResourceNote("testNote1");
		param.setKeyStatusCode("KS50");
		param.setRenew(false);
		param.setCopyBin(false);
		

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
		String resultMessage = new String(resultJson.get("resultMessage").toString().getBytes("iso-8859-1"),"UTF-8");
		
		System.out.println(resultMessage);
		
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
	
	/**
	 * 적용알고리즘 공통코드 조회
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @throws Exception
	 */
	private void selectSysCodeListExper(String restIp, int restPort, String strTocken) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

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
			
			//System.out.println("list Size : " + list.size());
			if(totalListCount > 0) {
				for(int i=0; i<list.size(); i++) {
					JSONObject data = (JSONObject) list.get(i);
					
					SysCode sysCode = new SysCode();
					Gson gson = new Gson();
					sysCode = gson.fromJson(data.toJSONString(), sysCode.getClass());
					
					System.out.println("syscode : " + sysCode.getSysCode());
					System.out.println("SysCodeName : " + sysCode.getSysCodeName());
					System.out.println("SysCodeValue : " + sysCode.getSysCodeValue());
					
				
					
				}
			
			}
		}
		
	}
	
	/**
	 * 일반 공통코드 리스트
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @throws Exception
	 */
	private void selectParamSysCodeList(String restIp, int restPort, String strTocken) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.SYSTEM_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTPARAMSYSCODELIST;

		String categoryKey = "DATA_TYPE_CD"; //데이터타입
		categoryKey = "DENY_RESULT_TYPE_CD"; //접근거부시 처리
		categoryKey = "INITIAL_VECTOR_TYPE"; //초기벡터
		categoryKey = "OPERATION_MODE"; //운영모드
		
		SysCode param = new SysCode();
//		param.setCategoryKey(categoryKey);

		

		HashMap body = new HashMap();
		//body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());
		body.put("categoryKey", categoryKey);
		
		String parameters = TypeUtility.makeRequestBody(body);
		
		System.out.println(parameters);

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
		//long totalListCount = (long) resultJson.get("totalListCount");
		
		
		if(resultCode.equals("0000000000")) {
			ArrayList list = (ArrayList) resultJson.get("list");
			
			//System.out.println("list Size : " + list.size());
			//if(totalListCount > 0) {
				for(int i=0; i<list.size(); i++) {
					JSONObject data = (JSONObject) list.get(i);
					
					SysCode sysCode = new SysCode();
					Gson gson = new Gson();
					sysCode = gson.fromJson(data.toJSONString(), sysCode.getClass());
					
					System.out.println("syscode : " + sysCode.getSysCode());
					System.out.println("SysCodeName : " + sysCode.getSysCodeName());
					System.out.println("SysCodeValue : " + sysCode.getSysCodeValue());
					
				
					
				}
			
			//}
		}
		
	}
	
	/**
	 * 접근자 리스트
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @throws Exception
	 */
	private void selectEntityList(String restIp, int restPort, String strTocken) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.ENTITY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTENTITYLIST;

		String monitored = "false"; 

		HashMap body = new HashMap();
		//body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());
		body.put("monitored", monitored);
		
		String parameters = TypeUtility.makeRequestBody(body);
		
		System.out.println(parameters);

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
		//long totalListCount = (long) resultJson.get("totalListCount");
		
		
		if(resultCode.equals("0000000000")) {
			ArrayList list = (ArrayList) resultJson.get("list");
			
			//System.out.println("list Size : " + list.size());
			//if(totalListCount > 0) {
				for(int i=0; i<list.size(); i++) {
					JSONObject data = (JSONObject) list.get(i);
					
					Entity entity = new Entity();
					Gson gson = new Gson();
					entity = gson.fromJson(data.toJSONString(), entity.getClass());
					
					System.out.println("getEntityUid : " + entity.getEntityUid());
					System.out.println("getEntityName : " + new String(entity.getEntityName().toString().getBytes("iso-8859-1"),"UTF-8") );

					
				
					
				}
			
			//}
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
