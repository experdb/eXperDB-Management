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
 * 05. proxy service restart
 *
 * @author 
 * @see <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
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
			String backupConfStr = null;
			String presentConfStr = null;
			if(!"".equals(jObj.get("backup_file_path").toString())) backupConfStr = service.readBackupConfFile(jObj.get("backup_file_path").toString());
			if(!"".equals(jObj.get("present_file_path").toString())) presentConfStr = service.readBackupConfFile(jObj.get("present_file_path").toString());
			outputObj.put(ProtocolID.DX_EX_CODE,strDxExCode);
			outputObj.put(ProtocolID.BACKUP_CONF, backupConfStr);
			outputObj.put(ProtocolID.PRESENT_CONF, presentConfStr);
			outputObj.put(ProtocolID.RESULT_CODE, "0");
			outputObj.put(ProtocolID.ERR_CODE, "0");
			outputObj.put(ProtocolID.ERR_MSG, "");
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
		} catch (Exception e) {
			errLogger.error("PsP005 {} ", e.toString());

			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.PsP005);
			outputObj.put(ProtocolID.RESULT_CODE, "-1");
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