package com.experdb.proxy.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.net.Socket;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.experdb.proxy.db.repository.service.ProxyLinkServiceImpl;
import com.experdb.proxy.db.repository.service.ProxyServiceImpl;
import com.experdb.proxy.socket.ProtocolID;
import com.experdb.proxy.socket.SocketCtl;
import com.experdb.proxy.socket.TranCodeType;
import com.experdb.proxy.util.ProxyRunCommandExec;
import com.experdb.proxy.util.RunCommandExec;

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

public class PsP005 extends SocketCtl{
	
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");

	ApplicationContext context;

	public PsP005(Socket socket, BufferedInputStream is, BufferedOutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		socketLogger.info("PsP005.execute : " + strDxExCode);

		byte[] sendBuff = null;
		
		JSONObject outputObj = new JSONObject();
		try {

			context = new ClassPathXmlApplicationContext(new String[] { "context-tcontrol.xml" });
			ProxyLinkServiceImpl service = (ProxyLinkServiceImpl) context.getBean("ProxyLinkService");
			outputObj = fromJettisonToSimple(service.restartService(fromSimpleToJettison(jObj)));
			outputObj.put(ProtocolID.DX_EX_CODE,strDxExCode);
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
		} catch (Exception e) {
			errLogger.error("PsP005 {} ", e.toString());

			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.PsP005);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, "-1");
			outputObj.put(ProtocolID.ERR_MSG, e.toString());

			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);

		} finally {
			outputObj = null;
			sendBuff = null;
		}
	}
}