package com.k4m.dx.tcontrol.encript.service.call;

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
	public JSONObject selectCryptoKeyList(String restIp, int restPort, String strTocken) throws Exception {
		
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
		header.put(SystemCode.FieldName.LOGIN_ID, "admin");
		header.put(SystemCode.FieldName.ENTITY_UID, "00000000-0000-0000-0000-000000000001");
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);

		JSONObject resultJson = api.callService(strService, strCommand, header, parameters.toString());
		
		Iterator<?> iter = resultJson.entrySet().iterator();
		while (iter.hasNext()) {
			Map.Entry entry = (Map.Entry) iter.next();

			System.out.println(String.valueOf(entry.getKey()) + " = " + String.valueOf(entry.getValue()));
		}
		
		
		String resultCode = (String) resultJson.get("resultCode");
		String resultMessage = (String) resultJson.get("resultMessage");
		long totalListCount = (long) resultJson.get("totalListCount");
		
		
		if(resultCode.equals("0000000000")) {
			ArrayList list = (ArrayList) resultJson.get("list");
			
			//System.out.println("list Size : " + list.size());
			if(totalListCount > 0) {
				for(int i=0; i<list.size(); i++) {
					JSONObject data = (JSONObject) list.get(i);
					
					JSONObject jsonObj = new JSONObject();
					
					Gson gson = new Gson();
					CryptoKey cryptoKey = new CryptoKey();
					cryptoKey = gson.fromJson(data.toJSONString(), cryptoKey.getClass());

					jsonObj.put("no", i+1);
					jsonObj.put("keyUid", cryptoKey.getKeyUid());
					jsonObj.put("resourceName", cryptoKey.getResourceName());
					jsonObj.put("resourceUid", cryptoKey.getResourceUid());
					jsonObj.put("resourceTypeName", cryptoKey.getResourceTypeCode());
					jsonObj.put("resourceNote", cryptoKey.getResourceNote());
					jsonObj.put("resourceTypeName", cryptoKey.getResourceTypeName());
					jsonObj.put("cipherAlgorithmName", cryptoKey.getCipherAlgorithmName());
					jsonObj.put("cipherAlgorithmCode", cryptoKey.getCipherAlgorithmCode());
					jsonObj.put("createDateTime", cryptoKey.getCreateDateTime());
					jsonObj.put("createName", new String(cryptoKey.getCreateName().toString().getBytes("iso-8859-1"),"UTF-8"));
					jsonObj.put("updateDateTime", cryptoKey.getUpdateDateTime());					
					jsonObj.put("keyStatusCode", cryptoKey.getKeyStatusCode());
					jsonObj.put("keyStatusName", cryptoKey.getKeyStatusName());

					if(cryptoKey.getUpdateName() != null) {
						jsonObj.put("updateName", new String(cryptoKey.getUpdateName().toString().getBytes("iso-8859-1"),"UTF-8"));
					}
					jsonArray.add(jsonObj);
					
					StringBuffer bf = new StringBuffer();
					bf.append((i+1) + "키 식별자 : " + cryptoKey.getKeyUid());
					bf.append((i+1) + "키 이름 : " + cryptoKey.getResourceName());
					bf.append((i+1) + "ResourceUid : " + cryptoKey.getResourceUid());
					bf.append((i+1) + "유형 코드 : " + cryptoKey.getResourceTypeCode());
					bf.append((i+1) + "키 설명 : " + cryptoKey.getResourceNote());
					bf.append((i+1) + "유형 : " + cryptoKey.getResourceTypeName());
					bf.append((i+1) + "적용 알고리즘 : " + cryptoKey.getCipherAlgorithmName());
					bf.append((i+1) + "작성 일시 : " + cryptoKey.getCreateDateTime() );
					bf.append((i+1) + "작성자 : " + new String(cryptoKey.getCreateName().toString().getBytes("iso-8859-1"),"UTF-8"));
					bf.append((i+1) + "변경 일시 : " + cryptoKey.getUpdateDateTime());
					
					if(cryptoKey.getUpdateName() != null) {
					bf.append((i+1) + "변경 일시 : " + new String(cryptoKey.getUpdateName().toString().getBytes("iso-8859-1"),"UTF-8")); 
					}
					System.out.println(bf.toString());
				}
				result.put("data", jsonArray);
			}
		}
		return result;
	}

	public JSONObject insertCryptoKeySymmetric(String restIp, int restPort, String strTocken, CryptoKeySymmetric param) throws Exception{
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);

		JSONObject result = new JSONObject();
		
		String strService = SystemCode.ServiceName.KEY_SERVICE;
		String strCommand = SystemCode.ServiceCommand.INSERTCRYPTOKEYSYMMETRIC;


		HashMap body = new HashMap();
		body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());

		String parameters = TypeUtility.makeRequestBody(body);
		

		HashMap header = new HashMap();
		header.put(SystemCode.FieldName.LOGIN_ID, "admin");
		header.put(SystemCode.FieldName.ENTITY_UID, "00000000-0000-0000-0000-000000000001");
		header.put(SystemCode.FieldName.TOKEN_VALUE, strTocken);

		JSONObject resultJson = api.callService(strService, strCommand, header, parameters.toString());
		
		Iterator<?> iter = resultJson.entrySet().iterator();
		while (iter.hasNext()) {
			Map.Entry entry = (Map.Entry) iter.next();

			System.out.println(String.valueOf(entry.getKey()) + " = " + String.valueOf(entry.getValue()));
		}
		
		
		String resultCode = (String) resultJson.get("resultCode");
		String resultMessage = new String(resultJson.get("resultMessage").toString().getBytes("iso-8859-1"),"UTF-8");
		
		result.put("resultCode", resultCode);
		result.put("resultMessage", resultMessage);

		return result;
	}
}
