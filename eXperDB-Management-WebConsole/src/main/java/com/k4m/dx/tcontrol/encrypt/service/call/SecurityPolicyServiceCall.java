package com.k4m.dx.tcontrol.encrypt.service.call;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.google.gson.Gson;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.EncryptCommonService;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.SystemCode;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.TypeUtility;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.CryptoKeySymmetric;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.Profile;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.ProfileAclSpec;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.ProfileCipherSpec;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.ProfileProtection;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.SysCode;

public class SecurityPolicyServiceCall {
	
	
	/**
	 * 보안정책 > 보안정책관리
	 * @param restIp
	 * @param restPort
	 * @return 
	 * @throws Exception
	 */
	public JSONObject selectProfileList(String restIp, int restPort, String strTocken,String loginId, String entityId) throws Exception {
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
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);

		JSONObject resultJson = api.callService(strService, strCommand, header, parameters);
		
		String resultCode = (String) resultJson.get("resultCode");
		String resultMessage = (String) resultJson.get("resultMessage");
		resultMessage = new String(resultMessage.getBytes("iso-8859-1"),"UTF-8"); 
		
		System.out.println("resultCode : " + resultCode + " resultMessage : " + resultMessage);
		
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		if(resultCode.equals(SystemCode.ResultCode.SUCCESS)) {
			ArrayList list = (ArrayList) resultJson.get("list");
			if(list!=null) {
				for (int j = 0; j < list.size(); j++) {
					JSONObject jsonObj = (JSONObject) list.get(j);

					Gson gson = new Gson();
					Profile profile = new Profile();
					profile = gson.fromJson(jsonObj.toJSONString(), profile.getClass());
					
					String createDateTime = profile.getCreateDateTime();
					Date createDateTimeDate = dateFormat.parse(profile.getCreateDateTime());
					String profileTypeName = profile.getProfileTypeName();
					String profileTypeCode = profile.getProfileTypeCode();
					String profileStatusCode = profile.getProfileStatusCode();
					String profileNote = profile.getProfileNote();
					String profileStatusName =  profile.getProfileStatusName();
					String createName = profile.getCreateName();
					String createUid = profile.getCreateUid();
					String profileName = profile.getProfileName();
					String profileUid = profile.getProfileUid();	
					String updateDateTime = profile.getUpdateDateTime();			
					String updateName = profile.getUpdateName();
					
					jsonObj.put("rnum", j+1);
					jsonObj.put("profileName", new String(profileName.getBytes("iso-8859-1"),"UTF-8"));
					jsonObj.put("profileNote", new String(profileNote.getBytes("iso-8859-1"),"UTF-8"));
					jsonObj.put("profileStatusName", profileStatusName);
					jsonObj.put("createDateTime", dateFormat.format(createDateTimeDate));
					if(createName != null){
						jsonObj.put("createName", new String(createName.getBytes("iso-8859-1"),"UTF-8"));
					}
					if(updateDateTime!=null){
						Date updateDateTimeDate = dateFormat.parse(updateDateTime);
						jsonObj.put("updateDateTime", dateFormat.format(updateDateTimeDate));
					}
					if(updateName != null){
						jsonObj.put("updateName", new String(updateName.getBytes("iso-8859-1"),"UTF-8"));
					}
					jsonArray.add(jsonObj);
				}	
			}
			result.put("list", jsonArray);
		}
		result.put("resultCode", resultCode);
		result.put("resultMessage", resultMessage);
		return result;
	}

	/**
	 * 보안정책 등록
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @param param2 
	 * @param param3 
	 * @return 
	 * @throws Exception
	 */
	public JSONObject insertProfileProtection(String restIp, int restPort, String strTocken, String loginId, String entityId, ProfileProtection param1, List param2, List param3) throws Exception {
		JSONObject result = new JSONObject();
		
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.POLICY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.INSERTPROFILEPROTECTION;

		//JSONObject parameters = new JSONObject();
		//parameters.put("profile", vo);
		
		HashMap body = new HashMap();
		System.out.println("기본"+param1);
		body.put(TypeUtility.getJustClassName(param1.getClass()), param1.toJSONString());
		body.put("ProfileCipherSpec", param2);
		System.out.println("암호화정책"+param2);
		
        body.put("ProfileAclSpec", param3);
        System.out.println("접근제어정책"+param3);
        
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
		
		result.put("resultCode", resultCode);
		result.put("resultMessage", resultMessage);
		return result;
	}
	
	/**
	 * 보안정책 수정
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @param param2 
	 * @param param3 
	 * @throws Exception
	 */
	public JSONObject updateProfileProtection(String restIp, int restPort, String strTocken,String loginId, String entityId, ProfileProtection param1, List param2, List param3) throws Exception {
		JSONObject result = new JSONObject();
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.POLICY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.UPDATEPROFILEPROTECTION;

		//JSONObject parameters = new JSONObject();
		//parameters.put("profile", vo);
		
		HashMap body = new HashMap();
		System.out.println("기본"+param1);
		body.put(TypeUtility.getJustClassName(param1.getClass()), param1.toJSONString());
		body.put("ProfileCipherSpec", param2);
		System.out.println("암호화정책"+param2);
		
        body.put("ProfileAclSpec", param3);
        System.out.println("접근제어정책"+param3);

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
		result.put("resultCode", resultCode);
		result.put("resultMessage", resultMessage);
		return result;
	}
	
	/**
	 * 보안정책상세
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @param profileUid 
	 * @return 
	 * @throws Exception
	 */
	public JSONObject selectProfileProtectionContents(String lang, String restIp, int restPort, String strTocken, String loginId, String entityId, String profileUid) throws Exception {
		JSONArray jsonArray = new JSONArray();
		JSONArray jsonArray2 = new JSONArray();
		JSONObject result = new JSONObject();
		
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.POLICY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTPROFILEPROTECTIONCONTENTS;

		ProfileProtection param = new ProfileProtection();
		param.setProfileUid(profileUid);

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
			
			System.out.println("보호 정책 이름 : " + profileProtection.getProfileName()+"보호 정책 설명 : " + profileProtection.getProfileNote());
			result.put("profileName", new String(profileProtection.getProfileName().getBytes("iso-8859-1"),"UTF-8"));
			result.put("profileNote", new String(profileProtection.getProfileNote().getBytes("iso-8859-1"),"UTF-8"));
			
			System.out.println((boolean) profileProtection.getDefaultAccessAllowTrueFalse()); //	기본접근허용
			result.put("defaultAccessAllowTrueFalse", (boolean) profileProtection.getDefaultAccessAllowTrueFalse());
			
			long optionBits = 0L;
			optionBits= (long) profileProtection.getOptionBits();		
			
			boolean blnLoggingFail = !((optionBits & SystemCode.BitMask.POLICY_OPT_NO_AUDIT_LOG_ON_FAIL) == SystemCode.BitMask.POLICY_OPT_NO_AUDIT_LOG_ON_FAIL);
			boolean blnLoggingSuccess= !((optionBits & SystemCode.BitMask.POLICY_OPT_NO_AUDIT_LOG_ON_SUCCESS) == SystemCode.BitMask.POLICY_OPT_NO_AUDIT_LOG_ON_SUCCESS);
			boolean blnLogCompress = ((optionBits & SystemCode.BitMask.POLICY_OPT_COMPRESS_AUDIT_LOG) == SystemCode.BitMask.POLICY_OPT_COMPRESS_AUDIT_LOG);
			
			System.out.println(blnLoggingFail); //실패 로그 기록
			result.put("log_on_fail", blnLoggingFail);
			System.out.println(blnLoggingSuccess); //성공 로그 기록
			result.put("log_on_success", blnLoggingSuccess);
			System.out.println(blnLogCompress); //로그 압축
			result.put("compress_audit_log", blnLogCompress);
			
			System.out.println(profileProtection.getNullEncryptYesNo()); //nullEncryptYesNo	NULL 암호화
			result.put("nullEncryptYesNo", profileProtection.getNullEncryptYesNo());
			System.out.println(profileProtection.getPreventDoubleYesNo()); //preventDoubleYesNo	이중 암호화 방지
			result.put("preventDoubleYesNo", profileProtection.getPreventDoubleYesNo());
			System.out.println(profileProtection.getDenyResultTypeCode()); //denyResultTypeCode	접근 거부시 처리
			result.put("denyResultTypeCode", profileProtection.getDenyResultTypeCode());
			System.out.println(profileProtection.getDataTypeCode()); //dataTypeCode	데이터 타입
			result.put("dataTypeCode", profileProtection.getDataTypeCode());
			System.out.println(profileProtection.getMaskingValue()); //대체 문자열
			result.put("maskingValue", profileProtection.getMaskingValue());
			
			JSONArray arrProfileCipherSpec = (JSONArray) map.get("ProfileCipherSpec");
			System.out.println(" ################# ProfileCipherSpec ################### ");
			if(arrProfileCipherSpec.size()>0) {
				for(int i=0; i<arrProfileCipherSpec.size(); i++) {
					JSONObject json = (JSONObject) arrProfileCipherSpec.get(i);
					JSONObject jsonObj = new JSONObject();
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
					jsonObj.put("specIndex", profileCipherSpec.getSpecIndex());
					jsonObj.put("profileUid", profileCipherSpec.getProfileUid());
					jsonObj.put("CipherAlgorithmCode", profileCipherSpec.getCipherAlgorithmCode());
					jsonObj.put("CipherAlgorithmName", profileCipherSpec.getCipherAlgorithmName());
					jsonObj.put("operationModeCode", profileCipherSpec.getOperationModeCode());
					jsonObj.put("paddingMethodCode", profileCipherSpec.getPaddingMethodCode());
					jsonObj.put("initialVectorTypeCode", profileCipherSpec.getInitialVectorTypeCode());
					jsonObj.put("offset", profileCipherSpec.getOffset());
					jsonObj.put("length", profileCipherSpec.getLength());
					jsonObj.put("binUid", profileCipherSpec.getBinUid());
					
					jsonArray.add(jsonObj);
				}
				result.put("ProfileCipherSpecData", jsonArray);
			}
			
			JSONArray arrProfileAclSpec = (JSONArray) map.get("ProfileAclSpec");
			System.out.println(" ################# ProfileAclSpec ################### ");
			if(arrProfileAclSpec.size()>0) {
				for(int i=0; i<arrProfileAclSpec.size(); i++) {
					JSONObject json = (JSONObject) arrProfileAclSpec.get(i);
					JSONObject jsonObj = new JSONObject();
					ProfileAclSpec profileAclSpec = new ProfileAclSpec();
					Gson gsonProfileAclSpec = new Gson();
					profileAclSpec = gsonProfileAclSpec.fromJson(json.toJSONString(), profileAclSpec.getClass());

					System.out.println("specName : " + profileAclSpec.getSpecName());
					System.out.println("serverInstanceId : " + profileAclSpec.getServerInstanceId());
					System.out.println("serverLoginId : " + profileAclSpec.getServerLoginId());
					System.out.println("adminLoginId : " + profileAclSpec.getAdminLoginId());
					System.out.println("osLoginId : " + profileAclSpec.getOsLoginId());
					System.out.println("applicationName : " + profileAclSpec.getApplicationName());
					System.out.println("accessAddress : " + profileAclSpec.getAccessAddress());
					System.out.println("accessAddressMask : " + profileAclSpec.getAccessAddressMask());
					System.out.println("accessMacAddress : " + profileAclSpec.getAccessMacAddress());
					System.out.println("startDateTime : " + profileAclSpec.getStartDateTime());
					System.out.println("endDateTime : " + profileAclSpec.getEndDateTime());
					System.out.println("startTime : " + profileAclSpec.getStartTime());
					System.out.println("endTime : " + profileAclSpec.getEndTime());
					System.out.println("workDay : " + profileAclSpec.getWorkDay());
					System.out.println("massiveThreshold : " + profileAclSpec.getMassiveThreshold());
					System.out.println("massiveTimeInterval : " + profileAclSpec.getMassiveTimeInterval());
					System.out.println("extraName : " + profileAclSpec.getExtraName());
					System.out.println("hostName : " + profileAclSpec.getHostName());
					System.out.println("whitelistYesNo : " + profileAclSpec.getWhitelistYesNo());
					
					SimpleDateFormat dateformat = new SimpleDateFormat("yyyyMMddhhmmss"); 
					SimpleDateFormat formatDate = new SimpleDateFormat("yyyy-MM-dd");
					Date date = dateformat.parse(profileAclSpec.getStartDateTime());
					String startDateTime = formatDate.format(date);
					date = dateformat.parse(profileAclSpec.getEndDateTime());
					String endDateTime = formatDate.format(date);
					
					SimpleDateFormat timeFormat = new SimpleDateFormat("HHmmss"); 
					SimpleDateFormat formatTime = new SimpleDateFormat("HH:mm");
					Date time = timeFormat.parse(profileAclSpec.getStartTime());
					String startTime = formatTime.format(time);
					time = timeFormat.parse(profileAclSpec.getEndTime());
					String endTime = formatTime.format(time);
					
					String workDay = "";
					boolean monday = ContainsWeekDay(profileAclSpec.getWorkDay(), SystemCode.Weekday.MONDAY);
					boolean tuesday =ContainsWeekDay(profileAclSpec.getWorkDay(), SystemCode.Weekday.TUESDAY);
					boolean wednesday =ContainsWeekDay(profileAclSpec.getWorkDay(), SystemCode.Weekday.WEDNESDAY);
					boolean thursday =ContainsWeekDay(profileAclSpec.getWorkDay(), SystemCode.Weekday.THURSDAY);
					boolean friday =ContainsWeekDay(profileAclSpec.getWorkDay(), SystemCode.Weekday.FRIDAY);
					boolean saturday =ContainsWeekDay(profileAclSpec.getWorkDay(), SystemCode.Weekday.SATURDAY);
					boolean sunday =ContainsWeekDay(profileAclSpec.getWorkDay(), SystemCode.Weekday.SUNDAY);

					if(lang.equals("ko")){
						if(monday){
							workDay+= "월";	
						}
						if(tuesday){
							if(workDay.length()!=0){
								workDay+=",";
							}
								workDay+= "화";	
						}
						if(wednesday){
							if(workDay.length()!=0){
								workDay+=",";
							}
								workDay+= "수";	
						}
						if(thursday){
							if(workDay.length()!=0){
								workDay+=",";
							}
								workDay+= "목";	
						}
						if(friday){
							if(workDay.length()!=0){
								workDay+=",";
							}
								workDay+= "금";	
						}
						if(saturday){
							if(workDay.length()!=0){
								workDay+=",";
							}
								workDay+= "토";	
						}
						if(sunday){
							if(workDay.length()!=0){
								workDay+=",";
							}
								workDay+= "일";	
						}
					}
					
					if(lang.equals("en")){
						if(monday){
							workDay+= "MON";	
						}
						if(tuesday){
							if(workDay.length()!=0){
								workDay+=",";
							}
								workDay+= "TUE";	
						}
						if(wednesday){
							if(workDay.length()!=0){
								workDay+=",";
							}
								workDay+= "WED";	
						}
						if(thursday){
							if(workDay.length()!=0){
								workDay+=",";
							}
								workDay+= "THU";	
						}
						if(friday){
							if(workDay.length()!=0){
								workDay+=",";
							}
								workDay+= "FRI";	
						}
						if(saturday){
							if(workDay.length()!=0){
								workDay+=",";
							}
								workDay+= "SAT";	
						}
						if(sunday){
							if(workDay.length()!=0){
								workDay+=",";
							}
								workDay+= "SUN";	
						}
					}
					
					jsonObj.put("specName", new String(profileAclSpec.getSpecName().getBytes("iso-8859-1"),"UTF-8"));  
					if(profileAclSpec.getServerInstanceId() != null){
						jsonObj.put("serverInstanceId", new String(profileAclSpec.getServerInstanceId().getBytes("iso-8859-1"),"UTF-8"));
					}
					if(profileAclSpec.getServerLoginId() != null){
						jsonObj.put("serverLoginId", new String(profileAclSpec.getServerLoginId().getBytes("iso-8859-1"),"UTF-8"));
					}
					if(profileAclSpec.getAdminLoginId() != null){
						jsonObj.put("adminLoginId", new String(profileAclSpec.getAdminLoginId().getBytes("iso-8859-1"),"UTF-8"));
					}
					if(profileAclSpec.getOsLoginId() != null){
						jsonObj.put("osLoginId", new String(profileAclSpec.getOsLoginId().getBytes("iso-8859-1"),"UTF-8"));
					}
					if(profileAclSpec.getApplicationName() != null){
						jsonObj.put("applicationName", new String(profileAclSpec.getApplicationName().getBytes("iso-8859-1"),"UTF-8"));
					}
					if(profileAclSpec.getAccessAddress() != null){
						jsonObj.put("accessAddress", new String(profileAclSpec.getAccessAddress().getBytes("iso-8859-1"),"UTF-8"));
					}
					if(profileAclSpec.getAccessAddressMask() != null){
						jsonObj.put("accessAddressMask", new String(profileAclSpec.getAccessAddressMask().getBytes("iso-8859-1"),"UTF-8"));
					}
					if(profileAclSpec.getAccessMacAddress() != null){
						jsonObj.put("accessMacAddress", new String(profileAclSpec.getAccessMacAddress().getBytes("iso-8859-1"),"UTF-8"));
					}
					jsonObj.put("startDateTime", startDateTime);
					jsonObj.put("endDateTime", endDateTime);
					jsonObj.put("startTime", startTime);
					jsonObj.put("endTime", endTime);
					jsonObj.put("workDay", workDay);
					jsonObj.put("massiveThreshold", profileAclSpec.getMassiveThreshold());
					jsonObj.put("massiveTimeInterval", profileAclSpec.getMassiveTimeInterval());
					if(profileAclSpec.getExtraName() != null){
						jsonObj.put("extraName", new String(profileAclSpec.getExtraName().getBytes("iso-8859-1"),"UTF-8"));
					}
					if(profileAclSpec.getHostName() != null){
						jsonObj.put("hostName", new String(profileAclSpec.getHostName().getBytes("iso-8859-1"),"UTF-8"));
					}
					jsonObj.put("whitelistYesNo", profileAclSpec.getWhitelistYesNo());
					jsonArray2.add(jsonObj);
				}
				result.put("arrProfileAclSpec", jsonArray2);
			}
		}
		return result;
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
	
	/**
	 * 보호정책상세 > 암호화 키 리스트
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @return 
	 * @throws Exception
	 */
	public JSONArray selectCryptoKeySymmetricList(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {
		JSONArray jsonArray = new JSONArray();
		
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
					JSONObject jsonObj = new JSONObject();
					
					Gson gson = new Gson();
					CryptoKeySymmetric cryptoKeySymmetric = new CryptoKeySymmetric();
					cryptoKeySymmetric = gson.fromJson(jsonData.toJSONString(), cryptoKeySymmetric.getClass());
					
					System.out.println("resourceName : " + cryptoKeySymmetric.getResourceName());
					System.out.println("getBinUid : " + cryptoKeySymmetric.getBinUid());
					System.out.println("cipherAlgorithmName : " + cryptoKeySymmetric.getCipherAlgorithmName());
					System.out.println("resourceName : " + cryptoKeySymmetric.getResourceName());
					System.out.println("validEndDate : " + cryptoKeySymmetric.getValidEndDate());
					
					jsonObj.put("resourceName", cryptoKeySymmetric.getResourceName());
					jsonObj.put("getBinUid", cryptoKeySymmetric.getBinUid());
					jsonObj.put("cipherAlgorithmName", cryptoKeySymmetric.getCipherAlgorithmName());
					jsonObj.put("resourceName", cryptoKeySymmetric.getResourceName());
					jsonObj.put("validEndDate", cryptoKeySymmetric.getValidEndDate());
					
					
					jsonArray.add(jsonObj);
				}
			
			}
		}
		return jsonArray;
		
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
	public JSONObject deleteProfileProtection(String restIp, int restPort, String strTocken, String loginId, String entityId, ProfileProtection param) throws Exception {
		JSONObject result = new JSONObject();
		
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.POLICY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.DELETEPROFILEPROTECTION;

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

		result.put("resultCode", resultCode);
		result.put("resultMessage", resultMessage);
		
		System.out.println("resultCode : " + resultCode + " resultMessage : " + resultMessage);
		
		return result;
		
	}
	
	
	/**
	 * 일반 공통코드 리스트(데이터타입)
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @throws Exception
	 */
	public JSONArray selectParamSysCodeListDatatype(String restIp, int restPort, String strTocken,String loginId, String entityId) throws Exception {
		JSONArray jsonArray = new JSONArray();
		
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.SYSTEM_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTPARAMSYSCODELIST;

		String categoryKey = "DATA_TYPE_CD"; //데이터타입

		HashMap body = new HashMap();
		//body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());
		body.put("categoryKey", categoryKey);
		
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
		//long totalListCount = (long) resultJson.get("totalListCount");
		
		if(resultCode.equals("0000000000")) {
			ArrayList list = (ArrayList) resultJson.get("list");
				for(int i=0; i<list.size(); i++) {
					JSONObject data = (JSONObject) list.get(i);
					JSONObject jsonObj = new JSONObject();
					
					SysCode sysCode = new SysCode();
					Gson gson = new Gson();
					sysCode = gson.fromJson(data.toJSONString(), sysCode.getClass());
					
					jsonObj.put("sysCode", sysCode.getSysCode());
					jsonObj.put("sysCodeName", sysCode.getSysCodeName());
					jsonObj.put("SysCodeValue", sysCode.getSysCodeValue());
					
					jsonArray.add(jsonObj);
				}
		}
		return jsonArray;
	}
	
	/**
	 * 일반 공통코드 리스트(접근거부시 처리)
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @throws Exception
	 */
	public JSONArray selectParamSysCodeListDenyresult(String restIp, int restPort, String strTocken,String loginId, String entityId) throws Exception {
		JSONArray jsonArray = new JSONArray();
		
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.SYSTEM_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTPARAMSYSCODELIST;

		String categoryKey = "DENY_RESULT_TYPE_CD"; //접근거부시 처리

		HashMap body = new HashMap();
		//body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());
		body.put("categoryKey", categoryKey);
		
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
		//long totalListCount = (long) resultJson.get("totalListCount");
		
		if(resultCode.equals("0000000000")) {
			ArrayList list = (ArrayList) resultJson.get("list");
				for(int i=0; i<list.size(); i++) {
					JSONObject data = (JSONObject) list.get(i);
					JSONObject jsonObj = new JSONObject();
					
					SysCode sysCode = new SysCode();
					Gson gson = new Gson();
					sysCode = gson.fromJson(data.toJSONString(), sysCode.getClass());
					
					jsonObj.put("sysCode", sysCode.getSysCode());
					jsonObj.put("sysCodeName", sysCode.getSysCodeName());
					jsonObj.put("SysCodeValue", sysCode.getSysCodeValue());
					
					jsonArray.add(jsonObj);
				}
		}
		return jsonArray;
	}
	
	/**
	 * 일반 공통코드 리스트(초기 벡터)
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @throws Exception
	 */
	public JSONArray selectParamSysCodeListVector(String restIp, int restPort, String strTocken,String loginId, String entityId) throws Exception {
		JSONArray jsonArray = new JSONArray();
		
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.SYSTEM_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTPARAMSYSCODELIST;

		String categoryKey = "INITIAL_VECTOR_TYPE"; //초기벡터

		HashMap body = new HashMap();
		//body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());
		body.put("categoryKey", categoryKey);
		
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
		//long totalListCount = (long) resultJson.get("totalListCount");
		
		if(resultCode.equals("0000000000")) {
			ArrayList list = (ArrayList) resultJson.get("list");
				for(int i=0; i<list.size(); i++) {
					JSONObject data = (JSONObject) list.get(i);
					JSONObject jsonObj = new JSONObject();
					
					SysCode sysCode = new SysCode();
					Gson gson = new Gson();
					sysCode = gson.fromJson(data.toJSONString(), sysCode.getClass());
					
					jsonObj.put("sysCode", sysCode.getSysCode());
					jsonObj.put("sysCodeName", sysCode.getSysCodeName());
					jsonObj.put("SysCodeValue", sysCode.getSysCodeValue());
					
					jsonArray.add(jsonObj);
				}
		}
		return jsonArray;
	}
	
	/**
	 * 일반 공통코드 리스트(운영모드)
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @throws Exception
	 */
	
	public JSONArray selectParamSysCodeListOperation(String restIp, int restPort, String strTocken,String loginId, String entityId) throws Exception {
		JSONArray jsonArray = new JSONArray();
		
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.SYSTEM_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTPARAMSYSCODELIST;

		String categoryKey = "OPERATION_MODE"; //운영모드

		HashMap body = new HashMap();
		//body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());
		body.put("categoryKey", categoryKey);
		
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
		//long totalListCount = (long) resultJson.get("totalListCount");
		
		if(resultCode.equals("0000000000")) {
			ArrayList list = (ArrayList) resultJson.get("list");
				for(int i=0; i<list.size(); i++) {
					JSONObject data = (JSONObject) list.get(i);
					JSONObject jsonObj = new JSONObject();
					
					SysCode sysCode = new SysCode();
					Gson gson = new Gson();
					sysCode = gson.fromJson(data.toJSONString(), sysCode.getClass());
					
					jsonObj.put("sysCode", sysCode.getSysCode());
					jsonObj.put("sysCodeName", sysCode.getSysCodeName());
					jsonObj.put("SysCodeValue", sysCode.getSysCodeValue());
					
					jsonArray.add(jsonObj);
				}
		}
		return jsonArray;
	}
	
	
	
	/**
	 * 공통코드리스트
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @return 
	 * @throws Exception
	 */
	public JSONArray selectSysCodeList(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {
		JSONArray jsonArray = new JSONArray();
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
			if(totalListCount > 0) {
				for(int i=0; i<list.size(); i++) {
					JSONObject data = (JSONObject) list.get(i);
					StringBuffer bf = new StringBuffer();
					JSONObject jsonObj = new JSONObject();
					
					if(data.get("sysStatusCode").equals("SS50") && data.get("categoryKey").equals("CIPHER_ALGORITHM")){
						jsonObj.put("sysCodeName", data.get("sysCodeName"));
						jsonArray.add(jsonObj);
					}
				}
			}
		}
		return jsonArray;
	}
}
