package com.k4m.dx.tcontrol.util;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.json.MappingJacksonHttpMessageConverter;
import org.springframework.web.client.RestTemplate;


/**
 * REST API URL 생성 및 REST API를 호출 및 호출 결과를 반환한다.
 * @author manimany
 *
 */
public class RequestRestApi {
	
	/**
	 * 입력받은 URL에 REST API 요청을 보내고 결과값(JSON 형태)을 ResponseEntity<String>로 반환
	 * 
	 * @param url
	 * @return
	 * @throws Exception
	 */
	public ResponseEntity<String> requestRestAPI(String url) throws Exception {

		HttpHeaders requestHeaders = new HttpHeaders();
		requestHeaders.setContentType(MediaType.APPLICATION_JSON);
		HttpEntity<?> requestEntity = new HttpEntity<Object>(requestHeaders);
		
		RestTemplate restTemplate = new RestTemplate();
		
		// Add the String message converter
		restTemplate.getMessageConverters().add(new MappingJacksonHttpMessageConverter() );
		ResponseEntity<String> responseEntity =null;
		
		try {
			responseEntity = restTemplate.exchange(url, HttpMethod.GET, requestEntity, String.class );
		}catch (Exception e) {
			throw e;
		}
		//Globals.logger.debug(url+" REST API 응답 상태갑 = "+responseEntity.getStatusCode().toString());
		//Globals.logger.debug(url+" REST API 응답 헤더 = "+responseEntity.getHeaders().toString());
		//Globals.logger.debug(url+" REST API 응답 결과 = "+ responseEntity.getBody().toString());
		return responseEntity;
	}
	
	/**
	 * 입력받은 아이피, 포트, 커넥터명, 잡에 해당하는 REST API URL 생성하여 문자열로 반환
	 * @param ip
	 * @param port
	 * @param connectorName
	 * @param job
	 * @return
	 */
	public String makeRestURL(String ip, int port, String connectorName, String job){
		String returnURL = null;

		
		if(connectorName != null && connectorName.length() > 0 && job != null && job.length() > 0){
			returnURL =  "http://"+ip+":"+port+"/connectors/"+connectorName+"/"+job;
		}
		else {
			returnURL =  "http://"+ip+":"+port+"/connectors";	
		}
		
		return returnURL;
	}

}
