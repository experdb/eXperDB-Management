package com.k4m.dx.tcontrol.server;

import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;

import org.apache.commons.dbcp.PoolingDriver;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.k4m.dx.tcontrol.db.DBCPPoolManager;
import com.k4m.dx.tcontrol.db.SqlSessionManager;
import com.k4m.dx.tcontrol.socket.ErrCodeMng;
import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;

/**
 * kafka-connect CRUD
 *
 * @author 박태혁
 * @see <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.05.22   박태혁 최초 생성
 * </pre>
 */

public class DxT014 extends SocketCtl{
	
	private static Logger errLogger = LoggerFactory.getLogger("errorToFile");
	
	public DxT014(Socket socket, InputStream is, OutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
		
		JSONObject objSERVER_INFO = (JSONObject) jObj.get(ProtocolID.SERVER_INFO);
		String strCommandCode = (String) jObj.get(ProtocolID.COMMAND_CODE);
		JSONObject acInfoObj = (JSONObject) jObj.get(ProtocolID.ACCESS_CONTROL_INFO);

		List<LinkedHashMap<String, String>> outputArray = new ArrayList<LinkedHashMap<String, String>>();
		
		JSONObject outputObj = new JSONObject();
		
		try {
			//등록
			if(strCommandCode.equals(ProtocolID.COMMAND_CODE_C)) {
				
				//createAuthentication(jObj);
				
				outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
				outputObj.put(ProtocolID.RESULT_CODE, "0");
				outputObj.put(ProtocolID.ERR_CODE, "");
				outputObj.put(ProtocolID.ERR_MSG, "");
				outputObj.put(ProtocolID.RESULT_DATA, "success");
			
			//조회
			} else if(strCommandCode.equals(ProtocolID.COMMAND_CODE_R)) {
				//outputArray = selectAuthentication(objSERVER_INFO);
				
				outputObj = DxT006ResultJSON(outputArray, strDxExCode, strSuccessCode, strErrCode, strErrMsg);
			
			//수정
			} else if(strCommandCode.equals(ProtocolID.COMMAND_CODE_U)) {
				//updateAuthentication(jObj);
				
				outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
				outputObj.put(ProtocolID.RESULT_CODE, "0");
				outputObj.put(ProtocolID.ERR_CODE, "");
				outputObj.put(ProtocolID.ERR_MSG, "");
				outputObj.put(ProtocolID.RESULT_DATA, "success");
			//삭제
			} else if(strCommandCode.equals(ProtocolID.COMMAND_CODE_D)) {
				//deleteAuthentication(jObj);
				
				outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
				outputObj.put(ProtocolID.RESULT_CODE, "0");
				outputObj.put(ProtocolID.ERR_CODE, "");
				outputObj.put(ProtocolID.ERR_MSG, "");
				outputObj.put(ProtocolID.RESULT_DATA, "success");
			}
			
			send(TotalLengthBit, outputObj.toString().getBytes());
		} catch (Exception e) {
			errLogger.error("DxT006 {} ", e.toString());
			
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT006);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT006);
			outputObj.put(ProtocolID.ERR_MSG, "DxT006 Error [" + e.toString() + "]");
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);

		} finally {

		}	    
		

	}
}
