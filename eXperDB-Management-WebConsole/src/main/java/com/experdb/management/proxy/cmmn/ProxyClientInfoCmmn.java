package com.experdb.management.proxy.cmmn;

import java.net.ConnectException;
import java.util.HashMap;
import java.util.Map;
import org.json.simple.JSONObject;


public class ProxyClientInfoCmmn implements Runnable{

	@Override
	public void run() {
		// TODO Auto-generated method stub
	}

	// 1. proxy agent 실행
	public Map<String, Object> proxyAgentExcute(String IP, int PORT, String agt_cndt_cd) {
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		try {
			JSONObject jObj = new JSONObject();
			jObj.put(ProxyClientProtocolID.DX_EX_CODE, ProxyClientTranCodeType.PsP001);
			jObj.put(ProxyClientProtocolID.AGT_CNDT_CD, agt_cndt_cd);

			JSONObject objList;
			
			ProxyClientAdapter PCA = new ProxyClientAdapter(IP, PORT);
			PCA.open(); 

			objList = PCA.psP001(jObj);
		
			PCA.close();
			
			String strErrMsg = (String)objList.get(ProxyClientProtocolID.ERR_MSG);
			String strErrCode = (String)objList.get(ProxyClientProtocolID.ERR_CODE);
			String strDxExCode = (String)objList.get(ProxyClientProtocolID.DX_EX_CODE);
			String strResultCode = (String)objList.get(ProxyClientProtocolID.RESULT_CODE);
			String strResultData = (String)objList.get(ProxyClientProtocolID.RESULT_DATA);

			System.out.println("RESULT_CODE : " +  strResultCode);
			System.out.println("ERR_CODE : " +  strErrCode);
			System.out.println("ERR_MSG : " +  strErrMsg);
			System.out.println("RESULT_DATA : " +  strResultData);
			
			result.put("RESULT_CODE", strResultCode);
			result.put("ERR_CODE", strErrCode);
			result.put("ERR_MSG", strErrMsg);
			result.put("RESULT_DATA", strErrMsg);
				
			//CA.close();
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}

	public Map<String, Object> proxyAgentConnectionTest(String IP, int PORT) throws ConnectException, Exception{
		Map<String, Object> result = new HashMap<String, Object>();
		
		JSONObject jObj = new JSONObject();
		jObj.put(ProxyClientProtocolID.DX_EX_CODE, ProxyClientTranCodeType.PsP002);

		JSONObject objList;
		
		ProxyClientAdapter PCA = new ProxyClientAdapter(IP, PORT);
		PCA.open(); 

		objList = PCA.psP002(jObj);
	
		PCA.close();
		
		String strErrMsg = (String)objList.get(ProxyClientProtocolID.ERR_MSG);
		String strErrCode = (String)objList.get(ProxyClientProtocolID.ERR_CODE);
		String strDxExCode = (String)objList.get(ProxyClientProtocolID.DX_EX_CODE);
		String strResultCode = (String)objList.get(ProxyClientProtocolID.RESULT_CODE);
		String strResultData = (String)objList.get(ProxyClientProtocolID.RESULT_DATA);

		System.out.println("RESULT_CODE : " +  strResultCode);
		System.out.println("ERR_CODE : " +  strErrCode);
		System.out.println("ERR_MSG : " +  strErrMsg);
		System.out.println("RESULT_DATA : " +  strResultData);
		
		result.put("RESULT_CODE", strResultCode);
		result.put("ERR_CODE", strErrCode);
		result.put("ERR_MSG", strErrMsg);
		result.put("RESULT_DATA", strErrMsg);
				
		return result;
	}
	
	public Map<String, Object> createProxyConfigFile(String IP, int PORT, JSONObject jObj) throws ConnectException, Exception{
		Map<String, Object> result = new HashMap<String, Object>();
		
		jObj.put(ProxyClientProtocolID.DX_EX_CODE, ProxyClientTranCodeType.PsP004);
		
		JSONObject objList;
		
		ProxyClientAdapter PCA = new ProxyClientAdapter(IP, PORT);
		PCA.open(); 

		objList = PCA.psP004(jObj); 
	
		PCA.close();
		
		System.out.println("createProxyConfigFile result :: "+objList.toJSONString());
		
		String strErrMsg = (String)objList.get(ProxyClientProtocolID.ERR_MSG);
		String strErrCode = (String)objList.get(ProxyClientProtocolID.ERR_CODE);
		String strDxExCode = (String)objList.get(ProxyClientProtocolID.DX_EX_CODE);
		String strResultCode = (String)objList.get(ProxyClientProtocolID.RESULT_CODE);
		String strResultData = (String)objList.get(ProxyClientProtocolID.RESULT_DATA);
		
		result.put("RESULT_CODE", strResultCode);
		result.put("ERR_CODE", strErrCode);
		result.put("ERR_MSG", strErrMsg);
		result.put("RESULT_DATA", strResultData);
		result.put("PRY_PTH", (String)objList.get(ProxyClientProtocolID.PRY_PTH));
		result.put("KAL_PTH", (String)objList.get(ProxyClientProtocolID.KAL_PTH));
				
		return result;
	}

	// proxy, keepalived config 파일 가져오기
	public Map<String, Object> getConfigFile(String IP, int PORT, JSONObject jObj) throws ConnectException, Exception {
		Map<String, Object> result = new HashMap<>();
		
		JSONObject objResult;
		
		ProxyClientAdapter PCA = new ProxyClientAdapter(IP, PORT);
		
		PCA.open();
		
		objResult = PCA.psP003(jObj);
		
		PCA.close();
		
		String strErrMsg = (String)objResult.get(ProxyClientProtocolID.ERR_MSG);
		String strErrCode = (String)objResult.get(ProxyClientProtocolID.ERR_CODE);
		String strDxExCode = (String)objResult.get(ProxyClientProtocolID.DX_EX_CODE);
		String strResultCode = (String)objResult.get(ProxyClientProtocolID.RESULT_CODE);
		String strResultData = (String)objResult.get(ProxyClientProtocolID.RESULT_DATA);
		
		result.put("RESULT_CODE", strResultCode);
		result.put("ERR_CODE", strErrCode);
		result.put("ERR_MSG", strErrMsg);
		result.put("RESULT_DATA", strResultData);
				
		return result;
	}

	public Map<String, Object> proxyServiceExcute(String IP, int PORT, JSONObject jObj) throws ConnectException, Exception {
		Map<String, Object> result = new HashMap<>();
		jObj.put(ProxyClientProtocolID.DX_EX_CODE, ProxyClientTranCodeType.PsP006);
		JSONObject objResult;
		
		ProxyClientAdapter PCA = new ProxyClientAdapter(IP, PORT);
		
		PCA.open();
		
		objResult = PCA.psP006(jObj);
		
		PCA.close();
		
		String strErrMsg = (String)objResult.get(ProxyClientProtocolID.ERR_MSG);
		String strErrCode = (String)objResult.get(ProxyClientProtocolID.ERR_CODE);
		String strDxExCode = (String)objResult.get(ProxyClientProtocolID.DX_EX_CODE);
		String strResultCode = (String)objResult.get(ProxyClientProtocolID.RESULT_CODE);
		String strResultData = (String)objResult.get(ProxyClientProtocolID.RESULT_DATA);
		
		
		result.put("RESULT_CODE", strResultCode);
		result.put("ERR_CODE", strErrCode);
		result.put("ERR_MSG", strErrMsg);
		result.put("RESULT_DATA", strResultData);
		result.put("EXECUTE_RESULT", (String)objResult.get(ProxyClientProtocolID.EXECUTE_RESULT));
				
		return result;
	}
	
	// proxy, keepalived log 파일 가져오기
	public Map<String, Object> getLogFile(String IP, int PORT, JSONObject jObj) throws ConnectException, Exception {
		Map<String, Object> result = new HashMap<>();
		
		JSONObject objResult;
		
		ProxyClientAdapter PCA = new ProxyClientAdapter(IP, PORT);
		
		PCA.open();
		
		objResult = PCA.psP008(jObj);
		
		PCA.close();
		
		String strErrMsg = (String)objResult.get(ProxyClientProtocolID.ERR_MSG);
		String strErrCode = (String)objResult.get(ProxyClientProtocolID.ERR_CODE);
		String strDxExCode = (String)objResult.get(ProxyClientProtocolID.DX_EX_CODE);
		String strResultCode = (String)objResult.get(ProxyClientProtocolID.RESULT_CODE);
		String strResultData = (String)objResult.get(ProxyClientProtocolID.RESULT_DATA);
		int strDwLen = (int) objResult.get(ProxyClientProtocolID.DW_LEN);
		
		result.put("RESULT_CODE", strResultCode);
		result.put("ERR_CODE", strErrCode);
		result.put("ERR_MSG", strErrMsg);
		result.put("RESULT_DATA", strResultData);
		result.put("DW_LEN", strDwLen);
		
		return result;
	}
	
	public Map<String, Object> getProxyAgtInterface(String IP, int PORT) throws ConnectException, Exception {
		Map<String, Object> result = new HashMap<>();
		JSONObject jObj = new JSONObject();
		jObj.put(ProxyClientProtocolID.DX_EX_CODE, ProxyClientTranCodeType.PsP007);
		JSONObject objResult;
		
		ProxyClientAdapter PCA = new ProxyClientAdapter(IP, PORT);
		
		PCA.open();
		
		objResult = PCA.psP007(jObj);
		
		PCA.close();
		
		String strErrMsg = (String)objResult.get(ProxyClientProtocolID.ERR_MSG);
		String strErrCode = (String)objResult.get(ProxyClientProtocolID.ERR_CODE);
		String strDxExCode = (String)objResult.get(ProxyClientProtocolID.DX_EX_CODE);
		String strResultCode = (String)objResult.get(ProxyClientProtocolID.RESULT_CODE);
		String strResultData = (String)objResult.get(ProxyClientProtocolID.RESULT_DATA);
		
		
		result.put("RESULT_CODE", strResultCode);
		result.put("ERR_CODE", strErrCode);
		result.put("ERR_MSG", strErrMsg);
		result.put("RESULT_DATA", strResultData);
		result.put("INTF_LIST", (String)objResult.get(ProxyClientProtocolID.INTERFACE_LIST));
		result.put("INTF", (String)objResult.get(ProxyClientProtocolID.INTERFACE));
		
		return result;
	}
}
