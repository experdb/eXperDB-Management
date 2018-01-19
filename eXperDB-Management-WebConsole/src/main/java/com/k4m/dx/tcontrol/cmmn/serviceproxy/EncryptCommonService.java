package com.k4m.dx.tcontrol.cmmn.serviceproxy;

import java.util.HashMap;

import org.json.simple.JSONObject;
import org.springframework.http.ResponseEntity;

import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.ProfileVO;

public class EncryptCommonService {
	
	protected String restIp = "";
	protected int restPort = 0;
	
	public EncryptCommonService(String restIp, int restPort) {
		this.restIp = restIp;
		this.restPort = restPort;
	}
	
	public JSONObject callService(String serviceName, String serviceCommand, HashMap header, JSONObject parameters) throws Exception {
		
		
		ExperDBRestApiHandler handler = new ExperDBRestApiHandler(restIp, restPort);

		JSONObject resultList = handler.getRestRequest(serviceName, serviceCommand, header, parameters);
		
		return resultList;
	}
	
	public ResponseEntity<String> callLoginService(String serviceName, String serviceCommand, HashMap header, JSONObject parameters) throws Exception {
		
		
		ExperDBRestApiHandler handler = new ExperDBRestApiHandler(restIp, restPort);

		ResponseEntity<String> resultList = handler.getResponseEntity(serviceName, serviceCommand, header, parameters);
		
		return resultList;
	}
	
	
}
