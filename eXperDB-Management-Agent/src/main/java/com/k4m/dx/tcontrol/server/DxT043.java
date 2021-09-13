package com.k4m.dx.tcontrol.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.net.Socket;
import java.util.HashMap;

import org.apache.commons.validator.Field;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;

import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;
import com.k4m.dx.tcontrol.util.FileUtil;
import com.k4m.dx.tcontrol.util.RunCommandExec;

/**
 * Connector 로그
 *
 * @author
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2021.08.31    최초 생성
 *      </pre>
 */
public class DxT043 extends SocketCtl {

	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");

	ApplicationContext context;

	public DxT043(Socket socket, BufferedInputStream is, BufferedOutputStream os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public void execute(String strDxExCode, JSONObject jObj) throws Exception {

		socketLogger.info("DxT043.execute : " + strDxExCode);

		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";

		// String strCmd = (String) jObj.get(ProtocolID.REQ_CMD);
//		int trans_id = Integer.parseInt((String) jObj.get(ProtocolID.TRANS_ID));
//		String sys_type = (String) jObj.get(ProtocolID.CON_START_GBN);

		JSONObject outputObj = new JSONObject();
		try {

			String strReadLine = (String) jObj.get(ProtocolID.READLINE);
			String dwLen = (String) jObj.get(ProtocolID.DW_LEN);
			String sys_type = (String) jObj.get(ProtocolID.SYS_TYPE);

			int intDwlen = Integer.parseInt(dwLen);
			int intReadLine = Integer.parseInt(strReadLine);
			int intLastLine = intDwlen;

			if (intDwlen == 0) {
				intLastLine = intReadLine;
			}
			RunCommandExec r = new RunCommandExec();

			String kafkaPath = FileUtil.getPropertyValue("context.properties", "agent.trans_path");
			String kafkaLogDirectory = "trans_logs/kafka/";
			String connectorLogDirectory = "trans_logs/connector/";
			// trans 로그 폴더 생성
			if (!new File(kafkaPath + "/" + kafkaLogDirectory).exists()) {
				new File(kafkaPath + "/" + kafkaLogDirectory).mkdirs();
			}

			if (!new File(kafkaPath + "/" + connectorLogDirectory).exists()) {
				new File(kafkaPath + "/" + connectorLogDirectory).mkdirs();
			}
			String strFileName = "";
			String strCmd = "";
			String logDirectory = "";
			// String strConnectorNmCmd = "docker ps -a --format \"table
			// {{.Names}}\" | grep connect";
			// String strConnectorName = r.runExec(strConnectorNmCmd);
			// String strFileName = (String) jObj.get(ProtocolID.FILE_NAME);
			if (sys_type.equals("connector")) {
				strFileName = "connect-service.log";
				strCmd = "docker cp `docker ps -a --format \"table {{.Names}}\"  |  grep connect`:/kafka/logs/connect-service.log "
						+ kafkaPath + "/" + connectorLogDirectory;
				logDirectory = kafkaPath + "/" + connectorLogDirectory;
			} else if (sys_type.equals("kafka")) {
				strFileName = "server.log";
				strCmd = "docker cp `docker ps -a --format \"table {{.Names}}\"  |  grep kafka`:/kafka/logs/server.log "
						+ kafkaPath + "/" + kafkaLogDirectory;
				logDirectory = kafkaPath + "/" + kafkaLogDirectory;
			}
			// String strCmd = "tac " + "/home/experdb/" + "connect-service.log"
			// + " | head -" + (intLastLine);
			// 명령어 실행
			r.runExec(strCmd);
			File inFile = new File(logDirectory, strFileName);

			try {
				r.join();
			} catch (InterruptedException ie) {
				socketLogger.error("getLogFile error {}", ie.toString());
				ie.printStackTrace();
			}

			if (r.call().equals("success")) {
				HashMap hp = FileUtil.getRandomAccessLogFileView(inFile, intReadLine, Integer.parseInt("0"),
						intLastLine);

				outputObj.put(ProtocolID.RESULT_DATA, hp.get("file_desc"));
				outputObj.put(ProtocolID.FILE_SIZE, hp.get("file_size"));
				outputObj.put(ProtocolID.SEEK, hp.get("seek"));
				outputObj.put(ProtocolID.DW_LEN, intLastLine + Integer.parseInt(strReadLine));
				outputObj.put(ProtocolID.END_FLAG, hp.get("end_flag"));
				outputObj.put(ProtocolID.FILE_NAME, inFile.getName());

				hp = null;
			}

			outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
			outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, strErrMsg);

			inFile = null;

			send(outputObj);
		} catch (Exception e) {
			errLogger.error("DxT043 {} ", e.toString());

			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT043);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT043);
			outputObj.put(ProtocolID.ERR_MSG, "DxT043 Error [" + e.toString() + "]");

			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
		} finally {
			outputObj = null;
			sendBuff = null;
		}
	}
}
