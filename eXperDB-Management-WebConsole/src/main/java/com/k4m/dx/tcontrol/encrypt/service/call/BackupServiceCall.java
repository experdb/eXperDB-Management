package com.k4m.dx.tcontrol.encrypt.service.call;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.HashMap;

import org.json.simple.JSONObject;
import org.springframework.web.multipart.MultipartFile;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.k4m.dx.tcontrol.cmmn.crypto.Encrypter;
import com.k4m.dx.tcontrol.cmmn.rest.RequestResult;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.EncryptCommonService;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.SystemCode;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.TypeUtility;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.BackupFileHeader;

public class BackupServiceCall {
	
	@SuppressWarnings("unchecked")
	public JSONObject encryptBackup(String restIp, int restPort, String strTocken, String loginId, String entityId, HashMap<String, Object> param) throws Exception{
		JSONObject result = new JSONObject();
		
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);
		
		String strService = SystemCode.ServiceName.BACKUP_SERVICE;
		String strCommand = SystemCode.ServiceCommand.BACKUPDATA;
		
		BackupFileHeader bfh = new BackupFileHeader();
		
		bfh.setPassword((String) param.get("password"));
		bfh.setBackupFilename("encryptBackup.edk");
		
		if((boolean) param.get("chkKey")){
			int includeBit = bfh.getIncludedBits();
			bfh.setIncludedBits(includeBit | SystemCode.BitMask.BACKUP_INCLUDE_CRYPTO_KEY);
		}
		if((boolean) param.get("chkPolicy")){
			int includeBit = bfh.getIncludedBits();
			bfh.setIncludedBits(includeBit | SystemCode.BitMask.BACKUP_INCLUDE_POLICY);
		}
		if((boolean) param.get("chkServer")){
			int includeBit = bfh.getIncludedBits();
			bfh.setIncludedBits(includeBit | SystemCode.BitMask.BACKUP_INCLUDE_SERVER);
		}
		if((boolean) param.get("chkAdminUser")){			
			int includeBit = bfh.getIncludedBits();
			bfh.setIncludedBits(includeBit | SystemCode.BitMask.BACKUP_INCLUDE_ADMIN_USER);
		}
		if((boolean) param.get("chkConfig")){
			int includeBit = bfh.getIncludedBits();
			bfh.setIncludedBits(includeBit | SystemCode.BitMask.BACKUP_INCLUDE_CONFIG);
		}
		
		HashMap<String, String> body = new HashMap<String, String>();
		body.put(TypeUtility.getJustClassName(bfh.getClass()), bfh.toJSONString());
		
		String parameters = TypeUtility.makeRequestBody(body);
		
		HashMap<String, String> header = new HashMap<String, String>();
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);
		
		
		JSONObject backupResult = api.callEncryptBackupService(strService, strCommand, header, parameters);
		
		RequestResult requestResult = (RequestResult) backupResult.get("request");
		
		result.put("RESULT_CODE", requestResult.getResultCode());
		result.put("RESULT_MESSAGE", requestResult.getResultMessage());
		result.put("file", backupResult.get("fileContent"));
		
		return result;
	}
	
	public RequestResult encryptRestore(String restIp, int restPort, String strTocken, String loginId, String entityId, HashMap<String, Object> param, MultipartFile mFile) throws Exception{
		System.out.println("BackupServiceCall / encryptRestore CALLED");
		
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);
		
		String strService = SystemCode.ServiceName.BACKUP_SERVICE;
		String strCommand = SystemCode.ServiceCommand.RESTOREDATA;
		
		BackupFileHeader bfh = new BackupFileHeader();
		
		bfh.setPassword((String) param.get("password"));
		bfh.setBackupFilename("encryptBackup.edk");
		
		if((boolean) param.get("chkKey")){
			int includeBit = bfh.getIncludedBits();
			bfh.setIncludedBits(includeBit | SystemCode.BitMask.BACKUP_INCLUDE_CRYPTO_KEY);
		}
		if((boolean) param.get("chkPolicy")){
			int includeBit = bfh.getIncludedBits();
			bfh.setIncludedBits(includeBit | SystemCode.BitMask.BACKUP_INCLUDE_POLICY);
		}
		if((boolean) param.get("chkServer")){
			int includeBit = bfh.getIncludedBits();
			bfh.setIncludedBits(includeBit | SystemCode.BitMask.BACKUP_INCLUDE_SERVER);
		}
		if((boolean) param.get("chkAdminUser")){			
			int includeBit = bfh.getIncludedBits();
			bfh.setIncludedBits(includeBit | SystemCode.BitMask.BACKUP_INCLUDE_ADMIN_USER);
		}
		if((boolean) param.get("chkConfig")){
			int includeBit = bfh.getIncludedBits();
			bfh.setIncludedBits(includeBit | SystemCode.BitMask.BACKUP_INCLUDE_CONFIG);
		}
		
		HashMap<String, String> body = new HashMap<String, String>();
		body.put(TypeUtility.getJustClassName(bfh.getClass()), bfh.toJSONString());
		
		HashMap<String, String> header = new HashMap<String, String>();
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);
		
		RequestResult result = api.callEncryptRestoreService(strService, strCommand, header, body, mFile);
		
		return result;
	}
	
	@SuppressWarnings({ "unchecked"})
	public JSONObject validateBackupFile(MultipartFile mFile, HashMap<String, Object> param) throws Exception{
		System.out.println("ValidateBackupFile CALLED");
		JSONObject result = new JSONObject();
		BackupFileHeader header = new BackupFileHeader();
		
		String password = (String) param.get("password");
		
		BufferedReader inFile = new BufferedReader(new InputStreamReader(mFile.getInputStream()));
		String headerString = inFile.readLine();
		String headerHmac = inFile.readLine();
		String dataEncHmac = inFile.readLine();
		String dataEnc = inFile.readLine();
		
//		System.out.println("headerString : " + headerString);
//		System.out.println("headerHmac : " + headerHmac);
//		System.out.println("dataEncHmac : " + dataEncHmac);
//		System.out.println("dataEnc : " + dataEnc);
		
		GsonBuilder builder = new GsonBuilder();
		Gson gson = builder.setPrettyPrinting().create();
		header = gson.fromJson(headerString, BackupFileHeader.class);
		
		password = (password + header.getFileUid()).substring(0, 16);
		
		if(!headerHmac.equals(Encrypter.hmac(headerString, password)))	{
			System.out.println("비밀번호가 틀렸거나 파일이 훼손되어 복원할 수 없습니다.");
			result.put("RESULT_CODE", SystemCode.ResultCode.UNMANAGED_ERROR);
			result.put("RESULT_MESSAGE", "Header MAC integrity validation failed. \nCheck the backup file password or the unauthorized change of backup file contents.");
			return result;
		}
		
		if(!dataEncHmac.equals(Encrypter.hmac(dataEnc, password))){
			System.out.println("파일이 훼손되어 복원할 수 없습니다.");
			result.put("RESULT_CODE", SystemCode.ResultCode.UNMANAGED_ERROR);
			result.put("RESULT_MESSAGE", "Data MAC integrity validation failed. \nCheck the unauthorized change of backup file contents.");
			return result;
			
		}
		
		if(!header.ContainsAdminUser() && (boolean) param.get("chkAdminUser")){
			System.out.println("not contains admin user info in file");	
			result.put("RESULT_CODE", SystemCode.ResultCode.ITEM_NOT_FOUND_ERROR);
			result.put("RESULT_MESSAGE", "The backup file does not contain the admin user data");
			return result;
		}
		
		if(!header.ContainsCryptoKey() && (boolean) param.get("chkKey")){
			System.out.println("not contains key in file");
			result.put("RESULT_CODE", SystemCode.ResultCode.ITEM_NOT_FOUND_ERROR);
			result.put("RESULT_MESSAGE", "The backup file does not contain the key data");
			return result;
		}
		
		if(!header.ContainsPolicy() && (boolean) param.get("chkKey")){
			System.out.println("not contains policy in file");
			result.put("RESULT_CODE", SystemCode.ResultCode.ITEM_NOT_FOUND_ERROR);
			result.put("RESULT_MESSAGE", "The backup file does not contain the policy data");
			return result;
		}
		
		if(!header.ContainsServer() && (boolean) param.get("chkServer")){
			System.out.println("not contains server in file");
			result.put("RESULT_CODE", SystemCode.ResultCode.ITEM_NOT_FOUND_ERROR);
			result.put("RESULT_MESSAGE", "The backup file does not contain the server data");
			return result;
		}
		
		if(!header.ContainsBackupLog() && (boolean) param.get("chkConfig")){
			System.out.println("not contains config info in file");
			result.put("RESULT_CODE", SystemCode.ResultCode.ITEM_NOT_FOUND_ERROR);
			result.put("RESULT_MESSAGE", "The backup file does not contain the config data");
			return result;
		}
		
		result.put("RESULT_CODE", SystemCode.ResultCode.SUCCESS);
		result.put("RESULT_MESSAGE", "SUCCESS");
		
		return result;
	}
	

}
