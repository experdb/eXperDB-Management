package com.experdb.proxy.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.net.Socket;
import java.util.HashMap;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.experdb.proxy.db.repository.service.ProxyLinkService;
import com.experdb.proxy.db.repository.service.ProxyLinkServiceImpl;
import com.experdb.proxy.socket.ProtocolID;
import com.experdb.proxy.socket.SocketCtl;
import com.experdb.proxy.socket.TranCodeType;
import com.experdb.proxy.socket.listener.DXTcontrolProxy;
import com.experdb.proxy.util.FileUtil;
import com.experdb.proxy.util.RunCommandExec;

/**
*
* @author 윤정 매니저
* @see proxy log 파일 불러오기
* 
*  <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2021.04.22				최초 생성
* </pre>
*/

public class PsP010 extends SocketCtl{
	
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	ApplicationContext context;

	public PsP010(Socket socket, BufferedInputStream is, BufferedOutputStream os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}
	
	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		socketLogger.info("PsP010.execute : " + strDxExCode);
		JSONObject outputObj = new JSONObject();
		
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
		
		try {
			
			context = new ClassPathXmlApplicationContext(new String[] { "context-tcontrol.xml" });
			ProxyLinkServiceImpl service = (ProxyLinkServiceImpl) context.getBean("ProxyLinkService");
			outputObj = fromJettisonToSimple(service.checkKeepalivedInstallYn(fromSimpleToJettison(jObj)));
			outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
		} catch (Exception e) {
			errLogger.error("PsP009 {} ", e.toString());

			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.PsP009);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.PsP009);
			outputObj.put(ProtocolID.ERR_MSG, "PsP009 Error [" + e.toString() + "]");
			outputObj.put(ProtocolID.RESULT_DATA, "false");

			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);

		} finally {
			outputObj = null;
			sendBuff = null;
		}
	}
}
