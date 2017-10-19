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
		
		socketLogger.info("execute(String strDxExCode, JSONArray arrCmd)");

		JSONArray outputArray = new JSONArray();
		JSONObject outputObj = new JSONObject();
		
		context = new ClassPathXmlApplicationContext(new String[] {"context-tcontrol.xml"});
		SystemServiceImpl service = (SystemServiceImpl) context.getBean("SystemService");
		
		String strResultCode = "TC001701";

		try {

			for(int i=0;i<arrCmd.size();i++){
				System.out.println("Start : "+ (i+1));
				
				JSONObject objJob = (JSONObject) arrCmd.get(i);
				
				
				String strSCD_ID = objJob.get(ProtocolID.SCD_ID).toString();
				String strWORK_ID = objJob.get(ProtocolID.WORK_ID).toString();
				String strEXD_ORD = objJob.get(ProtocolID.EXD_ORD).toString();
				String strNXT_EXD_YN = objJob.get(ProtocolID.NXT_EXD_YN).toString();
				String strBCK_OPT_CD = objJob.get(ProtocolID.BCK_OPT_CD).toString();
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
				
				if(strLOG_YN.equals("Y")) {
					service.insertT_WRKEXE_G(vo);
				}
				
				String strCommand = objJob.get(ProtocolID.REQ_CMD).toString();

				socketLogger.info(strCommand);

				RunCommandExec r = new RunCommandExec(strCommand);
				r.start();
				try{
					r.join();
				}catch(InterruptedException ie){
					ie.printStackTrace();
				}
				String retVal = r.call();
				
				socketLogger.info("##### 결과 : " + retVal);
				//다음실행여부가 Y 이면 에러나도 다음 시행함.
				if(retVal.equals("success")) {
					String strFileName = strBCK_FILENM;
					String strFileSize = "";
					
					//dump 일경우만 실행
					if(strBCK_OPT_CD.equals("TC000202")) {
						
						String strSlush = "/";

						if(!strBCK_FILE_PTH.contentEquals("")) {
							String strSl = strBCK_FILE_PTH.substring(strBCK_FILE_PTH.length()-1, strBCK_FILE_PTH.length());
							if(strSl.equals("/")) {
								strSlush = "";
							}
						}
						
						String strCmd = "ls -al " + strBCK_FILE_PTH + strSlush + strFileName + " | awk '{print $5}'";
						strFileSize = CommonUtil.getPidExec(strCmd);
						
						
						socketLogger.info("##### strFileSize cmd : " + strCmd );
						socketLogger.info("##### strFileSize : " + strFileSize );
						
						if(strFileSize == null) strFileSize = "0";
						
						if(strFileSize == null || strFileSize.equals("0")) {
							
							
							WrkExeVO endVO = new WrkExeVO();
							endVO.setEXE_RSLT_CD("TC001702");
							endVO.setEXE_SN(intSeq);
							endVO.setRSLT_MSG("An Error is Zero File Size");
							
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
					endVO.setRSLT_MSG(retVal);
					
					if(strLOG_YN.equals("Y")) {
						service.updateT_WRKEXE_G(endVO);
					}
					
					continue;
				} else {
					strResultCode = "TC001702";
					
					WrkExeVO endVO = new WrkExeVO();
					endVO.setEXE_RSLT_CD(strResultCode);
					endVO.setEXE_SN(intSeq);
					endVO.setRSLT_MSG(retVal);
					
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
			socketLogger.info("send start");
			outputObj = DxT005ResultJSON(strDxExCode, strSuccessCode, strErrCode, strErrMsg);
			sendBuff = outputObj.toString().getBytes();
			
			send(TotalLengthBit, sendBuff);
			
			socketLogger.info("send end");

		} catch (Exception e) {
			errLogger.error("DxT005 {} ", e.toString());
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
		String test = "/k4m/DxTcontrolWorkspace/";
		String test2 = test.substring(test.length()-1, test.length());
		
		System.out.println("@@@@@@@@@@@@@@@@" + test2);
	}
}
