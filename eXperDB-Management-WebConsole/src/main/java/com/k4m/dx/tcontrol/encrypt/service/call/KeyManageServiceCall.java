package com.k4m.dx.tcontrol.encrypt.service.call;

import java.util.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.google.gson.Gson;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.EncryptCommonService;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.SystemCode;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.TypeUtility;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.CryptoKey;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.CryptoKeySymmetric;

public class KeyManageServiceCall {

	/**
	 * 암호화키리스트
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @return 
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public JSONObject selectCryptoKeyList(String restIp, int restPort, String strTocken,String loginId, String entityId) throws Exception {
		
		JSONArray jsonArray = new JSONArray();
		JSONObject result = new JSONObject();
		
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.KEY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTCRYPTOKEYLIST;

		CryptoKey param = new CryptoKey();
		param.setKeyTypeCode(SystemCode.KeyTypeCode.SYMMETRIC);
		
		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());

		String parameters = TypeUtility.makeRequestBody(body);
		

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);

		JSONObject resultJson = api.callService(strService, strCommand, header, parameters.toString());
		
		Iterator<?> iter = resultJson.entrySet().iterator();
		while (iter.hasNext()) {
			Map.Entry entry = (Map.Entry) iter.next();

//			System.out.println(String.valueOf(entry.getKey()) + " = " + String.valueOf(entry.getValue()));
		}
		
		
		String resultCode = (String) resultJson.get("resultCode");
		String resultMessage =new String(resultJson.get("resultMessage").toString().getBytes("iso-8859-1"),"UTF-8");
//		long totalListCount = (long) resultJson.get("totalListCount");
		
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		if(resultCode.equals("0000000000")) {
			
			ArrayList list = (ArrayList) resultJson.get("list");
			
			if(list != null) {
				for(int i=0; i<list.size(); i++) {
					JSONObject data = (JSONObject) list.get(i);
					
					JSONObject jsonObj = new JSONObject();
					                          
					Gson gson = new Gson();
					CryptoKey cryptoKey = new CryptoKey();
					cryptoKey = gson.fromJson(data.toJSONString(), cryptoKey.getClass());

					jsonObj.put("no", i+1);
					jsonObj.put("keyUid", cryptoKey.getKeyUid());
					jsonObj.put("resourceName", new String(cryptoKey.getResourceName().toString().getBytes("iso-8859-1"),"UTF-8"));
					jsonObj.put("resourceUid", cryptoKey.getResourceUid());
					jsonObj.put("resourceTypeCode", cryptoKey.getResourceTypeCode());
					jsonObj.put("resourceNote", new String(cryptoKey.getResourceNote().toString().getBytes("iso-8859-1"),"UTF-8"));
					jsonObj.put("resourceTypeName", cryptoKey.getResourceTypeName());
					jsonObj.put("cipherAlgorithmName", cryptoKey.getCipherAlgorithmName());
					jsonObj.put("cipherAlgorithmCode", cryptoKey.getCipherAlgorithmCode());
					
					Date createDateTime = (Date) dateFormat.parse(cryptoKey.getCreateDateTime());
					jsonObj.put("createDateTime", dateFormat.format(createDateTime));
					
					if(cryptoKey.getCreateName() != null) {
						jsonObj.put("createName", new String(cryptoKey.getCreateName().toString().getBytes("iso-8859-1"),"UTF-8"));
					}
					
					if(cryptoKey.getUpdateDateTime() != null){
						Date updateDateTime = (Date) dateFormat.parse(cryptoKey.getUpdateDateTime());
						jsonObj.put("updateDateTime", dateFormat.format(updateDateTime));		
					}
								
					jsonObj.put("keyStatusCode", cryptoKey.getKeyStatusCode());
					jsonObj.put("keyStatusName", cryptoKey.getKeyStatusName());

					if(cryptoKey.getUpdateName() != null) {
						jsonObj.put("updateName", new String(cryptoKey.getUpdateName().toString().getBytes("iso-8859-1"),"UTF-8"));
					}
					jsonArray.add(jsonObj);
					
					StringBuffer bf = new StringBuffer();
					bf.append((i+1) + "키 식별자 : " + cryptoKey.getKeyUid());
					bf.append((i+1) + "키 이름 : " + new String(cryptoKey.getResourceName().toString().getBytes("iso-8859-1"),"UTF-8"));
					bf.append((i+1) + "ResourceUid : " + cryptoKey.getResourceUid());
					bf.append((i+1) + "유형 코드 : " + cryptoKey.getResourceTypeCode());
					bf.append((i+1) + "키 설명 : " + new String(cryptoKey.getResourceNote().toString().getBytes("iso-8859-1"),"UTF-8"));
					bf.append((i+1) + "유형 : " + cryptoKey.getResourceTypeName());
					bf.append((i+1) + "적용 알고리즘 : " + cryptoKey.getCipherAlgorithmName());
					bf.append((i+1) + "작성 일시 : " + cryptoKey.getCreateDateTime() );
					
					if(cryptoKey.getCreateName() != null){
					bf.append((i+1) + "작성자 : " + new String(cryptoKey.getCreateName().toString().getBytes("iso-8859-1"),"UTF-8"));
					}
					bf.append((i+1) + "변경 일시 : " + cryptoKey.getUpdateDateTime());
					
					if(cryptoKey.getUpdateName() != null) {
					bf.append((i+1) + "변경 일시 : " + new String(cryptoKey.getUpdateName().toString().getBytes("iso-8859-1"),"UTF-8")); 
					}
					System.out.println(bf.toString());
				}
			}
//			result.put("list", jsonArray);
		}
			result.put("resultCode", resultCode);
			result.put("resultMessage", resultMessage);
		
		return result;
	}

	public JSONObject insertCryptoKeySymmetric(String restIp, int restPort, String strTocken,String loginId, String entityId, CryptoKeySymmetric param) throws Exception{
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		JSONObject result = new JSONObject();
		
		String strService = SystemCode.ServiceName.KEY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.INSERTCRYPTOKEYSYMMETRIC;


		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());

		String parameters = TypeUtility.makeRequestBody(body);
		

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);

		JSONObject resultJson = api.callService(strService, strCommand, header, parameters.toString());
		
		Iterator<?> iter = resultJson.entrySet().iterator();
		while (iter.hasNext()) {
			Map.Entry entry = (Map.Entry) iter.next();

//			System.out.println(String.valueOf(entry.getKey()) + " = " + String.valueOf(entry.getValue()));
		}
		
		
		String resultCode = (String) resultJson.get("resultCode");
		String resultMessage = new String(resultJson.get("resultMessage").toString().getBytes("iso-8859-1"),"UTF-8");
		
		result.put("resultCode", resultCode);
		result.put("resultMessage", resultMessage);

		return result;
	}

	
	public JSONObject updateCryptoKeySymmetric(String restIp, int restPort, String strTocken,String loginId, String entityId, CryptoKeySymmetric param, ArrayList param2) throws Exception {
		
		JSONArray jsonArray = new JSONArray();
		JSONObject result = new JSONObject();
		
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.KEY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.UPDATECRYPTOKEYSYMMETRIC;

		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());
		body.put("CryptoKeySymmetricList", param2);

		String parameters = TypeUtility.makeRequestBody(body);
		
		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);

		JSONObject resultJson = api.callService(strService, strCommand, header, parameters.toString());
		
		Iterator<?> iter = resultJson.entrySet().iterator();
		while (iter.hasNext()) {
			Map.Entry entry = (Map.Entry) iter.next();

//			System.out.println(String.valueOf(entry.getKey()) + " = " + String.valueOf(entry.getValue()));
		}
		
		
		String resultCode = (String) resultJson.get("resultCode");
		String resultMessage = new String(resultJson.get("resultMessage").toString().getBytes("iso-8859-1"),"UTF-8");
		
		result.put("resultCode", resultCode);
		result.put("resultMessage", resultMessage);

		return result;
	}

	public JSONObject selectCryptoKeySymmetricList(String restIp, int restPort, String strTocken,String loginId, String entityId,
			CryptoKeySymmetric param) throws Exception {
		
		JSONArray jsonArray = new JSONArray();
		JSONObject result = new JSONObject();
		
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.KEY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTCRYPTOKEYSYMMETRICLIST;

		
		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());

		String parameters = TypeUtility.makeRequestBody(body);
		

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);

		JSONObject resultJson = api.callService(strService, strCommand, header, parameters.toString());
		
		Iterator<?> iter = resultJson.entrySet().iterator();
		while (iter.hasNext()) {
			Map.Entry entry = (Map.Entry) iter.next();

//			System.out.println(String.valueOf(entry.getKey()) + " = " + String.valueOf(entry.getValue()));
		}
				
		String resultCode = (String) resultJson.get("resultCode");
		String resultMessage = new String(resultJson.get("resultMessage").toString().getBytes("iso-8859-1"),"UTF-8");
		long totalListCount = (long) resultJson.get("totalListCount");
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		if(resultCode.equals("0000000000")) {
			ArrayList list = (ArrayList) resultJson.get("list");
			
			//System.out.println("list Size : " + list.size());
			if(totalListCount > 0) {
				for(int i=0; i<list.size(); i++) {
					JSONObject jsonData = (JSONObject) list.get(i);
					
					JSONObject jsonObj = new JSONObject();
					
					Gson gson = new Gson();
					CryptoKeySymmetric cryptoKeySymmetric = new CryptoKeySymmetric();
					cryptoKeySymmetric = gson.fromJson(jsonData.toJSONString(), cryptoKeySymmetric.getClass());
					
					jsonObj.put("no", i+1);
					
					jsonObj.put("binuid", cryptoKeySymmetric.getBinUid());
					jsonObj.put("binstatuscode", cryptoKeySymmetric.getBinStatusCode());				
					jsonObj.put("version", cryptoKeySymmetric.getBinVersion());
					jsonObj.put("keyStatusName", cryptoKeySymmetric.getKeyStatusName());
					
					if(cryptoKeySymmetric.getValidEndDateTime() != null) {
						Date validEndDateTimeDate = dateFormat.parse(cryptoKeySymmetric.getValidEndDateTime());
						jsonObj.put("validEndDateTime", dateFormat.format(validEndDateTimeDate));
					}
					
					if(cryptoKeySymmetric.getCreateName() != null) {
						jsonObj.put("createName", new String(cryptoKeySymmetric.getCreateName().toString().getBytes("iso-8859-1"),"UTF-8"));
					}
					
					Date createDateTimeDate = dateFormat.parse(cryptoKeySymmetric.getCreateDateTime());
					jsonObj.put("createDateTime", dateFormat.format(createDateTimeDate));
					
					if(cryptoKeySymmetric.getUpdateName() != null) {
						jsonObj.put("updateName", new String(cryptoKeySymmetric.getUpdateName().toString().getBytes("iso-8859-1"),"UTF-8"));
					}
					
					if(cryptoKeySymmetric.getUpdateDateTime() != null) {
						Date updateDateTimeDate = dateFormat.parse(cryptoKeySymmetric.getUpdateDateTime());
						jsonObj.put("updateDateTime", dateFormat.format(updateDateTimeDate));
					}

					jsonArray.add(jsonObj);
				}
				result.put("list", jsonArray);
			}
		}
			result.put("resultCode", resultCode);
			result.put("resultMessage", resultMessage);

		return result;
	}

	public JSONObject deleteCryptoKeySymmetric(String restIp, int restPort, String strTocken,String loginId, String entityId, CryptoKeySymmetric param) throws Exception{
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		String strService = SystemCode.ServiceName.KEY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.DELETECRYPTOKEYSYMMETRIC;


		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());

		String parameters = TypeUtility.makeRequestBody(body);
		
		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, loginId);
		header.put(SystemCode.FieldName.ENTITY_UID, entityId);
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);

		JSONObject resultJson = api.callService(strService, strCommand, header, parameters.toString());
		
		Iterator<?> iter = resultJson.entrySet().iterator();
		while (iter.hasNext()) {
			Map.Entry entry = (Map.Entry) iter.next();

//			System.out.println(String.valueOf(entry.getKey()) + " = " + String.valueOf(entry.getValue()));
		}
		
		
		String resultCode = (String) resultJson.get("resultCode");
		String resultMessage = new String(resultJson.get("resultMessage").toString().getBytes("iso-8859-1"),"UTF-8");
		
		JSONObject jsonObj = new JSONObject();
		
		jsonObj.put("resultCode", (String) resultJson.get("resultCode"));
		jsonObj.put("resultMessage", new String(resultJson.get("resultMessage").toString().getBytes("iso-8859-1"),"UTF-8"));
		
		System.out.println(resultMessage);
		
		return jsonObj;
	}
}
