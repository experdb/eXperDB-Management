package com.k4m.dx.tcontrol.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.net.Socket;
import java.util.ArrayList;
import java.util.List;
import java.util.TreeMap;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;

import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;
import com.k4m.dx.tcontrol.util.TransRunCommandExec;

/**
 * Connect 실행
 *
 * @author 변승우
 * @see <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2020.04.20   변승우 최초 생성
 * </pre>
 */

public class DxT041 extends SocketCtl{
	
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	ApplicationContext context;
	
	public DxT041(Socket socket, BufferedInputStream is, BufferedOutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		socketLogger.info("DxT041.execute : " + strDxExCode);

		JSONParser parser = new JSONParser();
		JSONObject outputObj = new JSONObject();
		JSONObject jsonObj = new JSONObject(new TreeMap ());
		String strSuccessCode = "0";
		String strErrCode = "";
		String strErrMsg = "";
		byte[] sendBuff = null;

		JSONObject objSERVER_INFO = (JSONObject) jObj.get(ProtocolID.SERVER_INFO);
		
		try {
			String strCmd = (String)objSERVER_INFO.get("REQ_CMD");

			TransRunCommandExec r = new TransRunCommandExec(strCmd);

			//명령어 실행
			r.run();

			try {
				r.join();
			} catch (InterruptedException ie) {
				ie.printStackTrace();
			}

			String retVal = r.call();
			String strResultMessge = r.getMessage();

			if (retVal.equals("success")) {	
				if (!strResultMessge.isEmpty()) {
					if (strResultMessge.length() > 0 && strResultMessge.charAt(strResultMessge.length()-1)==',') {
						strResultMessge = strResultMessge.substring(0, strResultMessge.length()-1);
					}
				}
			}

			outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
			outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
			outputObj.put(ProtocolID.RESULT_DATA, strResultMessge);

			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
		} catch (Exception e) {
			errLogger.error("DxT041 {} ", e.toString());

			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT041);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT041);
			outputObj.put(ProtocolID.ERR_MSG, "DxT041 Error [" + e.toString() + "]");
			outputObj.put(ProtocolID.RESULT_DATA, jsonObj);
			outputObj.put(ProtocolID.RESULT_SUB_DATA, "");

			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);

		} finally {
			outputObj = null;
			sendBuff = null;
		}

	}

	/**
	 * Secret키와 Content-type을 설정
	 * 
	 * @param appType
	 * @param params
	 * @return HttpEntity<?>
	 */
	private HttpEntity<?> apiClientHttpEntity(String appType, String params) {

		HttpHeaders requestHeaders = new HttpHeaders();
		requestHeaders.set("Content-Type", "application/" + appType);

		if ("".equals(params) || (params == null))
			return new HttpEntity<Object>(requestHeaders);
		else
			return new HttpEntity<Object>(params, requestHeaders);
	}
}