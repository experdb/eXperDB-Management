package com.k4m.dx.tcontrol.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.net.Socket;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.HashMap;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.k4m.dx.tcontrol.db.SqlSessionManager;
import com.k4m.dx.tcontrol.socket.ErrCodeMng;
import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;
import com.k4m.dx.tcontrol.util.CommonUtil;

/**
 * BottledWater 실행/종료
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

public class DxT013 extends SocketCtl{
	
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	public DxT013(Socket socket, BufferedInputStream is, BufferedOutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		socketLogger.info("DxT013.execute : " + strDxExCode);
		
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";

		
		String execTxt = (String) jObj.get(ProtocolID.EXEC_TXT);
		String commandCode = (String) jObj.get(ProtocolID.COMMAND_CODE);
		String trfTrgId = (String) jObj.get(ProtocolID.TRF_TRG_ID);
		
	
		
		JSONObject outputObj = new JSONObject();
		
		try {
			
			if(commandCode.equals(ProtocolID.RUN)) {

				shellCmd(execTxt);
				
			} else if(commandCode.equals(ProtocolID.STOP)) {
				String strCmd = "ps -ef| grep bottledwater |grep " + execTxt + " | awk '{print $2}'";
				
				CommonUtil util = new CommonUtil();
				
				String strPid = util.getPidExec(strCmd);
				
				
				String strStopCmd = "kill -9 " + strPid ;
				shellCmd(strStopCmd);
				
				
				String strDeleteSlotCmd = "rm -rf /tmp/bw_" + execTxt + ".pid";
				shellCmd(strDeleteSlotCmd);
				
				socketLogger.info(" deleteSlot Start ");
				
				int i=0;
				while(true) {
					
					String strPid2 = util.getPidExec(strCmd);
					
					socketLogger.info(i + " pid1 : " + strPid + " pid2 : " + strPid2);
					if(!strPid2.equals(strPid)) break;
					i++;
				}
				
				util = null;
				socketLogger.info(" deleteSlot Start2 ");
				
				deleteSlot(strDxExCode, jObj, execTxt);
				
				socketLogger.info(" deleteSlot End ");
				
				//service.updateT_TRFTRGCNG_I(vo);
			} 
			
			
			outputObj = DxT013ResultJSON(strDxExCode, strSuccessCode, strErrCode, strErrMsg);
	        
	        sendBuff = outputObj.toString().getBytes();
	        send(4, sendBuff);

			
		} catch (Exception e) {
			errLogger.error("DxT013 {} ", e.toString());
			
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT013);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT013);
			outputObj.put(ProtocolID.ERR_MSG, "DxT013 Error [" + e.toString() + "]");
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
			
		} finally {
		}	

	}
	
	   public static String shellCmd(String command) throws Exception {
		   
		   //ps -ef| grep bottledwater |grep test25 | awk '{print $2}'

		   String strResult = "";

           Runtime runtime = Runtime.getRuntime();
           
           Process process = runtime.exec(new String[]{"/bin/sh", "-c", command});

           
          return strResult;
	   }

	   
	   /**
	    * delete slot
	    * @param strDxExCode
	    * @param jObj
	    * @param strSlotName
	    * @throws Exception
	    */
		public void deleteSlot(String strDxExCode, JSONObject jObj, String strSlotName) throws Exception {
			byte[] sendBuff = null;
			String strErrCode = "";
			String strErrMsg = "";
			String strSuccessCode = "0";
			
			JSONObject objSERVER_INFO = (JSONObject) jObj.get(ProtocolID.SERVER_INFO);
			
			SqlSessionFactory sqlSessionFactory = null;

			sqlSessionFactory = SqlSessionManager.getInstance();
			
			String poolName = "" + objSERVER_INFO.get(ProtocolID.SERVER_IP) + "_" + objSERVER_INFO.get(ProtocolID.DATABASE_NAME) + "_" + objSERVER_INFO.get(ProtocolID.SERVER_PORT);
			
			Connection connDB = null;
			SqlSession sessDB = null;

			
			JSONObject outputObj = new JSONObject();
			
			try {
				
				SocketExt.setupDriverPool(objSERVER_INFO, poolName);

				try {
				//DB 컨넥션을 가져온다.
				connDB = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);
				sessDB = sqlSessionFactory.openSession(connDB);
				
				} catch(Exception e) {
					strErrCode += ErrCodeMng.Err001;
					strErrMsg += ErrCodeMng.Err001_Msg + " " + e.toString();
					strSuccessCode = "1";
				}
			
				HashMap hp = new HashMap();
				hp.put("SLOT_NAME", strSlotName);
				
				sessDB.selectList("app.selectDelSlot", hp);


				
			} catch (Exception e) {
				errLogger.error("DxT013 {} ", e.toString());
				
				outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT013);
				outputObj.put(ProtocolID.RESULT_CODE, "1");
				outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT013);
				outputObj.put(ProtocolID.ERR_MSG, "DxT002 Error [" + e.toString() + "]");
				
				sendBuff = outputObj.toString().getBytes();
				send(4, sendBuff);
				
			} finally {
				sessDB.close();
				connDB.close();
			}	        


		}
}
