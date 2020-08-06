package com.k4m.dx.tcontrol.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.net.Socket;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.k4m.dx.tcontrol.db.repository.service.SystemServiceImpl;
import com.k4m.dx.tcontrol.db.repository.vo.WrkExeVO;
import com.k4m.dx.tcontrol.server.DxT015.CompareSeqDesc;
import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;
import com.k4m.dx.tcontrol.util.CommonUtil;
import com.k4m.dx.tcontrol.util.FileEntry;
import com.k4m.dx.tcontrol.util.FileListSearcher;
import com.k4m.dx.tcontrol.util.FileUtil;
import com.k4m.dx.tcontrol.util.RunCommandExec;

/**
 * 백업 실행
 *
 * @author 박태혁
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.05.22   박태혁 최초 생성
 *      </pre>
 */

public class DxT005 extends SocketCtl {

	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");

	private static String TC001801 = "TC001801"; // 대기
	private static String TC001802 = "TC001802"; // 실행중
	private static String TC001701 = "TC001701"; // 성공
	private static String TC001702 = "TC001702"; // 실패
	private static String TC001901 = "TC001901"; // 백업
	private static String TC001902 = "TC001902"; // 스크립트실행
	
	private static String TC000201 = "TC000201"; // rman
	private static String TC000202 = "TC000202"; // dump
	
	

	ApplicationContext context;

	public DxT005(Socket socket, BufferedInputStream is, BufferedOutputStream os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public DxT005() {
		// TODO Auto-generated constructor stub
	}

	public void execute(String strDxExCode, JSONArray arrCmd) throws Exception {
		socketLogger.info("DxT005.execute : " + strDxExCode);

		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";

		JSONObject outputObj = new JSONObject();

		context = new ClassPathXmlApplicationContext(new String[] { "context-tcontrol.xml" });
		SystemServiceImpl service = (SystemServiceImpl) context.getBean("SystemService");

		String strResultCode = TC001701;

		try {

			int intGrpSeq = service.selectQ_WRKEXE_G_02_SEQ();

			for (int i = 0; i < arrCmd.size(); i++) {

				JSONObject objJob = (JSONObject) arrCmd.get(i);

				String strSCD_ID = objJob.get(ProtocolID.SCD_ID).toString();
				String strWORK_ID = objJob.get(ProtocolID.WORK_ID).toString();
				String strEXD_ORD = objJob.get(ProtocolID.EXD_ORD).toString();
				String strNXT_EXD_YN = objJob.get(ProtocolID.NXT_EXD_YN).toString();
				String strBCK_OPT_CD = objJob.get(ProtocolID.BCK_OPT_CD).toString();
				String strBCK_BSN_DSCD = objJob.get(ProtocolID.BCK_BSN_DSCD).toString();
				String strDB_ID = objJob.get(ProtocolID.DB_ID).toString();
				if(strDB_ID == null || strDB_ID.equals("")) {
					strDB_ID = "1";
				}				
				String strBCK_FILE_PTH = objJob.get(ProtocolID.BCK_FILE_PTH).toString();
				String strLOG_YN = objJob.get(ProtocolID.LOG_YN).toString();
				String strBCK_FILENM = objJob.get(ProtocolID.BCK_FILENM).toString();
				String strDB_SVR_IPADR_ID = objJob.get(ProtocolID.DB_SVR_IPADR_ID).toString();
				if(strDB_SVR_IPADR_ID == null || strDB_SVR_IPADR_ID.equals("")) {
					strDB_SVR_IPADR_ID = "1";
				}				
				String strBSN_DSCD = objJob.get(ProtocolID.BSN_DSCD).toString();

				int intSeq = service.selectQ_WRKEXE_G_01_SEQ();

				WrkExeVO vo = new WrkExeVO();
				vo.setEXE_SN(intSeq);
				vo.setSCD_ID(Integer.parseInt(strSCD_ID));
				vo.setWRK_ID(Integer.parseInt(strWORK_ID));
				vo.setEXE_RSLT_CD("");
				vo.setBCK_OPT_CD(strBCK_OPT_CD);
				vo.setDB_ID(Integer.parseInt(strDB_ID));
				vo.setBCK_FILE_PTH(strBCK_FILE_PTH);
				vo.setEXE_GRP_SN(intGrpSeq);
				vo.setSCD_CNDT(TC001802); // 실행중
				vo.setDB_SVR_IPADR_ID(Integer.parseInt(strDB_SVR_IPADR_ID));

				// RMAN 백업일경우, Validation 은 스케줄 수행 정보나 이력을 업데이트 하지 않음
				if (strLOG_YN.equals("Y")) {
					// 스케줄 상태변경
					socketLogger.info("[ 스케줄 상태 변경 ]   " + vo.getSCD_CNDT() + " 실행중" );	
					service.updateSCD_CNDT(vo);

					// 스케줄 이력등록
					socketLogger.info("[ 스케줄 수행이력 등록 ]  " );	
					service.insertT_WRKEXE_G(vo);
				}else{
					socketLogger.info("[ 백업 Validate 실행 ]  " );	
				}

				String strCommand = objJob.get(ProtocolID.REQ_CMD).toString();

				socketLogger.info("[ 명령어 ] " + strCommand);

				RunCommandExec r = new RunCommandExec(strCommand);
				
				socketLogger.info("[ 백업시작 ]  " );			
				
				r.start();
				try {							
					r.join();
				} catch (InterruptedException ie) {
					ie.printStackTrace();
				}
				String retVal = r.call();
				String strResultMessge = r.getMessage();

				socketLogger.info("[ 결과 ] " + retVal);

				
				// socketLogger.info("##### 결과 : " + retVal + " message : " +
				// strResultMessge);
				// 다음실행여부가 Y 이면 에러나도 다음 시행함.
				if (retVal.equals("success")) {
					String strFileName = strBCK_FILENM;
					String strFileSize = "0";

					
					//TC001901 : 백업 업무구분코드
					if(strBSN_DSCD.equals(TC001901)) {
						//RMAN 백업
						if(strBCK_BSN_DSCD.equals(TC000201)){
							strFileSize = "0";
							strFileName = "";
							
							WrkExeVO endVO = new WrkExeVO();
							endVO.setEXE_RSLT_CD(strResultCode);
							endVO.setEXE_SN(intSeq);
							endVO.setFILE_SZ(Long.parseLong(strFileSize));
							endVO.setBCK_FILENM(strFileName);
							endVO.setRSLT_MSG(retVal + " " + strResultMessge);				
							endVO.setSCD_ID(Integer.parseInt(strSCD_ID));
							endVO.setSCD_CNDT(TC001801); // 대기중
							
							
							if (strLOG_YN.equals("Y")) {
								// 스케줄 상태변경 - console에서 변경 처리하는 것으로 변경
								socketLogger.info("[ 스케줄 상태 변경 ]   " + endVO.getSCD_CNDT() + " 대기중" );	
								service.updateSCD_CNDT(endVO);
								
								socketLogger.info("[ 스케줄 수행이력 업데이트 ]   " + endVO.getEXE_RSLT_CD() + " 성공" );	
								service.updateT_WRKEXE_G(endVO);
								
								socketLogger.info("[SUCCESS] DxT005 SCD_ID[" + strSCD_ID + "] " + retVal + " " + strResultMessge);

							}
						}else if (strBCK_BSN_DSCD.equals(TC000202)) {					
							socketLogger.info("[  덤프백업,  유지갯수 및 보관일수 처리 ] " );
	
							// 백업파일관리
							// BCK_MTN_ECNT(백업유지개수) FILE_STG_DCNT(파일보관일수)
							// 백업유지개수
							String strBCK_MTN_ECNT = objJob.get(ProtocolID.BCK_MTN_ECNT).toString();
							int intBCK_MTN_ECNT = Integer.parseInt(strBCK_MTN_ECNT);
							
							// 파일보관일수
							String strFILE_STG_DCNT = objJob.get(ProtocolID.FILE_STG_DCNT).toString();
							int intFILE_STG_DCNT = Integer.parseInt(strFILE_STG_DCNT);
	
							String strSlush = "/";
	
							if (!strBCK_FILE_PTH.contentEquals("")) {
								String strSl = strBCK_FILE_PTH.substring(strBCK_FILE_PTH.length() - 1,
										strBCK_FILE_PTH.length());
								if (strSl.equals("/")) {
									strSlush = "";
								}
							}
	
							String strCmd = "ls -al " + strBCK_FILE_PTH + strSlush + strFileName + " | awk '{print $5}'";
							
							if(strCommand.contains("directory")) {
								strCmd = "du " + strBCK_FILE_PTH + strSlush + strFileName + " | awk '{print $1}'";
							}
							
							CommonUtil util = new CommonUtil();
							
							strFileSize = util.getPidExec(strCmd);
							
							util = null;
	
							socketLogger.info(" [ File COMMAND ] " + strCmd);
	
							// socketLogger.info("##### strFileSize cmd : " + strCmd );
							// socketLogger.info("##### strFileSize : " + strFileSize );
	
							if (strFileSize == null)
								strFileSize = "0";
							String[] sarrFileName = strFileName.split("_");
							String fileName = sarrFileName[0] + "_" + sarrFileName[1];
							
							//백업파일관리
							dumpFileManagement(strBCK_FILE_PTH, fileName, intBCK_MTN_ECNT, intFILE_STG_DCNT, strSlush);
							
													
							//아래 코드 있을 이유 확인 해봐야 함
							if (strFileSize == null || strFileSize.equals("0")) {
								WrkExeVO endVO = new WrkExeVO();
								endVO.setEXE_RSLT_CD(TC001702);
								endVO.setEXE_SN(intSeq);
								endVO.setRSLT_MSG("An Error is Zero File Size");
	
								endVO.setSCD_ID(Integer.parseInt(strSCD_ID));
								endVO.setSCD_CNDT(TC001801); // 대기중
	
								
								socketLogger.info("[ 스케줄 상태 변경 ]   " + endVO.getSCD_CNDT() + " 대기중" );	
								service.updateSCD_CNDT(endVO);
	
								// 스캐줄 이력 update
								socketLogger.info("[ 스케줄 수행이력 업데이트 ]   " + endVO.getEXE_RSLT_CD() + " 실패" );	
								service.updateT_WRKEXE_G(endVO);
	
								if (strNXT_EXD_YN.toLowerCase().equals("y")) {
									continue;
								} else {
									break;
								}
							}else{
								WrkExeVO endVO = new WrkExeVO();
								endVO.setEXE_RSLT_CD(strResultCode);
								endVO.setEXE_SN(intSeq);
								endVO.setRSLT_MSG(retVal + " " + strResultMessge);
								endVO.setFILE_SZ(Long.parseLong(strFileSize));
								endVO.setBCK_FILENM(strFileName);
								endVO.setSCD_ID(Integer.parseInt(strSCD_ID));
								endVO.setSCD_CNDT(TC001801); // 대기중
	
								
								socketLogger.info("[ 스케줄 상태 변경 ]   " + endVO.getSCD_CNDT() + " 대기중" );	
								service.updateSCD_CNDT(endVO);
	
								// 스캐줄 이력 update
								socketLogger.info("[ 스케줄 수행이력 업데이트 ]   " + endVO.getEXE_RSLT_CD() + " 성공" );	
								service.updateT_WRKEXE_G(endVO);
								
								socketLogger.info("[SUCCESS] DxT005 SCD_ID[" + strSCD_ID + "] " + retVal + " " + strResultMessge);
			
							}
						}
					}else{
						
						socketLogger.info(" [ SCRIPT / DB2PG 수행 후, 프로세스 ] ");
						
						strFileSize = "0";
						strFileName = "";
						
						WrkExeVO endVO = new WrkExeVO();
						endVO.setEXE_RSLT_CD(strResultCode);
						endVO.setEXE_SN(intSeq);
						endVO.setFILE_SZ(Long.parseLong(strFileSize));
						endVO.setBCK_FILENM(strFileName);
						endVO.setRSLT_MSG(retVal + " " + strResultMessge);				
						endVO.setSCD_ID(Integer.parseInt(strSCD_ID));
						endVO.setSCD_CNDT(TC001801); // 대기중

						// 스케줄 상태변경 - console에서 변경 처리하는 것으로 변경
						socketLogger.info("[ 스케줄 상태 변경 ]   " + endVO.getSCD_CNDT() + " 대기중" );	
						service.updateSCD_CNDT(endVO);

						socketLogger.info("[ 스케줄 수행이력 업데이트 ]   " + endVO.getEXE_RSLT_CD() + " 성공" );	
						service.updateT_WRKEXE_G(endVO);				
						
						socketLogger.info("[SUCCESS] DxT005 SCD_ID[" + strSCD_ID + "] " + retVal + " " + strResultMessge);
	
					}
				
					continue;
					
				} else {
					
					//실패했을  경우
					strResultCode = TC001702;

					errLogger.error("[ERROR] DxT005 SCD_ID[" + strSCD_ID + "] {} ", retVal + " " + strResultMessge);

					WrkExeVO endVO = new WrkExeVO();
					endVO.setEXE_RSLT_CD(strResultCode);
					endVO.setEXE_SN(intSeq);
					endVO.setRSLT_MSG(retVal + " " + strResultMessge);

					endVO.setSCD_ID(Integer.parseInt(strSCD_ID));
					endVO.setSCD_CNDT(TC001801); // 대기중

					// 스케줄 상태변경
					socketLogger.info("[ 스케줄 상태 변경 ]   " + endVO.getSCD_CNDT() + " 대기중" );	
					service.updateSCD_CNDT(endVO);
									
					socketLogger.info("[  스케줄 수행이력 업데이트 ]   " +  strResultCode + " 실패" );	
					service.updateT_WRKEXE_G(endVO);

					if (strNXT_EXD_YN.toLowerCase().equals("y")) {
						continue;
					} else {
						break;
					}
				}
			}
			
			// socketLogger.info("send start");
			outputObj = DxT005ResultJSON(strDxExCode, strSuccessCode, strErrCode, strErrMsg);
			sendBuff = outputObj.toString().getBytes();

			send(TotalLengthBit, sendBuff);
			
			sendBuff = null;
			
		} catch (Exception e) {
			errLogger.error("[ERROR] DxT005 {} ", e.toString());
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT005);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT005);
			outputObj.put(ProtocolID.ERR_MSG, "DxT005 Error [" + e.toString() + "]");

			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
		} finally {
			outputObj = null;
			sendBuff = null;
		}
	}

	

	
	/**
	 * dump 백업시 BCK_MTN_ECNT(백업유지개수) FILE_STG_DCNT(파일보관일수) 관리
	 * 
	 * @param filePath
	 * @param fileName
	 * @param BCK_MTN_ECNT (백업유지개수)
	 * @param FILE_STG_DCNT (파일보관일수)
	 * @throws Exception
	 */
	private void dumpFileManagement(String filePath, String fileName, int BCK_MTN_ECNT, int FILE_STG_DCNT, String strSlush)
			throws Exception {
		FileListSearcher fs = new FileListSearcher(filePath);

		List<HashMap<String, String>> resultFileList = new ArrayList<HashMap<String, String>>();

		List<FileEntry> fileList = fs.getSearchFiles();

		Collections.sort(fileList, new CompareSeqDesc());

		Calendar cal = Calendar.getInstance();
		long todayMil = cal.getTimeInMillis(); // 현재 시간(밀리 세컨드)
		long oneDayMil = 24 * 60 * 60 * 1000; // 일 단위

		Calendar fileCal = Calendar.getInstance();
		Date fileDate = null;

		int intCount = 0;
		for (FileEntry fn : fileList) {

			String strDumpFileName = fn.getFileName();
			long strLastModified = fn.getLastModified();

			if (strDumpFileName.contains(fileName)) {
				
				String strBachupFile = filePath + strSlush +  strDumpFileName;
				
				//1. 파일보관일수 많큼 파일을 보관한다.
				fileDate = new Date(strLastModified);
				// 현재시간과 파일 수정시간 시간차 계산(단위 : 밀리 세컨드)
				fileCal.setTime(fileDate);
				long diffMil = todayMil - fileCal.getTimeInMillis();

				// 날짜로 계산
				int diffDay = (int) (diffMil / oneDayMil);
				
				if(diffDay > FILE_STG_DCNT) {
					if(FileUtil.isFile(strBachupFile)) {
						FileUtil.fileDelete(strBachupFile);
					}
				}
				
				//2. 백업유지 개수 많큼 파일을 유지한다.
				if (intCount >= BCK_MTN_ECNT) {
					if(FileUtil.isFile(strBachupFile)) {
						FileUtil.fileDelete(strBachupFile);
					}
				}
				intCount++;

			}

		}
	}

	public static void main(String[] args) {
		 String filePath = "C:\\k4m\\01-1. DX 제폼개발\\04. 시험\\test";
		String fileName = "experdb_1_20180402";
		String[] sarrFileName = fileName.split("_");
		fileName = sarrFileName[0] + "_" + sarrFileName[1];
		
		 DxT005 test = new DxT005();
		 try {
			test.dumpFileManagement(filePath, fileName, 0, 0, "/");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}
}
