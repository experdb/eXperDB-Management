package com.k4m.dx.tcontrol.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
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

public class KafkaRestApi {

	protected String restUrl = "";
	protected int restPort = 0;

	public KafkaRestApi(String restUrl, int restPort) {
		this.restUrl = restUrl;
		this.restPort = restPort;
	}

	private Logger logger = LoggerFactory.getLogger(KafkaRestApi.class);

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

	public ArrayList<Map<String, Object>> searchKafkaConnect(String strName) throws Exception {
		String baseUrl = getApiServerUrl() + "/connectors";
		String jsonString = "";
		JSONObject configJsonObjectMap = null;
		ResponseEntity<String> responseEntity = null;
		
		ArrayList<Map<String, Object>> configList = new ArrayList<Map<String, Object>>();

		try {

			RestTemplate restTemplate = new RestTemplate();

			restTemplate.getMessageConverters().add(new MappingJacksonHttpMessageConverter());

			HttpEntity<?> requestEntity = apiClientHttpEntity("json", null);

			responseEntity = restTemplate.exchange(baseUrl, HttpMethod.GET, requestEntity, String.class);
			jsonString = responseEntity.getBody();

			if (responseEntity != null && responseEntity.getStatusCode().value() == 200) {

				Map<String, Object> connectorConfig = null;
				Map<String, Object> connectorStatus = null;

				JSONParser jsonParser = new JSONParser();
				JSONArray objects = (JSONArray) jsonParser.parse(jsonString);

				// 반환받은 커넥터명에 해당하는 config 및 status 정보를 조회하고 리스트에 담는다.
				for (int i = 0; i < objects.size(); i++) {
					connectorConfig = new HashMap<String, Object>();
					connectorStatus = new HashMap<String, Object>();

					// 서버 해당 커넥터의 설정 정보 조회
					connectorConfig = getKafkaConnectorConfigorStatus(restUrl, restPort, objects.get(i).toString(),
							"config");
					//System.out.println(connectorConfig);
					
					//System.out.println( "name : " + connectorConfig.get("name"));

					// 서버 해당 커넥터의 상태 정보 조회
					connectorStatus = getKafkaConnectorConfigorStatus(restUrl, restPort, objects.get(i).toString(),
							"status");

					// 서버 해당 커넥터의 상태 정보를 페이지 정보 조회를 위해 설정정보 맵에 추가
					connectorConfig.put("status", ((JSONObject) connectorStatus.get("connector")).get("state"));

					// System.out.println(connectorConfig.get("status"));
					if(strName.equals("")) {
						configList.add(connectorConfig);
					} else {
						if(strName.equals(connectorConfig.get("name"))) {
							configList.add(connectorConfig);
						}
					}
				}
			} else {
				// 응답 코드가 200이 아닌 경우 에러 처리
				// Globals.logger.error(url+" REST API 접속에서 예외가 발생했습니다.");
				throw new Exception(baseUrl + " REST API 접속에서 예외가 발생했습니다. 응답 코드가 적절하지 않습니다.");
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
		return configList;
	}

	private Map<String, Object> getKafkaConnectorConfigorStatus(String ip, int port, String connectorName, String job)
			throws Exception {

		JSONObject configJsonObjectMap = null;
		String jsonString = null;
		String url = null;

		ResponseEntity<String> responseEntity = null;
		RequestRestApi requestRestApi = new RequestRestApi();

		try {
			url = requestRestApi.makeRestURL(ip, port, connectorName, job);
			// Globals.logger.debug(url+" REST API 호출");

			// 데이터베이스에서 조회된 값으로 REST URL을 만들고, 해당 URL로 조회 요청을 하고 결과값을 반환 받는다.
			responseEntity = requestRestApi.requestRestAPI(url);
			jsonString = responseEntity.getBody();
			// Globals.logger.debug("호출결과 =="+jsonString);

			if (responseEntity != null && responseEntity.getStatusCode().value() == 200) {

				JSONParser jsonParser = new JSONParser();

				configJsonObjectMap = (JSONObject) jsonParser.parse(jsonString);

				// Globals.logger.debug(configJsonObjectMap.getClass().getName());

				Iterator<?> iter = configJsonObjectMap.entrySet().iterator();
				while (iter.hasNext()) {
					Map.Entry entry = (Map.Entry) iter.next();
					// Globals.logger.debug(connectorName+" 커넥터 설정 정보
					// 키:"+String.valueOf(entry.getKey())+", 값:"+
					// String.valueOf(entry.getValue()));
				}
			} else {
				// 응답 코드가 200이 아닌 경우 에러 처리
				// Globals.logger.error(url+" REST API 접속에서 예외가 발생했습니다.");
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
	public boolean createKafkaConnect(String strName, String strConnector_class, String strTasks_max, String strTopics,
			String strHdfs_url, String strHadoop_conf_dir, String strHadoop_home, String strFlush_size,
			String strRotate_interval_ms) throws Exception {
		ApplicationContext context;
		
		boolean blnReturn = true;

		try {

			String baseUrl = getApiServerUrl() + "/connectors";

			RestTemplate restTemplate = new RestTemplate();
			MappingJacksonHttpMessageConverter converter = new MappingJacksonHttpMessageConverter();
			restTemplate.getMessageConverters().add(converter);

			JSONObject config = new JSONObject();
			config.put("connector.class", strConnector_class);
			config.put("tasks.max", strTasks_max);
			config.put("topics", strTopics);
			config.put("hdfs.url", strHdfs_url);
			config.put("hadoop.conf.dir", strHadoop_conf_dir);
			config.put("hadoop.home", strHadoop_home);
			config.put("flush.size", strFlush_size);
			config.put("rotate.interval.ms", strRotate_interval_ms);

			JSONObject parameters = new JSONObject();
			parameters.put("name", strName);
			parameters.put("config", config);

			HttpEntity<?> requestEntity = apiClientHttpEntity("json", parameters.toString());

			// restTemplate.exchange(baseUrl, HttpMethod.POST, requestEntity,
			// String.class );
			ResponseEntity<String> responseEntity = restTemplate.exchange(baseUrl, HttpMethod.POST, requestEntity,
					String.class);
			logger.info(responseEntity.getBody());

			// System.out.println(responseEntity.getBody());

		} catch (Exception e) {
			//e.printStackTrace();
			blnReturn = false;
		}
		
		return blnReturn;
	}

	/**
	 * delete Kafka-Connect
	 * 
	 * @param strConnect
	 */
	public boolean deleteKafkaConnect(String strConnect) {
		boolean blnReturn = true;
		
		try {
			
		String baseUrl = getApiServerUrl() + "/connectors/" + strConnect;

		RestTemplate restTemplate = new RestTemplate();
		MappingJacksonHttpMessageConverter converter = new MappingJacksonHttpMessageConverter();
		restTemplate.getMessageConverters().add(converter);

		HttpEntity<?> requestEntity = apiClientHttpEntity("json", null);

		ResponseEntity<String> responseEntity = restTemplate.exchange(baseUrl, HttpMethod.DELETE, requestEntity,
				String.class, strConnect);
		logger.info(responseEntity.getBody());
		
		} catch(Exception e) {
			blnReturn = false;
		}
		
		return blnReturn;
	}

	/**
	 * update kafka-Connect
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
	public boolean updateKafkaConnect(String strName, String strConnector_class, String strTasks_max, String strTopics,
			String strHdfs_url, String strHadoop_conf_dir, String strHadoop_home, String strFlush_size,
			String strRotate_interval_ms) throws Exception {
		ApplicationContext context;

		boolean blnReturn = true;
		
		try {

			String baseUrl = getApiServerUrl() + "/connectors/" + strName + "/config" ;

			RestTemplate restTemplate = new RestTemplate();
			MappingJacksonHttpMessageConverter converter = new MappingJacksonHttpMessageConverter();
			restTemplate.getMessageConverters().add(converter);

			JSONObject parameters = new JSONObject();
			parameters.put("connector.class", strConnector_class);
			parameters.put("tasks.max", strTasks_max);
			parameters.put("topics", strTopics);
			parameters.put("hdfs.url", strHdfs_url);
			parameters.put("hadoop.conf.dir", strHadoop_conf_dir);
			parameters.put("hadoop.home", strHadoop_home);
			parameters.put("flush.size", strFlush_size);
			parameters.put("rotate.interval.ms", strRotate_interval_ms);


			HttpEntity<?> requestEntity = apiClientHttpEntity("json", parameters.toString());

			// restTemplate.exchange(baseUrl, HttpMethod.POST, requestEntity,
			// String.class );
			ResponseEntity<String> responseEntity = restTemplate.exchange(baseUrl, HttpMethod.PUT, requestEntity,
					String.class);
			logger.info(responseEntity.getBody());

			// System.out.println(responseEntity.getBody());

		} catch (Exception e) {
			//e.printStackTrace();
			blnReturn = false;
		}
		
		return blnReturn;
	}
	
	
	public void runBottledWater() throws Exception {
		String strHome = "";
		String postgres = "";
		String slot = "";
		String broker = "";
		String schemaRegistry = "";
		String topicPrefix = "";
		
		String strRunCommand = "/home/postgres/experdb/bin/bottledwater --postgres=postgres://experdba@127.0.0.1/postgres --slot=postgres --broker=localhost:9092 --schema-registry=localhost:8081 --topic-prefix=postgres --allow-unkeyed --on-error=log";
	}

	public static void main(String[] args) throws Exception {
		String ip = "222.110.153.201";
		int port = 8083;

		KafkaRestApi kafkaRestApi = new KafkaRestApi(ip, port);

		/**
		 * {"rotate.interval.ms":"60000"
		 * ,"hdfs.url":"hdfs://KAFKA0:8020/dxm/warehouse/"
		 * ,"topics":"default-topic" ,"name":"default-config" ,"tasks.max":"3"
		 * ,"hadoop.conf.dir":"/etc/kafka-connect-hdfs" ,"flush.size":"100"
		 * ,"connector.class":"io.confluent.connect.hdfs.HdfsSinkConnector"}
		 **/
		String strName = "kafka-connect_test06";
		String strConnector_class = "io.confluent.connect.hdfs.HdfsSinkConnector";
		String strTasks_max = "3";
		String strTopics = "connect_test06.postgres.table1, connect_test06.postgres.table2";
		String strHdfs_url = "hdfs://KAFKA0:8020/dxm/warehouse/";
		String strHadoop_conf_dir = "/etc/kafka-connect-hdfs";
		String strHadoop_home = "/home/";
		String strFlush_size = "100";
		String strRotate_interval_ms = "1000";

		/**
		kafkaRestApi.createKafkaConnect(strName, strConnector_class, strTasks_max, strTopics, strHdfs_url,
				strHadoop_conf_dir, strHadoop_home, strFlush_size, strRotate_interval_ms);
				**/
		/**
		kafkaRestApi.updateKafkaConnect(strName, strConnector_class, strTasks_max, strTopics, strHdfs_url,
				strHadoop_conf_dir, strHadoop_home, strFlush_size, strRotate_interval_ms);
		**/
		
		// kafkaRestApi.searchKafkaConnect();

		// kafkaRestApi.deleteKafkaConnect(strName);
		
		strName = "default-config";
		ArrayList<Map<String, Object>> kafkaConnectList = kafkaRestApi.searchKafkaConnect(strName);
		
		for(Map<String, Object> map: kafkaConnectList) {
			String name = (String) map.get("name");
			System.out.print(name);
		}

	}

}
