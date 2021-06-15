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
import com.experdb.proxy.util.ProxyRunCommandExec;

/**
 * 01. proxy agent setting
 *
 * @author 
 * @see <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 * </pre>
 */
public class PsP001 extends SocketCtl{
	
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");

	ApplicationContext context;

	public PsP001(Socket socket, BufferedInputStream is, BufferedOutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		socketLogger.info("PsP001.execute : " + strDxExCode);

		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
		
		JSONObject outputObj = new JSONObject();

		try {
			String proxyAgentCmd = "";

			String agtCndtCd = jObj.get(ProtocolID.AGT_CNDT_CD).toString();             //agent 실행 구분

			if ("TC001101".equals(agtCndtCd)) {
				proxyAgentCmd = "sh stop.sh";
			} else {
				proxyAgentCmd = "sh startup.sh";
			}

			ProxyRunCommandExec proxyExec = new ProxyRunCommandExec(proxyAgentCmd, 0);
			proxyExec.start();

			String retVal = proxyExec.call();
			String strResultMessge = proxyExec.getMessage();

			strSuccessCode = "0";
			strErrCode = "";
			strErrMsg = "";

			outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
			outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
			outputObj.put(ProtocolID.RESULT_DATA, retVal);

			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
		} catch (Exception e) {
			errLogger.error("PsP001 {} ", e.toString());

			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.PsP001);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.PsP001);
			outputObj.put(ProtocolID.ERR_MSG, "PsP001 Error [" + e.toString() + "]");
			outputObj.put(ProtocolID.RESULT_DATA, "");

			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);

		} finally {
			outputObj = null;
			sendBuff = null;
		}
	}
}