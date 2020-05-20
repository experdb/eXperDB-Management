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
import com.k4m.dx.tcontrol.db.repository.vo.PgAuditSettingVO;
import com.k4m.dx.tcontrol.db.repository.vo.PgAuditVO;
import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;

/**
 * Audit 감사 설정
 *
 * @author 박태혁
 * @see <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.05.22   박태혁 최초 생성
 *  
 *
 * </pre>
 */

public class DxT007 extends SocketCtl{
	
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	public DxT007(Socket socket, BufferedInputStream is, BufferedOutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		socketLogger.info("DxT007.execute : " + strDxExCode);
		
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
		
		JSONObject objSERVER_INFO = (JSONObject) jObj.get(ProtocolID.SERVER_INFO);
		String strCommandCode = (String) jObj.get(ProtocolID.COMMAND_CODE);
		JSONObject objSettingInfo = (JSONObject) jObj.get(ProtocolID.SETTING_INFO);

		PgAuditSettingVO outputArray = new PgAuditSettingVO();
		
		JSONObject outputObj = new JSONObject();
		
		try {
			//등록
			if(strCommandCode.equals(ProtocolID.COMMAND_CODE_C)) {
				
				createAuditLog(jObj);
				
				outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
				outputObj.put(ProtocolID.RESULT_CODE, "0");
				outputObj.put(ProtocolID.ERR_CODE, "");
				outputObj.put(ProtocolID.ERR_MSG, "");
				outputObj.put(ProtocolID.RESULT_DATA, "success");
			
			//조회
			} else if(strCommandCode.equals(ProtocolID.COMMAND_CODE_R)) {
				outputArray = selectPgAuditLogSetting(objSERVER_INFO);
				
				outputObj = DxT007ResultJSON(outputArray, strDxExCode, strSuccessCode, strErrCode, strErrMsg);
			
			}
			
			send(TotalLengthBit, outputObj.toString().getBytes());
		} catch (Exception e) {
			errLogger.error("DxT007 {} ", e.toString());
			
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT007);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT007);
			outputObj.put(ProtocolID.ERR_MSG, "DxT007 Error [" + e.toString() + "]");
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);

		} finally {

		}	    
		
		


	}
	
	
	private PgAuditSettingVO selectPgAuditLogSetting(JSONObject serverInfoObj) throws Exception{

		
		PgAuditSettingVO pgAuditSettingVO = new PgAuditSettingVO();
		
		SqlSessionFactory sqlSessionFactory = null;
		
		sqlSessionFactory = SqlSessionManager.getInstance();
		
		String poolName = "" + serverInfoObj.get(ProtocolID.SERVER_IP) + "_" + serverInfoObj.get(ProtocolID.DATABASE_NAME) + "_" + serverInfoObj.get(ProtocolID.SERVER_PORT);
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
			
			pgAuditSettingVO = sessDB.selectOne("app.selectPgAuditLogSetting");
			
			sessDB.close();
			connDB.close();
			
		} catch(Exception e) {
			errLogger.error("createAuditLog {} ", e.toString());
			throw e;
		} finally {

			if(sessDB !=null) sessDB.close();
			if(connDB !=null) connDB.close();
		}	
		
		return pgAuditSettingVO;
	}
	
	private List<PgAuditVO> selectPgAuditList(JSONObject jObj) throws Exception{
		JSONObject serverInfoObj = (JSONObject) jObj.get(ProtocolID.SERVER_INFO);
		JSONObject acInfoObj = (JSONObject) jObj.get(ProtocolID.SETTING_INFO);
		
		PgAuditVO vo = new PgAuditVO();
		vo.setObject_name((String) acInfoObj.get(ProtocolID.OBJECT_NAME));
		vo.setUser_name((String) acInfoObj.get(ProtocolID.USER_NAME));
		vo.setStart_date((String) acInfoObj.get(ProtocolID.START_DATE));
		vo.setEnd_date((String) acInfoObj.get(ProtocolID.END_DATE));

		
		SqlSessionFactory sqlSessionFactory = null;
		
		sqlSessionFactory = SqlSessionManager.getInstance();
		
		String poolName = "" + serverInfoObj.get(ProtocolID.SERVER_IP) + "_" + serverInfoObj.get(ProtocolID.DATABASE_NAME) + "_" + serverInfoObj.get(ProtocolID.SERVER_PORT);
		
		Connection connDB = null;
		SqlSession sessDB = null;
		List<Object> selectList = new ArrayList<Object>();
		
		List<PgAuditVO> list = new ArrayList<PgAuditVO>();
		
		try {
			
			SocketExt.setupDriverPool(serverInfoObj, poolName);

			//DB 컨넥션을 가져온다.
			connDB = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);
			
			//connDB.setAutoCommit(false);
			
			sessDB = sqlSessionFactory.openSession(connDB);
			
			list = sessDB.selectList("app.selectPgAuditLogList", vo);
			
			sessDB.close();
			connDB.close();
			
		} catch(Exception e) {
			errLogger.error("createAuditLog {} ", e.toString());
			throw e;
		} finally {

			if(sessDB !=null) sessDB.close();
			if(connDB !=null) connDB.close();
		}	
		
		return list;
	}
	
	/**
	 * 감사로그 등록
	 * @param jObj
	 * @throws Exception
	 */
	private void createAuditLog(JSONObject jObj) throws Exception {
		
		JSONObject serverInfoObj = (JSONObject) jObj.get(ProtocolID.SERVER_INFO);
		JSONObject acInfoObj = (JSONObject) jObj.get(ProtocolID.SETTING_INFO);
		

		
		SqlSessionFactory sqlSessionFactory = null;
		
		sqlSessionFactory = SqlSessionManager.getInstance();
		
		String poolName = "" + serverInfoObj.get(ProtocolID.SERVER_IP) + "_" + serverInfoObj.get(ProtocolID.DATABASE_NAME) + "_" + serverInfoObj.get(ProtocolID.SERVER_PORT);
		
		Connection connDB = null;
		SqlSession sessDB = null;
		List<Object> selectList = new ArrayList<Object>();
		
		try {
			
			SocketExt.setupDriverPool(serverInfoObj, poolName);

			//DB 컨넥션을 가져온다.
			connDB = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);

			sessDB = sqlSessionFactory.openSession(connDB);
			
			String strAuditUseYn = (String) acInfoObj.get(ProtocolID.AUDIT_USE_YN);
			String strAuditLog = (String) acInfoObj.get(ProtocolID.AUDIT_LOG);
			String strAuditLevel = (String) acInfoObj.get(ProtocolID.AUDIT_LEVEL);
			String strAuditCatalog = (String) acInfoObj.get(ProtocolID.AUDIT_CATALOG);
			String strAuditParameter = (String) acInfoObj.get(ProtocolID.AUDIT_PARAMETER);
			String strAuditRelation = (String) acInfoObj.get(ProtocolID.AUDIT_RELATION);
			String strAuditStatementOnce = (String) acInfoObj.get(ProtocolID.AUDIT_STATEMENT_ONCE);
			String strAuditRole = (String) acInfoObj.get(ProtocolID.AUDIT_ROLE);
			
			if(strAuditLog.equals("")) {
				//socketLogger.info("strAuditLog  ##" + strAuditLog + "$$");
				strAuditLog = "";
			}
			AuditVO vo = new AuditVO();
			vo.setAuditLog(strAuditLog);
			vo.setAuditLevel(strAuditLevel);
			vo.setAuditCatalog(strAuditCatalog);
			vo.setAuditParameter(strAuditParameter);
			vo.setAuditRelation(strAuditRelation);
			vo.setAuditStatementOnce(strAuditStatementOnce);
			vo.setAuditRole(strAuditRole);
			
			//if(strAuditUseYn.equals("N")) strAuditLog = "";

			
			//1. auditLog - read, write, function, role, ddl, misc
			sessDB.insert("app.updatePgAuditLogSetting", vo);
			
			//2. auditLevel
			sessDB.insert("app.updatePgAuditLogLevelSetting", vo);
			
			//3. auditCatalog
			sessDB.insert("app.updatePgAuditLogCatalogSetting", vo);
			
			//4. auditParameter
			sessDB.insert("app.updatePgAuditLogParameterSetting", vo);

			//5. auditRelation
			sessDB.insert("app.updatePgAuditLogRelationSetting", vo);

			//6. auditStatementOnce
			sessDB.insert("app.updatePgAuditLogStatementOnceSetting", vo);
			
			//7. auditRole
			sessDB.selectOne("app.updatePgAuditRoleSetting", vo);

			//8. conf file reloadOne
			sessDB.selectOne("app.selectPgConfReload");
			
			sessDB.close();
			connDB.close();

		} catch(Exception e) {
			errLogger.error("createAuditLog {} ", e.toString());
			throw e;
		} finally {

			if(sessDB !=null) sessDB.close();
			if(connDB !=null) connDB.close();
		}	
		
	}
	
	
}
