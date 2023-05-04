package com.k4m.dx.tcontrol.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.net.Socket;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;
import com.k4m.dx.tcontrol.util.FileUtil;

/**
 * pgbackrest log 조회
 *
 * @author 변승우
 * @see <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일              수정자           수정내용
 *  -------         --------    ---------------------------
 *  2023.05.04   변승우           최초 생성
 * </pre>
 */

public class DxT048 extends SocketCtl{

	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	public DxT048(Socket socket, BufferedInputStream is, BufferedOutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	@SuppressWarnings("unchecked")
	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		
		socketLogger.info("DxT048.execute : " + strDxExCode);
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";

		String strLogFileName = "wrknm_20230503112233.log";
		String logDir = "/data/experdata/data/pg_backrest/log/log/";
		
		JSONObject outputObj = new JSONObject();

		try {
			File inFile = new File(logDir, strLogFileName);
			String strFileView = FileUtil.getFileView(inFile);
			
			outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
			outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
			outputObj.put(ProtocolID.RESULT_DATA, strFileView);

			inFile = null;
			send(TotalLengthBit, outputObj.toString().getBytes());

			
		} catch (Exception e) {
			errLogger.error("DxT048 {} ", e.toString());
			
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT048);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT048);
			outputObj.put(ProtocolID.ERR_MSG, "DxT048 Error [" + e.toString() + "]");
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);

		} finally {
			outputObj = null;
			sendBuff = null;
		}	    
	}
}


