package com.k4m.dx.tcontrol.encrypt.service.call;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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
	 * @param param 
	 * @return 
	 * @throws Exception
	 */
	public JSONObject selectAuditLogSiteList(String restIp, int restPort, String strTocken, AuditLogSite param, String loginId, String entityId) throws Exception {
		JSONArray jsonArray = new JSONArray();
		JSONObject result = new JSONObject();
		
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.LOG_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTAUDITLOGSITELIST;

		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());

		String parameters = TypeUtility.makeRequestBody(body);

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);

		JSONObject resultJson = api.callService(strService, strCommand, header, parameters.toString());
		
		String resultCode = (String) resultJson.get("resultCode");
		String resultMessage = new String(((String) resultJson.get("resultMessage")).getBytes("iso-8859-1"));
		
		if(resultCode.equals(SystemCode.ResultCode.SUCCESS)) {
			ArrayList list = (ArrayList) resultJson.get("list");		
			if(list != null){
				for(int i=0; i<list.size(); i++) {
					JSONObject log = (JSONObject) list.get(i);
					Gson gson = new Gson();
					AuditLogSite auditLogSite = new AuditLogSite();
					auditLogSite = gson.fromJson(log.toJSONString(), auditLogSite.getClass());
					
					JSONObject jsonObj = new JSONObject();
					jsonObj.put("rnum", i+1);
					jsonObj.put("createDateTime", auditLogSite.getCreateDateTime());
					jsonObj.put("count", auditLogSite.getCount());
					jsonObj.put("extraName", auditLogSite.getExtraName());
					jsonObj.put("serverIntegrityResult", auditLogSite.getServerIntegrityResult());
					jsonObj.put("siteResultCode", auditLogSite.getSiteResultCode());
					jsonObj.put("adminLoginId", auditLogSite.getAdminLoginId());
					jsonObj.put("agentRemoteAddress", auditLogSite.getAgentRemoteAddress());
					jsonObj.put("siteAccessAddress", auditLogSite.getSiteAccessAddress());
					jsonObj.put("siteIntegrityResult", auditLogSite.getSiteIntegrityResult());
					jsonObj.put("weekday", auditLogSite.getWeekday());
					jsonObj.put("integrityValue", auditLogSite.getIntegrityValue());
					jsonObj.put("hostName", auditLogSite.getHostName());
					jsonObj.put("pageOffset", auditLogSite.getPageOffset());
					jsonObj.put("updateDateTime", auditLogSite.getUpdateDateTime());
					jsonObj.put("encryptTrueFalse", auditLogSite.getEncryptTrueFalse());
					jsonObj.put("totalCountLimit", auditLogSite.getTotalCountLimit());
					jsonObj.put("applicationName", auditLogSite.getApplicationName());
					jsonObj.put("moduleInfo", auditLogSite.getModuleInfo());
					jsonObj.put("agentLogDateTime", auditLogSite.getAgentLogDateTime());
					jsonObj.put("pageSize", auditLogSite.getPageSize());
					jsonObj.put("instanceId", auditLogSite.getInstanceId());
					jsonObj.put("locationInfo", auditLogSite.getLocationInfo());
					jsonObj.put("osLoginId", auditLogSite.getOsLoginId());
					jsonObj.put("successTrueFalse", auditLogSite.getSuccessTrueFalse());
					jsonObj.put("agentUid", auditLogSite.getAgentUid());
					jsonObj.put("macAddr", auditLogSite.getMacAddr());
					jsonObj.put("serverLoginId", auditLogSite.getServerLoginId());
					jsonObj.put("profileName", new String(auditLogSite.getProfileName().getBytes("iso-8859-1"),"UTF-8"));
					jsonArray.add(jsonObj);
				}
				result.put("list", jsonArray);
			}
		}
		result.put("resultCode", resultCode);
		result.put("resultMessage", resultMessage);
		
		return result;
	}
	
	/**
	 * 관리서버 감사로그
	 * @param restIp
	 * @param restPort
	 * @param param 
	 * @return 
	 * @throws Exception
	 */
	public JSONObject selectAuditLogList(String restIp, int restPort, String strTocken, String loginId, String entityId, AuditLog param) throws Exception {
		JSONArray jsonArray = new JSONArray();
		JSONObject result = new JSONObject();
		
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.LOG_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTAUDITLOGLIST;
		
		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());

		String parameters = TypeUtility.makeRequestBody(body);
		
		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);

		JSONObject resultJson = api.callService(strService, strCommand, header, parameters.toString());
			
		String resultCode = (String) resultJson.get("resultCode");
		String resultMessage = (String) resultJson.get("resultMessage");
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		if(resultCode.equals(SystemCode.ResultCode.SUCCESS)) {
			ArrayList list = (ArrayList) resultJson.get("list");		
			if(list != null){
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
					//접근일시 logDateTime
					String logDateTime = auditLog.getCreateDateTime();
					Date logDateTimeDate = dateFormat.parse(logDateTime);
					
					jsonObj.put("rnum", i+1);
					jsonObj.put("logDateTime", dateFormat.format(logDateTimeDate));
					jsonObj.put("entityName", strEntityName);
					jsonObj.put("remoteAddress", auditLog.getRemoteAddress());
					jsonObj.put("requestPath", auditLog.getRequestPath());
					jsonObj.put("parameter", auditLog.getParameter());
					jsonObj.put("resultCode", auditLog.getResultCode());
					jsonObj.put("resultMessage", strResultMessage);
					jsonArray.add(jsonObj);
				}
				result.put("list", jsonArray);
			}
		}
			result.put("resultCode", resultCode);
			result.put("resultMessage", resultMessage);
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
	public JSONObject selectAuditLogListKey(String restIp, int restPort, String strTocken,String loginId, String entityId, AuditLog param) throws Exception {
		JSONArray jsonArray = new JSONArray();
		JSONObject result = new JSONObject();
		
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.LOG_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTAUDITLOGLIST;

		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());

		String parameters = TypeUtility.makeRequestBody(body);

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);

		JSONObject resultJson = api.callService(strService, strCommand, header, parameters.toString());				
		
		String resultCode = (String) resultJson.get("resultCode");
		String resultMessage = (String) resultJson.get("resultMessage");
		resultMessage = new String(resultMessage.getBytes("iso-8859-1"),"UTF-8"); 
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		if(resultCode.equals("0000000000")) {
			ArrayList list = (ArrayList) resultJson.get("list");
			if(list!=null){
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
					//접근일시 logDateTime
					String logDateTime = auditLog.getCreateDateTime();
					Date logDateTimeDate = dateFormat.parse(logDateTime);
					
					jsonObj.put("rnum", i+1);
					jsonObj.put("logDateTime", dateFormat.format(logDateTimeDate));
					jsonObj.put("entityName", strEntityName);
					jsonObj.put("remoteAddress", auditLog.getRemoteAddress());
					jsonObj.put("requestPath", auditLog.getRequestPath());
					jsonObj.put("parameter", auditLog.getParameter());
					jsonObj.put("resultCode", auditLog.getResultCode());
					jsonObj.put("resultMessage", strResultMessage);
					jsonArray.add(jsonObj);
				}
				result.put("list", jsonArray);
			}
		}
			result.put("resultCode", resultCode);
			result.put("resultMessage", resultMessage);
		
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
	public JSONObject selectBackupLogList(String restIp, int restPort, String strTocken,String loginId, String entityId, BackupLog param) throws Exception {
		JSONArray jsonArray = new JSONArray();
		JSONObject result = new JSONObject();
		
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.BACKUP_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTBACKUPLOGLIST;
		
		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());

		String parameters = TypeUtility.makeRequestBody(body);
		
		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
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
					jsonObj.put("logDateTime",log.get("logDateTime"));
					jsonObj.put("entityName",strEntityName);
					jsonObj.put("remoteAddress",log.get("remoteAddress"));
					jsonObj.put("serverAddress",log.get("serverAddress"));
					jsonObj.put("backupWorkType",log.get("backupWorkType"));
					jsonObj.put("backupType",log.get("backupType"));
					jsonObj.put("logDateTimeFrom",log.get("logDateTimeFrom"));
					jsonObj.put("logDateTimeTo",log.get("logDateTimeTo"));
					jsonObj.put("containsCryptoKey",log.get("containsCryptoKey"));
					jsonObj.put("containsPolicy",log.get("containsPolicy"));
					jsonObj.put("containsServer",log.get("containsServer"));
					jsonObj.put("containsAdminUser",log.get("containsAdminUser"));
					jsonObj.put("containsConfig",log.get("containsConfig"));
					jsonObj.put("containsCoreLog",log.get("containsCoreLog"));
					jsonObj.put("containsSiteLog",log.get("containsSiteLog"));
					jsonObj.put("containsBackupLog",log.get("containsBackupLog"));
					jsonObj.put("containsSystemUsageLog",log.get("containsSystemUsageLog"));
					jsonObj.put("containsSystemStatusLog",log.get("containsSystemStatusLog"));
					jsonObj.put("containsTableCryptLog",log.get("containsTableCryptLog"));
					jsonObj.put("filePath",log.get("filePath"));
					
					jsonArray.add(jsonObj);
				}
				result.put("data", jsonArray);
				System.out.println(result);		
			}
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
	public JSONObject selectSystemUsageLogList(String restIp, int restPort, String strTocken,String loginId, String entityId, SystemUsage param) throws Exception {
		JSONArray jsonArray = new JSONArray();
		JSONObject result = new JSONObject();
		
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.LOG_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTSYSTEMUSAGELOGLIST;

		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());

		String parameters = TypeUtility.makeRequestBody(body);

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
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
	 * 접근자 리스트
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @return 
	 * @throws Exception
	 */
	public JSONArray selectEntityList(String restIp, int restPort, String strTocken, String loginId, String entityId) throws Exception {
		JSONArray jsonArray = new JSONArray();
		
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.ENTITY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTENTITYLIST;

		String monitored = "false"; 
		HashMap body = new HashMap();
		body.put("monitored", monitored);
		String parameters = TypeUtility.makeRequestBody(body);
		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
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

	public JSONArray selectEntityAgentList(String restIp, int restPort, String strTocken,String loginId, String entityId) throws Exception {
		
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);
		
		JSONArray jsonArray = new JSONArray();

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
		//long totalListCount = (long) resultJson.get("totalListCount");
		
		
		if(resultCode.equals("0000000000")) {
			ArrayList list = (ArrayList) resultJson.get("list");
			if(list!=null) {
				for(int i=0; i<list.size(); i++) {
					JSONObject data = (JSONObject) list.get(i);
					
					Entity entity = new Entity();
					Gson gson = new Gson();
					entity = gson.fromJson(data.toJSONString(), entity.getClass());
					
					JSONObject jsonObj = new JSONObject();

					jsonObj.put("entityUid", entity.getEntityUid());
					jsonObj.put("entityName", new String(entity.getEntityName().toString().getBytes("iso-8859-1"),"UTF-8"));
					
					jsonArray.add(jsonObj);
					
					System.out.println("getEntityUid : " + entity.getEntityUid());
					System.out.println("getEntityName : " + new String(entity.getEntityName().toString().getBytes("iso-8859-1"),"UTF-8") );
				}
			}
				
		}
		return jsonArray;
	}
		
}
