package com.experdb.proxy.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.net.Socket;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;

import com.experdb.proxy.socket.ProtocolID;
import com.experdb.proxy.socket.SocketCtl;
import com.experdb.proxy.socket.TranCodeType;

/**
 *
 * @author 윤정 매니저
 * @see Proxy config 파일 불러오기
 * 
 *  <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2021.04.08				최초 생성
 * </pre>
 */

public class PsP003 extends SocketCtl{
	
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	ApplicationContext context;

	public PsP003(Socket socket, BufferedInputStream is, BufferedOutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}
	
	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		
		socketLogger.info("PsP003.execute : " + strDxExCode);
		
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
		
		String strConfigFileDir = (String) jObj.get(ProtocolID.FILE_DIRECTORY);

		JSONObject outputObj = new JSONObject();
		try {
			
		} catch (Exception e) {
			errLogger.error("PsP003 {} ", e.toString());

			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.PsP003);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.PsP003);
			outputObj.put(ProtocolID.ERR_MSG, "PsP003 Error [" + e.toString() + "]");
			outputObj.put(ProtocolID.RESULT_DATA, "");

			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
		} finally {
			outputObj = null;
			sendBuff = null;
		}
	}
	
	
}
