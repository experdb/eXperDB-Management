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
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.dbcp.PoolingDriver;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.k4m.dx.tcontrol.db.DBCPPoolManager;
import com.k4m.dx.tcontrol.db.SqlSessionManager;
import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;
import com.k4m.dx.tcontrol.util.PgHbaConfigLine;

/**
 * 백업 실행
 *
 * @author 박태혁
 * @see <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.05.22   박태혁 최초 생성
 *  조회 : SELECT * from pg_catalog.pg_read_file('pg_hba.conf')
 *  1. Extension 설치 여부
		SELECT 1 AS INS FROM PG_AVAILABLE_EXTENSIONS WHERE NAME='adminpack';
	2. Extension 생성 여부
		SELECT 1 from pg_extension WHERE extname = 'adminpack'
	3. 결과가 0일 경우 Extension 생성
      CREATE EXTENSION adminpack

 * </pre>
 */

public class DxT006 extends SocketCtl{
	
	private static Logger errLogger = LoggerFactory.getLogger("errorToFile");
	
	public DxT006(Socket socket, BufferedInputStream is, BufferedOutputStream	os) {
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
				
				createAuthentication(jObj);
				
				outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
				outputObj.put(ProtocolID.RESULT_CODE, "0");
				outputObj.put(ProtocolID.ERR_CODE, "");
				outputObj.put(ProtocolID.ERR_MSG, "");
				outputObj.put(ProtocolID.RESULT_DATA, "success");
			
			//조회
			} else if(strCommandCode.equals(ProtocolID.COMMAND_CODE_R)) {
				outputArray = selectAuthentication(objSERVER_INFO);
				
				outputObj = DxT006ResultJSON(outputArray, strDxExCode, strSuccessCode, strErrCode, strErrMsg);
			
			//수정
			} else if(strCommandCode.equals(ProtocolID.COMMAND_CODE_U)) {
				updateAuthentication(jObj);
				
				outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
				outputObj.put(ProtocolID.RESULT_CODE, "0");
				outputObj.put(ProtocolID.ERR_CODE, "");
				outputObj.put(ProtocolID.ERR_MSG, "");
				outputObj.put(ProtocolID.RESULT_DATA, "success");
			//삭제
			} else if(strCommandCode.equals(ProtocolID.COMMAND_CODE_D)) {
				deleteAuthentication(jObj);
				
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
	
	/**
	 * 접근제어 조회
	 * @return
	 */
	public List<LinkedHashMap<String, String>> selectAuthentication(JSONObject dbInfoObj) throws Exception{
		List<LinkedHashMap<String, String>> arrResult = new ArrayList<LinkedHashMap<String, String>>();
		
		SqlSessionFactory sqlSessionFactory = null;
		
		sqlSessionFactory = SqlSessionManager.getInstance();
		
		String poolName = "" + dbInfoObj.get(ProtocolID.SERVER_NAME) + "_" + dbInfoObj.get(ProtocolID.DATABASE_NAME);
		
		Connection connDB = null;
		SqlSession sessDB = null;
		List<Object> selectList = new ArrayList<Object>();
		
		try {
			
			SocketExt.setupDriverPool(dbInfoObj, poolName);

			//DB 컨넥션을 가져온다.
			connDB = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);
			connDB.setAutoCommit(false);
			
			sessDB = sqlSessionFactory.openSession(connDB);

			selectList = sessDB.selectList("app.selectAuthentication");
			
			String[] arrData = null;
			
			for(int i=0; i<selectList.size(); i++) {
				arrData = selectList.get(0).toString().split("\n");
			}
			
			int j=0;
			for(int i=0; i<arrData.length; i++) {
				
			    PgHbaConfigLine config = new PgHbaConfigLine(arrData[i]);
			    LinkedHashMap<String, String> aclLine = new LinkedHashMap<String, String>();
				if(config.isValid() || (!config.isValid() && !config.isComment()) && !(config.getText()).isEmpty()){
					config.setItemNumber(i);
					aclLine.put("Seq", String.valueOf(j));
					aclLine.put("Set", config.isComment() ? "0" : "1");
					aclLine.put("Type", config.getConnectType());
					aclLine.put("Database", config.getDatabase());
					aclLine.put("User", config.getUser());
					aclLine.put("Ip", config.getIpaddress());
					aclLine.put("Method", config.getMethod());
					aclLine.put("Option", config.getOption());
					aclLine.put("Changed", "");
					arrResult.add(aclLine);
					
					j++;
				}

			}
			
		} catch (Exception e) {
			errLogger.error("selectAuthentication {} ", e.toString());
			throw e;
		} finally {
			sessDB.close();
			connDB.close();
		}	
		
		return arrResult;
	}
	
	private List<Map> getAuthList(String[] arrAuthData) throws Exception{
		List<Map> array = new ArrayList<Map>();

		for(int i = 0; i < arrAuthData.length ; i++){
		    PgHbaConfigLine config = new PgHbaConfigLine(arrAuthData[i]);
			Map<String, String> aclLine = new LinkedHashMap<String, String>();
			if(config.isValid() || (!config.isValid() && !config.isComment()) && !(config.getText()).isEmpty()){
				config.setItemNumber(i);
				aclLine.put("Seq", String.valueOf(i++));
				aclLine.put("Set", config.isComment() ? "" : "1");
				aclLine.put("Type", config.getConnectType());
				aclLine.put("Database", config.getDatabase());
				aclLine.put("User", config.getUser());
				aclLine.put("Ip", config.getIpaddress());
				aclLine.put("Method", config.getMethod());
				aclLine.put("Option", config.getOption());
				aclLine.put("Changed", "");
				array.add(aclLine);
			}
		}
		
		return array;
	}
	
	/**
	 * 접근제어 등록
	 * @param jObj
	 * @throws Exception
	 */
	private void createAuthentication(JSONObject jObj) throws Exception {
		
		JSONObject serverInfoObj = (JSONObject) jObj.get(ProtocolID.SERVER_INFO);
		JSONObject acInfoObj = (JSONObject) jObj.get(ProtocolID.ACCESS_CONTROL_INFO);
		
		PgHbaConfigLine config =  new PgHbaConfigLine(null);	
		
		config.setChanged(true);
		if((acInfoObj.get("Set")).equals("1")) {
			config.setComment(false);
		} else {
			config.setComment(true);
		}
		config.setConnectType((String)acInfoObj.get("Type"));
		config.setDatabase((String)acInfoObj.get("Database"));
		config.setUser((String)acInfoObj.get("User"));
		config.setIpaddress((String)acInfoObj.get("Ip"));
		config.setMethod((String)acInfoObj.get("Method"));
		config.setOption((String)acInfoObj.get("Option"));
		
		SqlSessionFactory sqlSessionFactory = null;
		
		sqlSessionFactory = SqlSessionManager.getInstance();
		
		String poolName = "" + serverInfoObj.get(ProtocolID.SERVER_NAME) + "_" + serverInfoObj.get(ProtocolID.DATABASE_NAME);
		
		Connection connDB = null;
		SqlSession sessDB = null;
		List<Object> selectList = new ArrayList<Object>();
		
		try {
			
			SocketExt.setupDriverPool(serverInfoObj, poolName);

			//DB 컨넥션을 가져온다.
			connDB = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);
			
			//connDB.setAutoCommit(false);
			
			sessDB = sqlSessionFactory.openSession(connDB);

			selectList = sessDB.selectList("app.selectAuthentication");
			
			String[] arrData = null;
			HashMap<Integer, PgHbaConfigLine> hba = new LinkedHashMap<Integer, PgHbaConfigLine>();
			
			String buffer = "";
			
			if(selectList.size() > 0) {
				HashMap hp = new HashMap();
				hp = (HashMap) selectList.get(0);
				String strPgHbaData = (String) hp.get("pg_read_file");

				arrData = strPgHbaData.split("\n");
				
				for(int i=0; i<arrData.length; i++) {
					buffer += arrData[i].toString() + "\n";
				}
				
				 buffer += config.getText() + "\n";
			}
			
			HashMap hp = new HashMap();
			hp.put("hbadata", buffer);
			
			sessDB.selectList("app.selectPgConfUnlink");
			sessDB.selectList("app.selectPgConfWrite", hp);
			sessDB.selectList("app.selectPgConfRename");
			sessDB.selectList("app.selectPgConfReload");
			
			//sessDB.commit();
			//connDB.commit();
			
		} catch(Exception e) {
			errLogger.error("createAuthentication {} ", e.toString());
			throw e;
		} finally {
			sessDB.close();
			connDB.close();
		}	
		
	}
	
	/**
	 * 접근제어 수정
	 * @param jObj
	 * @throws Exception
	 */
	private void updateAuthentication(JSONObject jObj) throws Exception {
		
		JSONObject serverInfoObj = (JSONObject) jObj.get(ProtocolID.SERVER_INFO);
		JSONObject acInfoObj = (JSONObject) jObj.get(ProtocolID.ACCESS_CONTROL_INFO);
		
		PgHbaConfigLine config =  new PgHbaConfigLine(null);	
		
		config.setChanged(true);
		if((acInfoObj.get("Set")).equals("1")) {
			config.setComment(false);
		} else {
			config.setComment(true);
		}
		config.setConnectType((String)acInfoObj.get("Type"));
		config.setDatabase((String)acInfoObj.get("Database"));
		config.setUser((String)acInfoObj.get("User"));
		config.setIpaddress((String)acInfoObj.get("Ip"));
		config.setMethod((String)acInfoObj.get("Method"));
		config.setOption((String)acInfoObj.get("Option"));
		
		String strSeq = (String) acInfoObj.get("Seq");
		
		int intUpdateSeq = Integer.parseInt(strSeq);
		
		SqlSessionFactory sqlSessionFactory = null;
		
		sqlSessionFactory = SqlSessionManager.getInstance();


		String poolName = "" + serverInfoObj.get(ProtocolID.SERVER_NAME) + "_" + serverInfoObj.get(ProtocolID.DATABASE_NAME);
		
		Connection connDB = null;
		SqlSession sessDB = null;
		List<Object> selectList = new ArrayList<Object>();
		
		try {
			
			SocketExt.setupDriverPool(serverInfoObj, poolName);

			//DB 컨넥션을 가져온다.
			connDB = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);
			
			//connDB.setAutoCommit(false);
			
			sessDB = sqlSessionFactory.openSession(connDB);

			selectList = sessDB.selectList("app.selectAuthentication");
			
			String[] arrData = null;
			HashMap<Integer, PgHbaConfigLine> hba = new LinkedHashMap<Integer, PgHbaConfigLine>();
			
			String buffer = "";
			
			if(selectList.size() > 0) {
				HashMap hp = new HashMap();
				hp = (HashMap) selectList.get(0);
				String strPgHbaData = (String) hp.get("pg_read_file");
				
				//System.out.println(strPgHbaData);

				arrData = strPgHbaData.split("\n");
				
				int intSeq = 0;
				
				for(int i=0; i<arrData.length; i++) {

					PgHbaConfigLine conf = new PgHbaConfigLine(arrData[i].toString());
					
					if(intSeq == intUpdateSeq) {
						buffer += config.getText() + "\n";
					} else {
						buffer += arrData[i].toString() + "\n";
					}
					
					if(conf.isValid() || (!conf.isValid() && !conf.isComment()) && !(conf.getText()).isEmpty()){
						System.out.println(intSeq + " ==> " + arrData[i].toString());
						intSeq ++;
					}
				}
			}
			
			HashMap hp = new HashMap();
			hp.put("hbadata", buffer);
			
			sessDB.selectList("app.selectPgConfUnlink");
			sessDB.selectList("app.selectPgConfWrite", hp);
			sessDB.selectList("app.selectPgConfRename");
			sessDB.selectList("app.selectPgConfReload");
			
			//sessDB.commit();
			//connDB.commit();
			
		} catch(Exception e) {
			errLogger.error("updateAuthentication {} ", e.toString());
			throw e;
		} finally {
			sessDB.close();
			connDB.close();
		}	
		
	}
	
	/**
	 * 접근제어 삭제
	 * @param jObj
	 * @throws Exception
	 */
	private void deleteAuthentication(JSONObject jObj) throws Exception {
		
		JSONObject serverInfoObj = (JSONObject) jObj.get(ProtocolID.SERVER_INFO);
		
		ArrayList<HashMap<String, String>> arrAcSeq = (ArrayList<HashMap<String, String>>) jObj.get(ProtocolID.ARR_AC_SEQ);
		
		
		SqlSessionFactory sqlSessionFactory = null;
		
		sqlSessionFactory = SqlSessionManager.getInstance();
		
		
		String poolName = "" + serverInfoObj.get(ProtocolID.SERVER_NAME) + "_" + serverInfoObj.get(ProtocolID.DATABASE_NAME);
		
		Connection connDB = null;
		SqlSession sessDB = null;
		List<Object> selectList = new ArrayList<Object>();
		
		try {
			SocketExt.setupDriverPool(serverInfoObj, poolName);

			//DB 컨넥션을 가져온다.
			connDB = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);
			
			//connDB.setAutoCommit(false);
			
			sessDB = sqlSessionFactory.openSession(connDB);

			selectList = sessDB.selectList("app.selectAuthentication");
			
			String[] arrData = null;
			HashMap<Integer, PgHbaConfigLine> hba = new LinkedHashMap<Integer, PgHbaConfigLine>();
			
			String buffer = "";
			
			if(selectList.size() > 0) {
				HashMap hp = new HashMap();
				hp = (HashMap) selectList.get(0);
				String strPgHbaData = (String) hp.get("pg_read_file");
				
				//System.out.println(strPgHbaData);

				arrData = strPgHbaData.split("\n");
				
				int intSeq = 0;
				
				
				for(int i=0; i<arrData.length; i++) {
					
					boolean blnAcSeqCheck = false;

					PgHbaConfigLine conf = new PgHbaConfigLine(arrData[i].toString());
					
/*					if(!blnAcSeqCheck) {
						buffer += arrData[i].toString() + "\n";
						
						System.out.println("buffer ==> " + buffer);
					}*/
					
					if(conf.isValid() || (!conf.isValid() && !conf.isComment()) && !(conf.getText()).isEmpty()){
						for(HashMap<String, String> intSeq2 : arrAcSeq) {
							String strAcSeq =  intSeq2.get(ProtocolID.AC_SEQ);
							int intAcSeq = Integer.parseInt(strAcSeq);
							if(intAcSeq == intSeq) {
								blnAcSeqCheck = true;
								break;
							}
							
						}
						
						if(!blnAcSeqCheck) {
							buffer += arrData[i].toString() + "\n";
							
							System.out.println(intSeq + " buffer ==> " + arrData[i].toString());
						}
						
						System.out.println(intSeq + " ==> " + arrData[i].toString());
						intSeq ++;
					} else {
						buffer += arrData[i].toString() + "\n";
					}
				}
			}
			
			HashMap hp = new HashMap();
			hp.put("hbadata", buffer);
			
			sessDB.selectList("app.selectPgConfUnlink");
			sessDB.selectList("app.selectPgConfWrite", hp);
			sessDB.selectList("app.selectPgConfRename");
			sessDB.selectList("app.selectPgConfReload");
			
			
		} catch(Exception e) {
			errLogger.error("deleteAuthentication {} ", e.toString());
		} finally {
			sessDB.close();
			connDB.close();
		}	
		
	}
	
}
