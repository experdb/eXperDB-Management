package com.k4m.dx.tcontrol.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.net.InetAddress;
import java.net.Socket;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.k4m.dx.tcontrol.db.SqlSessionManager;
import com.k4m.dx.tcontrol.db.repository.vo.ServerInfoVO;
import com.k4m.dx.tcontrol.db.repository.vo.TablespaceVO;
import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;
import com.k4m.dx.tcontrol.util.CommonUtil;
import com.k4m.dx.tcontrol.util.NetworkUtil;

/**
 * 26.	database server 정보 조회
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

public class DxT025 extends SocketCtl{
	
	private static Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private static Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	private String[] arrCmd = {
				                "pg_rman show -B" 
							   };
	
	public DxT025(Socket socket, BufferedInputStream is, BufferedOutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		
		
		JSONObject serverInfoObj = (JSONObject) jObj.get(ProtocolID.SERVER_INFO);
		String strBackupDir = (String) jObj.get(ProtocolID.FILE_DIRECTORY);
		String strSpace = " ";
		String strCmdDetail = "detail";
		
		socketLogger.info("execute : " + strDxExCode);
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
	
		JSONObject outputObj = new JSONObject();
		JSONArray arrOut = new JSONArray();

		try {
			
			String strRmanSHow = CommonUtil.getCmdExec(arrCmd[0] + strSpace + strBackupDir + strSpace + strCmdDetail);
			ArrayList<HashMap<String, String>> flist = rmanSHowList(strRmanSHow);

			outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
			outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
			
			outputObj.put(ProtocolID.RESULT_DATA, flist);

			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
			
		} catch (Exception e) {
			errLogger.error("DxT025 {} ", e.toString());
			
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT025);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT025);
			outputObj.put(ProtocolID.ERR_MSG, "DxT025 Error [" + e.toString() + "]");
			outputObj.put(ProtocolID.RESULT_DATA, "failed");
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);

		} finally {

		}	    
	}
	
	private ArrayList rmanSHowList(String strRmanSHowList) throws Exception {
		ArrayList<HashMap<String, String>> list = new ArrayList<HashMap<String, String>>();
		
		
		if(strRmanSHowList.length() > 0) {
			String[] arrRmanShow = strRmanSHowList.split("\n");
			int intFileI = 0;
			for(String st: arrRmanShow) {
				System.out.println("### intFileI : " + intFileI);
				if(intFileI > 2) {
					HashMap hp = new HashMap();
			    	  String[] arrStr = st.split(" ");
			    	  int lineT = 0;
			    	  for(int i=0; i<arrStr.length; i++) {
			    		  //System.out.println(arrStr[i].toString());
			    		  
			    		  if(!arrStr[i].toString().trim().equals("")) {
			    			  System.out.println(lineT + " :: " + arrStr[i].toString());
				    		  if(lineT == 0) {
				    			  hp.put(ProtocolID.RMAN_START_DATE, arrStr[i].toString());
				    		  } else if(lineT == 1) {
				    			  hp.put(ProtocolID.RMAN_START_TIME, arrStr[i].toString());
				    		  } else if(lineT == 2) {
				    			  hp.put(ProtocolID.RMAN_END_DATE, arrStr[i].toString());
				    		  } else if(lineT == 3) {
				    			  hp.put(ProtocolID.RMAN_END_TIME, arrStr[i].toString());
				    		  } else if(lineT == 4) {
				    			  hp.put(ProtocolID.RMAN_MODE, arrStr[i].toString());
				    		  } else if(lineT == 5) {
				    			  hp.put(ProtocolID.RMAN_DATA, arrStr[i].toString());
				    		  } else if(lineT == 6) {
				    			  hp.put(ProtocolID.RMAN_ARCLOG, arrStr[i].toString());
				    		  } else if(lineT == 7) {
				    			  hp.put(ProtocolID.RMAN_SRVLOG, arrStr[i].toString());
				    		  } else if(lineT == 8) {
				    			  hp.put(ProtocolID.RMAN_TOTAL, arrStr[i].toString());
				    		  } else if(lineT == 9) {
				    			  hp.put(ProtocolID.RMAN_COMPRESSED, arrStr[i].toString());
				    		  } else if(lineT == 10) {
				    			  hp.put(ProtocolID.RMAN_CURTLI, arrStr[i].toString());
				    		  } else if(lineT == 11) {
				    			  hp.put(ProtocolID.RMAN_PARENTTLI, arrStr[i].toString());
				    		  } else if(lineT == 12) {
				    			  hp.put(ProtocolID.RMAN_STATUS, arrStr[i].toString());
				    		  }
				    		  
				    		  lineT = lineT + 1;

				    		  System.out.println("lineT : " + lineT);
			    		  }
			    	  }
			    	  list.add(hp);
				}
				
				intFileI++;
			}
		}
		
		return list;
	}
	
	
}


