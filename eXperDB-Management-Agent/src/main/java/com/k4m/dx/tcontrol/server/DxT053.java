package com.k4m.dx.tcontrol.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.FileReader;
import java.net.Socket;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.k4m.dx.tcontrol.db.repository.service.SystemServiceImpl;
import com.k4m.dx.tcontrol.db.repository.vo.RmanRestoreVO;
import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;
import com.k4m.dx.tcontrol.util.CommonUtil;
import com.k4m.dx.tcontrol.util.RunCommandExec;

public class DxT053 extends SocketCtl {
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");

	ApplicationContext context;
	
	public DxT053(Socket socket, BufferedInputStream is, BufferedOutputStream os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	@SuppressWarnings("unchecked")
	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		socketLogger.info("DxT053.execute : " + strDxExCode);
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
		String restoreCmd = "";
		RmanRestoreVO vo = new RmanRestoreVO();

		CommonUtil util = new CommonUtil();
		JSONObject outputObj = new JSONObject();
		
		context = new ClassPathXmlApplicationContext(new String[] { "context-tcontrol.xml" });
		SystemServiceImpl service = (SystemServiceImpl) context.getBean("SystemService");

		try {
			String pgBlogPathCmd = "echo $PGBLOG";
			String pgBlogPath = util.getPidExec(pgBlogPathCmd);

			String restoreType = String.valueOf(jObj.get(ProtocolID.RESTORE_FLAG));
			String exelog = String.valueOf(jObj.get(ProtocolID.EXELOG));
			
			String restoreWrkName = String.valueOf(jObj.get(ProtocolID.WRK_NM));
			
			vo.setEXELOG(exelog);

			// 복구 타입에 따른 명령어
			if (restoreType.equals("full")) {
				restoreCmd = "pgbackrest --stanza=experdb --config=$PGHOME/etc/pgbackrest/config/" + restoreWrkName + ".conf --delta restore > "
						+ pgBlogPath + "/" + exelog + ".log";
			} else {
				String time_restore = String.valueOf(jObj.get(ProtocolID.TIME_RESTORE));
				restoreCmd = "pgbackrest --stanza=experdb --config=$PGHOME/etc/pgbackrest/config/" + restoreWrkName + ".conf --type=time \"--target="
						+ time_restore + "\" --target-action=promote --delta restore > " + pgBlogPath + "/" + exelog + ".log";
			}

			RunCommandExec r = new RunCommandExec(restoreCmd);
			r.start();

			try {
				r.join();
			} catch (InterruptedException ie) {
				ie.printStackTrace();
			}

			String retVal = r.call();
			String strResultMessage = r.getMessage();
			if (retVal.equals("success")) {
				// LOG에서 restore size & 수행시간

				String configPath = pgBlogPath + "/" + exelog + ".log";
				BufferedReader br = new BufferedReader(new FileReader(configPath));
				String restoreFileSize = "";
				String elapsedTime = "";
				
				String fileContent;
				while ((fileContent = br.readLine()) != null) {
					if(fileContent.contains("restore size")) {
						String restoreSizeArray[] = fileContent.split("=");
						String restoreSize[] = restoreSizeArray[1].trim().split(",");
						
						restoreFileSize = restoreSize[0];
						
						vo.setRESTORE_SIZE(restoreFileSize);
					}
					
					if(fileContent.contains("successfully")) {
						String elapsedTimeArray[] = fileContent.split("\\(");
						elapsedTime = elapsedTimeArray[1].replace("ms)", " ").trim();
						
						vo.setELAPSED_TIME(elapsedTime);
					}
				}
				
				br.close();
				
				vo.setRESTORE_CNDT("0");
				
//				if(restore_type.equals("pitr")) {
//					String pgRecoveryCmd = "rm -rf $PGDATA/recovery.signal";
//					util.getPidExec(pgRecoveryCmd);
//				}
//				
//				String pgStartCmd = "pg_ctl start";
//				util.getPidExec(pgStartCmd);
				
			} else {
				errLogger.error("[ERROR] DxT053 {} ", retVal + " " + strResultMessage);
				strSuccessCode = "2";
				
				vo.setRESTORE_CNDT("3");
			}
			
			//DB업데이트
			service.updateBackrestRestore(vo);
			
			outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
			outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
		} catch (Exception e) {
			errLogger.error("DxT053 {} ", e.toString());
			
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT053);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT053);
			outputObj.put(ProtocolID.ERR_MSG, "DxT053 Error [" + e.toString() + "]");
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
		}finally {
			outputObj = null;
			sendBuff = null;
		}
	}
}
