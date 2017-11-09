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
 * Audit 감사 Log 조회
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

public class DxT008 extends SocketCtl{
	
	private static Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private static Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	public DxT008(Socket socket, BufferedInputStream is, BufferedOutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		socketLogger.info("DxT008.execute : " + strDxExCode);
		
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
		
		JSONObject objSERVER_INFO = (JSONObject) jObj.get(ProtocolID.SERVER_INFO);
		String strCommandCode = (String) jObj.get(ProtocolID.COMMAND_CODE);
		JSONObject objSettingInfo = (JSONObject) jObj.get(ProtocolID.SETTING_INFO);

		List<PgAuditVO> outputArray = new ArrayList<PgAuditVO>();
		
		JSONObject outputObj = new JSONObject();
		
		try {

				outputArray = selectPgAuditList(objSERVER_INFO);
				
				outputObj = DxT007ResultJSON(outputArray, strDxExCode, strSuccessCode, strErrCode, strErrMsg);
			
			send(TotalLengthBit, outputObj.toString().getBytes());
		} catch (Exception e) {
			errLogger.error("DxT008 {} ", e.toString());
			
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT008);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT008);
			outputObj.put(ProtocolID.ERR_MSG, "DxT008 Error [" + e.toString() + "]");
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);

		} finally {

		}	    
		
		


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
		
		List<PgAuditVO> list = new ArrayList<PgAuditVO>();
		
		try {
			
			SocketExt.setupDriverPool(serverInfoObj, poolName);

			//DB 컨넥션을 가져온다.
			connDB = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);
			
			sessDB = sqlSessionFactory.openSession(connDB);
			
			list = sessDB.selectList("app.selectPgAuditLogList", vo);
			
		} catch(Exception e) {
			errLogger.error("createAuditLog {} ", e.toString());
			throw e;
		} finally {
			sessDB.close();
			connDB.close();
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
			
			if(strAuditUseYn.equals("N")) strAuditLog = "";
			
			//1. auditLog - read, write, function, role, ddl, misc
			HashMap<String, String> hpLog = new HashMap<String, String>();
			hpLog.put("pgauditlog", strAuditLog);
			
			sessDB.insert("app.updatePgAuditLogSetting", hpLog);
			
			//2. auditLevel
			HashMap hpAuditLevel = new HashMap();
			hpAuditLevel.put("pgauditLogLevel", strAuditLevel);
			
			sessDB.insert("app.updatePgAuditLogLevelSetting", hpAuditLevel);
			
			//3. auditCatalog
			HashMap hpAuditCatalog = new HashMap();
			hpAuditCatalog.put("pgauditLogCatalog", strAuditCatalog);
			
			sessDB.insert("app.updatePgAuditLogCatalogSetting", hpAuditCatalog);
			
			//4. auditParameter
			HashMap hpAuditParameter = new HashMap();
			hpAuditParameter.put("pgauditLogParameter", strAuditParameter);
			
			sessDB.insert("app.updatePgAuditLogParameterSetting", hpAuditParameter);

			//5. auditRelation
			HashMap hpAuditRelation = new HashMap();
			hpAuditRelation.put("pgauditLogRelation", strAuditRelation);
			
			sessDB.insert("app.updatePgAuditLogRelationSetting", hpAuditRelation);

			//6. auditStatementOnce
			HashMap hpAuditStatementOnce = new HashMap();
			hpAuditStatementOnce.put("pgauditLogStatementOnce", strAuditStatementOnce);
			
			sessDB.insert("app.updatePgAuditLogStatementOnceSetting", hpAuditStatementOnce);
			
			//7. auditRole
			HashMap hpAuditRole = new HashMap();
			hpAuditRole.put("pgauditRole", strAuditRole);
			
			sessDB.insert("app.updatePgAuditRoleSetting", hpAuditRole);

			//8. conf file reload
			sessDB.selectOne("app.selectPgConfReload");
			

		} catch(Exception e) {
			errLogger.error("createAuditLog {} ", e.toString());
			throw e;
		} finally {
			sessDB.close();
			connDB.close();
		}	
		
	}
	
	
}
