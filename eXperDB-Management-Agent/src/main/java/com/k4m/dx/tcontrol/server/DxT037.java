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
import com.k4m.dx.tcontrol.util.RunCommandExec;

/**
 * kafkaConnectionTest 카푸카커넥터 연결테스트
 *
 * @author 변승우
 * @see <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2020.04.09   변승우 최초 생성
 * </pre>
 */

public class DxT037 extends SocketCtl{
	
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	public DxT037(Socket socket, BufferedInputStream is, BufferedOutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		socketLogger.info("DxT037.execute : " + strDxExCode);
		
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";

		
		String strCmd = (String) jObj.get(ProtocolID.REQ_CMD);
		
	
		JSONObject outputObj = new JSONObject();
		
		try {
			socketLogger.info("[COMMAND] " + strCmd);

			RunCommandExec r = new RunCommandExec(strCmd);
			
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
			

			outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
			outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
			outputObj.put(ProtocolID.RESULT_DATA, retVal);
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);

			
		} catch (Exception e) {
			errLogger.error("DxT037 {} ", e.toString());
			
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT037);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT037);
			outputObj.put(ProtocolID.ERR_MSG, "DxT037 Error [" + e.toString() + "]");
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
			
		} finally {
			
			outputObj = null;
			sendBuff = null;
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
				
				sessDB.close();
				connDB.close();
				
				hp = null;


				
			} catch (Exception e) {
				errLogger.error("DxT013 {} ", e.toString());
				
				outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT013);
				outputObj.put(ProtocolID.RESULT_CODE, "1");
				outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT013);
				outputObj.put(ProtocolID.ERR_MSG, "DxT002 Error [" + e.toString() + "]");
				
				sendBuff = outputObj.toString().getBytes();
				send(4, sendBuff);
				
			} finally {
				if(sessDB !=null) sessDB.close();
				if(connDB !=null) connDB.close();
				
				outputObj = null;
				sendBuff = null;
			}	        


		}
}
