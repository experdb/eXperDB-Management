package com.k4m.dx.tcontrol.server;

import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.k4m.dx.tcontrol.db.DBCPPoolManager;
import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;

/**
 * Transfer Connect Test
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

public class DxT004 extends SocketCtl{
	
	private static Logger errLogger = LoggerFactory.getLogger("errorToFile");
	
	public DxT004(Socket socket, InputStream is, OutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public void execute(String strDxExCode, JSONObject dbInfoObj) throws Exception {
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";

		JSONArray outputArray = new JSONArray();

		
		String poolName = "ConnectionTest";
		Connection conn = null;
		
		try {
			Class.forName("org.postgresql.Driver");
			
			Properties props = new Properties();
			props.setProperty("user",(String)dbInfoObj.get(ProtocolID.USER_ID));
			props.setProperty("password",(String)dbInfoObj.get(ProtocolID.USER_PWD));
			
			String strConnUrl = "jdbc:postgresql://"+ dbInfoObj.get(ProtocolID.SERVER_IP) +":"+ dbInfoObj.get(ProtocolID.SERVER_PORT) +"/"+ dbInfoObj.get(ProtocolID.DATABASE_NAME);

			conn = DriverManager.getConnection(strConnUrl, props);
			outputArray.add("접속 테스트가 성공했습니다.");

		} catch (Exception e) {
			errLogger.error("DxT003 {} ", e.toString());
			outputArray.add("접속 테스트가 실패했습니다.");
			strErrCode = "ErrDxT003";
			strErrMsg = "접속 테스트가 실패했습니다.";
			strSuccessCode = "1";
		} finally {
			if (poolName != null){
				DBCPPoolManager.shutdownDriver(poolName);
			}
		}	    
		
		JSONObject outputObj = ResultJSON(outputArray, strDxExCode, strSuccessCode, strErrCode, strErrMsg);
		send(TotalLengthBit, outputObj.toString().getBytes());


	}
}
