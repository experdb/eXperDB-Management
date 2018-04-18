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
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.k4m.dx.tcontrol.db.SqlSessionManager;
import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;

/**
 * 23.	kafka_con_config 등록/삭제
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

public class DxT018 extends SocketCtl{
	
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	public DxT018(Socket socket, BufferedInputStream is, BufferedOutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		
		socketLogger.info("DxT018.execute : " + strDxExCode);
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";

		String strCommandCode = (String) jObj.get(ProtocolID.COMMAND_CODE);
	
		JSONObject outputObj = new JSONObject();
		List<Object> selectDataList = new ArrayList<Object>();
		try {
			
			if(strCommandCode.equals(ProtocolID.COMMAND_CODE_C)) {


				insertKafkaConConfig(jObj);
				
				outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
				outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
				outputObj.put(ProtocolID.ERR_CODE, strErrCode);
				outputObj.put(ProtocolID.ERR_MSG, strErrMsg);

			} else if(strCommandCode.equals(ProtocolID.COMMAND_CODE_R)) {

			} else if(strCommandCode.equals(ProtocolID.COMMAND_CODE_U)) {
				
			} else if(strCommandCode.equals(ProtocolID.COMMAND_CODE_D)) {
				
				deleteKafkaConConfig(jObj);
				
				outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
				outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
				outputObj.put(ProtocolID.ERR_CODE, strErrCode);
				outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
				
			}



			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
			
		} catch (Exception e) {
			errLogger.error("DxT018 {} ", e.toString());
			
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT018);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT018);
			outputObj.put(ProtocolID.ERR_MSG, "DxT018 Error [" + e.toString() + "]");
			outputObj.put(ProtocolID.RESULT_DATA, "failed");
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);

		} finally {
			outputObj = null;
			sendBuff = null;
		}	    
	}
	
	private List<Object> selectTblMapps(JSONObject jObj) throws Exception {
		
		List<Object> selectDataList = new ArrayList<Object>();
		
		JSONObject serverInfoObj = (JSONObject) jObj.get(ProtocolID.SERVER_INFO);
		List<HashMap<String,String>> objTable_Info = (List<HashMap<String,String>>) jObj.get(ProtocolID.TABLE_INFO);
		

		SqlSessionFactory sqlSessionFactory = null;
		
		sqlSessionFactory = SqlSessionManager.getInstance();
		
		String poolName = "" + serverInfoObj.get(ProtocolID.SERVER_IP) + "_" + serverInfoObj.get(ProtocolID.DATABASE_NAME)+ "_" + serverInfoObj.get(ProtocolID.SERVER_PORT);
		//+ "_" + (String)serverInfoObj.get(ProtocolID.USER_ID)
		//+ "_" + (String)serverInfoObj.get(ProtocolID.USER_PWD);
		
		Connection connDB = null;
		SqlSession sessDB = null;
		
		try {
			
			SocketExt.setupDriverPool(serverInfoObj, poolName);

			//DB 컨넥션을 가져온다.
			connDB = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);
			
			//connDB.setAutoCommit(false);
			
			sessDB = sqlSessionFactory.openSession(connDB);

			if(objTable_Info.size() > 0) {
				
				HashMap hp = new HashMap();
				String strDatabaseName = objTable_Info.get(0).get(ProtocolID.DATABASE_NAME).toString();
				String strTableName = objTable_Info.get(0).get(ProtocolID.TABLE_NAME).toString();
				String strTableSchema = objTable_Info.get(0).get(ProtocolID.TABLE_SCHEMA).toString();
				
				hp.put(ProtocolID.DATABASE_NAME, strDatabaseName);
				hp.put(ProtocolID.TABLE_NAME, strTableName);
				hp.put(ProtocolID.TABLE_SCHEMA, strTableSchema);
				
				selectDataList = sessDB.selectList("app.selectTblMapps", hp);
				
				hp = null;
						
			}
			
			sessDB.close();
			connDB.close();

		} catch(Exception e) {
			errLogger.error("selectTblMapps {} ", e.toString());
			throw e;
		} finally {

			if(sessDB !=null) sessDB.close();
			if(connDB !=null) connDB.close();
		}	
		
		return selectDataList;
		
	}
	
	
	private void insertKafkaConConfig(JSONObject jObj) throws Exception {
		
		JSONObject serverInfoObj = (JSONObject) jObj.get(ProtocolID.SERVER_INFO);
		JSONObject objTable_Info = (JSONObject) jObj.get(ProtocolID.TABLE_INFO);
		

		SqlSessionFactory sqlSessionFactory = null;
		
		sqlSessionFactory = SqlSessionManager.getInstance();
		
		String poolName = "" + serverInfoObj.get(ProtocolID.SERVER_IP) + "_" + serverInfoObj.get(ProtocolID.DATABASE_NAME)+ "_" + serverInfoObj.get(ProtocolID.SERVER_PORT);
		//+ "_" + (String)serverInfoObj.get(ProtocolID.USER_ID)
		//+ "_" + (String)serverInfoObj.get(ProtocolID.USER_PWD);
		
		Connection connDB = null;
		SqlSession sessDB = null;
		
		try {
			
			SocketExt.setupDriverPool(serverInfoObj, poolName);

			//DB 컨넥션을 가져온다.
			connDB = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);
			
			//connDB.setAutoCommit(false);
			
			sessDB = sqlSessionFactory.openSession(connDB);

			if(objTable_Info.size() > 0) {

					String strDatabaseName = (String) objTable_Info.get(ProtocolID.DATABASE_NAME);
					String strConnectName = (String) objTable_Info.get(ProtocolID.CONNECT_NAME);
					String strContents = (String) objTable_Info.get(ProtocolID.CONTENTS);
					String strRemark = (String) objTable_Info.get(ProtocolID.REMARK);
					String strUserID = (String) serverInfoObj.get(ProtocolID.USER_ID);

					JSONParser parser = new JSONParser();
					Object obj = parser.parse( strContents );
					JSONObject jsonContents = (JSONObject) obj;
					
					//HashMap hp = (HashMap) objTable_Info.get(i);
					HashMap hp = new HashMap();
					hp.put(ProtocolID.DATABASE_NAME, strDatabaseName);
					hp.put(ProtocolID.CONNECT_NAME, strConnectName);
					hp.put(ProtocolID.CONTENTS, strContents);
					hp.put(ProtocolID.REMARK, strRemark);
					hp.put(ProtocolID.USER_ID, strUserID);
					
					sessDB.insert("app.insertKafkaConConfig", hp);
					
					hp = null;
			}
			
			sessDB.close();
			connDB.close();

		} catch(Exception e) {
			errLogger.error("insertKafkaConConfig {} ", e.toString());
			throw e;
		} finally {

			if(sessDB !=null) sessDB.close();
			if(connDB !=null) connDB.close();
		}	
		
	}
	
	private void deleteKafkaConConfig(JSONObject jObj) throws Exception {
		
		JSONObject serverInfoObj = (JSONObject) jObj.get(ProtocolID.SERVER_INFO);
		JSONObject objTable_Info = (JSONObject) jObj.get(ProtocolID.TABLE_INFO);
		

		SqlSessionFactory sqlSessionFactory = null;
		
		sqlSessionFactory = SqlSessionManager.getInstance();
		
		String poolName = "" + serverInfoObj.get(ProtocolID.SERVER_IP) + "_" + serverInfoObj.get(ProtocolID.DATABASE_NAME)+ "_" + serverInfoObj.get(ProtocolID.SERVER_PORT);
		//+ "_" + (String)serverInfoObj.get(ProtocolID.USER_ID)
		//+ "_" + (String)serverInfoObj.get(ProtocolID.USER_PWD);
		
		Connection connDB = null;
		SqlSession sessDB = null;
		
		try {
			
			SocketExt.setupDriverPool(serverInfoObj, poolName);

			//DB 컨넥션을 가져온다.
			connDB = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);
			
			//connDB.setAutoCommit(false);
			
			sessDB = sqlSessionFactory.openSession(connDB);

			if(objTable_Info.size() > 0) {

				String strDatabaseName = (String) objTable_Info.get(ProtocolID.DATABASE_NAME);
				String strConnectName = (String) objTable_Info.get(ProtocolID.CONNECT_NAME);

				HashMap hp = new HashMap();
				hp.put(ProtocolID.DATABASE_NAME, strDatabaseName);
				hp.put(ProtocolID.CONNECT_NAME, strConnectName);

				sessDB.delete("app.deleteKafkaConConfig", hp);
				
				hp = null;
			}
			
			sessDB.close();
			connDB.close();

		} catch(Exception e) {
			errLogger.error("createAuthentication {} ", e.toString());
			throw e;
		} finally {

			if(sessDB !=null) sessDB.close();
			if(connDB !=null) connDB.close();
		}	
		
	}
	
	
}


