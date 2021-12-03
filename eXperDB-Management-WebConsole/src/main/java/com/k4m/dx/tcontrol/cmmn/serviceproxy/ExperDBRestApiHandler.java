package com.k4m.dx.tcontrol.cmmn.serviceproxy;

import java.util.HashMap;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
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
*  2021.12.01	신예은  Encrypt backup/restore 기능을 위한 restRequest, sendRestCmd 추가 생성
*      </pre>
*/
public class ExperDBRestApiHandler {
	

	protected String restIp = "";
	protected int restPort = 0;

	public ExperDBRestApiHandler(String restIp, int restPort) {
		this.restIp = restIp;
		this.restPort = restPort;
	}
	
	private ResponseEntity<String> sendRestCmd(String strService, String strCommand, HashMap header, String parameters) throws Exception {
		
		ExperDBRestApi api = new ExperDBRestApi(restIp, restPort);
		
		ResponseEntity<String> responseEntity = api.restResponseEntity(strService, strCommand, header, parameters);

		return responseEntity;

	}
	
	private JSONObject sendRestCmdForEncryptBackupRestore(String strService, String strCommand, HashMap<String, String> header, String parameters) throws Exception {
		ExperDBRestApi api = new ExperDBRestApi(restIp, restPort);
		JSONObject result = api.restResponseEncryptBackupRestore(strService, strCommand, header, parameters);
		
		return result;
	}
	
	private RequestResult sendRestCmdForEncryptBackupRestore(String strService, String strCommand, HashMap<String, String> header, HashMap<String, String> body, MultipartFile mFile) throws Exception {
		ExperDBRestApi api = new ExperDBRestApi(restIp, restPort);
		RequestResult requestResult = new RequestResult();
		String responseString = api.restResponseEncryptBackupRestore(strService, strCommand, header, body, mFile);
		
		JSONParser parser = new JSONParser();
		Object obj = parser.parse(responseString);
		JSONObject resObject = (JSONObject) obj;
		
		requestResult.setResultCode((String) resObject.get("resultCode"), (String) resObject.get("resultMessage")); 
		
		return requestResult;
	}
	
	
	public JSONObject getRestRequest(String strService, String strCommand, HashMap header, String parameters) throws Exception {
		
		JSONObject resultJsonObjectMap = null;
		
		ResponseEntity<String> responseEntity = sendRestCmd(strService, strCommand, header, parameters);


		//body setting
		String jsonString = responseEntity.getBody();
		
		if (responseEntity != null && responseEntity.getStatusCode().value() == 200) {

			JSONParser jsonParser = new JSONParser();

			resultJsonObjectMap = (JSONObject) jsonParser.parse(jsonString);
			
		} else {
			resultJsonObjectMap.put("resultCode", "ERR001");
			resultJsonObjectMap.put("resultMessage", "REST API 접속에서 예외가 발생했습니다. 응답 코드가 적절하지 않습니다.");
		}

		return resultJsonObjectMap;

	}
	
	public ResponseEntity<String> getResponseEntity(String strService, String strCommand, HashMap header, String parameters) throws Exception {
		return sendRestCmd(strService, strCommand, header, parameters);
	}
	
	public JSONObject getEncryptBackupRestRequest (String strService, String strCommand, HashMap<String, String> header, String parameters) throws Exception {
		JSONObject result = sendRestCmdForEncryptBackupRestore(strService, strCommand, header, parameters);
		return result;
	}
	
	public RequestResult getEncryptRestoreRestRequest(String strService, String strCommand, HashMap<String, String> header, HashMap<String, String> body, MultipartFile mFile) throws Exception{
		RequestResult requestResult = sendRestCmdForEncryptBackupRestore(strService, strCommand, header, body, mFile);
		return requestResult;
	}
}
