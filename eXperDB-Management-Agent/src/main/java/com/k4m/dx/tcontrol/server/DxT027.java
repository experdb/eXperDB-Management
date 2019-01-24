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
 * 	Postgres Data 경로 조회
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

public class DxT027 extends SocketCtl{
	
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	public DxT027(Socket socket, BufferedInputStream is, BufferedOutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		
		socketLogger.info("DxT027.execute : " + strDxExCode);
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
	
		JSONObject outputObj = new JSONObject();

		try {
			
			String[] arrCmd = {"echo $PGDATA "
								, "echo $PGALOG"
								, "echo $SRVLOG"
								, "echo $PGRBAK"

			};
			
			CommonUtil util = new CommonUtil();
			
			String PGDATA = util.getPidExec(arrCmd[0]);
			String PGALOG = util.getPidExec(arrCmd[1]);
			String SRVLOG = util.getPidExec(arrCmd[2]);
			String PGRBAK = util.getPidExec(arrCmd[3]);

			
			util = null;
			
			HashMap hp = new HashMap();
			hp.put(ProtocolID.PGDATA, PGDATA);
			hp.put(ProtocolID.PGALOG, PGALOG);
			hp.put(ProtocolID.SRVLOG, SRVLOG);
			hp.put(ProtocolID.PGRBAK, PGRBAK);

				
			outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
			outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
			outputObj.put(ProtocolID.RESULT_DATA, hp);

			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
			
		} catch (Exception e) {
			errLogger.error("DxT027 {} ", e.toString());
			
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT027);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT027);
			outputObj.put(ProtocolID.ERR_MSG, "DxT027 Error [" + e.toString() + "]");
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


