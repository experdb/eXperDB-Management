package com.k4m.dx.tcontrol.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.net.Socket;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.k4m.dx.tcontrol.db.SqlSessionManager;
import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;
import com.k4m.dx.tcontrol.util.DateUtil;
import com.k4m.dx.tcontrol.util.FileEntry;
import com.k4m.dx.tcontrol.util.FileListSearcher;
import com.k4m.dx.tcontrol.util.FileUtil;
import com.k4m.dx.tcontrol.util.PgHbaConfigLine;

/**
 * 22.	tbl_mapps 등록/삭제
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

public class DxT017 extends SocketCtl{
	
	private static Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private static Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	public DxT017(Socket socket, BufferedInputStream is, BufferedOutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		
		socketLogger.info("DxT017.execute : " + strDxExCode);
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";

		String strCommandCode = (String) jObj.get(ProtocolID.COMMAND_CODE);
	
		JSONObject outputObj = new JSONObject();
		List<Object> selectDataList = new ArrayList<Object>();
		try {
			
			if(strCommandCode.equals(ProtocolID.COMMAND_CODE_C)) {


				insertTblMapps(jObj);
				
				outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
				outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
				outputObj.put(ProtocolID.ERR_CODE, strErrCode);
				outputObj.put(ProtocolID.ERR_MSG, strErrMsg);

			} else if(strCommandCode.equals(ProtocolID.COMMAND_CODE_R)) {
				
				selectDataList = selectTblMapps(jObj);
				
		        outputObj = ResultJSON(selectDataList, strDxExCode, "0", "", "");
		        
		        sendBuff = outputObj.toString().getBytes();
				
			} else if(strCommandCode.equals(ProtocolID.COMMAND_CODE_U)) {
				
			} else if(strCommandCode.equals(ProtocolID.COMMAND_CODE_D)) {
				
				deleteTblMapps(jObj);
				
				outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
				outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
				outputObj.put(ProtocolID.ERR_CODE, strErrCode);
				outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
				
			}



			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
			
		} catch (Exception e) {
			errLogger.error("DxT017 {} ", e.toString());
			
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT017);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT017);
			outputObj.put(ProtocolID.ERR_MSG, "DxT017 Error [" + e.toString() + "]");
			outputObj.put(ProtocolID.RESULT_DATA, "failed");
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);

		} finally {

		}	    
	}
	
	private List<Object> selectTblMapps(JSONObject jObj) throws Exception {
		
		List<Object> selectDataList = new ArrayList<Object>();
		
		JSONObject serverInfoObj = (JSONObject) jObj.get(ProtocolID.SERVER_INFO);
		List<HashMap<String,String>> objTable_Info = (List<HashMap<String,String>>) jObj.get(ProtocolID.TABLE_INFO);
		

		SqlSessionFactory sqlSessionFactory = null;
		
		sqlSessionFactory = SqlSessionManager.getInstance();
		
		String poolName = "" + serverInfoObj.get(ProtocolID.SERVER_IP) + "_" + serverInfoObj.get(ProtocolID.DATABASE_NAME) + "_" + serverInfoObj.get(ProtocolID.SERVER_PORT);
		
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
						
			}

		} catch(Exception e) {
			errLogger.error("selectTblMapps {} ", e.toString());
			throw e;
		} finally {
			sessDB.close();
			connDB.close();
		}	
		
		return selectDataList;
		
	}
	
	
	private void insertTblMapps(JSONObject jObj) throws Exception {
		
		JSONObject serverInfoObj = (JSONObject) jObj.get(ProtocolID.SERVER_INFO);
		List<HashMap<String,String>> objTable_Info = (List<HashMap<String,String>>) jObj.get(ProtocolID.TABLE_INFO);
		

		SqlSessionFactory sqlSessionFactory = null;
		
		sqlSessionFactory = SqlSessionManager.getInstance();
		
		String poolName = "" + serverInfoObj.get(ProtocolID.SERVER_IP) + "_" + serverInfoObj.get(ProtocolID.DATABASE_NAME)+ "_" + serverInfoObj.get(ProtocolID.SERVER_PORT);
		
		Connection connDB = null;
		SqlSession sessDB = null;
		List<Object> selectList = new ArrayList<Object>();
		
		try {
			
			SocketExt.setupDriverPool(serverInfoObj, poolName);

			//DB 컨넥션을 가져온다.
			connDB = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);
			
			//connDB.setAutoCommit(false);
			
			sessDB = sqlSessionFactory.openSession(connDB);

			if(objTable_Info.size() > 0) {
				for(int i=0; i<objTable_Info.size(); i++) {
					String strTableName = objTable_Info.get(i).get(ProtocolID.TABLE_NAME).toString();
					String strTableSchema = objTable_Info.get(i).get(ProtocolID.TABLE_SCHEMA).toString();
					String strTopicName = objTable_Info.get(i).get(ProtocolID.TOPIC_NAME).toString();
					String strRemark = objTable_Info.get(i).get(ProtocolID.REMARK).toString();
					
					//HashMap hp = (HashMap) objTable_Info.get(i);
					HashMap hp = new HashMap();
					hp.put(ProtocolID.TABLE_NAME, strTableName);
					hp.put(ProtocolID.TABLE_SCHEMA, strTableSchema);
					hp.put(ProtocolID.TOPIC_NAME, strTopicName);
					hp.put(ProtocolID.REMARK, strRemark);
					hp.put("REGCLASS", strTableSchema + "." + strTableName);
					
					sessDB.insert("app.insertTblMapps", hp);
					sessDB.insert("app.insertColMapps", hp);
				}

			}

		} catch(Exception e) {
			errLogger.error("insertTblMapps {} ", e.toString());
			throw e;
		} finally {
			sessDB.close();
			connDB.close();
		}	
		
	}
	
	
	
	private void deleteTblMapps(JSONObject jObj) throws Exception {
		
		JSONObject serverInfoObj = (JSONObject) jObj.get(ProtocolID.SERVER_INFO);
		List<HashMap<String,String>> objTable_Info = (List<HashMap<String,String>>) jObj.get(ProtocolID.TABLE_INFO);
		

		SqlSessionFactory sqlSessionFactory = null;
		
		sqlSessionFactory = SqlSessionManager.getInstance();
		
		String poolName = "" + serverInfoObj.get(ProtocolID.SERVER_IP) + "_" + serverInfoObj.get(ProtocolID.DATABASE_NAME)+ "_" + serverInfoObj.get(ProtocolID.SERVER_PORT);
		
		Connection connDB = null;
		SqlSession sessDB = null;
		
		try {
			
			SocketExt.setupDriverPool(serverInfoObj, poolName);

			//DB 컨넥션을 가져온다.
			connDB = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);
			
			//connDB.setAutoCommit(false);
			
			sessDB = sqlSessionFactory.openSession(connDB);

			if(objTable_Info.size() > 0) {
				for(int i=0; i<objTable_Info.size(); i++) {

					//HashMap hp = (HashMap) objTable_Info.get(i);
					
					String strDatabaseName = objTable_Info.get(i).get(ProtocolID.DATABASE_NAME).toString();
					String strTableName = objTable_Info.get(i).get(ProtocolID.TABLE_NAME).toString();
					String strTableSchema = objTable_Info.get(i).get(ProtocolID.TABLE_SCHEMA).toString();
					

					
					//HashMap hp = (HashMap) objTable_Info.get(i);
					HashMap hp = new HashMap();
					hp.put(ProtocolID.DATABASE_NAME, strDatabaseName);
					hp.put(ProtocolID.TABLE_NAME, strTableName);
					hp.put(ProtocolID.TABLE_SCHEMA, strTableSchema);
					
					
					sessDB.delete("app.deleteTblMapps", hp);
					sessDB.delete("app.deleteColMapps", hp);
				}

			}

		} catch(Exception e) {
			errLogger.error("createAuthentication {} ", e.toString());
			throw e;
		} finally {
			sessDB.close();
			connDB.close();
		}	
		
	}
	

	
	
}


