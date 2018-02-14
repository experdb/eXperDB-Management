package com.k4m.dx.tcontrol.cmmn.serviceproxy;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Base64;
import org.codehaus.jackson.map.ObjectMapper;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;

import com.google.gson.Gson;
import com.k4m.dx.tcontrol.cmmn.AES256_encryptor;
import com.k4m.dx.tcontrol.cmmn.crypto.Generator;
import com.k4m.dx.tcontrol.cmmn.crypto.Rfc2898DeriveBytes;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.AdminServerPasswordRequest;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.AuditLog;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.AuditLogSite;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.AuthCredentialToken;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.BackupLog;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.CryptoKey;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.CryptoKeySymmetric;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.Entity;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.EntityPermission;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.Profile;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.ProfileAclSpec;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.ProfileCipherSpec;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.ProfileProtection;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.SysCode;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.SystemUsage;


public class ServiceCallTest {

	public static void main(String[] args) throws Exception {

		String restIp = "222.110.153.204";
		int restPort = 9443;
		
		restIp = "127.0.0.1";
		restPort = 8443;
		
		String strTocken = "+nVKppjBPWJlrHUweC30uGVzhWop+LL2J85p9BIAHj8=";

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
		
		//에이전트 리스트
		
		
		//접근자리스트
		//test.selectEntityList(restIp, restPort, strTocken);
		
		// 보호정책상세 > 암호화 키 리스트
		//test.selectCryptoKeySymmetricList(restIp, restPort, strTocken);


		//test.selectProfileProtectionVersion(restIp, restPort, strTocken);
		
		//감사로그 > 암복호화로그
		//test.selectAuditLogSiteList(restIp, restPort, strTocken);
		
		//감사로그 > 관리서버 감사로그
		//test.selectAuditLogList(restIp, restPort, strTocken);
		
		//감사로그 > 암호화 키 접근로그
		//test.selectAuditLogListKey(restIp, restPort, strTocken);
		
		//감사로그 > 백업/복원 감사로그
		//test.selectBackupLogList(restIp, restPort, strTocken);
		
		//감사로그 > 자원 사용
		//test.selectSystemUsageLogList(restIp, restPort, strTocken);
		
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
		
		//보안정책 > 보안정책등록
		//test.insertProfileProtection(restIp, restPort, strTocken);
		
		//사용자 등록
		//test.insertEntityWithPermission(restIp, restPort, strTocken);
		
		//사용자 삭제
		//test.deleteEntity(restIp, restPort, strTocken);
		
		//test.decodeTest();
		
		//보호정책 상세 요일 display
		int workDay = 0;
		
		ContainsWeekDay(workDay, SystemCode.Weekday.MONDAY);
		
		ContainsWeekDay((int)workDay, SystemCode.Weekday.TUESDAY);
		ContainsWeekDay((int)workDay, SystemCode.Weekday.WEDNESDAY);
		ContainsWeekDay((int)workDay, SystemCode.Weekday.THURSDAY);
		ContainsWeekDay((int)workDay, SystemCode.Weekday.FRIDAY);
		ContainsWeekDay((int)workDay, SystemCode.Weekday.SATURDAY);
		ContainsWeekDay((int)workDay, SystemCode.Weekday.SUNDAY);
		
		
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
		//header.put(SystemCode.FieldName.LOGIN_ID, "admin");
		//header.put(SystemCode.FieldName.ENTITY_UID, "00000000-0000-0000-0000-000000000001");
		header.put(SystemCode.FieldName.LOGIN_ID, "testuser");
		header.put(SystemCode.FieldName.ENTITY_UID, "d06c0acb-ca3a-4324-83ed-71df370acdb3");
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
					
					System.out.println(" operationModeCode : " + profileCipherSpec.getOperationModeCode());
					System.out.println(" paddingMethodCode : " + profileCipherSpec.getPaddingMethodCode());
					System.out.println(" initialVectorTypeCode : " + profileCipherSpec.getInitialVectorTypeCode());
					System.out.println(" offset : " + profileCipherSpec.getOffset());
					System.out.println(" length : " + profileCipherSpec.getLength());
					System.out.println(" binUid : " + profileCipherSpec.getBinUid());
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
		//param1.setProfileUid("57a20cfe-6e77-4a08-8e8f-4f328fa8a0e0");
		
		param1.setProfileName("test_profile");
		param1.setProfileNote("profilenote");
		param1.setDataTypeCode("DTCH");
		param1.setBase64YesNo("Y");
		param1.setPreventDoubleYesNo("Y");
		param1.setNullEncryptYesNo("N");
		param1.setDenyResultTypeCode("DRER");
		param1.setMaskingValue("");
		
		long optionBits = 0;
		
		//실패 로그기록 체크가 아니면
		optionBits |= SystemCode.BitMask.POLICY_OPT_NO_AUDIT_LOG_ON_FAIL;
		
		//성공로그기록 체크가 아니면 
		optionBits |= SystemCode.BitMask.POLICY_OPT_NO_AUDIT_LOG_ON_SUCCESS;
		
		//로그압축 체크이면
		//optionBits |= SystemCode.BitMask.POLICY_OPT_COMPRESS_AUDIT_LOG;
		
		param1.setOptionBits(optionBits);
		
		param1.setDefaultAccessAllowTrueFalse(true);
		
		List param2 = new ArrayList();
		ProfileCipherSpec p = new ProfileCipherSpec();
		p.setSpecIndex(1);
		p.setCipherAlgorithmCode("CAD1");
		p.setOperationModeCode("OMCB");
		p.setInitialVectorTypeCode("IVFX");
		p.setOffset(1);
		p.setLength(null);
		p.setBinUid("20171027130442382_de351577-5b53-4265-8bee-a60289de88e2");
		
		param2.add(p.toJSONString());
		
		
		List param3 = new ArrayList();
		
		ProfileAclSpec r = new ProfileAclSpec();
		
		r.setSpecIndex(1); //row
		r.setSpecOrder(1); //row
		r.setSpecName("규칙2");
		r.setServerInstanceId("experdba"); //서버 인스턴스
		r.setServerLoginId("experdb");
		r.setAdminLoginId("experdb");				
		r.setApplicationName("");
		r.setExtraName("");
		r.setHostName("");
		r.setAccessAddress("");
		r.setAccessAddressMask("");
		r.setAccessMacAddress("");
		r.setStartDateTime("2018-02-01 00:00:00");
		r.setEndDateTime("9997-12-31 00:00:00");
		r.setStartTime("00:00:00");
		r.setEndTime("23:59:59");
		r.setOsLoginId("experdb");
		r.setMassiveTimeInterval(0);
		r.setMassiveThreshold(0);
		
		r.setWhitelistYesNo("Y");

		int workDay = SystemCode.Weekday.MONDAY
	    | SystemCode.Weekday.TUESDAY
	    | SystemCode.Weekday.WEDNESDAY
	    | SystemCode.Weekday.THURSDAY
	    | SystemCode.Weekday.FRIDAY
	    | SystemCode.Weekday.SATURDAY
	    | SystemCode.Weekday.SUNDAY;
		
		r.setWorkDay(workDay);
		
		param3.add(r.toJSONString());
		

		//JSONObject parameters = new JSONObject();
		//parameters.put("profile", vo);
		
		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(param1.getClass()), param1.toJSONString());
		body.put("ProfileCipherSpec", param2);
        body.put("ProfileAclSpec", param3);

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
		//header.put(SystemCode.FieldName.LOGIN_ID, "admin");
		//header.put(SystemCode.FieldName.PASSWORD, "password");
		
		header.put(SystemCode.FieldName.LOGIN_ID, "testuser");
		header.put(SystemCode.FieldName.PASSWORD, "1234qwer");

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
	 * 자원사용로그
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @throws Exception
	 */
	private void selectSystemUsageLogList(String restIp, int restPort, String strTocken) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.LOG_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTSYSTEMUSAGELOGLIST;


		
		SystemUsage param = new SystemUsage();

		param.setSearchDateTimeFrom("2018-01-24 00:00:00.000000"); 
		param.setSearchDateTimeTo("2018-01-24 23:59:59.999999");
		param.setMonitoredUid("admin");
		
		param.setPageOffset(1);
		param.setPageSize(10);

		
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
					SystemUsage systemUsage = new SystemUsage();
					systemUsage = gson.fromJson(log.toJSONString(), systemUsage.getClass());
					
					systemUsage.getSiteLogDateTime();
					systemUsage.getServerLogDateTime();
				
					
					System.out.println("모니터링 발생 일시 : " + systemUsage.getSiteLogDateTime());
					System.out.println("모니터링 기록 일시 : " + systemUsage.getServerLogDateTime());
					System.out.println("모니터링 대상 주소 : " + systemUsage.getMonitoredAddress());
					System.out.println("모니터링 대상 식별자 : " + systemUsage.getMonitoredUid());
					System.out.println("모니터링 대상 이름 : " + systemUsage.getMonitoredName());
					System.out.println("자원 유형 : " + systemUsage.getTargetResourceType());
					System.out.println("자원 : " + systemUsage.getTargetResource());
					System.out.println("모니터링 결과 : " + systemUsage.getResultLevel());
					System.out.println("사용률(%) : " + systemUsage.getUsageRate());
					System.out.println("모니터링 발생 일시 : " + systemUsage.getLimitRate());
					System.out.println("임계치(%) : " + systemUsage.getLogMessage());
					
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


		String validEndDateTime = "2020-02-09" + " 23:59:59.999999";
		
		CryptoKeySymmetric param = new CryptoKeySymmetric();
		param.setKeyUid("");
		param.setResourceUid("");
		param.setResourceName("test01");
		param.setCipherAlgorithmCode("CAD1");
		param.setResourceNote("testNote");
		param.setKeyStatusCode("KS50");
		param.setValidEndDateTime(validEndDateTime);

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
		//categoryKey = "INITIAL_VECTOR_TYPE"; //초기벡터
		//categoryKey = "OPERATION_MODE"; //운영모드
		//categoryKey = "KEY_STATUS_CD"; //바이너리
		
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
	
	/**
	 * 에이전트 리스트
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @throws Exception
	 */
	private void selectEntityList2(String restIp, int restPort, String strTocken) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.ENTITY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTENTITYLIST;

		String monitored = "false"; 
		
		Entity param = new Entity();
		param.setEntityTypeCode(SystemCode.EntityTypeCode.AGENT);

		HashMap body = new HashMap();
		//body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());
		body.put("monitored", monitored);
		body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());
		
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
	
	/**
	 * 보호정책상세 > 암호화 키 리스트
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @throws Exception
	 */
	private void selectCryptoKeySymmetricList(String restIp, int restPort, String strTocken) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.KEY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTCRYPTOKEYSYMMETRICLIST;


		
		
		CryptoKeySymmetric param = new CryptoKeySymmetric();

		
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
					JSONObject jsonData = (JSONObject) list.get(i);
					
					Gson gson = new Gson();
					CryptoKeySymmetric cryptoKeySymmetric = new CryptoKeySymmetric();
					cryptoKeySymmetric = gson.fromJson(jsonData.toJSONString(), cryptoKeySymmetric.getClass());
					
					System.out.println("getBinName : " + cryptoKeySymmetric.getBinName());
					System.out.println("getBinUid : " + cryptoKeySymmetric.getBinUid());
					
				}
			
			}
		}
		
	}
	
	/**
	 * 사용자 등록
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @throws Exception
	 */
	private void insertEntityWithPermission(String restIp, int restPort, String strTocken) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.ENTITY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.INSERTENTITYWITHPERMISSION;

		String strUserId = "testuser";
		String password = "1234qwer";
		
		Entity param1 = new Entity();

		param1.setEntityName("이름");
		param1.setContainerTypeCode(SystemCode.ContainerTypeCode.ELEMENT);
		param1.setEntityTypeCode(SystemCode.EntityTypeCode.ADMIN_USER);
		param1.setEntityStatusCode("ES50");
		param1.setCreateUid("admin");
		
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
		
		
	}
	
	/**
	 * 사용자 삭제
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @throws Exception
	 */
	private void deleteEntity(String restIp, int restPort, String strTocken) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.ENTITY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.DELETEENTITY;

		String entityUid = "6165b677-7289-4df5-a747-88d847628f10";
		
		Entity param1 = new Entity();

		param1.setEntityUid(entityUid);

		if (entityUid.startsWith("00000000-0000-0000-0000-"))
		{
			throw new Exception ("기본 관리자는 삭제할 수 없습니다.");
		}
		
	
		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(param1.getClass()), param1.toJSONString());
		
	
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
	
	private void decodeTest() throws Exception {
		int myIteration = 200000;
		int AES_KEY_SIZE = 16;
		int MASTER_KEY_SIZE = 32;
				
				
				
		String loadStr = "{\"mas\":\"uMbslqhNKDQrvs/RcPluZcenWtOrYLmZ8Wc+6Zs4xk1npKFX50HgPvlKSi9+CPIP\",\"ter\":\"kWlRZF2SkyTRXDL7eqDdIQ==\",\"key\":\"UW0IxVLs9S7e1vFdIWSTcpXwU4EuZvHmegHYZv59dpg=\"}";
		
		JSONParser parser = new JSONParser();
		JSONObject json = (JSONObject) parser.parse(loadStr);
		
		//Rfc2898DeriveBytes key = new Rfc2898DeriveBytes("password", Base64.encodeBase64(json.get("key")))
		
		String masterStrEnc = json.get("mas").toString();
		String iv = json.get("ter").toString();
		String salt = json.get("key").toString();
		
		byte[] byteIv = Base64.decodeBase64(iv);
		//byte[] byMasterStrEnc = Base64.decodeBase64(masterStrEnc);
		
		String password = "1234qwer";
		//String strTxt = "password";

		
		Rfc2898DeriveBytes key = new Rfc2898DeriveBytes(password, Base64.decodeBase64(salt), myIteration);
		//key.getBytes(AES_KEY_SIZE);

		byte[] byMasterStrEnc = Base64.decodeBase64(masterStrEnc);
		//byte[] bySalt = Base64.decodeBase64(salt.getBytes());
		AESCrypt aes = new AESCrypt(password, key.getBytes(AES_KEY_SIZE));
		
		//byte[] strEnc = aes.encrypt(strTxt);
		//String decryptedText = aes.decrypt(strEnc).toString(); 
		//System.out.println(strEnc);
		
		String decryptedText = aes.decrypt(byMasterStrEnc, byteIv).toString(); 
		
		//checkChar(decryptedText);
		
		System.out.println(decryptedText);
		

	}
	
	private void encTest() throws Exception {
		int MASTER_KEY_SIZE = 32;
		
		byte[] masterStr = new byte[MASTER_KEY_SIZE];
		masterStr = Generator.generateRandomBits(MASTER_KEY_SIZE);
		
	}
	
	/**
	 * 보호정책 상세 요일 display
	 * @param input
	 * @param weekDay
	 * @return
	 */
	private static boolean ContainsWeekDay(int input, int weekDay)
	{
		if ((input & weekDay) == weekDay)
		{
			return true;
		}
		return false;
	}
	
}
