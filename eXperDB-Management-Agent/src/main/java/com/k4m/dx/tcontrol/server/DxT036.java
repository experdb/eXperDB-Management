package com.k4m.dx.tcontrol.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.net.Socket;
import java.util.TreeMap;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;

import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;
import com.k4m.dx.tcontrol.util.FileUtil;
import com.k4m.dx.tcontrol.util.RunCommandExec;
import com.k4m.dx.tcontrol.util.ScaleRunCommandExec;

/**
 * 24.	Hostname 조회
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

public class DxT036 extends SocketCtl{
	
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");

	ApplicationContext context;

	public DxT036(Socket socket, BufferedInputStream is, BufferedOutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		socketLogger.info("DxT036.execute : " + strDxExCode);

		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";

		JSONObject outputObj = new JSONObject();
		JSONObject jsonObj = new JSONObject(new TreeMap ());
		JSONParser parser = new JSONParser();
		JSONArray arrCmd = new JSONArray();

		try {
			String scaleCmd = "";
			String scaleSubCmd = "";
			String scaleSet = jObj.get(ProtocolID.SCALE_SET).toString();             //scale 구분
			String searchGbn = jObj.get(ProtocolID.SEARCH_GBN).toString();           //조회구분
			String strResultSubMessge = "";
			String scaleLastNodeCnt = "";

			//cmd문
			arrCmd = (JSONArray) jObj.get(ProtocolID.ARR_CMD);
			scaleCmd = arrCmd.get(0).toString();
			if (arrCmd.size() > 1) {
				scaleSubCmd = arrCmd.get(1).toString();
			}

			//scale 실행일 경우
			if ("scaleIn".equals(scaleSet) || "scaleOut".equals(scaleSet)) {
socketLogger.info("DxT036.scaleCmd============================= : " + scaleCmd);
				ScaleRunCommandExec scaleExec = new ScaleRunCommandExec(scaleCmd, jObj, 0);
				scaleExec.start();

				//scale 확인
				ScaleRunCommandExec scaleExecWatch = new ScaleRunCommandExec(scaleSubCmd, jObj, 1);
				scaleExecWatch.start();

				strSuccessCode = "0";
				strErrCode = "";
				strErrMsg = "";
			} else { //조회인경우
				String masterNm = "";
				
				//instance ip 찾기
				if ("main".equals(searchGbn) || ("scaleChk".equals(searchGbn) && !"".equals(scaleSubCmd)) || "instanceCnt".equals(searchGbn))  {
					masterNm = masterIpSearch();
					scaleCmd = scaleCmd + " \"Name=tag:Name,Values=" + masterNm + "\"";
					
					scaleLastNodeCnt = lastNodeCntSearch();
				}

				//조회 쿼리돌리고 값 리턴함
				RunCommandExec r = new RunCommandExec(scaleCmd);
				//명령어 실행
				r.run();

				try {
					r.join();
				} catch (InterruptedException ie) {
					ie.printStackTrace();
				}

				String retVal = r.call();
				String strResultMessge = r.getMessage();

				if (!searchGbn.isEmpty()) {
					if (searchGbn.equals("scaleChk") && !"".equals(scaleSubCmd)) {
						//조회 쿼리돌리고 값 리턴함
						RunCommandExec rSub = new RunCommandExec(scaleSubCmd);
						//명령어 실행
						rSub.run();

						try {
							rSub.join();
						} catch (InterruptedException ie) {
							ie.printStackTrace();
						}

						strResultSubMessge = rSub.getMessage();	
					}
				}

				if (retVal.equals("success")) {
					if (searchGbn.equals("scaleAwsChk")) {
						strResultSubMessge = strResultMessge;
						strResultMessge = "";
					}
					
					if (!strResultMessge.isEmpty()) {
						if (searchGbn.equals("main") || searchGbn.equals("scaleChk") || searchGbn.equals("instanceCnt")) {
							strResultMessge = "{ \"Instances\":" + strResultMessge + "}";
						}
						
						if (searchGbn.equals("main")) {
							strResultSubMessge = masterNmSearch();
						}

						if (!strResultMessge.isEmpty()) {
							Object obj = parser.parse( strResultMessge);
							jsonObj = (JSONObject) obj;
						}
					}
				}
			}

			outputObj.put(ProtocolID.SCALE_LAST_NODE_CNT, scaleLastNodeCnt);
			outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
			outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
			outputObj.put(ProtocolID.RESULT_DATA, jsonObj);
			outputObj.put(ProtocolID.RESULT_SUB_DATA, strResultSubMessge);

			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
		} catch (Exception e) {
			errLogger.error("DxT036 {} ", e.toString());

			outputObj.put(ProtocolID.SCALE_LAST_NODE_CNT, "");
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT036);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT036);
			outputObj.put(ProtocolID.ERR_MSG, "DxT036 Error [" + e.toString() + "]");
			outputObj.put(ProtocolID.RESULT_DATA, jsonObj);
			outputObj.put(ProtocolID.RESULT_SUB_DATA, "");

			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);

		} finally {
			outputObj = null;
			sendBuff = null;
		}
	}
	
	//조회 일경우 조회 목록 받기
	public String masterIpSearch() throws Exception {
		String scaleMainCmd = "";
		String scale_path = "";

		try {
			scale_path = FileUtil.getPropertyValue("context.properties", "agent.scale_path");
			
			//scaleMainCmd = "psql -c \"select conninfo from nodes where type = 'primary' ; \" -t -d repmgr -U repmgr | grep -v conninfo | grep -v row  | sed \"s/host=//\" | awk '{print $1}'";
			scaleMainCmd = "cat " + scale_path + "/setting.json";
			RunCommandExec rMain = new RunCommandExec(scaleMainCmd);
			//명령어 실행
			rMain.run();

			try {
				rMain.join();
			} catch (InterruptedException ie) {
				ie.printStackTrace();
			}

			String strResultMessgeMain = rMain.getMessage();

			if (!"".equals(strResultMessgeMain)) {
				JSONParser parser = new JSONParser();
				Object obj = parser.parse( strResultMessgeMain );
				JSONObject jsonObj = (JSONObject) obj;
				
				String instanceName = (String) jsonObj.get("instanceName");
				int iInstanceCnt = 0;
				if (!"".equals(instanceName)) {
					iInstanceCnt = instanceName.lastIndexOf("-");
					scaleMainCmd = instanceName.substring(0, iInstanceCnt+1) + "*";
				}
			}
		} catch (Exception ie) {
			ie.printStackTrace();
		}

		return scaleMainCmd;
	}
	
	//조회 일 경우 lastLoad값 받기
	public String lastNodeCntSearch() throws Exception {
		String scaleMainCmd = "";
		String scale_path = "";
		String lastNodeCnt = "0";

		try {
			scale_path = FileUtil.getPropertyValue("context.properties", "agent.scale_path");
			
			//scaleMainCmd = "psql -c \"select conninfo from nodes where type = 'primary' ; \" -t -d repmgr -U repmgr | grep -v conninfo | grep -v row  | sed \"s/host=//\" | awk '{print $1}'";
			scaleMainCmd = "cat " + scale_path + "/setting.json";
			RunCommandExec rMain = new RunCommandExec(scaleMainCmd);
			//명령어 실행
			rMain.run();

			try {
				rMain.join();
			} catch (InterruptedException ie) {
				ie.printStackTrace();
			}

			String strResultMessgeMain = rMain.getMessage();

			if (!"".equals(strResultMessgeMain)) {
				JSONParser parser = new JSONParser();
				Object obj = parser.parse( strResultMessgeMain );
				JSONObject jsonObj = (JSONObject) obj;
				
				String lastNodeCntStr = (String) jsonObj.get("staticLastNode");

				if (!"".equals(lastNodeCntStr)) {
					lastNodeCnt = lastNodeCntStr;
				}
			}
		} catch (Exception ie) {
			ie.printStackTrace();
		}

		return lastNodeCnt;
	}
	
	//조회 일경우 조회 목록 받기
	public String masterNmSearch() throws Exception {
		String scaleMainCmd = "";
		String scale_path = "";

		try {
			scale_path = FileUtil.getPropertyValue("context.properties", "agent.scale_path");
			
			//scaleMainCmd = "psql -c \"select conninfo from nodes where type = 'primary' ; \" -t -d repmgr -U repmgr | grep -v conninfo | grep -v row  | sed \"s/host=//\" | awk '{print $1}'";
			scaleMainCmd = "cat " + scale_path + "/setting.json";
			RunCommandExec rMain = new RunCommandExec(scaleMainCmd);
			//명령어 실행
			rMain.run();

			try {
				rMain.join();
			} catch (InterruptedException ie) {
				ie.printStackTrace();
			}

			String strResultMessgeMain = rMain.getMessage();

			if (!"".equals(strResultMessgeMain)) {
				JSONParser parser = new JSONParser();
				Object obj = parser.parse( strResultMessgeMain );
				JSONObject jsonObj = (JSONObject) obj;
				
				String ipInternal = (String) jsonObj.get("ipInternal");
				if (!"".equals(ipInternal)) {
					scaleMainCmd = ipInternal;
				}
			}
		} catch (Exception ie) {
			ie.printStackTrace();
		}

		return scaleMainCmd;
	}
}