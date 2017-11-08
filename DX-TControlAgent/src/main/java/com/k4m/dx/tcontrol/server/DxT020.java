package com.k4m.dx.tcontrol.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.net.Socket;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.k4m.dx.tcontrol.db.SqlSessionManager;
import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;
import com.k4m.dx.tcontrol.util.CommonUtil;

/**
 * 25.	연결test multi 조회
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

public class DxT020 extends SocketCtl{
	
	private static Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private static Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	public DxT020(Socket socket, BufferedInputStream is, BufferedOutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		
		
		JSONArray arrServerInfo = (JSONArray) jObj.get(ProtocolID.ARR_SERVER_INFO);
		
		socketLogger.info("DxT020.execute : " + strDxExCode);
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
	
		JSONObject outputObj = new JSONObject();
		JSONArray arrOut = new JSONArray();

		try {
			
			for(int i=0;i<arrServerInfo.size();i++){
				System.out.println("Start : "+ (i+1));
				
				JSONObject objJob = (JSONObject) arrServerInfo.get(i);
				
				String strServerIP = objJob.get(ProtocolID.SERVER_IP).toString();
				String strServerPort = objJob.get(ProtocolID.SERVER_PORT).toString();
				String strDatabaseName = objJob.get(ProtocolID.DATABASE_NAME).toString();
				
				try {
					String strMasterGbn = selectConnectInfo(objJob);
					
					JSONObject objReturn = new JSONObject();
					objReturn.put(ProtocolID.SERVER_IP, strServerIP);
					objReturn.put(ProtocolID.SERVER_PORT, strServerPort);
					objReturn.put(ProtocolID.DATABASE_NAME, strDatabaseName);
					objReturn.put(ProtocolID.MASTER_GBN, strMasterGbn);
					objReturn.put(ProtocolID.CONNECT_YN, "Y");
					
					arrOut.add(objReturn);
				} catch(Exception e) {
					JSONObject objReturn = new JSONObject();
					objReturn.put(ProtocolID.SERVER_IP, strServerIP);
					objReturn.put(ProtocolID.SERVER_PORT, strServerPort);
					objReturn.put(ProtocolID.DATABASE_NAME, strDatabaseName);
					objReturn.put(ProtocolID.MASTER_GBN, "N");
					objReturn.put(ProtocolID.CONNECT_YN, "N");
					
					arrOut.add(objReturn);
				}

			}
				
			outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
			outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
			outputObj.put(ProtocolID.RESULT_DATA, arrOut);

			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
			
		} catch (Exception e) {
			errLogger.error("DxT020 {} ", e.toString());
			
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT020);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT020);
			outputObj.put(ProtocolID.ERR_MSG, "DxT020 Error [" + e.toString() + "]");
			outputObj.put(ProtocolID.RESULT_DATA, "failed");
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);

		} finally {

		}	    
	}
	
	private String selectConnectInfo(JSONObject serverInfoObj) throws Exception {
		

		SqlSessionFactory sqlSessionFactory = null;
		
		sqlSessionFactory = SqlSessionManager.getInstance();
		
		String poolName = "" + serverInfoObj.get(ProtocolID.SERVER_NAME) + "_" + serverInfoObj.get(ProtocolID.DATABASE_NAME);
		
		Connection connDB = null;
		SqlSession sessDB = null;
		
		String strMasterGbn = "";
		
		try {
			
			SocketExt.setupDriverPool(serverInfoObj, poolName);

			//DB 컨넥션을 가져온다.
			connDB = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);

			sessDB = sqlSessionFactory.openSession(connDB);
			
			HashMap hp = (HashMap) sessDB.selectOne("app.selectMasterGbm");
				
			strMasterGbn = (String) hp.get("master_gbn");
						


		} catch(Exception e) {
			errLogger.error("selectConnectInfo {} ", e.toString());
			throw e;
		} finally {
			sessDB.close();
			connDB.close();
		}	
		
		return strMasterGbn;
		
	}
	
	

}


