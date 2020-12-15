package com.k4m.dx.tcontrol.encrypt.service.call;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

import com.google.gson.Gson;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.AESCrypt;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.EncryptCommonService;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.SystemCode;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.TypeUtility;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.AdminServerPasswordRequest;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.Entity;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.MasterKeyFile;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.SysCode;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.SysConfig;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.SysMultiValueConfig;

public class EncryptSettingServiceCall {

	public JSONObject selectSysConfigListLike(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {
		
		JSONObject result = new JSONObject();
		JSONArray jsonArray = new JSONArray();
	
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.SYSTEM_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTSYSCONFIGLISTLIKE;

		
		HashMap body = new HashMap();
		body.put(SystemCode.CustomFormParamKey.sysConfigKeyPrefix, SystemCode.SysConfigKeyPrefix.GLOBAL_POLICY);

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
				
				JSONObject jObj = new JSONObject();
				
				jObj.put("configKey", (String) jsonObj.get("configKey"));
				jObj.put("configValue", (String) jsonObj.get("configValue"));
				jObj.put("resultCode", resultCode);
				jObj.put("resultMessage", resultMessage);
				
				jsonArray.add(jObj);
				
				String strConfigKey = (String) jsonObj.get("configKey");
				String strConfigValue = (String) jsonObj.get("configValue"); 
				System.out.println("strConfigKey : " + strConfigKey + " - strConfigValue : " + strConfigValue);

				result.put("list", jsonArray);
			}
		} 
			result.put("resultCode", resultCode);
			result.put("resultMessage", resultMessage);
	
		return result;
	}

	public JSONObject selectSysMultiValueConfigListLike(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {
		
		JSONObject result = new JSONObject();
		JSONArray jsonArray = new JSONArray();
		
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

		if(resultCode.equals(SystemCode.ResultCode.SUCCESS)) {
			
			ArrayList list = (ArrayList) resultJson.get("list");
			for (int j = 0; j < list.size(); j++) {
				JSONObject jsonObj = (JSONObject) list.get(j);
				
				SysMultiValueConfig sysMultiValueConfig = new SysMultiValueConfig();
				Gson gson = new Gson();
				sysMultiValueConfig = gson.fromJson(jsonObj.toJSONString(), sysMultiValueConfig.getClass());
				
				JSONObject jObj = new JSONObject();
				
				String strConfigKey = (String) sysMultiValueConfig.getConfigKey();
				boolean blnIsvalueTrueFalse = sysMultiValueConfig.isValueTrueFalse();
				String strValueString = sysMultiValueConfig.getValueString();
				
				BigDecimal bdValueNumber = sysMultiValueConfig.getValueNumber();
				BigDecimal bdValueNumber2 = sysMultiValueConfig.getValueNumber2();
				
				
				System.out.println("strConfigKey : " + strConfigKey);
				if(strConfigKey.equals(SystemCode.SysConfigKey.BATCH_LOG_CONF)) {
					
					//1. 암복호화 로그를 지정되 시간에만 수집 체크박스 체크여부 = blnIsvalueTrueFalse
					System.out.println("blnIsvalueTrueFalse : " + blnIsvalueTrueFalse);
					jObj.put("blnIsvalueTrueFalse", blnIsvalueTrueFalse);
					
					int weekday = Integer.parseInt(strValueString, 16);
					for (int i = 0; i < 7; i++)
					{
						System.out.println(i + " " + ContainsWeekDay(weekday, numWeek[i]));
						jObj.put("day"+i, ContainsWeekDay(weekday, numWeek[i]));
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
					jObj.put("transferStart", bdValueNumber);
					jObj.put("transferStop", bdValueNumber2);
					jObj.put("resultCode", resultCode);
					jObj.put("resultMessage", resultMessage);		
					
				} else if(strConfigKey.equals(SystemCode.SysConfigKey.BATCH_LOG_UPLOAD_DELAY)) {
					//암복호화 로그 전송 대기 시간 
					System.out.println("암복호화 로그 전송 대기 시간 : " + bdValueNumber);
					jObj.put("logTransferWaitTime", bdValueNumber);
				}
				jsonArray.add(jObj);
				result.put("list", jsonArray);
			}
		}
			result.put("resultCode", resultCode);
			result.put("resultMessage", resultMessage);
	
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

	public JSONObject updateSysConfigList(String restIp, int restPort, String strTocken, JSONObject obj01, String loginId, String entityId) throws Exception {
		
		JSONObject result = new JSONObject();
		
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.SYSTEM_SERVICE;
		String strCommand = SystemCode.ServiceCommand.UPDATESYSCONFIGLIST;
		
		//if(암복호화 로그 서버에서 압축 시간 < 암복호화 로그 압축 출력 시간 ) [{0}]값은 [{1}]보다 크거나 같아야 합니다"
		//if(암복호화 로그 압축 중단 시간 <= 암복호화 로그 압축 출력 시간 ) [{0}]값은 [{1}]보다 커야 합니다
		
		List param = new ArrayList();
		
		//기본 접근 허용
		SysConfig defaultAccessAllow = new SysConfig();
		defaultAccessAllow.setConfigKey(SystemCode.SysConfigKey.GLOBAL_POLICY_DEFAULT_ACCESS_ALLOW_TF);
		if(obj01.get("global_policy_default_access_allow_tf").equals(true)){
			defaultAccessAllow.setConfigValue("1");
		}else{
			defaultAccessAllow.setConfigValue("0"); 
		}
		param.add(defaultAccessAllow.toJSONString());
		
		//암복호화 로그 기록 중지 
		SysConfig forcedLoggingOff = new SysConfig();
		forcedLoggingOff.setConfigKey(SystemCode.SysConfigKey.GLOBAL_POLICY_FORCED_LOGGING_OFF_TF);
		if(obj01.get("global_policy_forced_logging_off_tf").equals(true)){
			forcedLoggingOff.setConfigValue("1"); 
		}else{
			forcedLoggingOff.setConfigValue("0"); 
		}
		param.add(forcedLoggingOff.toJSONString());

		//부스트
		SysConfig boost = new SysConfig();
		boost.setConfigKey(SystemCode.SysConfigKey.GLOBAL_POLICY_BOOST_TF);
		if(obj01.get("global_policy_boost_tf").equals(true)){ 
			boost.setConfigValue("True"); 
		}else{
			boost.setConfigValue("False"); 
		}
		param.add(boost.toJSONString());
		
		//암복호화 로그 서버에서 압축 시간 
		SysConfig cryptTmResolution = new SysConfig();
		cryptTmResolution.setConfigKey(SystemCode.SysConfigKey.GLOBAL_POLICY_CRYPT_LOG_TM_RESOLUTION);
		cryptTmResolution.setConfigValue(obj01.get("global_policy_crypt_log_tm_resolution").toString());
		param.add(cryptTmResolution.toJSONString());
		
		//암복호화 로그 AP에서 최대 압축값
		SysConfig cryptLogCompressLimit = new SysConfig();
		cryptLogCompressLimit.setConfigKey(SystemCode.SysConfigKey.GLOBAL_POLICY_CRYPT_LOG_COMPRESS_LIMIT);
		cryptLogCompressLimit.setConfigValue(obj01.get("global_policy_crypt_log_compress_limit").toString());
		param.add(cryptLogCompressLimit.toJSONString());
		
        //암복호화 로그 압축 시작값
		SysConfig cryptLogCompressInitial = new SysConfig();
		cryptLogCompressInitial.setConfigKey(SystemCode.SysConfigKey.GLOBAL_POLICY_CRYPT_LOG_COMPRESS_INITIAL);
		cryptLogCompressInitial.setConfigValue(obj01.get("global_policy_crypt_log_compress_initial").toString());
		param.add(cryptLogCompressInitial.toJSONString()); 
		
		//암복호화 로그 압축 중단 시간 
		SysConfig cryptLogCompressFlushTimeout = new SysConfig();
		cryptLogCompressFlushTimeout.setConfigKey(SystemCode.SysConfigKey.GLOBAL_POLICY_CRYPT_LOG_COMPRESS_FLUSH_TIMEOUT);
		cryptLogCompressFlushTimeout.setConfigValue(obj01.get("global_policy_crypt_log_compress_flush_timeout").toString());
		param.add(cryptLogCompressFlushTimeout.toJSONString());
		
		//암복호화 로그 압축 출력 시간
		SysConfig cryptLogCompressPrintPeriod = new SysConfig();
		cryptLogCompressPrintPeriod.setConfigKey (SystemCode.SysConfigKey.GLOBAL_POLICY_CRYPT_LOG_COMPRESS_PRINT_PERIOD);
		cryptLogCompressPrintPeriod.setConfigValue (obj01.get("global_policy_crypt_log_compress_print_period").toString());
		param.add(cryptLogCompressPrintPeriod.toJSONString());
		
		//암복호화 로그 전송 대기 시간 -> 보안정책 옵션 설정 저장2 에서 등록함

		HashMap body = new HashMap();
		body.put("SysConfig", param);

		body.put(SystemCode.CustomFormParamKey.isPolicyConfig, true);
		
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
		
		result.put("resultCode", resultCode);
		result.put("resultMessage", resultMessage);

		return result;
		
	}

	public JSONObject updateSysMultiValueConfigList(String restIp, int restPort, String strTocken, JSONObject obj02,
			JSONArray rows03, String loginId, String entityId) throws Exception {
		
		JSONObject result = new JSONObject();
		
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
		
		if(obj02.get("blnIsvalueTrueFalse").equals(true)){
			batchLogConf.setValueTrueFalse(true); //암복호화 로그를 지정되 시간에만 수집 체크 true/false
		}else{
			batchLogConf.setValueTrueFalse(false); //암복호화 로그를 지정되 시간에만 수집 체크 true/false
		}
   
		BigDecimal valueNumber = new BigDecimal(0);
		BigDecimal valueNumber2 = new BigDecimal(24);
		
		String start_exe_h = obj02.get("start_exe_h").toString();	
		int intStart_exe_h = Integer.parseInt(start_exe_h);
		
		String stop_exe_h = obj02.get("stop_exe_h").toString();	
		int intStop_exe_h = Integer.parseInt(stop_exe_h);
		
		batchLogConf.setValueNumber(new BigDecimal(intStart_exe_h)); //전송 시작
		batchLogConf.setValueNumber2(new BigDecimal(intStop_exe_h)); //전송 종료
		
		
		int weekday = 0;
		for (int i = 0; i < 7; i++)
		{
			if (rows03.get(i).equals(true)) {
				weekday |= numWeek[i];
		    }
		}
		batchLogConf.setValueString(Integer.toHexString(weekday));
		param.add(batchLogConf.toJSONString());

		SysMultiValueConfig logUploadDelay = new SysMultiValueConfig();
		logUploadDelay.setConfigKey(SystemCode.SysConfigKey.BATCH_LOG_UPLOAD_DELAY);		
		String logTransferWaitTime = obj02.get("logTransferWaitTime").toString();	
		int intLogTransferWaitTime = Integer.parseInt(logTransferWaitTime);
		logUploadDelay.setValueNumber(new BigDecimal(intLogTransferWaitTime)); //암복호화 로그 전송 대기 시간  값
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
		
		result.put("resultCode", resultCode);
		result.put("resultMessage", resultMessage);

		return result;
	}

	public JSONObject selectSysMultiValueConfigListLike2(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {
		JSONObject result = new JSONObject();
		JSONArray jsonArray = new JSONArray();
		
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
			JSONObject jObj = new JSONObject();
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
					jObj.put("MONITOR_POLLING_SERVER", bdValueNumber);
				} else if(strConfigKey.equals(SystemCode.SysConfigKey.MONITOR_POLLING_AGENT)) {
					System.out.println("정책전송 중지 : " + blnIsvalueTrueFalse);
					jObj.put("ValueTrueFalse", blnIsvalueTrueFalse);
					System.out.println("에이전트와 관리서버 통신 주기 : " + bdValueNumber);
					jObj.put("MONITOR_POLLING_AGENT", bdValueNumber);
				} else if(strConfigKey.equals(SystemCode.SysConfigKey.MONITOR_EXPIRE_CRYPTO_KEY)) {
					System.out.println("암호화 키의 유효기간이 다음 날짜 이하로 남으면 경고 : " + bdValueNumber);
					jObj.put("MONITOR_EXPIRE_CRYPTO_KEY", bdValueNumber);
				} else if(strConfigKey.equals(SystemCode.SysConfigKey.MONITOR_AGENT_AUDIT_LOG_HMAC)) {
					System.out.println("에이전트가 기록하는 로그에 위변조 방지를 적용 : " + blnIsvalueTrueFalse);
					jObj.put("MONITOR_AGENT_AUDIT_LOG_HMAC", blnIsvalueTrueFalse);
				}
				jsonArray.add(jObj);
				result.put("list", jsonArray);
			}	
		} 		
			result.put("resultCode", resultCode);
			result.put("resultMessage", resultMessage);
		return result;
	}

	public JSONObject updateSysMultiValueConfigList2(String restIp, int restPort, String strTocken, JSONObject obj, String loginId, String entityId) throws Exception {
		JSONObject result = new JSONObject();
		
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
		String MONITOR_POLLING_SERVER = obj.get("MONITOR_POLLING_SERVER").toString();	
		int intMONITOR_POLLING_SERVER = Integer.parseInt(MONITOR_POLLING_SERVER);
		
		serverPolling.setValueNumber(new BigDecimal(intMONITOR_POLLING_SERVER)); //관리서버 모니터링 주기 입력값
		serverPolling.setValueNumber2(null); //무조건 null
		serverPolling.setValueString(SystemCode.MonitorResultLevel.WARN);

		param.add(serverPolling.toJSONString());
		
		//에이전트와 관리서버 통신주기
		//MONITOR_POLLING_AGENT
		SysMultiValueConfig agentPolling = new SysMultiValueConfig();
		agentPolling.setConfigKey(SystemCode.SysConfigKey.MONITOR_POLLING_AGENT);
		
		if(obj.get("ValueTrueFalse").equals(true)){
			agentPolling.setValueTrueFalse(true); // 정책전송 중지 체크 값 체크이면 true
		}else{
			agentPolling.setValueTrueFalse(false); // 정책전송 중지 체크 값 체크이면 true
		}
		
		String MONITOR_POLLING_AGENT = obj.get("MONITOR_POLLING_AGENT").toString();	
		int intMONITOR_POLLING_AGENT = Integer.parseInt(MONITOR_POLLING_AGENT);
		agentPolling.setValueNumber(new BigDecimal(intMONITOR_POLLING_AGENT)); //에이전트와 관리서버 통신주기 입력값
		agentPolling.setValueNumber2(null); //무조건 null
		agentPolling.setValueString(SystemCode.MonitorResultLevel.WARN);

		param.add(agentPolling.toJSONString());
		
		//에이전트가 기록하는 로그에 위변조 방지를 적용
		//MONITOR_AGENT_AUDIT_LOG_HMAC 
		SysMultiValueConfig agentLogHmac = new SysMultiValueConfig();
		agentLogHmac.setConfigKey(SystemCode.SysConfigKey.MONITOR_AGENT_AUDIT_LOG_HMAC);
		
		if(obj.get("MONITOR_AGENT_AUDIT_LOG_HMAC").equals(true)){
			agentLogHmac.setValueTrueFalse(true); //에이전트가 기록하는 로그에 위변조 방지를 적용 체크 값 체크면 true
		}else{
			agentLogHmac.setValueTrueFalse(false); //에이전트가 기록하는 로그에 위변조 방지를 적용 체크 값 체크면 true
		}
		
		agentLogHmac.setValueNumber(new BigDecimal(0)); // 무조건 0
		agentLogHmac.setValueNumber2(null); //무조건 null
		agentLogHmac.setValueString(SystemCode.MonitorResultLevel.NORMAL);

		param.add(agentLogHmac.toJSONString());
		
		//암호화 키의 유효기간이 다음 날짜 이하로 남으면 경고
		//MONITOR_EXPIRE_CRYPTO_KEY
		SysMultiValueConfig keyExpire = new SysMultiValueConfig();
		keyExpire.setConfigKey(SystemCode.SysConfigKey.MONITOR_EXPIRE_CRYPTO_KEY);
        keyExpire.setValueTrueFalse(false); //무조건 false
        String MONITOR_EXPIRE_CRYPTO_KEY = obj.get("MONITOR_EXPIRE_CRYPTO_KEY").toString();	
		int intMONITOR_EXPIRE_CRYPTO_KEY = Integer.parseInt(MONITOR_EXPIRE_CRYPTO_KEY);
		keyExpire.setValueNumber(new BigDecimal(intMONITOR_EXPIRE_CRYPTO_KEY)); //암호화 키의 유효기간이 다음 날짜 이하로 남으면 경고 입력값
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
		
		result.put("resultCode", resultCode);
		result.put("resultMessage", resultMessage);
		return result;
	}

	public String serverMasterKeyDecode(String passwordStr, String loadStr, String loginId, String entityId) throws Exception {
		AESCrypt aes = new AESCrypt();
		String encKey = null;
		//복호화
		try {
			//String pwd = "1234qwer";
			encKey = aes.GetMasterStr(passwordStr, loadStr);
		} catch(Exception e) {
			//화면에 alert 메시지
			System.out.println("message : " + "마스터키 파일을 읽을 수 없거나 비밀번호가 틀렸습니다");
		}
		return encKey;	
	}

	public String encMasterkey(String mstKeyRenewPassword, String loginId, String entityId) throws Exception {
		AESCrypt aes = new AESCrypt();		
		
		//암호화
		MasterKeyFile m = aes.GenerateMasterStr(mstKeyRenewPassword);	
		
		  Map obj = new LinkedHashMap();		  
		  obj.put("mas", m.getMas());
		  obj.put("ter", m.getTer());
		  obj.put("key", m.getKey());	
		  String jsonObj = JSONValue.toJSONString(obj);

		  return jsonObj;

	}

	public JSONObject changeServerKey(String restIp, int restPort, String strTocken, String oldPassword,
			String newPassword, String loginId, String entityId) throws Exception {

		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.SYSTEM_SERVICE;
		String strCommand = SystemCode.ServiceCommand.CHANGESERVERKEY;

		AdminServerPasswordRequest adminServerPasswordRequest = new AdminServerPasswordRequest();
		adminServerPasswordRequest.setOldPassword(oldPassword);
		adminServerPasswordRequest.setNewPassword(newPassword);

		//JSONObject parameters = new JSONObject();
		//parameters.put("profile", vo);
		
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
		
		System.out.println("resultCode : " + resultCode + " resultMessage : " + resultMessage);
		
		if(resultCode.equals(SystemCode.ResultCode.SUCCESS)) {
			return resultJson;
		} else {
			
		}
		return resultJson;

	}

	public JSONObject selectAgentMonitoring(String restIp, int restPort, String strTocken, String loginId,
			String entityId) throws Exception {
		
		JSONObject result = new JSONObject();
		
		JSONArray jsonArray = new JSONArray();
		
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
		resultMessage = new String(resultMessage.getBytes("iso-8859-1"),"UTF-8"); 
		//long totalListCount = (long) resultJson.get("totalListCount");
		
		
		if(resultCode.equals("0000000000")) {
			ArrayList list = (ArrayList) resultJson.get("list");
			
			//System.out.println("list Size : " + list.size());
			//if(totalListCount > 0) {
				for(int i=0; i<list.size(); i++) {
					JSONObject data = (JSONObject) list.get(i);
					JSONObject jsonObj = new JSONObject();
					Entity entity = new Entity();
					Gson gson = new Gson();
					entity = gson.fromJson(data.toJSONString(), entity.getClass());
					
					jsonObj.put("no", i+1);
					jsonObj.put("createDateTime", entity.getCreateDateTime());
					jsonObj.put("receivedPolicyVersion", entity.getReceivedPolicyVersion());
					jsonObj.put("entityUid", entity.getEntityUid());
					jsonObj.put("entityTypeCode", entity.getEntityTypeCode());
					jsonObj.put("latestDateTime", entity.getLatestDateTime());
					jsonObj.put("sentPolicyVersion", entity.getSentPolicyVersion());
					jsonObj.put("latestAddress", entity.getLatestAddress());
					jsonObj.put("entityStatusName", entity.getEntityStatusName());
					if(entity.getEntityName() != null) {
						jsonObj.put("entityName", new String(entity.getEntityName().toString().getBytes("iso-8859-1"),"UTF-8"));
					}
					if(entity.getUpdateName() != null) {
						jsonObj.put("updateName", new String(entity.getUpdateName().toString().getBytes("iso-8859-1"),"UTF-8"));
					}

					jsonObj.put("extendedField", entity.getExtendedField());
					jsonObj.put("appVersion", entity.getAppVersion());
					jsonObj.put("entityStatusCode", entity.getEntityStatusCode());
					jsonObj.put("updateDateTime", entity.getUpdateDateTime());
					jsonObj.put("resultMessage", resultCode);
					jsonObj.put("resultCode", resultMessage);

					jsonArray.add(jsonObj);
					
					result.put("list", jsonArray);
					result.put("resultCode", resultCode);
					result.put("resultMessage", resultMessage);
					System.out.println("getEntityUid : " + entity.getEntityUid());
					System.out.println("getEntityName : " + new String(entity.getEntityName().toString().getBytes("iso-8859-1"),"UTF-8") );
			}
		}
			result.put("resultCode", resultCode);
			result.put("resultMessage", resultMessage);
		
		return result;
	}

	public JSONArray selectParamSysCodeList(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {
		
		JSONArray jsonArray = new JSONArray();
		
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
					
					JSONObject jsonObj = new JSONObject();
					
					if(sysCode.getSysStatusCode().equals("SS50")) {
						jsonObj.put("sysStatusCode", sysCode.getSysStatusCode());
						jsonObj.put("sysCode", sysCode.getSysCode());
						jsonObj.put("sysCodeName", sysCode.getSysCodeName());
						jsonObj.put("sysCodeValue", sysCode.getSysCodeValue());	
						jsonObj.put("resultMessage", resultCode);
						jsonObj.put("resultCode", resultMessage);
						
						jsonArray.add(jsonObj);
						
					}
			}
		}else{
			JSONObject jsonObj = new JSONObject();
			jsonObj.put("resultMessage", resultCode);
			jsonObj.put("resultCode", resultMessage);
			jsonArray.add(jsonObj);		
		}
		return jsonArray;
	}

	public JSONObject updateEntity(String restIp, int restPort, String strTocken, String loginId, String entityId, String entityName, String entityUid, String entityStatusCode) throws Exception {
	
		JSONObject result = new JSONObject();
		
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.ENTITY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.UPDATEENTITY;


		Entity param = new Entity();
		param.setEntityUid(entityUid);
		param.setEntityName(entityName);
		param.setEntityStatusCode(entityStatusCode);
		param.setCreateUid(entityId);
		

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
				
		return result;
	}
}
