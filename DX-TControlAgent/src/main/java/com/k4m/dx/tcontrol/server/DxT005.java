package com.k4m.dx.tcontrol.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.k4m.dx.tcontrol.db.repository.service.SystemServiceImpl;
import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;
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
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
		
		socketLogger.info("execute(String strDxExCode, JSONArray arrCmd)");

		JSONArray outputArray = new JSONArray();
		JSONObject outputObj = new JSONObject();
		
		
		
		try {

			for(int i=0;i<arrCmd.size();i++){
				System.out.println("Start : "+ (i+1));
				
				JSONObject objJob = (JSONObject) arrCmd.get(i);
				
				
				String strSCD_ID = objJob.get(ProtocolID.SCD_ID).toString();
				String strWORK_ID = objJob.get(ProtocolID.WORK_ID).toString();
				String strEXD_ORD = objJob.get(ProtocolID.EXD_ORD).toString();
				String strNXT_EXD_YN = objJob.get(ProtocolID.NXT_EXD_YN).toString();
				String strCommand = objJob.get(ProtocolID.REQ_CMD).toString();
				
				socketLogger.info(strSCD_ID);
				socketLogger.info(strWORK_ID);
				socketLogger.info(strEXD_ORD);
				socketLogger.info(strNXT_EXD_YN);
				socketLogger.info(strCommand);

				RunCommandExec r = new RunCommandExec(strCommand);
				r.start();
				try{
					r.join();
				}catch(InterruptedException ie){
					ie.printStackTrace();
				}
				String retVal = r.call();
				
				
				//완료 건 update
				context = new ClassPathXmlApplicationContext(new String[] {"context-tcontrol.xml"});
				
				SystemServiceImpl service = (SystemServiceImpl) context.getBean("SystemService");

				System.out.println("retVal "+(i+1)+" : "+ retVal);
			}
			socketLogger.info("send start");
			outputObj = ResultJSON(outputArray, strDxExCode, strSuccessCode, strErrCode, strErrMsg);
			send(TotalLengthBit, outputObj.toString().getBytes());
			
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
}
