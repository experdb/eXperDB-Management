package com.k4m.dx.tcontrol.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.net.Socket;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;
import com.k4m.dx.tcontrol.socket.client.ClientProtocolID;
import com.k4m.dx.tcontrol.util.CommonUtil;
import com.k4m.dx.tcontrol.util.FileUtil;

public class DxT054 extends SocketCtl{
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	public DxT054(Socket socket, BufferedInputStream is, BufferedOutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}
	
	@SuppressWarnings("unchecked")
	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		socketLogger.info("DxT054.execute : " + strDxExCode);
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
		
		CommonUtil util = new CommonUtil();
		JSONObject outputObj = new JSONObject();
		

		try {
			String pgBlogPathCmd = "echo $PGBLOG";
			String pgBlogPath = util.getPidExec(pgBlogPathCmd);
			
			String exelog = (String) jObj.get(ClientProtocolID.EXELOG);
			String logFileNm = pgBlogPath + "/" + exelog + ".log";
			
			File inFile = new File(logFileNm);
			String strFileView = FileUtil.getFileView(inFile);
		
			outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
			outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
			outputObj.put(ProtocolID.RESULT_DATA, strFileView);
			
			inFile = null;
			send(TotalLengthBit, outputObj.toString().getBytes());
			
		} catch (Exception e) {
			errLogger.error("DxT054 {} ", e.toString());
			
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT054);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT054);
			outputObj.put(ProtocolID.ERR_MSG, "DxT054 Error [" + e.toString() + "]");
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);

		} finally {
			outputObj = null;
			sendBuff = null;
		}
	}
}
