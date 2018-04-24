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

public class ExperDBRestApi {
	
	
	
	private static final TrustManager[]	trustAllCerts = new TrustManager[] { new X509TrustManager() {
		public java.security.cert.X509Certificate[] getAcceptedIssuers() {
			return null;
		}

		@Override
		public void checkClientTrusted(java.security.cert.X509Certificate[] chain, String authType)
				throws CertificateException {
			// TODO Auto-generated method stub
			
		}

		@Override
		public void checkServerTrusted(java.security.cert.X509Certificate[] chain, String authType)
				throws CertificateException {
			// TODO Auto-generated method stub
			
		}
	} };
	
	protected String restIp = "";
	protected int restPort = 0;

	public ExperDBRestApi(String restIp, int restPort) {
		this.restIp = restIp;
		this.restPort = restPort;
	}
	
	
	private String getApiServerUrl() {
		return "https://" + restIp + ":" + restPort;
	}

	private HttpEntity<?> apiClientHttpEntity(String appType, Map header, String params) {

		HttpHeaders requestHeaders = new HttpHeaders();
		requestHeaders.set("Cache-Control", "no-cache");
		requestHeaders.set("Accept-Charset", "UTF-8");
		requestHeaders.set("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8");
		requestHeaders.set("accept", "*/*");
		
		for (Iterator itr = header.entrySet().iterator(); itr.hasNext();) {
			Entry entry = (Entry) itr.next();
			requestHeaders.set(entry.getKey().toString(), entry.getValue().toString());
		}

		if ("".equals(params) || (params == null))
			return new HttpEntity<Object>(requestHeaders);
		else
			return new HttpEntity<Object>(params, requestHeaders);
	}
	

    public ResponseEntity<String>  restResponseEntity(String strService, String strCommand, HashMap header, String parameters) throws Exception {


		String url;
		SSLContext ctx;
		
		try {
			ctx = SSLContext.getInstance(SystemCode.SSL_PROTOCOL);
			ctx.init(null, trustAllCerts, new SecureRandom());
		} catch (Exception e) {
			throw e;
		}
		
		//url = makeRestURL("policyService", "selectProfileProtectionVersion");
		url = makeRestURL(strService, strCommand);
		
		SSLConnectionSocketFactory csf = new SSLConnectionSocketFactory(ctx, SSLConnectionSocketFactory.ALLOW_ALL_HOSTNAME_VERIFIER);
		 
		// here we create the Http Client using our SSL Socket Factory and so trust relation
		CloseableHttpClient httpClient = HttpClients.custom().setSSLSocketFactory(csf).build();
		HttpComponentsClientHttpRequestFactory requestFactory = new HttpComponentsClientHttpRequestFactory();
		requestFactory.setHttpClient(httpClient);
		
		
		//JSONObject parameters = new JSONObject();
		//parameters.put("name", strName);
		//parameters.put("config", config)
		
		HttpEntity<?> requestEntity = apiClientHttpEntity("json", header, parameters);
		
		ResponseEntity<String> responseEntity =null;
		
		
		try {

			RestTemplate restTemplate = new RestTemplate(requestFactory);
			
			//responseEntity = restTemplate.exchange(url, HttpMethod.POST, requestEntity, String.class);
			
			responseEntity = restTemplate.exchange(url, HttpMethod.POST, requestEntity, String.class);
			//String strresponseEntity = restTemplate.postForObject(url, requestEntity, String.class);
			
		} catch (HttpClientErrorException e) {
			// Globals.logger.info(url+" REST API 접속에서 예외가 발생했습니다.");
			// Globals.logger.info(e);
			throw e;
		} catch (ResourceAccessException e) {
			// Globals.logger.info(url+" REST API 접속에서 예외가 발생했습니다.");
			// Globals.logger.info(e);
			throw e;
		} catch (Exception e) {
			throw e;
		}
		
		return responseEntity;

    }
    

    
	public HashMap makeHeaderMap1() {
		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, "admin");
		header.put(SystemCode.FieldName.ENTITY_UID, "00000000-0000-0000-0000-000000000001");
		//header.put(SystemCode.FieldName.PASSWORD, "password");
		header.put(SystemCode.FieldName.TOKEN_VALUE, "kL0hQcOPxh0ND+VXdFjHqzudLe9dZoU+aLBJ5ldqZfo=");
		header.put(SystemCode.FieldName.ADDRESS, "");
		return header;
	}
	
	/**
	 * 입력받은 아이피, 포트, 커넥터명, 잡에 해당하는 REST API URL 생성하여 문자열로 반환
	 * @param ip
	 * @param port
	 * @param connectorName
	 * @param job
	 * @return
	 */
	public String makeRestURL(String serviceName, String command){
		String returnURL = null;

		
		if(serviceName != null && serviceName.length() > 0 && command != null && command.length() > 0){
			returnURL =  getApiServerUrl() + "/experdb/rest/" + serviceName + "/" + command;
		}
		else {
			returnURL =  getApiServerUrl() + "/experdb/rest/";	
		}
		
		return returnURL;
	}
	
	public static void main(String[] args) throws Exception {
		String ip = "222.110.153.204";
		int port = 9443;
		String strService = "policyService";
		String strCommand = "selectProfileProtectionVersion";
		
		//ip = "127.0.0.1";
		//port = 8443;
		strService = "authService";
		strCommand = "login";

		
		test_login(ip, port, strService, strCommand);
		
	}
	
	private void test01(String ip, int port, String strService, String strCommand) throws Exception {

		
		ExperDBRestApi api = new ExperDBRestApi(ip, port);

		//JSONObject parameters = new JSONObject();
		//parameters.put("name", strName);
		//parameters.put("config", config)
		String parameters = "";
		
		HashMap header = new HashMap();
		header = api.makeHeaderMap1();
		
		ResponseEntity<String> responseEntity = api.restResponseEntity(strService, strCommand, header, parameters);

		//body setting
		String jsonString = responseEntity.getBody();
		JSONObject configJsonObjectMap = null;
		
		if (responseEntity != null && responseEntity.getStatusCode().value() == 200) {

			JSONParser jsonParser = new JSONParser();

			configJsonObjectMap = (JSONObject) jsonParser.parse(jsonString);
			
			String resultCode = (String) configJsonObjectMap.get("resultCode");
			String resultMessage = (String) configJsonObjectMap.get("resultMessage");

			System.out.println("resultCode : " + resultCode);
			System.out.println("resultMessage : " + resultMessage);


		} else {
			throw new Exception(" REST API 접속에서 예외가 발생했습니다. 응답 코드가 적절하지 않습니다.");
		}

		
	}
	
	/** 
	 * authService/login/
	 */
	private static void test_login(String ip, int port, String strService, String strCommand) throws Exception {
		

		ExperDBRestApi api = new ExperDBRestApi(ip, port);
		
		String strUserId = "admin";
		String strPassword = "password";

		//JSONObject parameters = new JSONObject();
		//parameters.put("name", strName);
		//parameters.put("config", config)
		String parameters = "";
		
		HashMap header = new HashMap();
		//header = api.makeHeaderMap1();
		header.put("experdb-loginid", strUserId);
		header.put("experdb-password", strPassword);
		
		//Map<String, Object> configJsonObjectMap = api.restRequest(strService, strCommand, header, parameters);
		ResponseEntity<String> responseEntity = api.restResponseEntity(strService, strCommand, header, parameters);
		
		
		//header setting 
		HttpHeaders headers = responseEntity.getHeaders();
		
		String ectityUid = headers.getFirst("experdb-entity-uid");
		String tockenValue = headers.getFirst("experdb-token-value");
		
		System.out.println("ectityUid : " + ectityUid + " tockenValue : " + tockenValue);

		//body setting
		String jsonString = responseEntity.getBody();
		JSONObject configJsonObjectMap = null;
		
		if (responseEntity != null && responseEntity.getStatusCode().value() == 200) {

			JSONParser jsonParser = new JSONParser();

			configJsonObjectMap = (JSONObject) jsonParser.parse(jsonString);
			
			String resultCode = (String) configJsonObjectMap.get("resultCode");
			String resultMessage = (String) configJsonObjectMap.get("resultMessage");

			System.out.println("resultCode : " + resultCode);
			System.out.println("resultMessage : " + resultMessage);


		} else {
			throw new Exception(" REST API 접속에서 예외가 발생했습니다. 응답 코드가 적절하지 않습니다.");
		}

		

	}
}
