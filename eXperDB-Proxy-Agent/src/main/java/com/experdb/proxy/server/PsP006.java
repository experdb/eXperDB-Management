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
import com.experdb.proxy.socket.ProtocolID;
import com.experdb.proxy.socket.SocketCtl;
import com.experdb.proxy.socket.TranCodeType;

/**
 * 06. proxy service start/stop
 *
 * @author 
 * @see <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 * </pre>
 */
public class PsP006 extends SocketCtl{
	
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");

	ApplicationContext context;

	public PsP006(Socket socket, BufferedInputStream is, BufferedOutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		socketLogger.info("PsP006.execute : " + strDxExCode);

		byte[] sendBuff = null;
		
		JSONObject outputObj = new JSONObject();
		try {

			context = new ClassPathXmlApplicationContext(new String[] { "context-tcontrol.xml" });
			ProxyLinkServiceImpl service = (ProxyLinkServiceImpl) context.getBean("ProxyLinkService");
			
			outputObj = fromJettisonToSimple(service.executeService(fromSimpleToJettison(jObj)));
			outputObj.put(ProtocolID.DX_EX_CODE,strDxExCode);
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
		} catch (Exception e) {
			errLogger.error("PsP006 {} ", e.toString());

			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.PsP006);
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