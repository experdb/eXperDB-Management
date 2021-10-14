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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.k4m.dx.tcontrol.db.SqlSessionManager;
import com.k4m.dx.tcontrol.db.repository.vo.ServerInfoVO;
import com.k4m.dx.tcontrol.db.repository.vo.TablespaceVO;
import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;
import com.k4m.dx.tcontrol.util.CommonUtil;
import com.k4m.dx.tcontrol.util.FileUtil;
import com.k4m.dx.tcontrol.util.NetworkUtil;

/**
 * 26. database server 정보 조회
 *
 * @author 박태혁
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.05.22   박태혁 최초 생성
 *      </pre>
 */

public class DxT022 extends SocketCtl {

	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");

	public DxT022(Socket socket, BufferedInputStream is, BufferedOutputStream os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public void execute(String strDxExCode, JSONObject jObj) throws Exception {

		JSONObject serverInfoObj = (JSONObject) jObj.get(ProtocolID.SERVER_INFO);

		socketLogger.info("execute : " + strDxExCode);
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";

		JSONObject outputObj = new JSONObject();
		JSONArray arrOut = new JSONArray();

		try {
			String strFileName = "pg_rman.ini";
			String strBackupPath = (String) jObj.get(ProtocolID.CMD_BACKUP_PATH);
			String strCmd = "pg_rman init -B " + strBackupPath + " -D $PGDATA";

			boolean blnIsDirectory = FileUtil.isDirectory(strBackupPath);
			if (!blnIsDirectory) {
				throw new Exception("디렉터리가 존재하지 않습니다.");
			}

			boolean blnIsFile = FileUtil.isFile(strBackupPath + System.getProperty("file.separator") + strFileName);

			if (!blnIsFile) {
				CommonUtil util = new CommonUtil();

				util.getPidExec(strCmd);

				util = null;
			}

			outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
			outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, strErrMsg);

			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);

		} catch (Exception e) {
			errLogger.error("DxT022 {} ", e.toString());

			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT022);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT022);
			outputObj.put(ProtocolID.ERR_MSG, "DxT022 Error [" + e.toString() + "]");

			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);

		} finally {
			outputObj = null;
			sendBuff = null;
		}
	}

	private ArrayList selectTablespaceInfo(JSONObject serverInfoObj) throws Exception {


		SqlSessionFactory sqlSessionFactory = SqlSessionManager.getInstance();

		String poolName = "" + serverInfoObj.get(ProtocolID.SERVER_IP) + "_" + serverInfoObj.get(ProtocolID.DATABASE_NAME) + "_" + serverInfoObj.get(ProtocolID.SERVER_PORT);
		// + "_" + (String)serverInfoObj.get(ProtocolID.USER_ID)
		// + "_" + (String)serverInfoObj.get(ProtocolID.USER_PWD);

		Connection connDB = null;
		SqlSession sessDB = null;

		ArrayList list = new ArrayList();

		try {

			SocketExt.setupDriverPool(serverInfoObj, poolName);

			// DB 컨넥션을 가져온다.
			connDB = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);

			sessDB = sqlSessionFactory.openSession(connDB);

			list = (ArrayList) sessDB.selectList("system.selectTablespaceInfo");
			
			sessDB.close();
			connDB.close();

		} catch (Exception e) {
			errLogger.error("selectDatabaseInfo {} ", e.toString());
			throw e;
		} finally {

			if(sessDB !=null) sessDB.close();
			if(connDB !=null) connDB.close();
		}

		return list;

	}

	private List<ServerInfoVO> selectPostgreSqlServerInfo(JSONObject serverInfoObj) throws Exception {

		SqlSessionFactory sqlSessionFactory = null;

		sqlSessionFactory = SqlSessionManager.getInstance();

		String poolName = "" + serverInfoObj.get(ProtocolID.SERVER_IP) + "_" + serverInfoObj.get(ProtocolID.DATABASE_NAME) + "_" + serverInfoObj.get(ProtocolID.SERVER_PORT);
				//+ (String) serverInfoObj.get(ProtocolID.USER_ID) + "_"
				//+ (String) serverInfoObj.get(ProtocolID.USER_PWD);

		Connection connDB = null;
		SqlSession sessDB = null;

		List<ServerInfoVO> list = null;

		try {

			SocketExt.setupDriverPool(serverInfoObj, poolName);

			// DB 컨넥션을 가져온다.
			connDB = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);

			sessDB = sqlSessionFactory.openSession(connDB);

			list = sessDB.selectList("system.selectPostgreSqlServerInfo");
			
			sessDB.close();
			connDB.close();

		} catch (Exception e) {
			errLogger.error("selectDatabaseInfo {} ", e.toString());
			throw e;
		} finally {

			if(sessDB !=null) sessDB.close();
			if(connDB !=null) connDB.close();
		}

		return list;

	}

	private void setShowData(JSONObject serverInfoObj, HashMap resultHP) throws Exception {

		SqlSessionFactory sqlSessionFactory = null;

		sqlSessionFactory = SqlSessionManager.getInstance();

		String poolName = "" + serverInfoObj.get(ProtocolID.SERVER_IP) + "_" + serverInfoObj.get(ProtocolID.DATABASE_NAME) + "_" + serverInfoObj.get(ProtocolID.SERVER_PORT);
				//+ (String) serverInfoObj.get(ProtocolID.USER_ID) + "_"
				//+ (String) serverInfoObj.get(ProtocolID.USER_PWD);

		Connection connDB = null;
		SqlSession sessDB = null;

		String strResult = "";

		try {

			SocketExt.setupDriverPool(serverInfoObj, poolName);

			// DB 컨넥션을 가져온다.
			connDB = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);
			
			sessDB = sqlSessionFactory.openSession(connDB);

			String listen_addresses = sessDB.selectOne("system.selectListen_addresses");
			resultHP.put(ProtocolID.CMD_LISTEN_ADDRESSES, listen_addresses);
			String port = sessDB.selectOne("system.selectPort");
			resultHP.put(ProtocolID.CMD_PORT, port);
			String max_connections = sessDB.selectOne("system.selectMax_connections");
			resultHP.put(ProtocolID.CMD_MAX_CONNECTIONS, max_connections);
			String shared_buffers = sessDB.selectOne("system.selectShared_buffers");
			resultHP.put(ProtocolID.CMD_SHARED_BUFFERS, shared_buffers);
			String effective_cache_size = sessDB.selectOne("system.selectEffective_cache_size");
			resultHP.put(ProtocolID.CMD_EFFECTIVE_CACHE_SIZE, effective_cache_size);
			String work_mem = sessDB.selectOne("system.selectWork_mem");
			resultHP.put(ProtocolID.CMD_WORK_MEM, work_mem);
			String maintenance_work_mem = sessDB.selectOne("system.selectMaintenance_work_mem");
			resultHP.put(ProtocolID.CMD_MAINTENANCE_WORK_MEM, maintenance_work_mem);
			String min_wal_size = sessDB.selectOne("system.selectMin_wal_size");
			resultHP.put(ProtocolID.CMD_MIN_WAL_SIZE, min_wal_size);
			String max_wal_size = sessDB.selectOne("system.selectMax_wal_size");
			resultHP.put(ProtocolID.CMD_MAX_WAL_SIZE, max_wal_size);
			String wal_level = sessDB.selectOne("system.selectWal_level");
			resultHP.put(ProtocolID.CMD_WAL_LEVEL, wal_level);
			String wal_buffers = sessDB.selectOne("system.selectWal_buffers");
			resultHP.put(ProtocolID.CMD_WAL_BUFFERS, wal_buffers);
			
			Double server_version = Double.parseDouble((String) sessDB.selectOne("system.selectServer_version"));
			String wal_keep_segments;
			if(server_version<13.0){
				wal_keep_segments = sessDB.selectOne("system.selectWal_keep_segments");				
			}else{
				wal_keep_segments = sessDB.selectOne("system.selectWal_keep_size");								
			}
			resultHP.put(ProtocolID.CMD_WAL_KEEP_SEGMENTS, wal_keep_segments);
			
			String archive_mode = sessDB.selectOne("system.selectArchive_mode");
			resultHP.put(ProtocolID.CMD_ARCHIVE_MODE, archive_mode);
			String archive_command = sessDB.selectOne("system.selectArchive_command");
			resultHP.put(ProtocolID.CMD_ARCHIVE_COMMAND, archive_command);
			String config_file = sessDB.selectOne("system.selectConfig_file");
			resultHP.put(ProtocolID.CMD_CONFIG_FILE, config_file);
			String data_directory = sessDB.selectOne("system.selectData_directory");
			resultHP.put(ProtocolID.CMD_DATA_DIRECTORY, data_directory);
			String hot_standby = sessDB.selectOne("system.selectHot_standby");
			resultHP.put(ProtocolID.CMD_HOT_STANDBY, hot_standby);
			String timezone = sessDB.selectOne("system.selectTimezone");
			resultHP.put(ProtocolID.CMD_TIMEZONE, timezone);
			String shared_preload_libraries = sessDB.selectOne("system.selectShared_preload_libraries");
			resultHP.put(ProtocolID.CMD_SHARED_PRELOAD_LIBRARIES, shared_preload_libraries);

			ArrayList list = (ArrayList) sessDB.selectList("system.selectTablespaceInfo");
			resultHP.put(ProtocolID.CMD_TABLESPACE_INFO, list);
			
			sessDB.close();
			connDB.close();

		} catch (Exception e) {
			errLogger.error("selectDatabaseInfo {} ", e.toString());
			throw e;
		} finally {

			if(sessDB !=null) sessDB.close();
			if(connDB !=null) connDB.close();
		}

	}

}
