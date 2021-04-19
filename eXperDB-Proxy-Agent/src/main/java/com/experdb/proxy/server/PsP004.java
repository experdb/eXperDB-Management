package com.experdb.proxy.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.net.Socket;

import org.codehaus.jettison.json.JSONException;
//import org.codehaus.jettison.json.JSONObject;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.experdb.proxy.db.repository.service.ProxyLinkServiceImpl;
import com.experdb.proxy.db.repository.service.ProxyServiceImpl;
import com.experdb.proxy.socket.ProtocolID;
import com.experdb.proxy.socket.SocketCtl;
import com.experdb.proxy.socket.TranCodeType;



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

public class PsP004 extends SocketCtl{
	
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");

	ApplicationContext context;

	public PsP004(Socket socket, BufferedInputStream is, BufferedOutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public org.codehaus.jettison.json.JSONObject fromSimpleToJettison(JSONObject jobj) throws JSONException{
		org.codehaus.jettison.json.JSONObject result = new org.codehaus.jettison.json.JSONObject(jobj.toJSONString());
		return result;
	}
	
	public JSONObject fromJettisonToSimple(org.codehaus.jettison.json.JSONObject jobj) throws ParseException{
		JSONParser parser = new JSONParser();
		Object obj = parser.parse(jobj.toString());
		JSONObject result = (JSONObject) obj;
		return result;
	}
	
	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
		
		JSONObject outputObj = new JSONObject();
		JSONObject result;
		try {
			context = new ClassPathXmlApplicationContext(new String[] { "context-tcontrol.xml" });
			ProxyLinkServiceImpl service = (ProxyLinkServiceImpl) context.getBean("ProxyLinkService");
			result = fromJettisonToSimple(service.createNewConfFile(fromSimpleToJettison(jObj)));
			
			outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
			outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
			outputObj.put(ProtocolID.RESULT_DATA, result.toJSONString());

			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
		} catch (Exception e) {
			errLogger.error("PsP004 {} ", e.toString());
			result = new JSONObject();
			result.put("errorCd", -1);
			result.put("error", e.toString());
			
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.PsP001);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.PsP001);
			outputObj.put(ProtocolID.ERR_MSG, "PsP002 Error [" + e.toString() + "]");
			outputObj.put(ProtocolID.RESULT_DATA, result.toJSONString());

			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);

		} finally {
			outputObj = null;
			sendBuff = null;
		}
	}
}