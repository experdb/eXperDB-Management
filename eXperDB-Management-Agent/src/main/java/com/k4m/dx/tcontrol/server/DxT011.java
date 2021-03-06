package com.k4m.dx.tcontrol.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.ArrayList;
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
 * role 조회
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

public class DxT011 extends SocketCtl{
	
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	public DxT011(Socket socket, BufferedInputStream is, BufferedOutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public void execute(String strDxExCode, JSONObject dbInfoObj) throws Exception {
		socketLogger.info("DxT011.execute : " + strDxExCode);
		
		byte[] sendBuff = null;
		
		SqlSessionFactory sqlSessionFactory = null;
		
		sqlSessionFactory = SqlSessionManager.getInstance();
		
		String poolName = "" + dbInfoObj.get(ProtocolID.SERVER_IP) + "_" + dbInfoObj.get(ProtocolID.DATABASE_NAME) + "_" + dbInfoObj.get(ProtocolID.SERVER_PORT);
				//+ "_" + (String)dbInfoObj.get(ProtocolID.USER_ID)
				//+ "_" + (String)dbInfoObj.get(ProtocolID.USER_PWD);
		
		Connection connDB = null;
		SqlSession sessDB = null;
		List<Object> selectDBList = new ArrayList<Object>();
		
		JSONObject outputObj = new JSONObject();
		
		try {
			
			SocketExt.setupDriverPool(dbInfoObj, poolName);

			//DB 컨넥션을 가져온다.
			connDB = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);
			sessDB = sqlSessionFactory.openSession(connDB);

			selectDBList = sessDB.selectList("app.selectRoleName");
			
			sessDB.close();
			connDB.close();
			
	        outputObj = ResultJSON(selectDBList, strDxExCode, "0", "", "");
	        
	        sendBuff = outputObj.toString().getBytes();
	        send(4, sendBuff);

			
		} catch (Exception e) {
			errLogger.error("DxT011 {} ", e.toString());
			
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT011);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT011);
			outputObj.put(ProtocolID.ERR_MSG, "DxT011 Error [" + e.toString() + "]");
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
		} finally {

			if(sessDB !=null) sessDB.close();
			if(connDB !=null) connDB.close();
			
			outputObj = null;
			sendBuff = null;
		}	        


	}
}
