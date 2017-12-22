package com.k4m.dx.tcontrol.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.net.Socket;

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
 * 백업 실행
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

public class DxT005 extends SocketCtl{
	
	private static Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private static Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	private static String TC001801 = "TC001801"; //대기
	private static String TC001802 = "TC001801"; //실행중

	
	
	ApplicationContext context;
	
	public DxT005(Socket socket, BufferedInputStream is, BufferedOutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public void execute(String strDxExCode, JSONArray arrCmd) throws Exception {
		socketLogger.info("DxT005.execute : " + strDxExCode);
		
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
		

		JSONArray outputArray = new JSONArray();
		JSONObject outputObj = new JSONObject();
		
		context = new ClassPathXmlApplicationContext(new String[] {"context-tcontrol.xml"});
		SystemServiceImpl service = (SystemServiceImpl) context.getBean("SystemService");
		
		String strResultCode = "TC001701";

		try {
			
			int intGrpSeq = service.selectQ_WRKEXE_G_02_SEQ();

			for(int i=0;i<arrCmd.size();i++){
				//System.out.println("Start : "+ (i+1));
				
				JSONObject objJob = (JSONObject) arrCmd.get(i);
				

				
				String strSCD_ID = objJob.get(ProtocolID.SCD_ID).toString();
				String strWORK_ID = objJob.get(ProtocolID.WORK_ID).toString();
				String strEXD_ORD = objJob.get(ProtocolID.EXD_ORD).toString();
				String strNXT_EXD_YN = objJob.get(ProtocolID.NXT_EXD_YN).toString();
				String strBCK_OPT_CD = objJob.get(ProtocolID.BCK_OPT_CD).toString();
				String strBCK_BSN_DSCD = objJob.get(ProtocolID.BCK_BSN_DSCD).toString(); 
				String strDB_ID = objJob.get(ProtocolID.DB_ID).toString();
				String strBCK_FILE_PTH = objJob.get(ProtocolID.BCK_FILE_PTH).toString();
				String strLOG_YN = objJob.get(ProtocolID.LOG_YN).toString();
				String strBCK_FILENM = objJob.get(ProtocolID.BCK_FILENM).toString();

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
				vo.setSCD_CNDT(TC001802); //실행중
				
				if(strLOG_YN.equals("Y")) {
					//스케줄 상태변경
					service.updateSCD_CNDT(vo);
					
					//스케줄 이력등록
					service.insertT_WRKEXE_G(vo);
				}
				
				String strCommand = objJob.get(ProtocolID.REQ_CMD).toString();

				socketLogger.info("[COMMAND] " + strCommand);

				RunCommandExec r = new RunCommandExec(strCommand);
				r.start();
				try{
					r.join();
				}catch(InterruptedException ie){
					ie.printStackTrace();
				}
				String retVal = r.call();
				String strResultMessge = r.getMessage();
				
				//socketLogger.info("##### 결과 : " + retVal + " message : " + strResultMessge);
				//다음실행여부가 Y 이면 에러나도 다음 시행함.
				if(retVal.equals("success")) {
					String strFileName = strBCK_FILENM;
					String strFileSize = "";
					
					//dump 일경우만 실행
					if(strBCK_BSN_DSCD.equals("TC000202")) {
						
						String strSlush = "/";

						if(!strBCK_FILE_PTH.contentEquals("")) {
							String strSl = strBCK_FILE_PTH.substring(strBCK_FILE_PTH.length()-1, strBCK_FILE_PTH.length());
							if(strSl.equals("/")) {
								strSlush = "";
							}
						}
						
						String strCmd = "ls -al " + strBCK_FILE_PTH + strSlush + strFileName + " | awk '{print $5}'";
						strFileSize = CommonUtil.getPidExec(strCmd);
						
						socketLogger.info("[File COMMAND] " + strCmd);
						
						
						//socketLogger.info("##### strFileSize cmd : " + strCmd );
						//socketLogger.info("##### strFileSize : " + strFileSize );
						
						if(strFileSize == null) strFileSize = "0";
						
						if(strFileSize == null || strFileSize.equals("0")) {
							
							
							WrkExeVO endVO = new WrkExeVO();
							endVO.setEXE_RSLT_CD("TC001702");
							endVO.setEXE_SN(intSeq);
							endVO.setRSLT_MSG("An Error is Zero File Size");
							
							endVO.setSCD_ID(Integer.parseInt(strSCD_ID));
							endVO.setSCD_CNDT(TC001801); //대기중
							
							//스케줄 상태변경
							service.updateSCD_CNDT(endVO);
							
							//스캐줄 이력 update
							service.updateT_WRKEXE_G(endVO);
							
							if(strNXT_EXD_YN.equals("y")) {
								continue;
							} else {
								break;
							}
							
						}
					
					} else {
						strFileSize = "0";
						strFileName = "";
					}
					
					WrkExeVO endVO = new WrkExeVO();
					endVO.setEXE_RSLT_CD(strResultCode);
					endVO.setEXE_SN(intSeq);
					endVO.setFILE_SZ(Integer.parseInt(strFileSize));
					endVO.setBCK_FILENM(strFileName);
					endVO.setRSLT_MSG(retVal + " " + strResultMessge);
					
					endVO.setSCD_ID(Integer.parseInt(strSCD_ID));
					endVO.setSCD_CNDT(TC001801); //대기중
					
					//스케줄 상태변경
					service.updateSCD_CNDT(endVO);
					
					if(strLOG_YN.equals("Y")) {
						socketLogger.info("[SUCCESS] DxT005 SCD_ID[" + strSCD_ID + "] " + retVal + " " + strResultMessge);
						
						service.updateT_WRKEXE_G(endVO);
					}
					
					continue;
				} else {
					
					errLogger.error("[ERROR] DxT005 SCD_ID[" + strSCD_ID + "] ", retVal + " " + strResultMessge);
					
					strResultCode = "TC001702";
					
					WrkExeVO endVO = new WrkExeVO();
					endVO.setEXE_RSLT_CD(strResultCode);
					endVO.setEXE_SN(intSeq);
					endVO.setRSLT_MSG(retVal + " " + strResultMessge);
					
					endVO.setSCD_ID(Integer.parseInt(strSCD_ID));
					endVO.setSCD_CNDT(TC001801); //대기중
					
					//스케줄 상태변경
					service.updateSCD_CNDT(endVO);
					
					service.updateT_WRKEXE_G(endVO);
					
					if(strNXT_EXD_YN.equals("y")) {
						continue;
					} else {
						break;
					}
				}
				
				//완료 건 update

				//System.out.println("retVal "+(i+1)+" : "+ retVal);
			}
			//socketLogger.info("send start");
			outputObj = DxT005ResultJSON(strDxExCode, strSuccessCode, strErrCode, strErrMsg);
			sendBuff = outputObj.toString().getBytes();
			
			send(TotalLengthBit, sendBuff);
			
			//socketLogger.info("send end");

		} catch (Exception e) {
			errLogger.error("[ERROR] DxT005 {} ", e.toString());
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT005);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT005);
			outputObj.put(ProtocolID.ERR_MSG, "DxT005 Error [" + e.toString() + "]");
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
		} finally {

		}	    
	}
	
	public static void main(String[] args) {
		//String test = "/k4m/DxTcontrolWorkspace/";
		//String test2 = test.substring(test.length()-1, test.length());
		
		try {
		String strCmd = "df";
		String result = CommonUtil.getPidExec(strCmd);
		
		System.out.println("@@@@@@@@@@@@@@@@" + result);
		} catch (Exception e) {
			
		}
	}
}
