package com.k4m.dx.tcontrol.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.net.Socket;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.k4m.dx.tcontrol.DaemonStart;
import com.k4m.dx.tcontrol.db.repository.service.SystemServiceImpl;
import com.k4m.dx.tcontrol.db.repository.vo.DumpRestoreVO;
import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;
import com.k4m.dx.tcontrol.util.FileUtil;
import com.k4m.dx.tcontrol.util.RunCommandExecNoWaitDump;

/**
 * Dump Restore 실행
 *
 * @author 박태혁
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2019.01.14   박태혁 최초 생성
 *      </pre>
 *      
 */

public class DxT030 extends SocketCtl {

	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");

	private static String SUCCESS = "0"; // 성공
	private static String RUNNING = "2"; // 실행중
	private static String FAILED = "3"; // 실패


	public DxT030(Socket socket, BufferedInputStream is, BufferedOutputStream os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public DxT030() {
		// TODO Auto-generated constructor stub
	}

	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		socketLogger.info("DxT030.execute : " + strDxExCode);

		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
		
		String strRestore_sn = jObj.get(ProtocolID.RESTORE_SN).toString();
		int intRestore_sn = Integer.parseInt(strRestore_sn);
		String PGDBAK = (String) jObj.get(ProtocolID.PGDBAK);
		
		String DB_NM = (String) jObj.get(ProtocolID.DB_NM);
		
		JSONObject objSERVER_INFO = new JSONObject(); 
		objSERVER_INFO = (JSONObject) jObj.get(ProtocolID.SERVER_INFO);
		
		//String SERVER_IP = objSERVER_INFO.get(ProtocolID.SERVER_IP).toString();
		String SERVER_IP = "127.0.0.1";
		String SERVER_PORT = objSERVER_INFO.get(ProtocolID.SERVER_PORT).toString();
		String DATABASE_NAME = objSERVER_INFO.get(ProtocolID.DATABASE_NAME).toString();
		String USER_ID = objSERVER_INFO.get(ProtocolID.USER_ID).toString();
		String USER_PWD =  objSERVER_INFO.get(ProtocolID.USER_PWD).toString();
		
		String HOST = "--host=" + SERVER_IP;
		String PORT = "--port=" + SERVER_PORT;
		String USERNAME = "--username=" + USER_ID;
		//String PASSWORD = "--password=" + USER_PWD;
		String DBNAME = "--dbname=" + DB_NM;
		
		JSONObject objDumpOption = new JSONObject(); 
		objDumpOption = (JSONObject) jObj.get(ProtocolID.DUMP_OPTION);
		
		String R_FORMAT = (String) objDumpOption.get(ProtocolID.FORMAT);
		String FORMAT = "--format=" + R_FORMAT;

		String R_FILENAME = (String) objDumpOption.get(ProtocolID.FILENAME);
		String FILENAME = PGDBAK + "/" + R_FILENAME;
		
		String R_JOBS = (String) objDumpOption.get(ProtocolID.JOBS);
		String JOBS = "--jobs=" + R_JOBS;
		
		String R_ROLE = (String) objDumpOption.get(ProtocolID.ROLE);
		String ROLE = "--role=" + R_ROLE;
		
		String R_PRE_DATA = (String) objDumpOption.get(ProtocolID.PRE_DATA);
		String PRE_DATA = "--section=pre-data";
		
		String R_DATA = (String) objDumpOption.get(ProtocolID.DATA);
		String DATA = "--section=data";
		
		String R_POST_DATA = (String) objDumpOption.get(ProtocolID.POST_DATA);
		String POST_DATA = "--section=post-data";
		
		String R_DATA_ONLY = (String) objDumpOption.get(ProtocolID.DATA_ONLY);
		String DATA_ONLY = "--data-only";
		
		String R_SCHEMA_ONLY = (String) objDumpOption.get(ProtocolID.SCHEMA_ONLY);
		String SCHEMA_ONLY = "--schema-only";
						
		String R_NO_OWNER = (String) objDumpOption.get(ProtocolID.NO_OWNER);
		String NO_OWNER = "--no-owner";
		
		String R_NO_PRIVILEGES = (String) objDumpOption.get(ProtocolID.NO_PRIVILEGES);
		String NO_PRIVILEGES = "--no-privileges";
		
		String R_NO_TABLESPACES = (String) objDumpOption.get(ProtocolID.NO_TABLESPACES);
		String NO_TABLESPACES = "--no-tablespaces";
				
		String R_CREATE = (String) objDumpOption.get(ProtocolID.CREATE);
		String CREATE = "--create";
		
		String R_CLEAN = (String) objDumpOption.get(ProtocolID.CLEAN);
		String CLEAN = "--clean";
		
		String R_SINGLE_TRANSACTION = (String) objDumpOption.get(ProtocolID.SINGLE_TRANSACTION);
		String SINGLE_TRANSACTION = "--single-transaction";
		
		String R_DISABLE_TRIGGERS = (String) objDumpOption.get(ProtocolID.DISABLE_TRIGGERS);
		String DISABLE_TRIGGERS = "--disable-triggers";
		
		String R_NO_DATA_FOR_FAILED_TABLES = (String) objDumpOption.get(ProtocolID.NO_DATA_FOR_FAILED_TABLES);
		String NO_DATA_FOR_FAILED_TABLES = "--no-data-for-failed-tables";
		
		String R_VERBOSE = (String) objDumpOption.get(ProtocolID.VERBOSE);
		String VERBOSE = "--verbose";
		
		String R_USE_SET_SESSON_AUTH = (String) objDumpOption.get(ProtocolID.USE_SET_SESSON_AUTH);
		String USE_SET_SESSON_AUTH = "--use-set-session-authorization";
		
		String R_EXIT_ON_ERROR = (String) objDumpOption.get(ProtocolID.EXIT_ON_ERROR);
		String EXIT_ON_ERROR = "--exit-on-error";
		
		//추가 2020/08/07
		String R_BLOBS_ONLY = (String) objDumpOption.get(ProtocolID.BLOBS_ONLY_YN);
		String BLOBS_ONLY = "--blobs";
		
		String R_NO_UNLOGGED_TABLE_DATA = (String) objDumpOption.get(ProtocolID.NO_UNLOGGED_TABLE_DATA_YN);
		String NO_UNLOGGED_TABLE_DATA = "--no-unlogged-table-data";
		
		String R_USE_COLUMN_INSERTS = (String) objDumpOption.get(ProtocolID.USE_COLUMN_INSERTS_YN);
		String USE_COLUMN_INSERTS = "--column-insert";
		
		String R_USE_COLUMN_COMMANDS = (String) objDumpOption.get(ProtocolID.USE_COLUMN_COMMANDS_YN);
		String USE_COLUMN_COMMANDS = "--attribute-inserts";
		
		String R_OIDS = (String) objDumpOption.get(ProtocolID.OIDS_YN);
		String OIDS = "--oids";
		
		String R_IDENTIFIER_QUOTES_APPLY = (String) objDumpOption.get(ProtocolID.IDENTIFIER_QUOTES_APPLY_YN);
		String IDENTIFIER_QUOTES_APPLY = "--quote-all-identifiers";
		
		String R_OBJ_CMD = (String) objDumpOption.get(ProtocolID.OBJ_CMD);

		String SPACE = " ";

		String logDir = "../logs/pg_resLog/" ;
		String strLogFileName = "restore_dump_" + strRestore_sn + ".log";
		
		socketLogger.info("strRestore_sn : " + strRestore_sn);
		
		FileUtil.createFileDir(logDir);
		
		StringBuffer sbRestoreCmd = new StringBuffer();
		sbRestoreCmd.append("pg_restore ")
		                .append(SPACE).append(HOST)
		                .append(SPACE).append(PORT)
		                .append(SPACE).append(USERNAME)
		                .append(SPACE).append(DBNAME)
		                ;
        if(!R_FORMAT.equals("")) sbRestoreCmd.append(SPACE).append(FORMAT);
        if(!R_JOBS.equals("")) sbRestoreCmd.append(SPACE).append(JOBS);
        if(!R_ROLE.equals("")) sbRestoreCmd.append(SPACE).append(ROLE);
        
        if(R_PRE_DATA.equals("Y")) sbRestoreCmd.append(SPACE).append(PRE_DATA);
        if(R_DATA.equals("Y")) sbRestoreCmd.append(SPACE).append(DATA);
        if(R_POST_DATA.equals("Y")) sbRestoreCmd.append(SPACE).append(POST_DATA);
        if(R_DATA_ONLY.equals("Y")) sbRestoreCmd.append(SPACE).append(DATA_ONLY);
        if(R_SCHEMA_ONLY.equals("Y")) sbRestoreCmd.append(SPACE).append(SCHEMA_ONLY);
        if(R_NO_OWNER.equals("Y")) sbRestoreCmd.append(SPACE).append(NO_OWNER);
        if(R_NO_PRIVILEGES.equals("Y")) sbRestoreCmd.append(SPACE).append(NO_PRIVILEGES);
        if(R_NO_TABLESPACES.equals("Y")) sbRestoreCmd.append(SPACE).append(NO_TABLESPACES);
        if(R_CREATE.equals("Y")) sbRestoreCmd.append(SPACE).append(CREATE);
        if(R_CLEAN.equals("Y")) sbRestoreCmd.append(SPACE).append(CLEAN);
        if(R_SINGLE_TRANSACTION.equals("Y")) sbRestoreCmd.append(SPACE).append(SINGLE_TRANSACTION);
        if(R_DISABLE_TRIGGERS.equals("Y")) sbRestoreCmd.append(SPACE).append(DISABLE_TRIGGERS);
        if(R_NO_DATA_FOR_FAILED_TABLES.equals("Y")) sbRestoreCmd.append(SPACE).append(NO_DATA_FOR_FAILED_TABLES);
        //if(R_VERBOSE.equals("Y")) sbRestoreCmd.append(SPACE).append(VERBOSE);
        sbRestoreCmd.append(SPACE).append(VERBOSE);
        if(R_USE_SET_SESSON_AUTH.equals("Y")) sbRestoreCmd.append(SPACE).append(USE_SET_SESSON_AUTH);
        if(R_EXIT_ON_ERROR.equals("Y")) sbRestoreCmd.append(SPACE).append(EXIT_ON_ERROR);
        
        //추가 2020.08.07
        if(R_BLOBS_ONLY.equals("Y")) sbRestoreCmd.append(SPACE).append(BLOBS_ONLY);
        if(R_NO_UNLOGGED_TABLE_DATA.equals("Y")) sbRestoreCmd.append(SPACE).append(NO_UNLOGGED_TABLE_DATA);
        if(R_USE_COLUMN_INSERTS.equals("Y")) sbRestoreCmd.append(SPACE).append(USE_COLUMN_INSERTS);
        if(R_USE_COLUMN_COMMANDS.equals("Y")) sbRestoreCmd.append(SPACE).append(USE_COLUMN_COMMANDS);
        if(R_OIDS.equals("Y")) sbRestoreCmd.append(SPACE).append(OIDS);
        if(R_IDENTIFIER_QUOTES_APPLY.equals("Y")) sbRestoreCmd.append(SPACE).append(IDENTIFIER_QUOTES_APPLY);
        if(!R_OBJ_CMD.equals("")) sbRestoreCmd.append(SPACE).append(R_OBJ_CMD);

        if(!R_FILENAME.equals("")) sbRestoreCmd.append(SPACE).append(FILENAME);
        
		sbRestoreCmd.append(SPACE).append(">>");
        //sbRestoreCmd.append(SPACE).append("| tee -a");
		sbRestoreCmd.append(SPACE).append(logDir).append(strLogFileName);
		
		socketLogger.info("dump restore CMD : " + sbRestoreCmd);

		JSONObject outputObj = new JSONObject();
		
		SystemServiceImpl service = (SystemServiceImpl) DaemonStart.getContext().getBean("SystemService");

		try {
			
			DumpRestoreVO vo = new DumpRestoreVO();
			vo.setRESTORE_SN(intRestore_sn);
			vo.setRESTORE_CNDT(RUNNING);
			
			// restore running start
			service.updateDUMP_RESTORE_CNDT(vo);

            RunCommandExecNoWaitDump runCommandExecNoWaitDump = new RunCommandExecNoWaitDump(sbRestoreCmd.toString(), intRestore_sn);
            runCommandExecNoWaitDump.start();

			// socketLogger.info("send start");
			outputObj = CommonResultJSON(strDxExCode, strSuccessCode, strErrCode, strErrMsg);
			sendBuff = outputObj.toString().getBytes();

			send(TotalLengthBit, sendBuff);
			
			sendBuff = null;
			// socketLogger.info("send end");

		} catch (Exception e) {
			errLogger.error("[ERROR] DxT030 {} ", e.toString());
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT030);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT030);
			outputObj.put(ProtocolID.ERR_MSG, "DxT030 Error [" + e.toString() + "]");

			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
		} finally {
			outputObj = null;
			sendBuff = null;
		}
	}

}
