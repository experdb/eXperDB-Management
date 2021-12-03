package com.k4m.dx.tcontrol.cmmn.serviceproxy;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.URL;
import java.nio.file.Files;
import java.security.KeyManagementException;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.cert.CertificateException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

import org.apache.commons.compress.utils.IOUtils;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItem;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.config.RegistryBuilder;
import org.apache.http.conn.HttpClientConnectionManager;
import org.apache.http.conn.socket.ConnectionSocketFactory;
import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.mime.MultipartEntityBuilder;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.impl.conn.PoolingHttpClientConnectionManager;
import org.apache.http.util.EntityUtils;
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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import com.k4m.dx.tcontrol.cmmn.rest.RequestResult;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.BackupFileHeader;


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
*  2021.12.01	신예은  Encrypt backup/restore 기능을 위한 restResponse 추가 생성
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
//		requestHeaders.set("Content-Type", "application/x-www-form-urlencoded;application/octet-stream;charset=UTF-8");
//		requestHeaders.set("Content-Type", "application/octet-stream;charset=UTF-8");
		requestHeaders.set("Accept", "*/*");
		
		for (Iterator itr = header.entrySet().iterator(); itr.hasNext();) {
			Entry entry = (Entry) itr.next();
			requestHeaders.set(entry.getKey().toString(), entry.getValue().toString());
		}

		System.out.println("requestHeader : " + requestHeaders.toString());
		
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
    
    @SuppressWarnings("unchecked")
	public JSONObject restResponseEncryptBackupRestore(String strService, String strCommand, HashMap<String, String> header, String parameters) throws Exception {
    	JSONObject result = new JSONObject();
    	RequestResult request = new RequestResult();
    	HttpsURLConnection conn = makeConnection(strService + "/" + strCommand, header);
    	String bodyString = parameters;
    	
    	IOException errorSendRequest = sendRequest(conn, bodyString);
    	if(errorSendRequest != null) throw errorSendRequest;
    	
    	Exception errorReceiveError = receiveError(conn);
    	
    	String resultCode = conn.getHeaderField(SystemCode.FieldName.RESULT_CODE);
    	String resultMessage = conn.getHeaderField(SystemCode.FieldName.RESULT_MESSAGE);
    	
    	request.setResultCode(resultCode, resultMessage);
    	
    	if(errorReceiveError != null){
    		throw errorReceiveError;
    	}else if(resultCode.equals(SystemCode.ResultCode.SUCCESS)){
    		InputStream is = null;
    		
    		is = conn.getInputStream();
    		
    		int bi;
    		StringBuffer sbuffer = new StringBuffer();
    		byte[] b = new byte[4096];
    		while((bi = is.read(b)) != -1){
    			sbuffer.append(new String(b, 0, bi));
    		}
    		
    		String str = sbuffer.toString();
    		
    		is.close();
    		
    		for(int i=0; i<conn.getHeaderFields().size(); i++){
    			header.put(conn.getHeaderFieldKey(i), conn.getHeaderField(i));
    		}
    		conn.disconnect();
    		
    		result.put("request", request);
    		result.put("fileContent", str);
    	}
    	
    	return result;
    }
    
    public String restResponseEncryptBackupRestore(String strService, String strCommand, HashMap<String, String> header, HashMap<String, String> body, MultipartFile mFile) throws Exception{
    	System.out.println("restResponseEncryptBackupRestore CALLED");
    	String url;
		SSLContext ctx;
		
		try {
			ctx = SSLContext.getInstance(SystemCode.SSL_PROTOCOL);
			ctx.init(null, trustAllCerts, new SecureRandom());
		} catch (Exception e) {
			throw e;
		}
		
		url = makeRestURL(strService, strCommand);

		SSLConnectionSocketFactory csf = new SSLConnectionSocketFactory(ctx, SSLConnectionSocketFactory.ALLOW_ALL_HOSTNAME_VERIFIER);
		 
		CloseableHttpClient httpClient = prebuildHttpClient(createPoolingConnectionManager(1, csf), 30000).build();
		
		HttpPost post = new HttpPost(url);
		post.setHeader("Cache-Control", "no-cache");
		post.setHeader("Accept-Charset", "UTF-8");
		post.setHeader("Content-Type", "multipart/form-data;charset=UTF-8");
		post.setHeader("accept", "*/*");
		
		Iterator itrHeader = header.entrySet().iterator();
		while (itrHeader.hasNext()) {
			Entry e = (Entry) itrHeader.next();
			post.setHeader(e.getKey().toString(), e.getValue().toString());
		}
		
		File tempfile = File.createTempFile("temp_", ".edk");
		mFile.transferTo(tempfile);
		
		FileBody fileBody = new FileBody(tempfile);
		MultipartEntityBuilder builder = MultipartEntityBuilder.create().addPart("File", fileBody);
		
		Iterator itrBody = body.entrySet().iterator();
		while (itrBody.hasNext()) {
			Entry e = (Entry) itrBody.next();
			builder.addPart(e.getKey().toString(), new StringBody(e.getValue().toString(), ContentType.APPLICATION_JSON));
		}
		
		org.apache.http.HttpEntity entity = builder.build();
		post.setEntity(entity);
		
		String responseString = executeHttpPostReturnString(httpClient, post);
		
		httpClient.close();
		tempfile.deleteOnExit();
		
		return responseString;
	}
    
    public static HttpClientBuilder prebuildHttpClient(HttpClientConnectionManager connectionManager, int timeoutSec) throws Exception {

		return HttpClients.custom()
				.setConnectionManager(connectionManager)
				.setDefaultRequestConfig(RequestConfig.custom()
						.setConnectTimeout(timeoutSec * 1000)
						.setConnectionRequestTimeout(timeoutSec * 1000)
						.setSocketTimeout(timeoutSec * 1000).build());
	}
    
    public static HttpClientConnectionManager createPoolingConnectionManager(int size, SSLConnectionSocketFactory sslFactory) {

		PoolingHttpClientConnectionManager retval = new PoolingHttpClientConnectionManager(RegistryBuilder.<ConnectionSocketFactory> create()
				.register("https", sslFactory)
				.build());
		retval.setMaxTotal(size);
		return retval;
	}
    
    public static String executeHttpPostReturnString(CloseableHttpClient httpClient, HttpPost post) throws Exception {
		String retval = null;

		CloseableHttpResponse response = null;
		try {
			response = httpClient.execute(post);
			org.apache.http.HttpEntity entity = response.getEntity();
			if (entity != null) {

				InputStream is = entity.getContent();
				BufferedReader reader;
				StringBuffer sb = null;
				try {
					reader = new BufferedReader(new InputStreamReader(is, "UTF-8"));
					String line = null;
					sb = new StringBuffer();

					while ((line = reader.readLine()) != null) {
						sb.append(line);
					}
					is.close();

				} catch (IOException e) {
					if (is != null) {
						is.close();
					}
					e.printStackTrace();
				}

				retval = sb.toString();
			}
			EntityUtils.consume(entity);
			response.close();
		} catch (Exception e) {
			if (response != null) {
				response.close();
			}
			throw e;
		}

		return retval;
	}
    
    
    private HttpsURLConnection makeConnection(String urlString, Map header) {
    	URL url;
    	HttpsURLConnection conn = null;
    	SSLContext ctx = null;
    	
    	try {
    		ctx = SSLContext.getInstance(SystemCode.SSL_PROTOCOL);
			ctx.init(null, trustAllCerts, new SecureRandom());
		} catch (KeyManagementException | NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
    	
    	try {
			url = new URL(getApiServerUrl() + "/experdb/rest/" + urlString);
			conn = (HttpsURLConnection) url.openConnection();
			conn.setRequestMethod("POST");
		} catch (IOException e) {
			e.printStackTrace();
		}
    	
    	conn.setSSLSocketFactory(ctx.getSocketFactory());
    	conn.setHostnameVerifier(new HostnameVerifier(){
    		public boolean verify(String hostname, SSLSession session) {
				return true;
			}
    	});
    	
    	conn.setDoOutput(true);
    	conn.setRequestProperty("Cache-Control", "no-cache");
    	conn.setRequestProperty("Accept-Charset", "UTF-8");
    	conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8");
    	conn.setRequestProperty("accept", "*/*");
    	
    	for (Iterator itr = header.entrySet().iterator(); itr.hasNext();) {
			Entry entry = (Entry) itr.next();
			conn.setRequestProperty(entry.getKey().toString(), entry.getValue().toString());
		}
    	
    	return conn;
    	
    }
    
    private IOException sendRequest(HttpsURLConnection conn, String bodyString) {
		DataOutputStream os = null;
		IOException retval = null;
		try {
			conn.connect();
			os = new DataOutputStream(conn.getOutputStream());
			os.writeBytes(bodyString);
			os.close();
			System.out.println("success : requestString : " + bodyString);
		} catch (IOException e) {
			closeQuietly(os);
			conn.disconnect();
			System.out.println(e.getMessage());
			retval = e;
			System.out.println("fail : requestString : " + bodyString);
		}
		return retval;
	}
    
    private static void closeQuietly(InputStream c) {
		if (c != null) {
			try {
				c.close();
			} catch (IOException e) {
				System.out.println("IO Error occurred on closing InputStream.\n" + e.getMessage());
			}
		}
	}
    
    private static void closeQuietly(OutputStream c) {
		if (c != null) {
			try {
				c.close();
			} catch (IOException e) {
				System.out.println("IO Error occurred on closing OutputStream.\n" + e.getMessage());
			}
		}
	}
    
    private Exception receiveError(HttpsURLConnection conn) {
		Exception retval = null;
		InputStream es = conn.getErrorStream();
		if (es != null) { //server service unknown error status.
			BufferedReader reader;
			StringBuffer sb = null;
			try {
				reader = new BufferedReader(new InputStreamReader(es, "UTF-8"));
				sb = new StringBuffer();
				String line = null;

				while ((line = reader.readLine()) != null) {
					sb.append(line);
				}
				es.close();
				conn.disconnect();
			} catch (IOException e) {
				closeQuietly(es);
				retval = e;
				conn.disconnect();
				System.out.println("Request to server returned error. " + e.getMessage());
			}
			retval = new Exception(sb.toString());
		}
		return retval;
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
		
		System.out.println("makeRestURL : " + returnURL);
		
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
		
		ip = "192.168.50.122";
		strService = "backupService";
		strCommand = "restoreData";
		
		test03(ip, port, strService, strCommand);
//		test02(ip, port, strService, strCommand);
//		test_login(ip, port, strService, strCommand);
		
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
	
	private static void test02(String ip, int port, String strService, String strCommand) throws Exception {

		
		ExperDBRestApi api = new ExperDBRestApi(ip, port);
		JSONObject result = new JSONObject();
		//JSONObject parameters = new JSONObject();
		//parameters.put("name", strName);
		//parameters.put("config", config)
		String parameters = "";
		
		HashMap header = new HashMap();
		
		header.put(SystemCode.FieldName.LOGIN_ID, "admin");
		header.put(SystemCode.FieldName.ENTITY_UID, "00000000-0000-0000-0000-000000000001");
		//header.put(SystemCode.FieldName.PASSWORD, "password");
		header.put(SystemCode.FieldName.TOKEN_VALUE, "LDSk9UO1et5f/nBHRtCMz5L30uN/zumvKaVHHs5FTSc=");
		header.put(SystemCode.FieldName.ADDRESS, "");
		
		
		BackupFileHeader bfh = new BackupFileHeader();
		
		bfh.setPassword("experdb12#");
		bfh.setBackupType("FULL");
//		bfh.setBackupFilename("C:\\Users\\yeeun\\Desktop\\work\\eXperDB-Encrypt\\10.edk");
		bfh.setBackupFilename("C:\\Users\\yeeun\\Desktop\\work\\eXperDB-Encrypt\\101.edk");
		
		HashMap param = new HashMap();
		
		param.put("chkKey", true);
		param.put("chkPolicy", true);
		param.put("chkServer", true);
		param.put("chkAdminUser", true);
		param.put("chkConfig", true);
		
		if((boolean) param.get("chkKey")){
			int includeBit = bfh.getIncludedBits();
			bfh.setIncludedBits(includeBit | SystemCode.BitMask.BACKUP_INCLUDE_CRYPTO_KEY);
		}
		if((boolean) param.get("chkPolicy")){
			int includeBit = bfh.getIncludedBits();
			bfh.setIncludedBits(includeBit | SystemCode.BitMask.BACKUP_INCLUDE_POLICY);
		}
		if((boolean) param.get("chkServer")){
			int includeBit = bfh.getIncludedBits();
			bfh.setIncludedBits(includeBit | SystemCode.BitMask.BACKUP_INCLUDE_SERVER);
		}
		if((boolean) param.get("chkAdminUser")){			
			int includeBit = bfh.getIncludedBits();
			bfh.setIncludedBits(includeBit | SystemCode.BitMask.BACKUP_INCLUDE_ADMIN_USER);
		}
		if((boolean) param.get("chkConfig")){
			int includeBit = bfh.getIncludedBits();
			bfh.setIncludedBits(includeBit | SystemCode.BitMask.BACKUP_INCLUDE_CONFIG);
		}
		
		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(bfh.getClass()), bfh.toJSONString());
		
		parameters = TypeUtility.makeRequestBody(body);
		
//		ResponseEntity<RequestResult> responseEntity = api.restResponseEntity2(strService, strCommand, header, parameters);
		result = api.restResponseEncryptBackupRestore(strService, strCommand, header, parameters);

		//body setting
//		String jsonString = responseEntity.getBody();
		JSONObject configJsonObjectMap = null;
		
//		System.out.println("RequestResult : " + responseEntity);
		

		
	}
	
	private static void test03(String ip, int port, String strService, String strCommand) throws Exception {

		ExperDBRestApi api = new ExperDBRestApi(ip, port);
		
		//JSONObject parameters = new JSONObject();
		//parameters.put("name", strName);
		//parameters.put("config", config)
		String parameters = "";
		
		HashMap header = new HashMap();
		
		header.put(SystemCode.FieldName.LOGIN_ID, "admin");
		header.put(SystemCode.FieldName.ENTITY_UID, "00000000-0000-0000-0000-000000000001");
		//header.put(SystemCode.FieldName.PASSWORD, "password");
		header.put(SystemCode.FieldName.TOKEN_VALUE, "Q/vgSQoz2+Nd/Y2GX0ZaK3/IqOmSI4nfbY3WQsR+br4=");
		header.put(SystemCode.FieldName.ADDRESS, "");


		BackupFileHeader bfh = new BackupFileHeader();
		
		HashMap param = new HashMap();
		
		param.put("chkKey", true);
		param.put("chkPolicy", true);
		param.put("chkServer", true);
		param.put("chkAdminUser", true);
		param.put("chkConfig", true);
		param.put("password", "300");
		
		
		bfh.setPassword((String) param.get("password"));
		bfh.setBackupFilename("200.edk");
		File file = new File("C:\\Users\\yeeun\\Desktop\\work\\eXperDB-Encrypt\\200.edk");
		FileItem fileItem = new DiskFileItem("mFile", Files.probeContentType(file.toPath()), false, file.getName(), (int) file.length(), file.getParentFile());
		InputStream input = new FileInputStream(file);
		OutputStream os = fileItem.getOutputStream();
		IOUtils.copy(input, os);
		
		MultipartFile mFile = new CommonsMultipartFile(fileItem);
		
		if((boolean) param.get("chkKey")){
			int includeBit = bfh.getIncludedBits();
			bfh.setIncludedBits(includeBit | SystemCode.BitMask.BACKUP_INCLUDE_CRYPTO_KEY);
		}
		if((boolean) param.get("chkPolicy")){
			int includeBit = bfh.getIncludedBits();
			bfh.setIncludedBits(includeBit | SystemCode.BitMask.BACKUP_INCLUDE_POLICY);
		}
		if((boolean) param.get("chkServer")){
			int includeBit = bfh.getIncludedBits();
			bfh.setIncludedBits(includeBit | SystemCode.BitMask.BACKUP_INCLUDE_SERVER);
		}
		if((boolean) param.get("chkAdminUser")){			
			int includeBit = bfh.getIncludedBits();
			bfh.setIncludedBits(includeBit | SystemCode.BitMask.BACKUP_INCLUDE_ADMIN_USER);
		}
		if((boolean) param.get("chkConfig")){
			int includeBit = bfh.getIncludedBits();
			bfh.setIncludedBits(includeBit | SystemCode.BitMask.BACKUP_INCLUDE_CONFIG);
		}
		
		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(bfh.getClass()), bfh.toJSONString());
		
//		parameters = TypeUtility.makeRequestBody(body);
		
		String responseEntity = api.restResponseEncryptBackupRestore(strService, strCommand, header, body, mFile);
		
		System.out.println("response : " + responseEntity);
		
		
		
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
