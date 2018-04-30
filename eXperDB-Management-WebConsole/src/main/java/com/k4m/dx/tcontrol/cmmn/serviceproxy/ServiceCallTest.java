package com.k4m.dx.tcontrol.cmmn.serviceproxy;

import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;

import com.google.gson.Gson;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.AdminServerPasswordRequest;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.AuditLog;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.AuditLogSite;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.AuditLogSiteStatCondition;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.AuthCredentialToken;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.BackupLog;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.CryptoKey;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.CryptoKeySymmetric;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.Entity;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.EntityPermission;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.MasterKeyFile;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.Profile;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.ProfileAclSpec;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.ProfileCipherSpec;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.ProfileProtection;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.SysCode;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.SysConfig;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.SysMultiValueConfig;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.SystemUsage;


/**
* @author 박태혁
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2018.04.23   박태혁 최초 생성
*      </pre>
*/

public class ServiceCallTest {

	public static void main(String[] args) throws Exception {

		String restIp = "222.110.153.204";
		int restPort = 9443;
		
		restIp = "127.0.0.1";

		restPort = 9443;
		
		restIp = "222.110.153.214";

		
		String loginId = "";
		String entityId = "";
		String password = "";
		
		loginId = "admin";
		password = "experdb12#";
		//password = "password";
		entityId = "00000000-0000-0000-0000-000000000001";
		
		//loginId = "testuser";
		//password = "1234qwer";
		//entityId = "d06c0acb-ca3a-4324-83ed-71df370acdb3";


		String strTocken = "r5DWdylMR8XzbUfmHD9PtHdZWXwVIlt9ODZcRnJ1JYg=";


		ServiceCallTest test = new ServiceCallTest();
	
		//test.loginTest(restIp, restPort, loginId, password);
		
		//마스터키 로드
		//test.loadServerKey(restIp, restPort, strTocken, loginId, entityId);
		
		//test.encTest();
		
		//String userId = "admin"; //검색할 User Id
		//test.selectEntityUid(restIp, restPort, strTocken, loginId, entityId, userId);
		
		//서버상태
		//test.selectServerStatus(restIp, restPort, strTocken, loginId, entityId);
		
		//공통코드 리스트
		//test.selectSysCodeList(restIp, restPort, strTocken, loginId, entityId);
		
		//적용알고리즘 공통코드
		//test.selectSysCodeListExper(restIp, restPort, strTocken, loginId, entityId);
		
		//일반공통코드 리스트
		//test.selectParamSysCodeList(restIp, restPort, strTocken, loginId, entityId);
		
		//에이전트 리스트
		
		
		//접근자리스트
		//test.selectEntityList(restIp, restPort, strTocken, loginId, entityId);
		
		//에이전트 정보
		//test.selectEntityList2(restIp, restPort, strTocken, loginId, entityId);
		
		// 보호정책상세 > 암호화 키 리스트
		//test.selectCryptoKeySymmetricList(restIp, restPort, strTocken, loginId, entityId);


		//test.selectProfileProtectionVersion(restIp, restPort, strTocken, loginId, entityId);
		
		//감사로그 > 암복호화로그
		//test.selectAuditLogSiteList(restIp, restPort, strTocken, loginId, entityId);
		
		//감사로그 > 관리서버 감사로그
		//test.selectAuditLogList(restIp, restPort, strTocken, loginId, entityId);
		
		//감사로그 > 암호화 키 접근로그
		//test.selectAuditLogListKey(restIp, restPort, strTocken, loginId, entityId);
		
		//감사로그 > 백업/복원 감사로그
		//test.selectBackupLogList(restIp, restPort, strTocken, loginId, entityId);
		
		//감사로그 > 자원 사용
		//test.selectSystemUsageLogList(restIp, restPort, strTocken, loginId, entityId);
		
		//보안정책 > 정책관리
		//test.selectProfileList(restIp, restPort, strTocken, loginId, entityId);
		
		//보안정책 > 보안정책 상세
		//test.selectProfileProtectionContents(restIp, restPort, strTocken, loginId, entityId);
		
		//암호화키 > 암호화키리스트
		//test.selectCryptoKeyList(restIp, restPort, strTocken, loginId, entityId);
		
		//암호화키 > 암호화 키 등록
		//test.insertCryptoKeySymmetric(restIp, restPort, strTocken, loginId, entityId);
		
		//암호화키 > 암호화 키 수정
		//test.updateCryptoKeySymmetric(restIp, restPort, strTocken, loginId, entityId);
		
		//암호화키 > 암호화 키 삭제
		//test.deleteCryptoKeySymmetric(restIp, restPort, strTocken, loginId, entityId);
		
		//보안정책 > 보안정책등록
		//test.insertProfileProtection(restIp, restPort, strTocken, loginId, entityId);
		
		//사용자 등록
		//test.insertEntityWithPermission(restIp, restPort, strTocken, loginId, entityId);
		
		//사용자 삭제
		//test.deleteEntity(restIp, restPort, strTocken, loginId, entityId);
		
		//test.decodeTest();
		
		//보호정책 상세 요일 display
		/*int workDay = 0;
		
		ContainsWeekDay(workDay, SystemCode.Weekday.MONDAY);
		
		ContainsWeekDay((int)workDay, SystemCode.Weekday.TUESDAY);
		ContainsWeekDay((int)workDay, SystemCode.Weekday.WEDNESDAY);
		ContainsWeekDay((int)workDay, SystemCode.Weekday.THURSDAY);
		ContainsWeekDay((int)workDay, SystemCode.Weekday.FRIDAY);
		ContainsWeekDay((int)workDay, SystemCode.Weekday.SATURDAY);
		ContainsWeekDay((int)workDay, SystemCode.Weekday.SUNDAY);*/
		
		//설정 > 보안정책 옵션 설정 조회1
		//test.selectSysConfigListLike(restIp, restPort, strTocken, loginId, entityId);
		
		//설정 > 보안정책 옵션 설정 조회2
		//test.selectSysMultiValueConfigListLike(restIp, restPort, strTocken, loginId, entityId);
		
		//설정 > 보안정책 옵션 설정 저장
		//test.sysConfigSave(restIp, restPort, strTocken, loginId, entityId);
		
		//설정 > 암호화 설정 조회
		//test.selectSysMultiValueConfigListLike2(restIp, restPort, strTocken, loginId, entityId);
		
		//설정 > 암호화 설정 저장
		//test.updateSysMultiValueConfigList2(restIp, restPort, strTocken, loginId, entityId);
		
		//test.selectEntityList2(restIp, restPort, strTocken, loginId, entityId);
		
		//test.selectEntityUid(restIp, restPort, strTocken, loginId, entityId, loginId);
		
		//암호화 통계
		test.selectAuditLogSiteHourForStat(restIp, restPort, strTocken, loginId, entityId);
		
	}

	/**
	 * 보안정책 > 보안정책관리
	 * @param restIp
	 * @param restPort
	 * @throws Exception
	 */
	private void selectProfileList(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {

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
		//header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		//header.put(SystemCode.FieldName.ENTITY_UID, entityId);
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
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
	private void selectProfileProtectionContents(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {

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
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
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
	private void insertProfileProtection(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {

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
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);

		JSONObject resultJson = api.callService(strService, strCommand, header, parameters);
		

		String resultCode = (String) resultJson.get("resultCode");
		String resultMessage = (String) resultJson.get("resultMessage");
		resultMessage = new String(resultMessage.getBytes("iso-8859-1"),"UTF-8"); 
		
		System.out.println("resultCode : " + resultCode + " resultMessage : " + resultMessage);
		


	}
	
	/**
	 * 보안정책 삭제
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @param loginId
	 * @param entityId
	 * @throws Exception
	 */
	private void deleteProfileProtection(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.POLICY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.DELETEPROFILEPROTECTION;


		ProfileProtection param = new ProfileProtection();

		String strProfileUid = "";
		
		param.setProfileUid(strProfileUid);

		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());

		String parameters = TypeUtility.makeRequestBody(body);
		

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
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
	
	private void selectProfileProtectionVersion(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.POLICY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTPROFILEPROTECTIONVERSION;


		//JSONObject parameters = new JSONObject();
		
		String parameters = "";


		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
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
	private void loginTest(String restIp, int restPort, String loginId, String password) throws Exception {

		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.AUTH_SERVICE;
		String strCommand = SystemCode.ServiceCommand.LOGIN;

		//JSONObject parameters = new JSONObject();
		// parameters.put("name", strName);
		// parameters.put("config", config)
		String parameters = "";

		HashMap header = new HashMap();
		//header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		//header.put(SystemCode.FieldName.PASSWORD, "password");
		
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.PASSWORD, password);

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
	private void selectAuditLogSiteList(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {
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
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
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
	private void selectAuditLogList(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {
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
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
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
	private void selectAuditLogListKey(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {
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
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
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
	private void selectBackupLogList(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {
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
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
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
	private void selectSystemUsageLogList(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.LOG_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTSYSTEMUSAGELOGLIST;


		
		SystemUsage param = new SystemUsage();

		param.setSearchDateTimeFrom("2018-01-24 00:00:00.000000"); 
		param.setSearchDateTimeTo("2018-01-24 23:59:59.999999");
		param.setMonitoredUid(loginId);
		
		param.setPageOffset(1);
		param.setPageSize(10);

		
		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());

		String parameters = TypeUtility.makeRequestBody(body);
		

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
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
	private void loadServerKey(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {

		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.SYSTEM_SERVICE;
		String strCommand = SystemCode.ServiceCommand.LOADSERVERKEY;
		
		String oldPassword = "1234qwer";
		oldPassword = "G/ZxwqSxwaItGGyG+oUOUgDaq8pakhb/vj7TK7OriPA=";

		AdminServerPasswordRequest adminServerPasswordRequest = new AdminServerPasswordRequest();
		adminServerPasswordRequest.setOldPassword(oldPassword);

		//JSONObject parameters = new JSONObject();
		//parameters.put("profile", vo);
		
		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(adminServerPasswordRequest.getClass()), adminServerPasswordRequest.toJSONString());

		String parameters = TypeUtility.makeRequestBody(body);

		HashMap header = new HashMap();
		//header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		//header.put(SystemCode.FieldName.ENTITY_UID, entityId);
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);
		
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);

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
	 * 마스터키 설정
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @param loginId
	 * @param entityId
	 * @throws Exception
	 */
	private void changeServerKey(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {

		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.SYSTEM_SERVICE;
		String strCommand = SystemCode.ServiceCommand.CHANGESERVERKEY;
		
		String oldPassword = "1234qwer";
		oldPassword = "marm13+irhFlLcINs7nlIQhKacF88OUybxqcXwRAptg=";
		
		String newPassword = "1234qwer";

		AdminServerPasswordRequest adminServerPasswordRequest = new AdminServerPasswordRequest();
		adminServerPasswordRequest.setOldPassword(oldPassword);
		adminServerPasswordRequest.setNewPassword(newPassword);

		//JSONObject parameters = new JSONObject();
		//parameters.put("profile", vo);
		
		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(adminServerPasswordRequest.getClass()), adminServerPasswordRequest.toJSONString());

		String parameters = TypeUtility.makeRequestBody(body);

		HashMap header = new HashMap();
		//header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		//header.put(SystemCode.FieldName.ENTITY_UID, entityId);
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);
		
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);

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
	private void selectServerStatus(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {

		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.SYSTEM_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTSERVERSTATUS;
		
		String oldPassword = "password";

		AdminServerPasswordRequest adminServerPasswordRequest = new AdminServerPasswordRequest();


		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(adminServerPasswordRequest.getClass()), adminServerPasswordRequest.toJSONString());

		String parameters = TypeUtility.makeRequestBody(body);

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
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
	private void selectCryptoKeyList(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.KEY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTCRYPTOKEYLIST;


		
		
		CryptoKey param = new CryptoKey();
		param.setKeyTypeCode(SystemCode.KeyTypeCode.SYMMETRIC);
		

		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());

		String parameters = TypeUtility.makeRequestBody(body);
		

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
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
	private void insertCryptoKeySymmetric(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {
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
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
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
	 * 암호화 키 삭제
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @throws Exception
	 */
	private void deleteCryptoKeySymmetric(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.KEY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.DELETECRYPTOKEYSYMMETRIC;


		String validEndDateTime = "2020-02-09" + " 23:59:59.999999";
		
		CryptoKeySymmetric param = new CryptoKeySymmetric();
		param.setKeyUid("");
		param.setResourceName("test01");
		param.setResourceTypeCode("");

		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());

		String parameters = TypeUtility.makeRequestBody(body);
		

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
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
	 * 암호화키 > 암호화 키 수정
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @param loginId
	 * @param entityId
	 * @throws Exception
	 */
	private void updateCryptoKeySymmetric(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {
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
		
		
		ArrayList param2 = new ArrayList();
		
		for(int i=0; i< 3; i++) {
			CryptoKeySymmetric key = new CryptoKeySymmetric();
			key.setBinUid("");
			key.setBinStatusCode("");
			key.setValidEndDateTime("");
			
			param2.add(key.toJSONString());
		}
		

		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());
		body.put("CryptoKeySymmetricList", param2);

		String parameters = TypeUtility.makeRequestBody(body);
		

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
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
	private void selectSysCodeList(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.SYSTEM_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTSYSCODELIST;


		

		HashMap body = new HashMap();
		//body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());

		String parameters = TypeUtility.makeRequestBody(body);
		

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
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
	private void selectSysCodeListExper(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.SYSTEM_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTCIPHERSYSCODELIST;

		SysCode param = new SysCode();
		//param.setCategoryKey(categoryKey);

		HashMap body = new HashMap();
		//body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());

		String parameters = TypeUtility.makeRequestBody(body);
		

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
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
	private void selectParamSysCodeList(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.SYSTEM_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTPARAMSYSCODELIST;

		String categoryKey = "DATA_TYPE_CD"; //데이터타입
		//categoryKey = "DENY_RESULT_TYPE_CD"; //접근거부시 처리
		//categoryKey = "INITIAL_VECTOR_TYPE"; //초기벡터
		//categoryKey = "OPERATION_MODE"; //운영모드
		//categoryKey = "KEY_STATUS_CD"; //바이너리
		
		categoryKey = "ENTITY_STATUS_CD"; //
		
		SysCode param = new SysCode();
//		param.setCategoryKey(categoryKey);

		

		HashMap body = new HashMap();
		//body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());
		body.put("categoryKey", categoryKey);
		
		String parameters = TypeUtility.makeRequestBody(body);
		
		System.out.println(parameters);

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
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
		
		System.out.println("resultCode : " + resultCode + " resultMessage : " + resultMessage);
		
		
		if(resultCode.equals("0000000000")) {
			ArrayList list = (ArrayList) resultJson.get("list");
			
			//System.out.println("list Size : " + list.size());
			//if(totalListCount > 0) {
				for(int i=0; i<list.size(); i++) {
					JSONObject data = (JSONObject) list.get(i);
					
					SysCode sysCode = new SysCode();
					Gson gson = new Gson();
					sysCode = gson.fromJson(data.toJSONString(), sysCode.getClass());
					
					if(sysCode.getSysStatusCode().equals("SS50")) {
					System.out.println("getSysStatusCode : " + sysCode.getSysStatusCode());
					System.out.println("syscode : " + sysCode.getSysCode());
					System.out.println("SysCodeName : " + sysCode.getSysCodeName());
					System.out.println("SysCodeValue : " + sysCode.getSysCodeValue());
					}
					
				
					
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
	private void selectEntityList(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {
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
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
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
	private void selectEntityList2(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {
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
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
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
					
					Entity entity = new Entity();
					Gson gson = new Gson();
					entity = gson.fromJson(data.toJSONString(), entity.getClass());
					
					System.out.println("getEntityUid : " + entity.getEntityUid());
					System.out.println("getEntityName : " + new String(entity.getEntityName().toString().getBytes("iso-8859-1"),"UTF-8") );

					
				
					
				}
			
			}
		}
		
	}
	
	/**
	 * 보호정책상세 > 암호화 키 리스트
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @throws Exception
	 */
	private void selectCryptoKeySymmetricList(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.KEY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTCRYPTOKEYSYMMETRICLIST;


		
		
		CryptoKeySymmetric param = new CryptoKeySymmetric();

		
		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());

		String parameters = TypeUtility.makeRequestBody(body);
		

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
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
	private void insertEntityWithPermission(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.ENTITY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.INSERTENTITYWITHPERMISSION;

		String strUserId = loginId;
		String password = "1234qwer";
		
		Entity param1 = new Entity();

		param1.setEntityName("이름");
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
		
		System.out.println(parameters);

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
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
	private void deleteEntity(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {
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
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
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
	 * 설정 > 보안정책 옵션 설정 조회
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @throws Exception
	 */
	private void selectSysConfigListLike(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {

		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.SYSTEM_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTSYSCONFIGLISTLIKE;

		
		HashMap body = new HashMap();
		body.put(SystemCode.CustomFormParamKey.sysConfigKeyPrefix, SystemCode.SysConfigKeyPrefix.GLOBAL_POLICY);

		String parameters = TypeUtility.makeRequestBody(body);

		HashMap header = new HashMap();
		//header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		//header.put(SystemCode.FieldName.ENTITY_UID, entityId);
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);

		JSONObject resultJson = api.callService(strService, strCommand, header, parameters);
		

		String resultCode = (String) resultJson.get("resultCode");
		String resultMessage = (String) resultJson.get("resultMessage");
		resultMessage = new String(resultMessage.getBytes("iso-8859-1"),"UTF-8"); 
		
		System.out.println("resultCode : " + resultCode + " resultMessage : " + resultMessage);
		
/*		GLOBAL_POLICY_DEFAULT_ACCESS_ALLOW_TF(기본 접근 허용) : 0, 1
		GLOBAL_POLICY_FORCED_LOGGING_OFF_TF(암복호화 로그 기록 중지) : 0, 1
		GLOBAL_POLICY_BOOST_TF(부스트) : True, False
		GLOBAL_POLICY_CRYPT_LOG_TM_RESOLUTION(암복호화 로그 서버에서 압축 시간 )
		GLOBAL_POLICY_CRYPT_LOG_COMPRESS_LIMIT(암복호화 로그 AP에서 최대 압축값)
		GLOBAL_POLICY_CRYPT_LOG_COMPRESS_FLUSH_TIMEOUT(암복호화 로그 압축 중단 시간 )
		GLOBAL_POLICY_CRYPT_LOG_COMPRESS_INITIAL(암복호화 로그 압축 시작값)
		GLOBAL_POLICY_CRYPT_LOG_COMPRESS_PRINT_PERIOD(암복호화 로그 압축 출력 시간 )*/
		
		if(resultCode.equals(SystemCode.ResultCode.SUCCESS)) {
			
			ArrayList list = (ArrayList) resultJson.get("list");
			for (int j = 0; j < list.size(); j++) {
				JSONObject jsonObj = (JSONObject) list.get(j);
				
				String strConfigKey = (String) jsonObj.get("configKey");
				String strConfigValue = (String) jsonObj.get("configValue"); 
				System.out.println("strConfigKey : " + strConfigKey + " - strConfigValue : " + strConfigValue);

			}
			
		} else {
			
		}

	}
	
	/**
	 * 설정 > 보안정책 옵션 설정 조회2
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @throws Exception
	 */
	private void selectSysMultiValueConfigListLike(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {
		
		int[] numWeek = { SystemCode.Weekday.MONDAY,
				 SystemCode.Weekday.TUESDAY,
				 SystemCode.Weekday.WEDNESDAY,
				 SystemCode.Weekday.THURSDAY,
				 SystemCode.Weekday.FRIDAY,
				 SystemCode.Weekday.SATURDAY,
				 SystemCode.Weekday.SUNDAY };

		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.SYSTEM_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTSYSMULTIVALUECONFIGLISTLIKE;

		
		HashMap body = new HashMap();
		body.put(SystemCode.CustomFormParamKey.sysConfigKeyPrefix, SystemCode.SysConfigKeyPrefix.BATCH_LOG);

		String parameters = TypeUtility.makeRequestBody(body);

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);

		JSONObject resultJson = api.callService(strService, strCommand, header, parameters);
		

		String resultCode = (String) resultJson.get("resultCode");
		String resultMessage = (String) resultJson.get("resultMessage");
		resultMessage = new String(resultMessage.getBytes("iso-8859-1"),"UTF-8"); 
		
		System.out.println("resultCode : " + resultCode + " resultMessage : " + resultMessage);
		
/*		GLOBAL_POLICY_DEFAULT_ACCESS_ALLOW_TF(기본 접근 허용) : 0, 1
		GLOBAL_POLICY_FORCED_LOGGING_OFF_TF(암복호화 로그 기록 중지) : 0, 1
		GLOBAL_POLICY_BOOST_TF(부스트) : True, False
		GLOBAL_POLICY_CRYPT_LOG_TM_RESOLUTION(암복호화 로그 서버에서 압축 시간 )
		GLOBAL_POLICY_CRYPT_LOG_COMPRESS_LIMIT(암복호화 로그 AP에서 최대 압축값)
		GLOBAL_POLICY_CRYPT_LOG_COMPRESS_FLUSH_TIMEOUT(암복호화 로그 압축 중단 시간 )
		GLOBAL_POLICY_CRYPT_LOG_COMPRESS_INITIAL(암복호화 로그 압축 시작값)
		GLOBAL_POLICY_CRYPT_LOG_COMPRESS_PRINT_PERIOD(암복호화 로그 압축 출력 시간 )*/
		
		if(resultCode.equals(SystemCode.ResultCode.SUCCESS)) {
			
			ArrayList list = (ArrayList) resultJson.get("list");
			for (int j = 0; j < list.size(); j++) {
				JSONObject jsonObj = (JSONObject) list.get(j);
				
				SysMultiValueConfig sysMultiValueConfig = new SysMultiValueConfig();
				Gson gson = new Gson();
				sysMultiValueConfig = gson.fromJson(jsonObj.toJSONString(), sysMultiValueConfig.getClass());
				
				String strConfigKey = (String) sysMultiValueConfig.getConfigKey();
				boolean blnIsvalueTrueFalse = sysMultiValueConfig.isValueTrueFalse();
				String strValueString = sysMultiValueConfig.getValueString();
				
				BigDecimal bdValueNumber = sysMultiValueConfig.getValueNumber();
				BigDecimal bdValueNumber2 = sysMultiValueConfig.getValueNumber2();
				
				System.out.println("strConfigKey : " + strConfigKey);
				if(strConfigKey.equals(SystemCode.SysConfigKey.BATCH_LOG_CONF)) {
					
					//1. 암복호화 로그를 지정되 시간에만 수집 체크박스 체크여부 = blnIsvalueTrueFalse
					System.out.println("blnIsvalueTrueFalse : " + blnIsvalueTrueFalse);
					
					int weekday = Integer.parseInt(strValueString, 16);
					for (int i = 0; i < 7; i++)
					{
						System.out.println(i + " " + ContainsWeekDay(weekday, numWeek[i]));
						if (ContainsWeekDay(weekday, numWeek[i])) {
							//요일 체크밗스 checked = checked
						} else {
							//요일 체크밗스 checked = ""
						}
							
					}
					
					//전송 시작 - bdValueNumber
					//전송 종료 - bdValueNumber2
					System.out.println("전송 시작 : " + bdValueNumber);
					System.out.println("전송 종료 : " + bdValueNumber2);
					
				} else if(strConfigKey.equals(SystemCode.SysConfigKey.BATCH_LOG_UPLOAD_DELAY)) {
					//암복호화 로그 전송 대기 시간 
					System.out.println("암복호화 로그 전송 대기 시간 : " + bdValueNumber);
				}

			}
			
		} else {
			
		}

	}
	
	/**
	 * 암호화 설정조회
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @param loginId
	 * @param entityId
	 * @throws Exception
	 */
	private void selectSysMultiValueConfigListLike2(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {
		
		int[] numWeek = { SystemCode.Weekday.MONDAY,
				 SystemCode.Weekday.TUESDAY,
				 SystemCode.Weekday.WEDNESDAY,
				 SystemCode.Weekday.THURSDAY,
				 SystemCode.Weekday.FRIDAY,
				 SystemCode.Weekday.SATURDAY,
				 SystemCode.Weekday.SUNDAY };

		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.SYSTEM_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTSYSMULTIVALUECONFIGLISTLIKE;

		
		HashMap body = new HashMap();
		body.put(SystemCode.CustomFormParamKey.sysConfigKeyPrefix, SystemCode.SysConfigKeyPrefix.MONITORING);

		String parameters = TypeUtility.makeRequestBody(body);

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
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
				
				SysMultiValueConfig sysMultiValueConfig = new SysMultiValueConfig();
				Gson gson = new Gson();
				sysMultiValueConfig = gson.fromJson(jsonObj.toJSONString(), sysMultiValueConfig.getClass());
				
				String strConfigKey = (String) sysMultiValueConfig.getConfigKey();
				boolean blnIsvalueTrueFalse = sysMultiValueConfig.isValueTrueFalse();
				String strValueString = sysMultiValueConfig.getValueString();
				
				BigDecimal bdValueNumber = sysMultiValueConfig.getValueNumber();
				BigDecimal bdValueNumber2 = sysMultiValueConfig.getValueNumber2();
				
				System.out.println("strConfigKey : " + strConfigKey);
				if(strConfigKey.equals(SystemCode.SysConfigKey.MONITOR_POLLING_SERVER)) {
					
					System.out.println("관리서버 모니터링 주기 : " + bdValueNumber);
				} else if(strConfigKey.equals(SystemCode.SysConfigKey.MONITOR_POLLING_AGENT)) {
					System.out.println("정책전송 중지 : " + blnIsvalueTrueFalse);
					System.out.println("에이전트와 관리서버 통신 주기 : " + bdValueNumber);
				} else if(strConfigKey.equals(SystemCode.SysConfigKey.MONITOR_EXPIRE_CRYPTO_KEY)) {

					System.out.println("암호화 키의 유효기간이 다음 날짜 이하로 남으면 경고 : " + bdValueNumber);
				} else if(strConfigKey.equals(SystemCode.SysConfigKey.MONITOR_AGENT_AUDIT_LOG_HMAC)) {

					System.out.println("에이전트가 기록하는 로그에 위변조 방지를 적용 : " + blnIsvalueTrueFalse);
				}
				
				

			}
			
		} else {
			
		}

	}
	
	/**
	 * 보안정책 옵션 설정 저장
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @param loginId
	 * @param entityId
	 * @throws Exception
	 */
	private void sysConfigSave(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {
		updateSysConfigList(restIp, restPort, strTocken, loginId, entityId);
		
		updateSysMultiValueConfigList(restIp, restPort, strTocken, loginId, entityId);
		
	}
	
	/**
	 * 보안정책 옵션 설정 저장1
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @param loginId
	 * @param entityId
	 * @throws Exception
	 */
	private void updateSysConfigList(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.SYSTEM_SERVICE;
		String strCommand = SystemCode.ServiceCommand.UPDATESYSCONFIGLIST;
		
		//if(암복호화 로그 서버에서 압축 시간 < 암복호화 로그 압축 출력 시간 ) [{0}]값은 [{1}]보다 크거나 같아야 합니다"
		//if(암복호화 로그 압축 중단 시간 <= 암복호화 로그 압축 출력 시간 ) [{0}]값은 [{1}]보다 커야 합니다
		
		List param = new ArrayList();
		
		//기본 접근 허용
		SysConfig defaultAccessAllow = new SysConfig();
		defaultAccessAllow.setConfigKey(SystemCode.SysConfigKey.GLOBAL_POLICY_DEFAULT_ACCESS_ALLOW_TF);
		defaultAccessAllow.setConfigValue("0"); //체크면 1
		param.add(defaultAccessAllow.toJSONString());
		
		//암복호화 로그 기록 중지 
		SysConfig forcedLoggingOff = new SysConfig();
		forcedLoggingOff.setConfigKey(SystemCode.SysConfigKey.GLOBAL_POLICY_FORCED_LOGGING_OFF_TF);
		forcedLoggingOff.setConfigValue("0"); //체크면 1
		param.add(forcedLoggingOff.toJSONString());

		//부스트
		SysConfig boost = new SysConfig();
		boost.setConfigKey(SystemCode.SysConfigKey.GLOBAL_POLICY_BOOST_TF);
		boost.setConfigValue("0"); //체크면 1
		param.add(boost.toJSONString());
		
		//암복호화 로그 서버에서 압축 시간 
		SysConfig cryptTmResolution = new SysConfig();
		cryptTmResolution.setConfigKey(SystemCode.SysConfigKey.GLOBAL_POLICY_CRYPT_LOG_TM_RESOLUTION);
		cryptTmResolution.setConfigValue("");
		param.add(cryptTmResolution.toJSONString());
		
		//암복호화 로그 AP에서 최대 압축값
		SysConfig cryptLogCompressLimit = new SysConfig();
		cryptLogCompressLimit.setConfigKey(SystemCode.SysConfigKey.GLOBAL_POLICY_CRYPT_LOG_COMPRESS_LIMIT);
		cryptLogCompressLimit.setConfigValue("");
		param.add(cryptLogCompressLimit.toJSONString());
		
        //암복호화 로그 압축 시작값
		SysConfig cryptLogCompressInitial = new SysConfig();
		cryptLogCompressInitial.setConfigKey(SystemCode.SysConfigKey.GLOBAL_POLICY_CRYPT_LOG_COMPRESS_INITIAL);
		cryptLogCompressInitial.setConfigValue("0");
		param.add(cryptLogCompressInitial.toJSONString()); 
		
		//암복호화 로그 압축 중단 시간 
		SysConfig cryptLogCompressFlushTimeout = new SysConfig();
		cryptLogCompressFlushTimeout.setConfigKey(SystemCode.SysConfigKey.GLOBAL_POLICY_CRYPT_LOG_COMPRESS_FLUSH_TIMEOUT);
		cryptLogCompressFlushTimeout.setConfigValue("");
		param.add(cryptLogCompressFlushTimeout.toJSONString());
		
		//암복호화 로그 압축 출력 시간
		SysConfig cryptLogCompressPrintPeriod = new SysConfig();
		cryptLogCompressPrintPeriod.setConfigKey (SystemCode.SysConfigKey.GLOBAL_POLICY_CRYPT_LOG_COMPRESS_PRINT_PERIOD);
		cryptLogCompressPrintPeriod.setConfigValue ( "");
		param.add(cryptLogCompressPrintPeriod.toJSONString());
		
		//암복호화 로그 전송 대기 시간 -> 보안정책 옵션 설정 저장2 에서 등록함

		

		HashMap body = new HashMap();
		body.put("SysConfig", param);

		String parameters = TypeUtility.makeRequestBody(body);
		

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);

		JSONObject resultJson1 = api.callService(strService, strCommand, header, parameters.toString());
		
		Iterator<?> iter1 = resultJson1.entrySet().iterator();
		while (iter1.hasNext()) {
			Map.Entry entry = (Map.Entry) iter1.next();

			System.out.println(String.valueOf(entry.getKey()) + " = " + String.valueOf(entry.getValue()));
		}

		String resultCode = (String) resultJson1.get("resultCode");
		String resultMessage = new String(resultJson1.get("resultMessage").toString().getBytes("iso-8859-1"),"UTF-8");
		
		System.out.println(resultMessage);
		
	}
	
	/**
	 * 보안정책 옵션 설정 저장2
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @param loginId
	 * @param entityId
	 * @throws Exception
	 */
	private void updateSysMultiValueConfigList(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		int[] numWeek = { SystemCode.Weekday.MONDAY,
				 SystemCode.Weekday.TUESDAY,
				 SystemCode.Weekday.WEDNESDAY,
				 SystemCode.Weekday.THURSDAY,
				 SystemCode.Weekday.FRIDAY,
				 SystemCode.Weekday.SATURDAY,
				 SystemCode.Weekday.SUNDAY };
		
		String strService = SystemCode.ServiceName.SYSTEM_SERVICE;
		String strCommand = SystemCode.ServiceCommand.UPDATESYSMULTIVALUECONFIGLIST;
		
		//if(암복호화 로그 서버에서 압축 시간 < 암복호화 로그 압축 출력 시간 ) [{0}]값은 [{1}]보다 크거나 같아야 합니다"
		//if(암복호화 로그 압축 중단 시간 <= 암복호화 로그 압축 출력 시간 ) [{0}]값은 [{1}]보다 커야 합니다
		
		List param = new ArrayList();
		
		SysMultiValueConfig batchLogConf = new SysMultiValueConfig();
		batchLogConf.setConfigKey (SystemCode.SysConfigKey.BATCH_LOG_CONF);
		batchLogConf.setValueTrueFalse ( false); //암복호화 로그를 지정되 시간에만 수집 체크 true/false
         
		BigDecimal valueNumber = new BigDecimal(0);
		BigDecimal valueNumber2 = new BigDecimal(24);
		
		batchLogConf.setValueNumber (valueNumber); //전송 시작
		batchLogConf.setValueNumber2 (valueNumber2); //전송 종료
		
		
		int weekday = 0;
		for (int i = 0; i < 7; i++)
		{
			//if (요일체크박스 체크이면) {
				//weekday |= numWeek[i];
		    //}
		}
		batchLogConf.setValueString(Integer.toHexString(weekday));
		param.add(batchLogConf.toJSONString());

		SysMultiValueConfig logUploadDelay = new SysMultiValueConfig();
		logUploadDelay.setConfigKey(SystemCode.SysConfigKey.BATCH_LOG_UPLOAD_DELAY);
		logUploadDelay.setValueNumber(new BigDecimal(1)); //암복호화 로그 전송 대기 시간  값
		param.add(logUploadDelay.toJSONString());

		

		HashMap body = new HashMap();
		body.put("SysMultiValueConfig", param);

		String parameters = TypeUtility.makeRequestBody(body);
		

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);

		JSONObject resultJson1 = api.callService(strService, strCommand, header, parameters.toString());
		
		Iterator<?> iter1 = resultJson1.entrySet().iterator();
		while (iter1.hasNext()) {
			Map.Entry entry = (Map.Entry) iter1.next();

			System.out.println(String.valueOf(entry.getKey()) + " = " + String.valueOf(entry.getValue()));
		}

		String resultCode = (String) resultJson1.get("resultCode");
		String resultMessage = new String(resultJson1.get("resultMessage").toString().getBytes("iso-8859-1"),"UTF-8");
		
		System.out.println(resultMessage);
		
	}
	
	/**
	 * 암호화 설정 저장
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @param loginId
	 * @param entityId
	 * @throws Exception
	 */
	private void updateSysMultiValueConfigList2(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		int[] numWeek = { SystemCode.Weekday.MONDAY,
				 SystemCode.Weekday.TUESDAY,
				 SystemCode.Weekday.WEDNESDAY,
				 SystemCode.Weekday.THURSDAY,
				 SystemCode.Weekday.FRIDAY,
				 SystemCode.Weekday.SATURDAY,
				 SystemCode.Weekday.SUNDAY };
		
		String strService = SystemCode.ServiceName.SYSTEM_SERVICE;
		String strCommand = SystemCode.ServiceCommand.UPDATESYSMULTIVALUECONFIGLIST;
		
		//if(암복호화 로그 서버에서 압축 시간 < 암복호화 로그 압축 출력 시간 ) [{0}]값은 [{1}]보다 크거나 같아야 합니다"
		//if(암복호화 로그 압축 중단 시간 <= 암복호화 로그 압축 출력 시간 ) [{0}]값은 [{1}]보다 커야 합니다
		
		List param = new ArrayList();
		
		//관리서버 모니터링 주기
		//MONITOR_POLLING_SERVER
		SysMultiValueConfig serverPolling = new SysMultiValueConfig();
		serverPolling.setConfigKey(SystemCode.SysConfigKey.MONITOR_POLLING_SERVER);
		serverPolling.setValueTrueFalse(false); //무조건 false
		serverPolling.setValueNumber(new BigDecimal(600)); //관리서버 모니터링 주기 입력값
		serverPolling.setValueNumber2(null); //무조건 null
		serverPolling.setValueString(SystemCode.MonitorResultLevel.WARN);

		param.add(serverPolling.toJSONString());
		
		//에이전트와 관리서버 통신주기
		//MONITOR_POLLING_AGENT
		SysMultiValueConfig agentPolling = new SysMultiValueConfig();
		agentPolling.setConfigKey(SystemCode.SysConfigKey.MONITOR_POLLING_AGENT);
		agentPolling.setValueTrueFalse(false); // 정책전송 중지 체크 값 체크이면 true
		agentPolling.setValueNumber(new BigDecimal(600)); //에이전트와 관리서버 통신주기 입력값
		agentPolling.setValueNumber2(null); //무조건 null
		agentPolling.setValueString(SystemCode.MonitorResultLevel.WARN);

		param.add(agentPolling.toJSONString());
		
		//에이전트가 기록하는 로그에 위변조 방지를 적용
		//MONITOR_AGENT_AUDIT_LOG_HMAC 
		SysMultiValueConfig agentLogHmac = new SysMultiValueConfig();
		agentLogHmac.setConfigKey(SystemCode.SysConfigKey.MONITOR_AGENT_AUDIT_LOG_HMAC);
		agentLogHmac.setValueTrueFalse(false); //에이전트가 기록하는 로그에 위변조 방지를 적용 체크 값 체크면 true
		agentLogHmac.setValueNumber(new BigDecimal(0)); // 무조건 0
		agentLogHmac.setValueNumber2(null); //무조건 null
		agentLogHmac.setValueString(SystemCode.MonitorResultLevel.NORMAL);

		param.add(agentLogHmac.toJSONString());
		
		//암호화 키의 유효기간이 다음 날짜 이하로 남으면 경고
		//MONITOR_EXPIRE_CRYPTO_KEY
		SysMultiValueConfig keyExpire = new SysMultiValueConfig();
		keyExpire.setConfigKey(SystemCode.SysConfigKey.MONITOR_EXPIRE_CRYPTO_KEY);
        keyExpire.setValueTrueFalse(false); //무조건 false
		keyExpire.setValueNumber(new BigDecimal(30)); //암호화 키의 유효기간이 다음 날짜 이하로 남으면 경고 입력값
		keyExpire.setValueNumber2(null); //무조건 null
		keyExpire.setValueString(SystemCode.MonitorResultLevel.WARN);

		param.add(keyExpire.toJSONString());


		HashMap body = new HashMap();
		body.put("SysMultiValueConfig", param);

		String parameters = TypeUtility.makeRequestBody(body);
		

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);

		JSONObject resultJson1 = api.callService(strService, strCommand, header, parameters.toString());
		
		Iterator<?> iter1 = resultJson1.entrySet().iterator();
		while (iter1.hasNext()) {
			Map.Entry entry = (Map.Entry) iter1.next();

			System.out.println(String.valueOf(entry.getKey()) + " = " + String.valueOf(entry.getValue()));
		}

		String resultCode = (String) resultJson1.get("resultCode");
		String resultMessage = new String(resultJson1.get("resultMessage").toString().getBytes("iso-8859-1"),"UTF-8");
		
		System.out.println(resultMessage);
		
	}
	
	/**
	 * entity_uid 검색
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @param loginId
	 * @param entityId
	 * @param userId
	 * @throws Exception
	 */
	private void selectEntityUid(String restIp, int restPort, String strTocken, String loginId, String entityId, String userId) throws Exception {
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

			System.out.println(String.valueOf(entry.getKey()) + " = " + String.valueOf(entry.getValue()));
		}

		String resultCode = (String) resultJson1.get("resultCode");
		String resultMessage = new String(resultJson1.get("resultMessage").toString().getBytes("iso-8859-1"),"UTF-8");

	
		System.out.println(resultMessage);
		
	}
	
	/**
	 * 에이전트 상태 저장
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @param loginId
	 * @param entityId
	 * @throws Exception
	 */
	private void updateEntity(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.ENTITY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.UPDATEENTITY;


		Entity param = new Entity();
		param.setEntityUid("");
		param.setEntityName("");
		param.setEntityStatusCode("");
		param.setCreateUid("");
		

		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());

		String parameters = TypeUtility.makeRequestBody(body);
		

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
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

	//암호화 통계
	private void selectAuditLogSiteHourForStat(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {

		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.LOG_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTAUDITLOGSITEHOURFORSTAT;

		AuditLogSiteStatCondition param = new AuditLogSiteStatCondition();

		
		/** setCategoryColumn
		 * PROFILE_NM / 정책 이름
			SITE_ACCESS_ADDRESS / 라이언트 주소
			HOST_NM /  호스트 이름
			EXTRA_NM / 추가 필드
			MODULE_INFO / 모듈 정보
			LOCATION_INFO / DB 컬럼
			SERVER_LOGIN_ID / DB 사용자 아이디

		 */
		param.setSearchAgentLogDateTimeFrom("2018042700");
		param.setSearchAgentLogDateTimeTo("2018042724");
		param.setCategoryColumn("SITE_ACCESS_ADDRESS");
		param.setSeriesDefinition(AuditLogSiteStatCondition.SERIES_HOURLY);

		//JSONObject parameters = new JSONObject();
		//parameters.put("profile", vo);
		
		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());

		String parameters = TypeUtility.makeRequestBody(body);

		HashMap header = new HashMap();
		//header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		//header.put(SystemCode.FieldName.ENTITY_UID, entityId);
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);

		JSONObject resultJson = api.callService(strService, strCommand, header, parameters);
		

		String resultCode = (String) resultJson.get("resultCode");
		String resultMessage = (String) resultJson.get("resultMessage");
		resultMessage = new String(resultMessage.getBytes("iso-8859-1"),"UTF-8"); 
		
		System.out.println("resultCode : " + resultCode + " resultMessage : " + resultMessage);
		
		if(resultCode.equals(SystemCode.ResultCode.SUCCESS)) {
			
			ArrayList list = (ArrayList) resultJson.get("list");
			if(list != null) {
				for (int j = 0; j < list.size(); j++) {
					JSONObject jsonObj = (JSONObject) list.get(j);
					
	
		
					String categoryColumn = jsonObj.get("categorycolumn").toString();
					String encryptSuccessCount = jsonObj.get("encryptsuccesscount").toString();
					String encryptFailCount = jsonObj.get("encryptfailcount").toString();
					String decryptSuccessCount = jsonObj.get("decryptsuccesscount").toString();
					String decryptFailCount = jsonObj.get("decryptfailcount").toString();
					String sumCount = jsonObj.get("sumcount").toString();

					
					System.out.println("encryptSuccessCount : " + encryptSuccessCount + " encryptFailCount : " + encryptFailCount);
					System.out.println("decryptSuccessCount : " + decryptSuccessCount + " decryptFailCount : " + decryptFailCount);
					System.out.println("sumCount : " + sumCount );
	
				}
			}
			
		} else {
			
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
	
	private void decodeTest() throws Exception {
		
		AESCrypt aes = new AESCrypt();
		
		//암호화
		//aes.GenerateMasterStr("1234qwer");
		
		String loadStr = "{\"mas\":\"ScfypwlI+yt1j4XxuMPEKYeLj3BTLoEoBmy5vC3wWGl+M/a0/WK39s/8BudpUXNU\",\"ter\":\"5Os7QRcWTNBCprpra2/Xkg==\",\"key\":\"pQcdT8XmWoOIZQyELMR8A1nZ6jr72Kq/kD93799x1UE=\"}";
		//복호화
		try {
		String encText = aes.GetMasterStr("1234qwerdd", loadStr);
		System.out.println(encText);
		} catch(Exception e) {
			//화면에 alert 메시지
			System.out.println("message : " + "마스터키 파일을 읽을 수 없거나 비밀번호가 틀렸습니다");
		}
		
	
	}
	
	/**
	 * 서버 마스터 키 암호 저장
	 * @throws Exception
	 */
	private void serverMasterKey_save() throws Exception {
		
	}
	
	private void encTest() throws Exception {
		AESCrypt aes = new AESCrypt();
		
		//암호화
		MasterKeyFile m = aes.GenerateMasterStr("1234qwer");
		System.out.println(m.getMas());
		System.out.println(m.getTer());
		System.out.println(m.getKey());
		
		System.out.println(m.toJSONString());
		
		
		
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
