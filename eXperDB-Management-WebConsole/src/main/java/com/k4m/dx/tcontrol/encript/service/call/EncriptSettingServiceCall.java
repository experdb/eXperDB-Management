package com.k4m.dx.tcontrol.encript.service.call;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.google.gson.Gson;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.EncryptCommonService;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.SystemCode;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.TypeUtility;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.SysMultiValueConfig;

public class EncriptSettingServiceCall {

	public JSONArray selectSysConfigListLike(String restIp, int restPort, String strTocken) throws Exception {
		JSONArray jsonArray = new JSONArray();
	
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.SYSTEM_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTSYSCONFIGLISTLIKE;

		
		HashMap body = new HashMap();
		body.put(SystemCode.CustomFormParamKey.sysConfigKeyPrefix, SystemCode.SysConfigKeyPrefix.GLOBAL_POLICY);

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
				
				jsonArray.add(jObj);
				
				String strConfigKey = (String) jsonObj.get("configKey");
				String strConfigValue = (String) jsonObj.get("configValue"); 
				System.out.println("strConfigKey : " + strConfigKey + " - strConfigValue : " + strConfigValue);

			}
		} else {
			
		}
		return jsonArray;
	}

	public JSONArray selectSysMultiValueConfigListLike(String restIp, int restPort, String strTocken) throws Exception {
		
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
					
				} else if(strConfigKey.equals(SystemCode.SysConfigKey.BATCH_LOG_UPLOAD_DELAY)) {
					//암복호화 로그 전송 대기 시간 
					System.out.println("암복호화 로그 전송 대기 시간 : " + bdValueNumber);
					jObj.put("logTransferWaitTime", bdValueNumber);
				}
				jsonArray.add(jObj);
			}
		} else {
			
		}
		return jsonArray;
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
