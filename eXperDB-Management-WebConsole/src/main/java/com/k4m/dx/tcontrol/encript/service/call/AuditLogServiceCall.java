package com.k4m.dx.tcontrol.encript.service.call;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.google.gson.Gson;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.EncryptCommonService;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.SystemCode;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.TypeUtility;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.AuditLog;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.AuditLogSite;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.BackupLog;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.Entity;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.SystemUsage;

public class AuditLogServiceCall {

	/**
	 * 암복호화 감사로그
	 * @param restIp
	 * @param restPort
	 * @return 
	 * @throws Exception
	 */
	public JSONObject selectAuditLogSiteList(String restIp, int restPort, String strTocken) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.LOG_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTAUDITLOGSITELIST;

		
		AuditLogSite param = new AuditLogSite();
		param.setSearchAgentLogDateTimeFrom("20180123000000"); 
		param.setSearchAgentLogDateTimeTo("20180208240000");
		param.setAgentUid("");
		param.setSuccessTrueFalse(true);
		param.setPageOffset(1);
		param.setPageSize(10001);
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
		
		return resultJson;
	}
	
	/**
	 * 관리서버 감사로그
	 * @param restIp
	 * @param restPort
	 * @param param 
	 * @return 
	 * @throws Exception
	 */
	public JSONObject selectAuditLogList(String restIp, int restPort, String strTocken, AuditLog param) throws Exception {
		JSONArray jsonArray = new JSONArray();
		JSONObject result = new JSONObject();
		
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.LOG_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTAUDITLOGLIST;
		
		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());

		String parameters = TypeUtility.makeRequestBody(body);
		
		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, "admin");
		header.put(SystemCode.FieldName.ENTITY_UID, "00000000-0000-0000-0000-000000000001");
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);

		JSONObject resultJson = api.callService(strService, strCommand, header, parameters.toString());
			
		String resultCode = (String) resultJson.get("resultCode");
		String resultMessage = (String) resultJson.get("resultMessage");
		long totalListCount = (long) resultJson.get("totalListCount");
		
		if(resultCode.equals("0000000000") &&  totalListCount > 0 ) {
			ArrayList list = (ArrayList) resultJson.get("list");		
			
			for(int i=0; i<list.size(); i++) {
				JSONObject log = (JSONObject) list.get(i);
				JSONObject jsonObj = new JSONObject();
				
				Gson gson = new Gson();
				AuditLog auditLog = new AuditLog();
				auditLog = gson.fromJson(log.toJSONString(), auditLog.getClass());
				
				//접근자이름 entityName
				String strEntityName = auditLog.getEntityName();
				if(strEntityName != null) {
					strEntityName = new String(strEntityName.getBytes("iso-8859-1"),"UTF-8"); 
				}
				//결과메시지resultMessage
				String strResultMessage = auditLog.getResultMessage();
				if(strResultMessage != null) {
					strResultMessage = new String(strResultMessage.getBytes("iso-8859-1"),"UTF-8"); 
				}
				jsonObj.put("rnum", i+1);
				jsonObj.put("logDateTime", auditLog.getCreateDateTime());
				jsonObj.put("entityName", strEntityName);
				jsonObj.put("remoteAddress", auditLog.getRemoteAddress());
				jsonObj.put("requestPath", auditLog.getRequestPath());
				jsonObj.put("parameter", auditLog.getParameter());
				jsonObj.put("resultCode", auditLog.getResultCode());
				jsonObj.put("resultMessage", strResultMessage);
				jsonArray.add(jsonObj);
			}
			result.put("data", jsonArray);
			System.out.println(result);
		}
		return result;
	}
	
	
	/**
	 * 암호화 키 접근로그
	 * @param restIp
	 * @param restPort
	 * @param param 
	 * @return 
	 * @throws Exception
	 */
	public JSONObject selectAuditLogListKey(String restIp, int restPort, String strTocken, AuditLog param) throws Exception {
		JSONArray jsonArray = new JSONArray();
		JSONObject result = new JSONObject();
		
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.LOG_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTAUDITLOGLIST;

		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());

		String parameters = TypeUtility.makeRequestBody(body);

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, "admin");
		header.put(SystemCode.FieldName.ENTITY_UID, "00000000-0000-0000-0000-000000000001");
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);

		JSONObject resultJson = api.callService(strService, strCommand, header, parameters.toString());				
		
		String resultCode = (String) resultJson.get("resultCode");
		String resultMessage = (String) resultJson.get("resultMessage");
		long totalListCount = (long) resultJson.get("totalListCount");
		
		resultMessage = new String(resultMessage.getBytes("iso-8859-1"),"UTF-8"); 
		
		if(resultCode.equals("0000000000") &&  totalListCount > 0) {
			ArrayList list = (ArrayList) resultJson.get("list");
			for(int i=0; i<list.size(); i++) {
				JSONObject log = (JSONObject) list.get(i);
				JSONObject jsonObj = new JSONObject();
				
				Gson gson = new Gson();
				AuditLog auditLog = new AuditLog();
				auditLog = gson.fromJson(log.toJSONString(), auditLog.getClass());

				//접근자이름 entityName
				String strEntityName = auditLog.getEntityName();
				if(strEntityName != null) {
					strEntityName = new String(strEntityName.getBytes("iso-8859-1"),"UTF-8"); 
				}
				//결과메시지resultMessage
				String strResultMessage = auditLog.getResultMessage();
				if(strResultMessage != null) {
					strResultMessage = new String(strResultMessage.getBytes("iso-8859-1"),"UTF-8"); 
				}
				jsonObj.put("rnum", i+1);
				jsonObj.put("logDateTime", auditLog.getCreateDateTime());
				jsonObj.put("entityName", strEntityName);
				jsonObj.put("remoteAddress", auditLog.getRemoteAddress());
				jsonObj.put("requestPath", auditLog.getRequestPath());
				jsonObj.put("parameter", auditLog.getParameter());
				jsonObj.put("resultCode", auditLog.getResultCode());
				jsonObj.put("resultMessage", strResultMessage);
				jsonArray.add(jsonObj);
			}
			result.put("data", jsonArray);
			System.out.println(result);
		}
		return result;
		
	}
	
	
	/**
	 * 자원사용로그
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @param param 
	 * @return 
	 * @throws Exception
	 */
	public JSONObject selectSystemUsageLogList(String restIp, int restPort, String strTocken, SystemUsage param) throws Exception {
		JSONArray jsonArray = new JSONArray();
		JSONObject result = new JSONObject();
		
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.LOG_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTSYSTEMUSAGELOGLIST;

		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());

		String parameters = TypeUtility.makeRequestBody(body);

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, "admin");
		header.put(SystemCode.FieldName.ENTITY_UID, "00000000-0000-0000-0000-000000000001");
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);

		JSONObject resultJson = api.callService(strService, strCommand, header, parameters.toString());
		
		String resultCode = (String) resultJson.get("resultCode");
		String resultMessage = (String) resultJson.get("resultMessage");
		long totalListCount = (long) resultJson.get("totalListCount");
		
		if(resultCode.equals("0000000000")) {
			ArrayList list = (ArrayList) resultJson.get("list");
			if(totalListCount > 0) {
				for(int i=0; i<list.size(); i++) {
					JSONObject log = (JSONObject) list.get(i);
					JSONObject jsonObj = new JSONObject();
					
					Gson gson = new Gson();
					SystemUsage systemUsage = new SystemUsage();
					systemUsage = gson.fromJson(log.toJSONString(), systemUsage.getClass());
					
					systemUsage.getSiteLogDateTime();
					systemUsage.getServerLogDateTime();				
					
					jsonObj.put("siteLogDateTime", systemUsage.getSiteLogDateTime());
					jsonObj.put("serverLogDateTime", systemUsage.getServerLogDateTime());
					jsonObj.put("monitoredAddress", systemUsage.getMonitoredAddress());
					jsonObj.put("monitoredUid", systemUsage.getMonitoredUid());
					jsonObj.put("monitoredName", systemUsage.getMonitoredName());
					jsonObj.put("targetResourceType", systemUsage.getTargetResourceType());
					jsonObj.put("targetResource", systemUsage.getTargetResource());
					jsonObj.put("resultLevel", systemUsage.getResultLevel());
					jsonObj.put("usageRate", systemUsage.getUsageRate());
					jsonObj.put("limitRate", systemUsage.getLimitRate());
					jsonObj.put("logMessage", systemUsage.getLogMessage());
					
					jsonArray.add(jsonObj);
				}
				result.put("data", jsonArray);
				System.out.println(result);			
			}
		}
		return result;
	}	
	
	
	/**
	 * 백업/복원 감사로그
	 * @param restIp
	 * @param restPort
	 * @param param 
	 * @return 
	 * @throws Exception
	 */
	public JSONObject selectBackupLogList(String restIp, int restPort, String strTocken, BackupLog param) throws Exception {
		JSONArray jsonArray = new JSONArray();
		JSONObject result = new JSONObject();
		
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.BACKUP_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTBACKUPLOGLIST;
		
		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());

		String parameters = TypeUtility.makeRequestBody(body);
		
		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, "admin");
		header.put(SystemCode.FieldName.ENTITY_UID, "00000000-0000-0000-0000-000000000001");
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);

		JSONObject resultJson = api.callService(strService, strCommand, header, parameters.toString());
		
		String resultCode = (String) resultJson.get("resultCode");
		String resultMessage = (String) resultJson.get("resultMessage");
		long totalListCount = (long) resultJson.get("totalListCount");
		
		if(resultCode.equals("0000000000")) {
			ArrayList list = (ArrayList) resultJson.get("list");
			if(totalListCount > 0) {
				for(int i=0; i<list.size(); i++) {
					JSONObject log = (JSONObject) list.get(i);
					JSONObject jsonObj = new JSONObject();
					
					Gson gson = new Gson();
					BackupLog backupLog = new BackupLog();
					backupLog = gson.fromJson(log.toJSONString(), backupLog.getClass());
					
					//접근자이름 entityName
					String strEntityName = (String) log.get("entityName");
					if(strEntityName != null) {
						strEntityName = new String(strEntityName.getBytes("iso-8859-1"),"UTF-8"); 
					}

					jsonObj.put("rnum", i+1);
					jsonObj.put("logDateTime", log.get("createDateTime"));
					jsonObj.put("entityName", strEntityName);
					jsonObj.put("remoteAddress", log.get("remoteAddress"));
					jsonObj.put("serverAddress", "");
					jsonObj.put("backupWorkType", "");
					jsonObj.put("backupType", "");
					jsonObj.put("logDateTimeFrom", "");
					jsonObj.put("logDateTimeTo", "");
					
					jsonArray.add(jsonObj);
				}
				result.put("data", jsonArray);
				System.out.println(result);		
			}
		}
		return result;
		
	}
	
	/**
	 * 접근자 리스트
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @return 
	 * @throws Exception
	 */
	public JSONArray selectEntityList(String restIp, int restPort, String strTocken) throws Exception {
		JSONArray jsonArray = new JSONArray();
		
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.ENTITY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTENTITYLIST;

		String monitored = "false"; 
		HashMap body = new HashMap();
		body.put("monitored", monitored);
		String parameters = TypeUtility.makeRequestBody(body);
		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, "admin");
		header.put(SystemCode.FieldName.ENTITY_UID, "00000000-0000-0000-0000-000000000001");
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);
		JSONObject resultJson = api.callService(strService, strCommand, header, parameters.toString());

		String resultCode = (String) resultJson.get("resultCode");
		String resultMessage = (String) resultJson.get("resultMessage");
		//long totalListCount = (long) resultJson.get("totalListCount");
		
		if(resultCode.equals("0000000000")) {
			ArrayList list = (ArrayList) resultJson.get("list");
				for(int i=0; i<list.size(); i++) {
					JSONObject data = (JSONObject) list.get(i);
					JSONObject jsonObj = new JSONObject();
					
					Entity entity = new Entity();
					Gson gson = new Gson();
					entity = gson.fromJson(data.toJSONString(), entity.getClass());

					jsonObj.put("getEntityUid", entity.getEntityUid());
					jsonObj.put("getEntityName", new String(entity.getEntityName().toString().getBytes("iso-8859-1"),"UTF-8"));
					jsonArray.add(jsonObj);
				}
		}
		return jsonArray;
	}
}
