package com.k4m.dx.tcontrol.monitoring.schedule.service;

import java.util.HashMap;

import org.json.simple.JSONObject;
import org.springframework.http.ResponseEntity;


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
*      </pre>
*/
public class RestCommonService {
	
	protected String restIp = "";
	protected int restPort = 0;
	
	public RestCommonService(String restIp, int restPort) {
		this.restIp = restIp;
		this.restPort = restPort;
	}
	
	public JSONObject callService(String serviceName, String serviceCommand, HashMap header, String parameters) throws Exception {
		
		
		ExperDBRestApiHandler handler = new ExperDBRestApiHandler(restIp, restPort);

		JSONObject resultList = handler.getRestRequest(serviceName, serviceCommand, header, parameters);
		
		return resultList;
	}
	
	public JSONObject callHttpService(String serviceName, String serviceCommand, HashMap header, String parameters) throws Exception {
		
		
		ExperDBRestApiHandler handler = new ExperDBRestApiHandler(restIp, restPort);

		JSONObject resultList = handler.getRestHttpRequest(serviceName, serviceCommand, header, parameters);
		
		return resultList;
	}
	
	public ResponseEntity<String> callLoginService(String serviceName, String serviceCommand, HashMap header, String parameters) throws Exception {
		
		
		ExperDBRestApiHandler handler = new ExperDBRestApiHandler(restIp, restPort);

		ResponseEntity<String> resultList = handler.getResponseEntity(serviceName, serviceCommand, header, parameters);
		
		return resultList;
	}
	
	
}
