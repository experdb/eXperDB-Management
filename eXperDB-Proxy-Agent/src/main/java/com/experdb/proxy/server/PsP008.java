package com.experdb.proxy.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
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
import com.experdb.proxy.util.RunCommandExec;

/**
 * 08. proxy log 파일 가져오기
 *
 * @author 윤정 매니저
 * @see <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2021.04.22				최초 생성
 * </pre>
 */
public class PsP008 extends SocketCtl{
	
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	ApplicationContext context;

	public PsP008(Socket socket, BufferedInputStream is, BufferedOutputStream os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		
		socketLogger.info("PsP008.execute : " + strDxExCode);
		
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
		
		String strLogFileDir = (String) jObj.get(ProtocolID.FILE_DIRECTORY);
		JSONObject outputObj = new JSONObject();
		try {

			String strReadLine = (String) jObj.get(ProtocolID.READLINE);
			String dwLen = (String) jObj.get(ProtocolID.DW_LEN);
			
			int intDwlen = Integer.parseInt(dwLen);
			int intReadLine = Integer.parseInt(strReadLine);
			int intLastLine = intDwlen;

			
			if(intDwlen == 0){
				intLastLine = intReadLine;
			}
			
			String strFileName = (String) jObj.get(ProtocolID.FILE_NAME);
			String strCmd = "tac " + strLogFileDir + strFileName + " | head -" + (intLastLine) + " > /var/log/exproxy_log/" + strFileName;
			
			RunCommandExec commandExec = new RunCommandExec();
			//명령어 실행
			commandExec.runExec(strCmd);

			File inFile = new File("/var/log/exproxy_log/", strFileName);

			try {
				commandExec.join();
			} catch (InterruptedException ie) {
				socketLogger.error("getLogFile error {}",ie.toString());
				ie.printStackTrace();
			}

			if(commandExec.call().equals("success")){
				HashMap hp = FileUtil.getRandomAccessFileView(inFile, intReadLine, Integer.parseInt("0"), intLastLine);

				outputObj.put(ProtocolID.RESULT_DATA, hp.get("file_desc"));
				outputObj.put(ProtocolID.FILE_SIZE, hp.get("file_size"));
				outputObj.put(ProtocolID.SEEK, hp.get("seek"));
				outputObj.put(ProtocolID.DW_LEN, intLastLine + Integer.parseInt(strReadLine));
				outputObj.put(ProtocolID.END_FLAG, hp.get("end_flag"));
			
				hp = null;
			}
			outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
			outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, strErrMsg);

			inFile = null;		
			
			send(outputObj);
		} catch (Exception e) {
			errLogger.error("PsP008 {} ", e.toString());

			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.PsP008);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.PsP008);
			outputObj.put(ProtocolID.ERR_MSG, "PsP008 Error [" + e.toString() + "]");
			outputObj.put(ProtocolID.RESULT_DATA, "");

			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
		} finally {
			outputObj = null;
			sendBuff = null;
		}
	}
}