package com.k4m.dx.tcontrol.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.net.Socket;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.k4m.dx.tcontrol.DaemonStart;
import com.k4m.dx.tcontrol.db.repository.service.SystemServiceImpl;
import com.k4m.dx.tcontrol.db.repository.vo.RmanRestoreVO;
import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;
import com.k4m.dx.tcontrol.util.ExecRmanReplaceTableSpace;
import com.k4m.dx.tcontrol.util.FileUtil;
import com.k4m.dx.tcontrol.util.RepTableSpaceWrap;
import com.k4m.dx.tcontrol.util.RunCommandExecNoWait;

/**
 * RMAN Restore 실행
 *
 * @author 박태혁
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2019.01.14   박태혁 최초 생성
 *      </pre>
 *      
 */

public class DxT028 extends SocketCtl {

	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");

	private static String SUCCESS = "0"; // 성공
	private static String RUNNING = "2"; // 실행중
	private static String FAILED = "3"; // 실패


	public DxT028(Socket socket, BufferedInputStream is, BufferedOutputStream os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public DxT028() {
		// TODO Auto-generated constructor stub
	}

	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		socketLogger.info("DxT028.execute : " + strDxExCode);

		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
		
		String strRestore_sn = (String) jObj.get(ProtocolID.RESTORE_SN);
		int intRestore_sn = Integer.parseInt(strRestore_sn);
		
		//백업경로
		String strPGRBAK = (String) jObj.get(ProtocolID.PGRBAK);
		
		// location of the database storage area
		String strPGDATA = (String) jObj.get(ProtocolID.PGDATA);
		
		//location of archive WAL storage area
		String strPGALOG = (String) jObj.get(ProtocolID.PGALOG);
		
		//location of server log storage area
		String strSRVLOG = (String) jObj.get(ProtocolID.SRVLOG);
		
		//복구상태 긴급복구(0), 시점복구(1)
		String strRESTORE_FLAG = (String) jObj.get(ProtocolID.RESTORE_FLAG);
		
		//TIMELINE
		String strTIMELINE = (String) jObj.get(ProtocolID.TIMELINE);
		
		//find + strPGRBAK + "-name \"mkdirs.sh\" -exec perl -pi -e 's/-p \//-p \/" + strCMD_RMAN_RESTORE_PATH + "\//g' {} \;
		
		String SPACE = " ";
		String VERBOSE = "--verbose";
		String PGDATA = "--pgdata=" + strPGDATA;
		String ARCLOG = "--arclog-path=" + strPGALOG;
		String SRVLOG = "--srvlog-path" + strSRVLOG;
		String TIMELINE = "--recovery-target-time=" + strTIMELINE;
		String logDir = "./pg_resLog/" ;
		String strLogFileName = "restore_" + strRestore_sn + ".log";
		
		FileUtil.createFileDir(logDir);
		
		StringBuffer sbRestoreCmd = new StringBuffer();
		sbRestoreCmd.append("pg_rman restore")
		                .append(SPACE).append(VERBOSE)
		                .append(SPACE).append(PGDATA)
		                .append(SPACE).append(ARCLOG)
		                .append(SPACE).append(SRVLOG);
						
		
		if(strRESTORE_FLAG.equals("1")) {
			sbRestoreCmd.append(SPACE).append(TIMELINE);
		}
		
		sbRestoreCmd.append(SPACE).append(">>");
		sbRestoreCmd.append(SPACE).append(logDir).append(strLogFileName);
		
		
		String strRESTORE_DIR = (String) jObj.get(ProtocolID.RESTORE_DIR);
		//기존/신규 구분
		String strASIS_FLAG = (String) jObj.get(ProtocolID.ASIS_FLAG);

		JSONObject outputObj = new JSONObject();
		
		SystemServiceImpl service = (SystemServiceImpl) DaemonStart.getContext().getBean("SystemService");


		try {
			
			RmanRestoreVO vo = new RmanRestoreVO();
			vo.setRESTORE_SN(intRestore_sn);
			vo.setRESTORE_CNDT(RUNNING);
			
			// restore running start
			service.updateRMAN_RESTORE_CNDT(vo);
			
			if(strASIS_FLAG.equals("1")) {
				RepTableSpaceWrap repTableSpaceWrap = new RepTableSpaceWrap(jObj, strPGRBAK, strRESTORE_DIR);
				repTableSpaceWrap.start();
				
				synchronized(repTableSpaceWrap) {
					try {
						repTableSpaceWrap.wait();
	                }catch(InterruptedException e){
	                    e.printStackTrace();
	                    
	        			RmanRestoreVO endVo = new RmanRestoreVO();
	        			endVo.setRESTORE_SN(intRestore_sn);
	        			endVo.setRESTORE_CNDT(FAILED);
	        			
	        			// restore running end
	        			service.updateRMAN_RESTORE_CNDT(vo);
	                }
					
	                RunCommandExecNoWait runCommandExecNoWait = new RunCommandExecNoWait(sbRestoreCmd.toString(), intRestore_sn);
	                runCommandExecNoWait.start();
	                
				}
			} else {
                RunCommandExecNoWait runCommandExecNoWait = new RunCommandExecNoWait(sbRestoreCmd.toString(), intRestore_sn);
                runCommandExecNoWait.start();
			}
			
			

			// socketLogger.info("send start");
			outputObj = CommonResultJSON(strDxExCode, strSuccessCode, strErrCode, strErrMsg);
			sendBuff = outputObj.toString().getBytes();

			send(TotalLengthBit, sendBuff);
			
			sendBuff = null;
			// socketLogger.info("send end");

		} catch (Exception e) {
			errLogger.error("[ERROR] DxT028 {} ", e.toString());
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT028);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT028);
			outputObj.put(ProtocolID.ERR_MSG, "DxT028 Error [" + e.toString() + "]");

			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
		} finally {
			outputObj = null;
			sendBuff = null;
		}
	}

}
