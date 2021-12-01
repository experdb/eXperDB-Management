package com.k4m.dx.tcontrol.cmmn.serviceproxy;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import org.json.simple.JSONObject;
import org.springframework.http.ResponseEntity;
import org.springframework.web.multipart.MultipartFile;

import com.k4m.dx.tcontrol.cmmn.rest.RequestResult;


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
*  2021.12.01	신예은  Encrypt backup/restore 기능을 위한 service 추가 생성
*      </pre>
*/
public class EncryptCommonService {
	
	protected String restIp = "";
	protected int restPort = 0;
	
	public EncryptCommonService(String restIp, int restPort) {
		this.restIp = restIp;
		this.restPort = restPort;
	}
	
	public JSONObject callService(String serviceName, String serviceCommand, HashMap header, String parameters) throws Exception {
		
		
		ExperDBRestApiHandler handler = new ExperDBRestApiHandler(restIp, restPort);

		JSONObject resultList = handler.getRestRequest(serviceName, serviceCommand, header, parameters);
		
		return resultList;
	}
	
	public ResponseEntity<String> callLoginService(String serviceName, String serviceCommand, HashMap header, String parameters) throws Exception {
		
		
		ExperDBRestApiHandler handler = new ExperDBRestApiHandler(restIp, restPort);

		ResponseEntity<String> resultList = handler.getResponseEntity(serviceName, serviceCommand, header, parameters);
		
		return resultList;
	}
	
	public JSONObject callEncryptBackupService(String serviceName, String serviceCommand, HashMap<String, String> header, String parameters) throws Exception {
		ExperDBRestApiHandler handler = new ExperDBRestApiHandler(restIp, restPort);
		JSONObject result = handler.getEncryptBackupRestRequest(serviceName, serviceCommand, header, parameters);
		
		return result;
		
	}
	
	public RequestResult callEncryptRestoreService(String serviceName, String serviceCommand, HashMap<String, String> header, HashMap<String, String> body, MultipartFile mFile) throws Exception{
		ExperDBRestApiHandler handler = new ExperDBRestApiHandler(restIp, restPort);
		RequestResult result = handler.getEncryptRestoreRestRequest(serviceName, serviceCommand, header, body, mFile);
		
		return result;
	}
	
	
}
