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
import com.k4m.dx.tcontrol.util.CommonUtil;

/**
 * 24.	Hostname 조회
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

public class DxT019 extends SocketCtl{
	
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	public DxT019(Socket socket, BufferedInputStream is, BufferedOutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		
		socketLogger.info("DxT019.execute : " + strDxExCode);
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
	
		JSONObject outputObj = new JSONObject();

		try {
			
			String[] arrCmd = {"hostname"
								, "echo $PGHOME"
								, "echo $PGRBAK"
								, "echo $PGDBAK"
								, "echo $PGRLOG"
								, "echo $PGDLOG"
								, "echo $HOSTUSER"
			};
			
			CommonUtil util = new CommonUtil();
			
			String CMD_HOSTNAME = util.getPidExec(arrCmd[0]);
			String PGHOME = util.getPidExec(arrCmd[1]);
			String PGRBAK = util.getPidExec(arrCmd[2]);
			String PGDBAK = util.getPidExec(arrCmd[3]);
			String PGRLOG = util.getPidExec(arrCmd[4]);
			String PGDLOG = util.getPidExec(arrCmd[5]);
			String HOSTUSER = util.getPidExec(arrCmd[6]);
			
			util = null;
			
			HashMap hp = new HashMap();
			hp.put(ProtocolID.CMD_HOSTNAME, CMD_HOSTNAME);
			hp.put(ProtocolID.PGHOME, PGHOME);
			hp.put(ProtocolID.PGRBAK, PGRBAK);
			hp.put(ProtocolID.PGDBAK, PGDBAK);
			hp.put(ProtocolID.PGRLOG, PGRLOG);
			hp.put(ProtocolID.PGDLOG, PGDLOG);
			hp.put(ProtocolID.USER_NAME, HOSTUSER);
				
			outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
			outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
			outputObj.put(ProtocolID.RESULT_DATA, hp);

			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
			
		} catch (Exception e) {
			errLogger.error("DxT019 {} ", e.toString());
			
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT019);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT019);
			outputObj.put(ProtocolID.ERR_MSG, "DxT019 Error [" + e.toString() + "]");
			HashMap hp = new HashMap();
			outputObj.put(ProtocolID.RESULT_DATA, hp);
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);

		} finally {
			outputObj = null;
			sendBuff = null;
		}	    
	}
	
}


