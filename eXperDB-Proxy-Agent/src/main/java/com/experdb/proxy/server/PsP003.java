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
 * 03. proxy config 파일 조회
 *
 * @author 윤정 매니저
 * @see <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2021.04.08				최초 생성
 * </pre>
 */
public class PsP003 extends SocketCtl{
	
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	ApplicationContext context;

	public PsP003(Socket socket, BufferedInputStream is, BufferedOutputStream os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}
	
	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		
		socketLogger.info("PsP003.execute : " + strDxExCode);
		
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
		
		String strConfigFileDir = (String) jObj.get(ProtocolID.FILE_DIRECTORY);
		JSONObject outputObj = new JSONObject();
		try {

			String strReadLine = (String) jObj.get(ProtocolID.READLINE);
//			String strSeek = (String) jObj.get(ProtocolID.SEEK);
			String dwLen = (String) jObj.get(ProtocolID.DW_LEN);

			int intDwlen = Integer.parseInt(dwLen);
			int intReadLine = Integer.parseInt(strReadLine);
			int intLastLine = intDwlen;
			
			if(intDwlen == 0){
				intLastLine = intReadLine;
			}

			String strFileName = (String) jObj.get(ProtocolID.FILE_NAME);
			File inFile = new File(strConfigFileDir, strFileName);

			HashMap hp = FileUtil.getRandomAccessFileView(inFile, intReadLine, Integer.parseInt("0"), intLastLine);

			outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
			outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
			outputObj.put(ProtocolID.RESULT_DATA, hp.get("file_desc"));
			outputObj.put(ProtocolID.FILE_SIZE, hp.get("file_size"));
			outputObj.put(ProtocolID.SEEK, hp.get("seek"));
			outputObj.put(ProtocolID.DW_LEN, intLastLine + Integer.parseInt(strReadLine));
			outputObj.put(ProtocolID.END_FLAG, hp.get("end_flag"));

			hp = null;
			inFile = null;

			send(outputObj);
		} catch (Exception e) {
			errLogger.error("PsP003 {} ", e.toString());

			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.PsP003);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.PsP003);
			outputObj.put(ProtocolID.ERR_MSG, "PsP003 Error [" + e.toString() + "]");
			outputObj.put(ProtocolID.RESULT_DATA, "");

			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
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
	}
}
