package com.experdb.management.proxy.cmmn;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.cmmn.AES256;
import com.k4m.dx.tcontrol.cmmn.AES256_KEY;
import com.k4m.dx.tcontrol.restore.service.RestoreDumpVO;
import com.k4m.dx.tcontrol.restore.service.RestoreRmanVO;

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
}
