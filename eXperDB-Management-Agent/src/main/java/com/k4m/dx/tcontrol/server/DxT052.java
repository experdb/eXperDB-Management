package com.k4m.dx.tcontrol.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.net.Socket;
import java.util.HashMap;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;
import com.k4m.dx.tcontrol.util.CommonUtil;

public class DxT052 extends SocketCtl{
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	public DxT052(Socket socket, BufferedInputStream is, BufferedOutputStream os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}
	
	@SuppressWarnings("unchecked")
	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		socketLogger.info("DxT052.execute : " + strDxExCode);
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
		
		CommonUtil util = new CommonUtil();
		JSONObject outputObj = new JSONObject();
		
		try {
			JSONObject infoObj = new JSONObject();
			
			String pgBbakPathCmd = "echo $PGBBAK";
			String pgBbakPath =  util.getPidExec(pgBbakPathCmd);
			
			String pgBblogPathCmd = "echo $PGBLOG";
			String pgBlogPath =  util.getPidExec(pgBblogPathCmd);
			
			infoObj.put("PGBBAK", pgBbakPath);
			infoObj.put("PGBLOG", pgBlogPath);	
			
			outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
			outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
			outputObj.put(ProtocolID.RESULT_DATA, infoObj);
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
		}catch (Exception e) {
			errLogger.error("DxT052 {} ", e.toString());
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT052);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT052);
			outputObj.put(ProtocolID.ERR_MSG, "DxT052 Error [" + e.toString() + "]");
			HashMap hp = new HashMap();
			outputObj.put(ProtocolID.RESULT_DATA, hp);
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
		}finally {
			outputObj = null;
			sendBuff = null;
		}
	}
}
