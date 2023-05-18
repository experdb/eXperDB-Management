package com.k4m.dx.tcontrol.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.net.Socket;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;

import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;
import com.k4m.dx.tcontrol.socket.client.ClientProtocolID;
import com.k4m.dx.tcontrol.util.CommonUtil;

/**
 * pgbackrest 백업 로그 확인
 *
 * @author
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2023.04.11    최초 생성
 *      </pre>
 */	

public class DxT046 extends SocketCtl{

	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	ApplicationContext context;
	
	public DxT046(Socket socket, BufferedInputStream is, BufferedOutputStream os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}
	
	public void execute(String strDxExCode, JSONObject jObj) throws Exception{
		
		socketLogger.info("DxT046.execute : " + strDxExCode);
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
		
		List<String> confName = (List<String>) jObj.get(ClientProtocolID.WRK_NM);
		
		JSONObject outputObj = new JSONObject();
		try {
			for (int i = 0; i < confName.size(); i++) {
				confName.set(i, confName.get(i)+"_pgbackrest.conf") ;
			}
			
			CommonUtil util = new CommonUtil();
			JSONObject infoObj = new JSONObject();
				
			for (int i = 0; i < confName.size(); i++) {
				String configPath = "$PGHOME/etc/pgbackrest/config/" + confName.get(i);
				String strCmd = "pgbackrest --stanza=experdb --config=" + configPath + " info --output=json";
				
				String backupInfo =  util.getPidExec(strCmd);
				infoObj.put("backrestinfo", backupInfo);				
			}
	
			outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
			outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
			outputObj.put(ProtocolID.RESULT_DATA, infoObj);
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
			
		} catch(Exception e){
			errLogger.error("DxT046 {} ", e.toString());
			
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT046);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT046);
			outputObj.put(ProtocolID.ERR_MSG, "DxT046 Error [" + e.toString() + "]");
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
