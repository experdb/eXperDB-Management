package com.k4m.dx.tcontrol.cmmn.serviceproxy;

import java.security.SecureRandom;
import java.security.cert.CertificateException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.ResourceAccessException;
import org.springframework.web.client.RestTemplate;


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
}
