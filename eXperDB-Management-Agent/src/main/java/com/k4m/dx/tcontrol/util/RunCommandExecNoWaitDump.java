package com.k4m.dx.tcontrol.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.k4m.dx.tcontrol.DaemonStart;
import com.k4m.dx.tcontrol.db.repository.service.SystemServiceImpl;
import com.k4m.dx.tcontrol.db.repository.vo.DumpRestoreVO;
import com.k4m.dx.tcontrol.db.repository.vo.RmanRestoreVO;


/**
* @author 박태혁
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2018.04.23   박태혁 최초 생성
*      </pre>
*/
public class RunCommandExecNoWaitDump extends Thread {

	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	private static String SUCCESS = "0"; // 성공
	private static String RUNNING = "2"; // 실행중
	private static String FAILED = "3"; // 실패
	
	private String CMD = null;
	private int intRestore_sn;
	
	public String retVal = null;
	public String consoleTxt = null;
	
	private String returnMessage = "";
	
	public RunCommandExecNoWaitDump(){}
	
	public RunCommandExecNoWaitDump(String cmd,  int intRestore_sn){
		this.CMD = cmd;

		this.intRestore_sn = intRestore_sn;
	}
	
	@Override
	public void run(){
		synchronized(this){
			runExecRtn2(CMD);
			
			notify();
		}
	}
	
	
	
	public void runExecRtn2(String cmd){
		Process proc = null;
		String strResult = "";
		String strScanner = "";
		String strReturnVal = "";
		String strResultErrInfo = "";
		
		String logDir = "../logs/pg_resLog/";
		String strRestore_sn = Integer.toString(intRestore_sn);
		String strLogFileName = "restore_dump_" + strRestore_sn + ".log";
		
		SystemServiceImpl service = (SystemServiceImpl) DaemonStart.getContext().getBean("SystemService");
		
		try{

			proc = Runtime.getRuntime().exec(new String[]{"/bin/sh", "-c", cmd}); 
			proc.waitFor ();
			
			// socketLogger.info("proc.exitValue() --> " + proc.exitValue());

			if ( proc.exitValue() != 0 ) {
				BufferedReader out = new BufferedReader ( new InputStreamReader ( proc.getInputStream() ) );
				while ( out.ready() ) {
					strResultErrInfo += out.readLine();
				}
				out.close();
				
				BufferedReader err = new BufferedReader ( new InputStreamReader ( proc.getErrorStream() ) );
				while ( err.ready() ) {
					strResult += err.readLine();
				}
				
    			
    			DumpRestoreVO failVo = new DumpRestoreVO();
    			failVo.setRESTORE_SN(intRestore_sn);
    			failVo.setRESTORE_CNDT(FAILED);
    			
    			// restore running end
    			service.updateDUMP_RESTORE_CNDT(failVo);
    			
				strResult += strResultErrInfo;
				socketLogger.info("err.ready() --> " + strResult);
				
				String strFilePath = logDir + strLogFileName;
				
				socketLogger.info("strFilePath --> " + strFilePath);
				
				FileUtil.writeFile(strFilePath, strResult);
				err.close();
				strReturnVal = "failed";
			} else {
				BufferedReader out = new BufferedReader ( new InputStreamReader ( proc.getInputStream() ) );

				while ( out.ready() ) {
					strResult += out.readLine();
					
					socketLogger.info("out.ready() --> " + strResult);
				}
				
				DumpRestoreVO successVo = new DumpRestoreVO();
    			successVo.setRESTORE_SN(intRestore_sn);
    			successVo.setRESTORE_CNDT(SUCCESS);
    			
    			// restore running end
    			service.updateDUMP_RESTORE_CNDT(successVo);
    			
				out.close();
				strReturnVal = "success";
			}
			
			DumpRestoreVO logVo = new DumpRestoreVO();
			logVo.setRESTORE_SN(intRestore_sn);
			logVo.setEXELOG(strResult);
			
			// exelog update
			service.updateDUMP_RESTORE_EXELOG(logVo);

			this.returnMessage = strResult;
			this.retVal = strReturnVal;
		}catch(IOException e){
			System.out.println(e);
			this.retVal = "IOException" + e.toString();
			this.returnMessage = "IOException" + e.toString();
		}catch(Exception e){
			System.out.println(e);
			this.retVal = "Exception" + e.toString();
			this.returnMessage = "Exception" + e.toString();
		} finally {
			proc.destroy();
			System.out.println("Exec End");
		}
	}
	

	
	public static void main(String[] args) throws Exception {
		RunCommandExec runCommandExec = new RunCommandExec();
		
		String path = runCommandExec.getClass().getResource("/").getPath();
		
		System.out.println(path);

		
	}
}
