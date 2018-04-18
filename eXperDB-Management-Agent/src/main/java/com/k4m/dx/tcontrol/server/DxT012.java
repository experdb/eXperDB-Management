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
 * 전체스키마태이블 조회
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

public class DxT012 extends SocketCtl{
	
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	public DxT012(Socket socket, BufferedInputStream is, BufferedOutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public void execute(String strDxExCode, JSONObject dbInfoObj) throws Exception {
		socketLogger.info("DxT012.execute : " + strDxExCode);
		
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
		
		SqlSessionFactory sqlSessionFactory = null;
		
		JSONObject resDataObj = new JSONObject();
		
		sqlSessionFactory = SqlSessionManager.getInstance();
		
		String poolName = "" + dbInfoObj.get(ProtocolID.SERVER_IP) + "_" + dbInfoObj.get(ProtocolID.DATABASE_NAME) + "_" + dbInfoObj.get(ProtocolID.SERVER_PORT);
				//+ "_" + (String)dbInfoObj.get(ProtocolID.USER_ID)
				//+ "_" + (String)dbInfoObj.get(ProtocolID.USER_PWD);
		
		Connection connDB = null;
		SqlSession sessDB = null;
		List<Object> selectTableList = new ArrayList<Object>();
		
		JSONObject outputObj = new JSONObject();
		
		try {
			
			SocketExt.setupDriverPool(dbInfoObj, poolName);

			try {
			//DB 컨넥션을 가져온다.
			connDB = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);
			sessDB = sqlSessionFactory.openSession(connDB);
			
			} catch(Exception e) {
				strErrCode += ErrCodeMng.Err001;
				strErrMsg += ErrCodeMng.Err001_Msg + " " + e.toString();
				strSuccessCode = "1";
			}
		
			
			selectTableList = sessDB.selectList("app.selectAllSchemaTableList");
			
			
			sessDB.close();
			connDB.close();
			
			outputObj = ResultJSON(selectTableList, strDxExCode, strSuccessCode, strErrCode, strErrMsg);
	        
	        sendBuff = outputObj.toString().getBytes();
	        send(4, sendBuff);

			
		} catch (Exception e) {
			errLogger.error("DxT012 {} ", e.toString());
			
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT012);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT012);
			outputObj.put(ProtocolID.ERR_MSG, "DxT012 Error [" + e.toString() + "]");
			
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
