package com.k4m.dx.tcontrol.server;

import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
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
	
	public DxT005(Socket socket, InputStream is, OutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public void execute(String strDxExCode, JSONArray arrCmd) throws Exception {
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";

		JSONArray outputArray = new JSONArray();
		
		try {

			for(int i=0;i<arrCmd.size();i++){
				System.out.println("Start : "+ (i+1));
				
				JSONObject objJob = (JSONObject) arrCmd.get(i);
				
				
				String strSCD_ID = objJob.get(ProtocolID.SCD_ID).toString();
				String strWORK_ID = objJob.get(ProtocolID.WORK_ID).toString();
				String strEXD_ORD = objJob.get(ProtocolID.EXD_ORD).toString();
				String strNXT_EXD_YN = objJob.get(ProtocolID.NXT_EXD_YN).toString();
				String strCommand = objJob.get(ProtocolID.REQ_CMD).toString();

				RunCommandExec r = new RunCommandExec(strCommand);
				r.start();
				try{
					r.join();
				}catch(InterruptedException ie){
					ie.printStackTrace();
				}
				String retVal = r.call();

				System.out.println("retVal "+(i+1)+" : "+ retVal);
			}
			

		} catch (Exception e) {
			errLogger.error("DxT005 {} ", e.toString());

		} finally {

		}	    
		
		JSONObject outputObj = ResultJSON(outputArray, strDxExCode, strSuccessCode, strErrCode, strErrMsg);
		send(TotalLengthBit, outputObj.toString().getBytes());


	}
}
