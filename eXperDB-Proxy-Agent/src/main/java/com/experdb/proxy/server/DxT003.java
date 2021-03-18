package com.experdb.proxy.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.net.Socket;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.experdb.proxy.socket.ProtocolID;
import com.experdb.proxy.socket.SocketCtl;
import com.experdb.proxy.socket.TranCodeType;

/**
 * Connection Test
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

public class DxT003 extends SocketCtl{
	
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	public DxT003(Socket socket, BufferedInputStream is, BufferedOutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public void execute(String strDxExCode, JSONObject dbInfoObj) throws Exception {
		socketLogger.info("DxT004.execute : " + strDxExCode);
		
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";

		JSONArray outputArray = new JSONArray();

		Connection conn = null;
		
		JSONObject outputObj = new JSONObject();
		
		try {
			Class.forName("org.postgresql.Driver");
			
			Properties props = new Properties();
			props.setProperty("user",(String)dbInfoObj.get(ProtocolID.USER_ID));
			props.setProperty("password",(String)dbInfoObj.get(ProtocolID.USER_PWD));
			
			String strConnUrl = "jdbc:postgresql://"+ dbInfoObj.get(ProtocolID.SERVER_IP) +":"+ dbInfoObj.get(ProtocolID.SERVER_PORT) +"/"+ dbInfoObj.get(ProtocolID.DATABASE_NAME);

			conn = DriverManager.getConnection(strConnUrl, props);
			outputArray.add("접속 테스트가 성공했습니다.");
			
			outputObj = ResultJSON(outputArray, strDxExCode, strSuccessCode, strErrCode, strErrMsg);
			send(TotalLengthBit, outputObj.toString().getBytes());

		} catch (Exception e) {
			errLogger.error("DxT003 {} ", e.toString());
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT003);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT003);
			outputObj.put(ProtocolID.ERR_MSG, "DxT003 Error [" + e.toString() + "]");
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
		} finally {
			if(conn != null) conn.close();
			outputObj = null;
			sendBuff = null;
		}	    

	}
}
