package com.k4m.dx.tcontrol.socket.listener;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.Socket;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TreeMap;

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

public class DXTcontrolScaleAwsExecute extends SocketCtl{
	
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");

	ApplicationContext context;

	public DXTcontrolScaleAwsExecute(Socket socket, BufferedInputStream is, BufferedOutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public JSONObject execute(JSONObject jObj) throws Exception {
		socketLogger.info("DXTcontrolScaleAwsExecute.execute : ");

		String strSuccessCode = "0";
		String strErrCode = "";
		String strErrMsg = "";
		
		JSONObject jsonObj = new JSONObject(new TreeMap ());
		JSONParser parser = new JSONParser();
		JSONObject outputObj = new JSONObject();

		try {
			String scaleCmd = scaleCmdSetting(jObj);
			String scaleSet = jObj.get(ProtocolID.SCALE_SET).toString();             //scale 구분
			String searchGbn = jObj.get(ProtocolID.SEARCH_GBN).toString();           //조회구분
			String strResultSubMessge = "";
			String scaleSubCmd = "";

			//scale 실행일 경우
			if ("scaleIn".equals(scaleSet) || "scaleOut".equals(scaleSet)) {
				ScaleRunCommandExec scaleExec = new ScaleRunCommandExec(scaleCmd, jObj, 0);
				scaleExec.start();
				
				jObj.put(ProtocolID.SCALE_SET,  jObj.get(ProtocolID.MONITERING).toString());
				scaleSubCmd = scaleCmdSetting(jObj);

				//scale 확인
				ScaleRunCommandExec scaleExecWatch = new ScaleRunCommandExec(scaleSubCmd, jObj, 1);
				scaleExecWatch.start();

				strSuccessCode = "0";
				strErrCode = "";
				strErrMsg = "";
			} else { //조회인경우
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

				socketLogger.info("retValretVal : " + retVal);
				socketLogger.info("strResultMessge : " + strResultMessge);
				
				if (retVal.equals("success")) {
					if (searchGbn.equals("scaleAwsChk") || searchGbn.equals("scaleChk")) {
						strResultSubMessge = strResultMessge;
						strResultMessge = "";
					}
					
					if (!strResultMessge.isEmpty()) {
						if (searchGbn.equals("instanceCnt")) {
							strResultMessge = "{ \"Instances\":" + strResultMessge + "}";
						}

						if (!strResultMessge.isEmpty()) {
							Object obj = parser.parse( strResultMessge);
							jsonObj = (JSONObject) obj;
						}
					}
				}
			}

			outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
			outputObj.put(ProtocolID.RESULT_DATA, jsonObj);
			outputObj.put(ProtocolID.RESULT_SUB_DATA, strResultSubMessge);
			
			return outputObj;

		} catch (Exception e) {
			errLogger.error("DXTcontrolScaleAwsExecute {} ", e.toString());

			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT036);
			outputObj.put(ProtocolID.ERR_MSG, "DxT036 Error [" + e.toString() + "]");
			outputObj.put(ProtocolID.RESULT_DATA, jsonObj);
			outputObj.put(ProtocolID.RESULT_SUB_DATA, "");

		} finally {
			outputObj = null;
		}
		
		return outputObj;
	}
	
	/**
	 * 전송 cmd 값 setting
	 * 
	 * @return String
	 * @throws IOException  
	 * @throws FileNotFoundException 
	 * @throws Exception
	 */
	public String scaleCmdSetting(JSONObject obj) throws FileNotFoundException, IOException {
		String scale_path = "";
		String strCmd = "";
		String strSubCmd = "";

		//구분값 : yyyMMddHHmmss
		SimpleDateFormat formatDate = new SimpleDateFormat ( "yyyMMddHHmmss");
		Date time = new Date();
		String timeId = formatDate.format(time);

		//명령어 setting
		String scaleSet = obj.get(ProtocolID.SCALE_SET).toString();
		String searchGbn = obj.get(ProtocolID.SEARCH_GBN).toString();
		String moniteringGbn = obj.get(ProtocolID.MONITERING).toString();
		
		String scale_count = obj.get(ProtocolID.SCALE_COUNT_SET).toString();
		int scale_exe_count = 1;
		
		if (scale_count != null && !"".equals(scale_count)) {
			scale_exe_count = Integer.parseInt(scale_count);
		}

		try {
			//scale 실행
			if (!scaleSet.isEmpty()) {
				if ("scaleIn".equals(scaleSet)) {
					if (scale_exe_count <= 1) { //one
						scale_path = FileUtil.getPropertyValue("context.properties", "agent.scale_in_cmd");
						strCmd = String.format(scale_path + " ", timeId);
					} else { //multi
						scale_path = FileUtil.getPropertyValue("context.properties", "agent.scale_in_multi_cmd");
						timeId = scale_exe_count + " -id " + timeId;
						strCmd = String.format(scale_path + " ", timeId);
						
						strCmd += strCmd + " > /dev/null ";  //의미없는 표준출력 넣어서 일단 돌아가게 만듬
					}
				} else if ("scaleOut".equals(scaleSet)) {
/*					if (scale_exe_count <= 1) { //one
						scale_path = FileUtil.getPropertyValue("context.properties", "agent.scale_out_cmd");
						strCmd = String.format(scale_path + " ", timeId);
					} else { //multi
*/						scale_path = FileUtil.getPropertyValue("context.properties", "agent.scale_out_multi_cmd");
						timeId = scale_exe_count + " -id " + timeId;
						strCmd = String.format(scale_path + " ", timeId);
/*					}*/
				} else if ("monitering".equals(scaleSet)) {
					scale_path = FileUtil.getPropertyValue("context.properties", "agent.scale_chk_prgress");
					strCmd = String.format(scale_path + " ", timeId);
				}
			} else {
				if (searchGbn.equals("scaleChk")) {
					strCmd = FileUtil.getPropertyValue("context.properties", "agent.scale_chk_prgress");
					strCmd = String.format(strCmd, "scale-");
				} else if (searchGbn.equals("scaleAwsChk")) { //설치여부 체크
					strCmd = "which aws";
				} else {
					strCmd = FileUtil.getPropertyValue("context.properties", "agent.scale_json_view");

					if ("instanceCnt".equals(searchGbn)) {
						strSubCmd = "--query \"Reservations[*].Instances[].{InstanceId:InstanceId}[]\"";
						strCmd = String.format(strCmd, strSubCmd);
						strCmd = strCmd + " \"Name=instance-state-name,Values=running\"";
					} else if (searchGbn.equals("scaleIngChk")) {
						strSubCmd = "--query \"Reservations[*].Instances[].{InstanceId:InstanceId}[]\"";
						strCmd = String.format(strCmd, strSubCmd);
						strCmd = strCmd + " \"Name=instance-state-name,Values=pending,shutting-down\"";
					}				
				}
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		socketLogger.info("DXTcontrolScaleAwsExecute.strCmd : " + strCmd);
		return strCmd;
	}
}