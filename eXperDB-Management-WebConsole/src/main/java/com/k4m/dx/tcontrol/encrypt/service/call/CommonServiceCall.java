package com.k4m.dx.tcontrol.encrypt.service.call;

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
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.SysCode;

public class CommonServiceCall {
	/**
	 * 적용알고리즘 공통코드 조회
	 * @param restIp
	 * @param restPort
	 * @param strTocken
	 * @return 
	 * @throws Exception
	 */
	public JSONArray selectSysCodeListExper(String restIp, int restPort, String strTocken) throws Exception {
		EncryptCommonService api = new EncryptCommonService(restIp, restPort);
		
		JSONArray jsonArray = new JSONArray();
		
		String strService = SystemCode.ServiceName.SYSTEM_SERVICE;
		String strCommand = SystemCode.ServiceCommand.SELECTCIPHERSYSCODELIST;

		SysCode param = new SysCode();
		//param.setCategoryKey(categoryKey);

		HashMap body = new HashMap();
		//body.put(TypeUtility.getJustClassName(param.getClass()), param.toJSONString());

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
			
			if(totalListCount > 0) {
				for(int i=0; i<list.size(); i++) {
					JSONObject data = (JSONObject) list.get(i);
					
					SysCode sysCode = new SysCode();
					Gson gson = new Gson();
					sysCode = gson.fromJson(data.toJSONString(), sysCode.getClass());
					
					JSONObject jsonObj = new JSONObject();
					
					jsonObj.put("sysCode", sysCode.getSysCode());
					jsonObj.put("sysCodeName", sysCode.getSysCodeName());
					jsonObj.put("SysCodeValue", sysCode.getSysCodeValue());
					
					//System.out.println("syscode : " + sysCode.getSysCode());
					//System.out.println("SysCodeName : " + sysCode.getSysCodeName());
					//System.out.println("SysCodeValue : " + sysCode.getSysCodeValue());	
					
					jsonArray.add(jsonObj);
				}	
			}
		}
		return jsonArray;
	}	
	
}
