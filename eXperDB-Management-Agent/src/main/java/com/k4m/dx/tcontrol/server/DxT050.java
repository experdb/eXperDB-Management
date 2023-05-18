package com.k4m.dx.tcontrol.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.FileInputStream;
import java.net.Socket;
import java.util.HashMap;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;
import com.k4m.dx.tcontrol.util.CommonUtil;

public class DxT050 extends SocketCtl{
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	public DxT050(Socket socket, BufferedInputStream is, BufferedOutputStream os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}
	
	@SuppressWarnings("unchecked")
	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		socketLogger.info("DxT050.execute : " + strDxExCode);
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
		String result = null;
		
		CommonUtil util = new CommonUtil();
		JSONObject outputObj = new JSONObject();
		
		String pgHomePathCmd = "echo $PGHOME";
		String pgHomePath =  util.getPidExec(pgHomePathCmd);
		
		String confPath = pgHomePath + "/etc/pgbackrest/config/";
		String confFile = confPath + String.valueOf(jObj.get(ProtocolID.WRK_NM)) + ".conf";
		
	    FileInputStream fileStream = null;
	    try{
	    	fileStream = new FileInputStream( confFile );	// 파일 스트림 생성
	    	
	    	//버퍼 선언
		    byte[ ] readBuffer = new byte[fileStream.available()];
		    while (fileStream.read( readBuffer ) != -1){}
		    fileStream.close(); //스트림 닫기	
		    result=new String(readBuffer);
		    
		    outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
			outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
			outputObj.put(ProtocolID.RESULT_DATA, result);
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
	    }catch (Exception e){
			errLogger.error("DxT050 {} ", e.toString());
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT050);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT050);
			outputObj.put(ProtocolID.ERR_MSG, "DxT050 Error [" + e.toString() + "]");
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
