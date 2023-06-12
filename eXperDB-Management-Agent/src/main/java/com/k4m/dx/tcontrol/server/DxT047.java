package com.k4m.dx.tcontrol.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.net.Socket;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

import org.codehaus.jackson.JsonNode;
import org.codehaus.jackson.map.ObjectMapper;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.google.gson.JsonArray;
import com.k4m.dx.tcontrol.db.repository.service.SystemServiceImpl;
import com.k4m.dx.tcontrol.db.repository.vo.WrkExeVO;
import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;
import com.k4m.dx.tcontrol.socket.client.ClientProtocolID;
import com.k4m.dx.tcontrol.util.CommonUtil;
import com.k4m.dx.tcontrol.util.RunCommandExec;

public class DxT047 extends SocketCtl{
	
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	private static String TC001801 = "TC001801"; // 대기
	private static String TC001802 = "TC001802"; // 실행중
	private static String TC001701 = "TC001701"; // 성공
	private static String TC001702 = "TC001702"; // 실패
	private static String TC001901 = "TC001901"; // 백업
	
	private static String TC000205 = "TC000205"; // backrest
		
	ApplicationContext context;
	
	public DxT047(Socket socket, BufferedInputStream is, BufferedOutputStream os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}
	
	public DxT047() {
		
	}
	
	public void execute(String strDxExCode, JSONObject jObj) throws Exception{
		
		context = new ClassPathXmlApplicationContext(new String[] { "context-tcontrol.xml" });
		SystemServiceImpl service = (SystemServiceImpl) context.getBean("SystemService");
		socketLogger.info("DxT047.execute : " + strDxExCode);
				
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
		String strResultCode = TC001701;
		int scd_id = 0;
		
		JSONObject outputObj = new JSONObject();
		
		try {
			
			int exe_sn = service.selectQ_WRKEXE_G_01_SEQ();
			scd_id = service.selectScd_id();
			int exe_grp_sn = service.selectQ_WRKEXE_G_02_SEQ();
						
			String ipadr = (String) jObj.get(ClientProtocolID.SERVER_IP);
			
			int ipadrId = service.selectDbSvrIpAdrId(ipadr);
			
			String configPath = "$PGHOME/etc/pgbackrest/config/";
			String fullPath = configPath + jObj.get(ProtocolID.BCK_FILENM);
		
			String backupType = (String) jObj.get(ProtocolID.BCK_TYPE);
			String logPath = (String) jObj.get(ProtocolID.LOG_PATH);
			
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
			String now = dateFormat.format(new Date());
			String logFileName = jObj.get(ProtocolID.WRK_NM) + "_" +  now + ".log";
			String logFullPath = logPath + "/" + logFileName;
			
			String bck_file_pth = (String) jObj.get(ClientProtocolID.BCK_FILE_PTH);
			String bck_filenm = (String) jObj.get(ClientProtocolID.BCK_FILENM);
			String usr_id = (String) jObj.get(ClientProtocolID.USER_ID);
			String wrk_nm = (String) jObj.get(ClientProtocolID.WRK_NM);
			String wrk_idStr = jObj.get(ClientProtocolID.WRK_ID).toString();
			String db_idStr = jObj.get(ClientProtocolID.DB_ID).toString();
			String bck_opt_cd = (String) jObj.get(ClientProtocolID.BCK_OPT_CD);
			int wrk_id = Integer.parseInt(wrk_idStr);
			int db_id = Integer.parseInt(db_idStr);
			
			WrkExeVO vo = new WrkExeVO();
			
			vo.setEXE_RSLT_CD(TC001802);
			vo.setEXE_GRP_SN(exe_grp_sn);
			vo.setEXE_SN(exe_sn);
			vo.setSCD_ID(scd_id);
			vo.setBCK_FILE_PTH(bck_file_pth);
			vo.setBCK_FILENM(logFullPath);
			vo.setFRST_REGR_ID(usr_id);
			vo.setLST_MDFR_ID(usr_id);
			vo.setWRK_NM(wrk_nm);
			vo.setDB_SVR_IPADR_ID(ipadrId);
			vo.setWRK_ID(wrk_id);
			vo.setDB_ID(db_id);
			vo.setBCK_OPT_CD(bck_opt_cd);
			
			service.insertPgbackrestBackup(vo);

			if(bck_opt_cd.equals("TC000302")) {
				backupType = "incr";
			}
			String lowerBckType = backupType.toLowerCase();
			
			String strCmd = "pgbackrest --stanza=experdb --config=" + fullPath + " --type=" + lowerBckType + " backup > " + logPath + "/" + logFileName;
						
			RunCommandExec r = new RunCommandExec(strCmd);
			
			r.start();
			try {
				r.join();
			} catch (InterruptedException ie) {
				ie.printStackTrace();
			}
			String retVal = r.call();
			String strResultMessage = r.getMessage();
			if(retVal.equals("success")) {
				
				String succesCmd = "pgbackrest --stanza=experdb --config=" + fullPath + " info --output=json";
				
				CommonUtil util = new CommonUtil();
				
				// 작업 완료 시 info 값으로 DB 값 업데이트
				String successObj = util.getPidExec(succesCmd);

				ObjectMapper mapper = new ObjectMapper();
				JsonNode jsonNode = mapper.readTree(successObj);
				
				int jsonSize = jsonNode.findValue("backup").size();
			
				long repoSizeInt = jsonNode.findValue("backup").path(jsonSize-1).path("info").path("repository").path("delta").asLong();
				long dbSizeInt = jsonNode.findValue("backup").path(jsonSize-1).path("info").path("delta").asLong();
				int startTimeInt = jsonNode.findValue("backup").path(jsonSize-1).path("timestamp").path("start").asInt();
				int stopTimeInt = jsonNode.findValue("backup").path(jsonSize-1).path("timestamp").path("stop").asInt(); 
				
				String startDateStr = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date(startTimeInt * 1000L));
				String stopDateStr = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date(stopTimeInt * 1000L));
				
				WrkExeVO endVO = new WrkExeVO();
				endVO.setEXE_SN(exe_sn);
				endVO.setWRK_STRT_DTM(startDateStr);
				endVO.setWRK_END_DTM(stopDateStr);
				endVO.setEXE_RSLT_CD(strResultCode);
				endVO.setFILE_SZ(repoSizeInt);
				endVO.setBCK_FILENM(logFullPath);
				endVO.setDB_SZ(dbSizeInt);
				endVO.setRSLT_MSG(retVal + " " + strResultMessage);
				
				service.updateBackrestWrk(endVO);
				
			}else {
				
				errLogger.error("[ERROR] DxT047 {} ", retVal + " " + strResultMessage);

				strResultCode = TC001702;
				strSuccessCode = "2";
				
				WrkExeVO endVO = new WrkExeVO();
				endVO.setEXE_RSLT_CD(strResultCode);
				endVO.setWRK_END_DTM(wrk_nm);
				endVO.setEXE_SN(exe_sn);
				endVO.setFILE_SZ(0);
				endVO.setBCK_FILENM(logFullPath);
				endVO.setRSLT_MSG(retVal + " " + strResultMessage);

				// 백업 이력 update
				service.updateBackrestWrk(endVO);
			}
			outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
			outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
			
		} catch(Exception e){
			errLogger.error("DxT047 {} ", e.toString());
			
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT047);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT047);
			outputObj.put(ProtocolID.ERR_MSG, "DxT047 Error [" + e.toString() + "]");
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);

		} finally {
			outputObj = null;
			sendBuff = null;
		}
	}

}
