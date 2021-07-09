package com.experdb.proxy.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.net.Socket;

import org.apache.commons.io.FileDeleteStrategy;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.experdb.proxy.db.repository.service.ProxyLinkServiceImpl;
import com.experdb.proxy.socket.ProtocolID;
import com.experdb.proxy.socket.SocketCtl;
import com.experdb.proxy.socket.TranCodeType;
import com.experdb.proxy.util.FileUtil;

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
public class PsP013 extends SocketCtl{
	
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");

	ApplicationContext context;

	public PsP013(Socket socket, BufferedInputStream is, BufferedOutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		socketLogger.info("PsP013.execute : " + strDxExCode);

		byte[] sendBuff = null;
		
		JSONObject outputObj = new JSONObject();
		try {

			if(jObj.get("del_backup_folder") != null){
				File backupFolder = new File(jObj.get("del_backup_folder").toString());
				FileDeleteStrategy.FORCE.delete(backupFolder);
				socketLogger.info("PsP013 : backup folder delete successs : " + backupFolder.toString());
			}
			
			outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
			outputObj.put(ProtocolID.RESULT_CODE, "0");
			outputObj.put(ProtocolID.ERR_CODE, "0");
			outputObj.put(ProtocolID.ERR_MSG, "");
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
		} catch (Exception e) {
			errLogger.error("PsP013 {} ", e.toString());

			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.PsP013);
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