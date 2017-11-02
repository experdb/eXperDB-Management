package com.k4m.dx.tcontrol.cmmn.serviceproxy;

import java.security.KeyManagementException;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
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

import org.apache.http.client.HttpClient;
import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.conn.ssl.TrustSelfSignedStrategy;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.ssl.SSLContextBuilder;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.ResourceAccessException;
import org.springframework.web.client.RestTemplate;


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

	private HttpEntity<?> apiClientHttpEntity(String appType, String params, Map header) {

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
	


    public JSONObject  restRequest(String strService, String strCommand, HashMap header, JSONObject parameters) throws Exception {

    	JSONObject configJsonObjectMap = null;
    	String jsonString = null;
		String url;
		HttpsURLConnection conn;
		SSLContext ctx;
		
		try {
			ctx = SSLContext.getInstance(SystemCode.SSL_PROTOCOL);
			ctx.init(null, trustAllCerts, new SecureRandom());
		} catch (Exception e) {
			throw e;
		}
		
		//url = makeRestURL("policyService", "selectProfileProtectionVersion");
		url = makeRestURL(strService, strCommand);
		
		SSLConnectionSocketFactory csf = new SSLConnectionSocketFactory(ctx);
		 
		// here we create the Http Client using our SSL Socket Factory and so trust relation
		CloseableHttpClient httpClient = HttpClients.custom().setSSLSocketFactory(csf).build();
		HttpComponentsClientHttpRequestFactory requestFactory = new HttpComponentsClientHttpRequestFactory();
		requestFactory.setHttpClient(httpClient);
		
		
		//JSONObject parameters = new JSONObject();
		//parameters.put("name", strName);
		//parameters.put("config", config)
		
		HttpEntity<?> requestEntity = apiClientHttpEntity("json", parameters.toString(), header);
		
		ResponseEntity<String> responseEntity =null;
		
		
		try {

			RestTemplate restTemplate = new RestTemplate(requestFactory);
			
			responseEntity = restTemplate.exchange(url, HttpMethod.POST, requestEntity, String.class);
			
			jsonString = responseEntity.getBody();
			
			if (responseEntity != null && responseEntity.getStatusCode().value() == 200) {

				JSONParser jsonParser = new JSONParser();

				configJsonObjectMap = (JSONObject) jsonParser.parse(jsonString);


				Iterator<?> iter = configJsonObjectMap.entrySet().iterator();
				while (iter.hasNext()) {
					Map.Entry entry = (Map.Entry) iter.next();
					System.out.println(String.valueOf(entry.getKey()) + " = " + String.valueOf(entry.getValue()));
				}
			} else {
				throw new Exception(url + " REST API 접속에서 예외가 발생했습니다. 응답 코드가 적절하지 않습니다.");
			}

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
		
		return configJsonObjectMap;

    }
	
    
	public HashMap makeHeaderMap1() {
		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, "admin");
		header.put(SystemCode.FieldName.ENTITY_UID, "00000000-0000-0000-0000-000000000001");
		header.put(SystemCode.FieldName.PASSWORD, "password");
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
		

		
		
		
		ExperDBRestApi api = new ExperDBRestApi(ip, port);

		JSONObject parameters = new JSONObject();
		//parameters.put("name", strName);
		//parameters.put("config", config)
		
		HashMap header = new HashMap();
		header = api.makeHeaderMap1();
		
		Map<String, Object> configJsonObjectMap = api.restRequest(strService, strCommand, header, parameters);
		
		
		JSONParser jsonParser = new JSONParser();

		Map<String, Object> map = (JSONObject) jsonParser.parse(configJsonObjectMap.get("map").toString());
		
		System.out.println("PROFILE_PROTECTION_VERSION : " + map.get("PROFILE_PROTECTION_VERSION"));
		
		Iterator<?> iter = configJsonObjectMap.entrySet().iterator();
		while (iter.hasNext()) {
			Map.Entry entry = (Map.Entry) iter.next();

			System.out.println(String.valueOf(entry.getKey()) + " = " + String.valueOf(entry.getValue()));
		}
		
	}
}
