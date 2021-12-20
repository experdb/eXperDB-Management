package com.k4m.dx.tcontrol.encrypt.service.call;

import java.util.ArrayList;
import java.util.HashMap;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.k4m.dx.tcontrol.cmmn.serviceproxy.EncryptCommonService;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.SystemCode;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.TypeUtility;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.AuditLogSiteStatCondition;

public class StatisticsServiceCall {

	//암호화 통계
	public JSONObject selectAuditLogSiteHourForStat(String restIp, int restPort, String strTocken, String loginId, String entityId, String from, String to, String categoryColumn) throws Exception {

		JSONObject result = new JSONObject();
		JSONArray jsonArray = new JSONArray();
		
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
		param.setSearchAgentLogDateTimeFrom(from);
		param.setSearchAgentLogDateTimeTo(to);
		param.setCategoryColumn(categoryColumn);
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
					
					JSONObject jObj = new JSONObject();
					
					jObj.put("encryptSuccessCount",  jsonObj.get("encryptsuccesscount").toString());
					jObj.put("encryptFailCount", jsonObj.get("encryptfailcount").toString());
					jObj.put("decryptSuccessCount", jsonObj.get("decryptsuccesscount").toString());
					jObj.put("decryptFailCount", jsonObj.get("decryptfailcount").toString());
					jObj.put("sumCount", jsonObj.get("sumcount").toString());
					jObj.put("categoryColumn", jsonObj.get("categorycolumn").toString());
					
					String category = jsonObj.get("categorycolumn").toString();
					String encryptSuccessCount = jsonObj.get("encryptsuccesscount").toString();
					String encryptFailCount = jsonObj.get("encryptfailcount").toString();
					String decryptSuccessCount = jsonObj.get("decryptsuccesscount").toString();
					String decryptFailCount = jsonObj.get("decryptfailcount").toString();
					String sumCount = jsonObj.get("sumcount").toString();
			
//					System.out.println("encryptSuccessCount : " + encryptSuccessCount + " encryptFailCount : " + encryptFailCount);
//					System.out.println("decryptSuccessCount : " + decryptSuccessCount + " decryptFailCount : " + decryptFailCount);
//					System.out.println("sumCount : " + sumCount );	
//					System.out.println("categoryColumn : " + category );	
					
					
					jsonArray.add(jObj);
					
					result.put("list", jsonArray);
					
				}
			}else{
				JSONObject jObj = new JSONObject();
				
				jObj.put("encryptSuccessCount", "0");
				jObj.put("encryptFailCount", "0");
				jObj.put("decryptSuccessCount", "0");
				jObj.put("decryptFailCount", "0");
				jObj.put("sumCount", "0");
				jObj.put("categoryColumn", "-");
				
				jsonArray.add(jObj);
				
				result.put("list", jsonArray);
			}
		}else{	
			result.put("list", jsonArray);			
		}
		
		result.put("resultCode", resultCode);
		result.put("resultMessage", resultMessage);
		
		return result;
	}
}
