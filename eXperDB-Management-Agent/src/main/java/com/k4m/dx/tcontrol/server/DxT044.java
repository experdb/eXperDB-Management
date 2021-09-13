package com.k4m.dx.tcontrol.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.net.Socket;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;

import com.k4m.dx.tcontrol.db.repository.vo.TransVO;
import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;
import com.k4m.dx.tcontrol.util.RunCommandExec;

/**
 * kafka 재시작
 *
 * @author
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2021.09.06    최초 생성
 *      </pre>
 */	
public class DxT044 extends SocketCtl {

	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");

	ApplicationContext context;

	public DxT044(Socket socket, BufferedInputStream is, BufferedOutputStream os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public void execute(String strDxExCode, JSONObject jObj) throws Exception {

		socketLogger.info("DxT044.execute : " + strDxExCode);

		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
		socketLogger.info("[123456789132136547654] " + jObj.toJSONString());
//		String strExeStatusIng = ""
		// 정보 넣어주고 insert 하는거 하기!
		
//		TransVO transVO = new TransVO();
//		transVO.setKc_id((int) jObj.get("kc_id"));
		
		
		JSONObject outputObj = new JSONObject();
		try {
			
			String strCmd = "docker restart `docker ps -a --format \"table {{.Names}}\" | grep connect`";
//			String strCmd = "docker ps -a --format \"table {{.Names}}\" | grep kafka";
			RunCommandExec r = new RunCommandExec(strCmd);
			
			r.start();
			
			try {
				r.join();
			} catch (InterruptedException ie) {
				ie.printStackTrace();
			}
			
			String retVal = r.call();
			String strResultMessge = r.getMessage();
			
			socketLogger.info("[RESULT] " + retVal);
			socketLogger.info("[MSG] " + strResultMessge);

			socketLogger.info("##### 결과 : " + retVal + " message : " +strResultMessge);	
//			jObj.put("",);
			if(retVal.equals("success")){
				
			}
			
			outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
			outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
			outputObj.put(ProtocolID.RESULT_DATA, retVal);

			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
		} catch (Exception e) {
			errLogger.error("DxT044 {} ", e.toString());

			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT044);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT044);
			outputObj.put(ProtocolID.ERR_MSG, "DxT044 Error [" + e.toString() + "]");
			outputObj.put(ProtocolID.RESULT_DATA, "fail");
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
		} finally {
			outputObj = null;
			sendBuff = null;
		}
	}
}
