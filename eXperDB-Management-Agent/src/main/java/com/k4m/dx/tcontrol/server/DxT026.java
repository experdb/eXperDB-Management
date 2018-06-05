package com.k4m.dx.tcontrol.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.k4m.dx.tcontrol.db.SqlSessionManager;
import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;

/**
 * Create Extension pgAudit 조회
 *
 * @author 변 승 우
 * @see <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2018.06.01   변승우 최초 생성
 * </pre>
 */

public class DxT026 extends SocketCtl{
	
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	public DxT026(Socket socket, BufferedInputStream is, BufferedOutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public void execute(String strDxExCode, JSONObject dbInfoObj, String strExtname) throws Exception {
		
		socketLogger.info("DxT026.execute : " + strDxExCode);
		
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
		
		SqlSessionFactory sqlSessionFactory = null;
		
		sqlSessionFactory = SqlSessionManager.getInstance();
		JSONObject objSERVER_INFO = (JSONObject) dbInfoObj.get(ProtocolID.SERVER_INFO);
		
		String poolName = "" + objSERVER_INFO.get(ProtocolID.SERVER_IP) + "_" + objSERVER_INFO.get(ProtocolID.DATABASE_NAME) + "_" + objSERVER_INFO.get(ProtocolID.SERVER_PORT);
		
		Connection connDB = null;
		SqlSession sessDB = null;
		
		JSONObject outputObj = new JSONObject();
		
		try {
			
			SocketExt.setupDriverPool(objSERVER_INFO, poolName);
			
			//DB 컨넥션을 가져온다.
			connDB = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName); 
			sessDB = sqlSessionFactory.openSession(connDB);
			
			socketLogger.info("DxT026.EXTENSION : " + strExtname);
				
			HashMap hp = new HashMap();
			hp.put("extname", strExtname);
			
			sessDB.update("app.createPgExtensionPgAudit",hp);
			
			outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
			outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
	 		
		} catch (Exception e) {
			errLogger.error("DxT026 {} ", e.toString()); 
			
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT026);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT026);
			outputObj.put(ProtocolID.ERR_MSG, "DxT026 Error [" + e.toString() + "]");

			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
			
			outputObj = null;
			sendBuff= null;			
			
			     
		} finally {
			if(sessDB !=null) sessDB.close();
			if(connDB !=null) connDB.close();
		}	        


	}
}
