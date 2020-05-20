package com.k4m.dx.tcontrol.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.json.MappingJacksonHttpMessageConverter;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.ResourceAccessException;
import org.springframework.web.client.RestTemplate;

public class DebeziumKafkaApi {
	
	protected String restUrl = "";
	protected int restPort = 0;

	public DebeziumKafkaApi(String restUrl, int restPort) {
		this.restUrl = restUrl;
		this.restPort = restPort;
	}


	private String getApiServerUrl() {
		return "http://" + restUrl + ":" + restPort;
	}
	
	
	/**
	 * Secret키와 Content-type을 설정
	 * 
	 * @param appType
	 * @param params
	 * @return HttpEntity<?>
	 */
	private HttpEntity<?> apiClientHttpEntity(String appType, String params) {

		HttpHeaders requestHeaders = new HttpHeaders();
		requestHeaders.set("Content-Type", "application/" + appType);

		if ("".equals(params) || (params == null))
			return new HttpEntity<Object>(requestHeaders);
		else
			return new HttpEntity<Object>(params, requestHeaders);
	}
	
	/**
	 * Create kafka-Connect
	 * 
	 * @param strName
	 * @param strConnector_class
	 * @param strTasks_max
	 * @param strTopics
	 * @param strHdfs_url
	 * @param strHadoop_conf_dir
	 * @param strHadoop_home
	 * @param strFlush_size
	 * @param strRotate_interval_ms
	 * @throws Exception
	 */
	public boolean createKafkaConnect() throws Exception {
		ApplicationContext context;
		
		boolean blnReturn = true;

		try {
			JSONObject config = new JSONObject();

			config.put("connector.class", "io.debezium.connector.postgresql.PostgresConnector");
			config.put("plugin.name", "wal2json");
			config.put("slot.name", "experdb");
			config.put("database.hostname", "192.168.56.130");
			config.put("database.port", "5432");
			config.put("database.user", "experdb");
			config.put("database.password", "experdb");
			config.put("database.dbname", "experdb");
			config.put("database.server.name", "test");
			config.put("table.whitelist", "experdb_management.t_syswrk_g");
			
			JSONObject parameters = new JSONObject();
			parameters.put("name", "oldDaTa-connector");
			parameters.put("config", config);

			HttpEntity<?> requestEntity = apiClientHttpEntity("json", parameters.toString());
			

			 System.out.println(requestEntity.getBody());

		} catch (Exception e) {
			//e.printStackTrace();
			blnReturn = false;
		}
		
		return blnReturn;
	}
	
	
	public static void main(String[] args) throws Exception {
		String ip = "192.168.56.131";
		int port = 8083;
		
		DebeziumKafkaApi debeziumApi = new DebeziumKafkaApi(ip, port);

		debeziumApi.createKafkaConnect();
	}
}
