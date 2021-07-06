package com.k4m.dx.tcontrol.encrypt.service.call;

import java.util.ArrayList;
import java.util.HashMap;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.google.gson.Gson;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.EncryptCommonService;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.SystemCode;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.TypeUtility;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.SystemStatus;

public class AgentMonitoringServiceCall {
	
	public JSONArray selectSystemStatus(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {

		JSONObject result = new JSONObject();
		JSONArray jsonArray = new JSONArray();
		
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.MONITOR_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTSYSTEMSTATUS;

		SystemStatus param = new SystemStatus();

		param.setMonitoredUid(""); //전체


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

					Gson gson = new Gson();
					SystemStatus systemStatus = new SystemStatus();
					systemStatus = gson.fromJson(jsonObj.toJSONString(), systemStatus.getClass());
					
					String serverLogDateTime = systemStatus.getServerLogDateTime();
					String siteLogDateTime = systemStatus.getSiteLogDateTime();
					String monitoredAddress = systemStatus.getMonitoredAddress();
					String siteAccessAddress = systemStatus.getSiteAccessAddress();
					String monitoredUid = systemStatus.getMonitoredUid();
					String monitoredName = systemStatus.getMonitoredName();
					String targetType = systemStatus.getTargetType();
					String targetUid = systemStatus.getTargetUid();
					String targetName = systemStatus.getTargetName();
					String monitorType = systemStatus.getMonitorType();
					String resultLevel = systemStatus.getResultLevel();
					String logMessage = systemStatus.getLogMessage();
					
					System.out.println("serverLogDateTime : " + serverLogDateTime);
					System.out.println("siteLogDateTime : " + siteLogDateTime);
					System.out.println("monitoredAddress : " + monitoredAddress);
					System.out.println("siteAccessAddress : " + siteAccessAddress);
					System.out.println("monitoredUid : " + monitoredUid);
					System.out.println("monitoredName : " + monitoredName);
					System.out.println("targetType : " + targetType);
					System.out.println("targetUid : " + targetUid );
					System.out.println("targetName : " + targetName );
					System.out.println("monitorType : " + monitorType );
					System.out.println("resultLevel : " + resultLevel );
					System.out.println("logMessage : " + logMessage );
					
					

					if(targetType.equals("AGENT") && targetUid.equals("STATUS") && targetName.equals("STATUS") && monitorType.equals("CONNECTION") && resultLevel.equals("WARN")){
						JSONObject jObj = new JSONObject();
						jObj.put("monitoredName", monitoredName);
						jObj.put("logMessage", logMessage);
						jObj.put("status", "stop");
						jObj.put("resultCode", resultCode);
						jObj.put("resultMessage", resultMessage);
						jsonArray.add(jObj);
					}
					
					if(targetType.equals("LICENSE") && targetName.equals("LICENSE")){
						JSONObject jObj = new JSONObject();
						jObj.put("monitoredName", monitoredName);
						jObj.put("logMessage", logMessage);
						jObj.put("status", "licenseCheck");
						jsonArray.add(jObj);
					}
					
				}
			}
		}else{
			JSONObject jObj = new JSONObject();
			jObj.put("resultCode", resultCode);
			jObj.put("resultMessage", resultMessage);
			jsonArray.add(jObj);
		}
		
		
		return jsonArray;
	}
}
