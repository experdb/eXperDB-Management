package com.k4m.dx.tcontrol.cmmn.client;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class ClientInfoCmmn {
	

		String Ip = "222.110.153.162";
		int port = 9001;

	
		// 1. 서버 연결 테스트 (serverConn)
		public Map<String, Object> DbserverConn(JSONObject serverObj){
		
			Map<String, Object> result =new HashMap<String, Object>();
			
			try {				
										
				JSONObject objList;
				
				ClientAdapter CA = new ClientAdapter(Ip, port);
				CA.open(); 
				
				objList = CA.dxT003(ClientTranCodeType.DxT003, serverObj);
				
				String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);
				String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
				String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
				String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
				
				System.out.println("strDxExCode : " + " " + strDxExCode);
				System.out.println("strResultCode : " + " " + strResultCode);
				System.out.println("strErrCode : " + " " + strErrCode);
				System.out.println("strErrMsg : " + " " + strErrMsg);
				
				System.out.println("RESULT_DATA : " + " " + objList.get(ClientProtocolID.RESULT_DATA));

				result.put("result_data", objList.get(ClientProtocolID.RESULT_DATA));
				result.put("result_code", strResultCode);
				 
				CA.close();
			} catch(Exception e) {
				e.printStackTrace();
			}
			return result;
		}
		
		
		// 2. 데이터베이스 리스트 (dbList)
		public JSONObject db_List(JSONObject serverObj){
			
			JSONArray jsonArray = new JSONArray(); // 객체를 담기위해 JSONArray 선언.
			JSONObject result = new JSONObject();

			
			List<Object> selectDBList = null;
			
			try {
			JSONObject objList;
			
			ClientAdapter CA = new ClientAdapter(Ip, port);
			CA.open(); 
				
			objList = CA.dxT001(ClientTranCodeType.DxT001, serverObj);
			
			String _tran_err_msg = (String)objList.get(ClientProtocolID.ERR_MSG);
			String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
			
			selectDBList =(ArrayList<Object>) objList.get(ClientProtocolID.RESULT_DATA);
			
			System.out.println("strDxExCode : " + " " + strDxExCode);
			
			for(int i=0; i<selectDBList.size(); i++) {	
				JSONObject jsonObj = new JSONObject();
				Object obj = selectDBList.get(i);				
				HashMap hp = (HashMap) obj;
				String datname = (String) hp.get("datname");
				
				jsonObj.put("dft_db_nm", datname);
				jsonArray.add(jsonObj);
			}
			result.put("data", jsonArray);
		
			CA.close();
		} catch(Exception e) {
			e.printStackTrace();
		}
			return result;
		}
}
