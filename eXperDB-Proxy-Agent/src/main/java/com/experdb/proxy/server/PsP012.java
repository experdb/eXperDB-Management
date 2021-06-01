package com.experdb.proxy.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.RandomAccessFile;
import java.net.Socket;
import java.util.HashMap;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;

import com.experdb.proxy.socket.ProtocolID;
import com.experdb.proxy.socket.SocketCtl;
import com.experdb.proxy.socket.TranCodeType;
import com.experdb.proxy.util.FileUtil;

/**
 *
 * @author 윤정 매니저
 * @see proxy 서버 연결 확인
 * 
 *  <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2021.04.08				최초 생성
 * </pre>
 */

public class PsP012 extends SocketCtl{
	
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	ApplicationContext context;

	public PsP012(Socket socket, BufferedInputStream is, BufferedOutputStream os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}
	
	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		
		socketLogger.info("PsP012.execute : " + strDxExCode);
		
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
		
		JSONObject outputObj = new JSONObject();
		try {

			outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
			outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
			
			socketLogger.info("PsP012 : " + outputObj.toJSONString());
		} catch (Exception e) {
			errLogger.error("PsP012 {} ", e.toString());

			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.PsP012);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.PsP012);
			outputObj.put(ProtocolID.ERR_MSG, "PsP012 Error [" + e.toString() + "]");
			outputObj.put(ProtocolID.RESULT_DATA, "");
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
			
			socketLogger.info("PsP012 : " + outputObj.toJSONString());
		} finally {
			outputObj = null;
			sendBuff = null;
		}
	}
	
	public static void main(String args[]) throws NumberFormatException, Exception{
		String strLogFileDir = "C:/Users/yj402/git/eXperDB-Management/eXperDB-Management-WebConsole/src/main/java/com/experdb/management/proxy/service/";
		String strFileName = "haproxy.cfg";
		String startLen = "100";
		String seek = "0";
		
		File inFile = new File(strLogFileDir, strFileName);
		System.out.println(inFile.getName());
		System.out.println(inFile.isFile());
		//byte[] buffer = FileUtil.getFileToByte(inFile);
		//HashMap hp = FileUtil.getFileView(inFile, Integer.parseInt(startLen), Integer.parseInt(dwLen));
		RandomAccessFile rdma = null;
		String strView = "";
		int intLastLine = 0;
		int intReadLine = Integer.parseInt(startLen);
		
		rdma = new RandomAccessFile(inFile, "r");

		// int intStartLine = intReadLine * intDwlenCount;

		rdma.seek(Integer.parseInt(seek));

		String temp;
		int recnum = 1;
		while ((temp = rdma.readLine()) != null) {

			strView += (intLastLine + recnum) + " " + new String(temp.getBytes("ISO-8859-1"), "UTF-8") + "<br>";
			if (((++recnum) % (intReadLine + 1)) == 0) {
				break;
			}
		}

		HashMap hp = FileUtil.getRandomAccessFileView(inFile, Integer.parseInt(startLen), Integer.parseInt(seek), 0);
//		System.out.println(hp.get("end_flag"));
	}
}
