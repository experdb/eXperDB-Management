package com.k4m.dx.tcontrol.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.net.Socket;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.k4m.dx.tcontrol.db.repository.service.SystemServiceImpl;
import com.k4m.dx.tcontrol.db.repository.vo.WrkExeVO;
import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;
import com.k4m.dx.tcontrol.util.CommonUtil;
import com.k4m.dx.tcontrol.util.RunCommandExec;

/**
 * 백업 즉시실행
 *
 * @author 변승우
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2020.03.20   변승우 최초 생성
 *      </pre>
 */

public class DxT034 extends SocketCtl {

	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");

	private static String TC001801 = "TC001801"; // 대기
	private static String TC001802 = "TC001802"; // 실행중
	private static String TC001701 = "TC001701"; // 성공
	private static String TC001702 = "TC001702"; // 실패
	private static String TC001901 = "TC001901"; // 백업
	private static String TC001902 = "TC001902"; // 스크립트실행
	
	private static String TC000202 = "TC000202"; // dump
	
	int scd_id=0;

	ApplicationContext context;

	public DxT034(Socket socket, BufferedInputStream is, BufferedOutputStream os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public DxT034() {
		// TODO Auto-generated constructor stub
	}

	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		socketLogger.info("DxT034.execute : " + strDxExCode);

		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
		
		context = new ClassPathXmlApplicationContext(new String[] { "context-tcontrol.xml" });
		SystemServiceImpl service = (SystemServiceImpl) context.getBean("SystemService");

		String strResultCode = TC001701;
		
		JSONObject outputObj = new JSONObject();
		JSONArray arrCmd = new JSONArray();
		
		try {			
				int exe_sn = service.selectQ_WRKEXE_G_01_SEQ();
				scd_id = service.selectScd_id();
				int exe_grp_sn = service.selectQ_WRKEXE_G_02_SEQ();
							
				
				String wrk_id = (String) jObj.get(ProtocolID.WORK_ID);
				String bck_opt_cd = (String) jObj.get(ProtocolID.BCK_OPT_CD);
				String bck_bsn_dscd = (String) jObj.get(ProtocolID.BCK_BSN_DSCD);
				String db_svr_ipadr_id = (String) jObj.get(ProtocolID.DB_SVR_IPADR_ID);
				String db_id = (String) jObj.get(ProtocolID.DB_ID);
				String bck_pth = (String) jObj.get(ProtocolID.BCK_FILE_PTH);
				String bck_fileNm = (String) jObj.get(ProtocolID.BCK_FILENM);
				
				arrCmd = (JSONArray) jObj.get(ProtocolID.ARR_CMD);
				
				
				WrkExeVO vo = new WrkExeVO();
				vo.setEXE_SN(exe_sn);
				vo.setSCD_ID(scd_id);
				vo.setWRK_ID(Integer.parseInt(wrk_id));
				vo.setEXE_RSLT_CD("");
				vo.setBCK_OPT_CD(bck_opt_cd);
				vo.setDB_ID(Integer.parseInt(db_id));
				vo.setBCK_FILE_PTH(bck_pth);
				vo.setBCK_FILENM(bck_fileNm);
				vo.setEXE_GRP_SN(exe_grp_sn);
				vo.setSCD_CNDT(TC001802); // 실행중
				vo.setDB_SVR_IPADR_ID(Integer.parseInt(db_svr_ipadr_id));
				
				service.insertWRKEXE_G(vo);
				
				
				for(int i=0; i<arrCmd.size(); i++){
	
				String strCommand = arrCmd.get(i).toString();

				socketLogger.info("[COMMAND] " + strCommand);

				RunCommandExec r = new RunCommandExec(strCommand);
				
				//명령어 실행
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
				if (retVal.equals("success")) {
				String strFileName = bck_fileNm;
				String strFileSize = "0";
					if (bck_bsn_dscd.equals(TC000202)) {
						
								socketLogger.info("[BCK_BSN_DSCD] " + bck_bsn_dscd);
								
								String strSlush = "/";
								
								if (!bck_pth.contentEquals("")) {
									String strSl = bck_pth.substring(bck_pth.length() - 1,
											bck_pth.length());
									if (strSl.equals("/")) {
										strSlush = "";
									}
								}
								
								String strCmd = "ls -al " + bck_pth + strSlush + bck_fileNm + " | awk '{print $5}'";
								
								if(strCommand.contains("directory")) {
									strCmd = "du " + bck_pth + strSlush + bck_fileNm + " | awk '{print $1}'";
								}
								
								CommonUtil util = new CommonUtil();
								
								strFileSize = util.getPidExec(strCmd);
								
								util = null;
				
								socketLogger.info("[File COMMAND] " + strCmd);
								
								if (strFileSize == null)
									strFileSize = "0";
								String[] sarrFileName = bck_fileNm.split("_");
								String fileName = sarrFileName[0] + "_" + sarrFileName[1];
						}
					
					//상태업데이트(성공)
					socketLogger.info("[SUCCESS] DxT005 SCD_ID[" + scd_id + "] " + retVal + " " + strResultMessge);
					WrkExeVO endVO = new WrkExeVO();
					endVO.setEXE_RSLT_CD(strResultCode);
					endVO.setEXE_SN(exe_sn);
					socketLogger.info("FileSize="+strFileSize);
					endVO.setFILE_SZ(Long.parseLong(strFileSize));
					endVO.setBCK_FILENM(strFileName);
					endVO.setRSLT_MSG(retVal + " " + strResultMessge);				
		
					// 백업 이력 update
					service.updateT_WRKEXE_G(endVO);
					
					}else{
						
					//상태업데이트(실패)
						errLogger.error("[ERROR] DxT034 SCD_ID[" + scd_id + "] {} ", retVal + " " + strResultMessge);

						strResultCode = TC001702;

						WrkExeVO endVO = new WrkExeVO();
						endVO.setEXE_RSLT_CD(strResultCode);
						endVO.setEXE_SN(exe_sn);
						endVO.setFILE_SZ(0);
						endVO.setBCK_FILENM("");
						endVO.setRSLT_MSG(retVal + " " + strResultMessge);

						// 백업 이력 update
						service.updateT_WRKEXE_G(endVO);
						
						
					}
				}
	
				outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
				outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
				outputObj.put(ProtocolID.ERR_CODE, strErrCode);
				outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
				
				sendBuff = outputObj.toString().getBytes();
				send(4, sendBuff);
				
		} catch (Exception e) {
			errLogger.error("[ERROR] DxT034 {} ", e.toString());
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT034);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT034);
			outputObj.put(ProtocolID.ERR_MSG, "DxT034 Error [" + e.toString() + "]");
			outputObj.put(ProtocolID.ERR_MSG, strErrMsg);

			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
		} finally {
			outputObj = null;
			sendBuff = null;
		}
	}

}
