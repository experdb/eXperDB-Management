package com.k4m.dx.tcontrol.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.net.Socket;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;

import com.k4m.dx.tcontrol.db.repository.service.SystemServiceImpl;
import com.k4m.dx.tcontrol.db.repository.vo.TransVO;
import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;
import com.k4m.dx.tcontrol.util.RunCommandExec;

/**
 * Connect 실행
 *
 * @author 변승우
 * @see <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2020.04.20   변승우 최초 생성
 * </pre>
 */

public class DxT038 extends SocketCtl{
	
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	ApplicationContext context;
	
	public DxT038(Socket socket, BufferedInputStream is, BufferedOutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		
		socketLogger.info("DxT038.execute : " + strDxExCode);
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
		
		context = new ClassPathXmlApplicationContext(new String[] { "context-tcontrol.xml" });
		SystemServiceImpl service = (SystemServiceImpl) context.getBean("SystemService");
		
		JSONObject objSERVER_INFO = (JSONObject) jObj.get(ProtocolID.SERVER_INFO);
		JSONObject objCONNECT_INFO = (JSONObject) jObj.get(ProtocolID.CONNECT_INFO);
		JSONObject objMAPP_INFO = (JSONObject) jObj.get(ProtocolID.MAPP_INFO);
		
		
		int trans_id = Integer.parseInt((String) objCONNECT_INFO.get("TRANS_ID"));
		String cmd = (String) jObj.get(ProtocolID.REQ_CMD);

		
		JSONObject outputObj = new JSONObject();
		
		try {
		
			JSONObject config = new JSONObject();

			config.put("connector.class", "io.debezium.connector.postgresql.PostgresConnector");
			config.put("plugin.name", "wal2json");
			config.put("slot.name", objCONNECT_INFO.get("CONNECT_NM"));
			config.put("database.hostname", objSERVER_INFO.get("SERVER_IP"));
			config.put("database.port", objSERVER_INFO.get("SERVER_PORT"));
			config.put("database.user", objSERVER_INFO.get("USER_ID"));
			config.put("database.password", objSERVER_INFO.get("USER_PWD"));
			config.put("database.dbname", objCONNECT_INFO.get("DB_NM"));
			config.put("database.server.name", objCONNECT_INFO.get("CONNECT_NM"));
			config.put("snapshot.mode", objCONNECT_INFO.get("SNAPSHOT_MODE"));
			config.put("schema.whitelist", objMAPP_INFO.get("EXRT_TRG_SCM_NM"));
			config.put("table.whitelist", objMAPP_INFO.get("EXRT_TRG_TB_NM"));
			
			JSONObject parameters = new JSONObject();
			parameters.put("name", objCONNECT_INFO.get("CONNECT_NM"));
			parameters.put("config", config);
			
			HttpEntity<?> requestEntity = apiClientHttpEntity("json", parameters.toString());
					
			 String strCmd = cmd + requestEntity.getBody()+"'";
			 
			 socketLogger.info("[Connect실행 명령어] =" + strCmd);
			 
			 
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
				
				if (retVal.equals("success")) {
					TransVO transVO = new TransVO();
					transVO.setTrans_id(trans_id);
					transVO.setExe_status("TC001501");
					service.updateTransExe(transVO);
				}
						
				outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
				outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
				outputObj.put(ProtocolID.ERR_CODE, strErrCode);
				outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
				outputObj.put(ProtocolID.RESULT_DATA, retVal);
				
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);

		} catch (Exception e) {
			errLogger.error("DxT038 {} ", e.toString());
			
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT038);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT038);
			outputObj.put(ProtocolID.ERR_MSG, "DxT038 Error [" + e.toString() + "]");
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);

		} finally {
			outputObj = null;
			sendBuff = null;
		}	    

	}
	
	
	/**
	 * Secret키와 Content-type을 설정
	 * 
	 * @param appType
	 * @param params
	 * @return HttpEntity<?>
	 */
	private HttpEntity<?> apiClientHttpEntity(String appType, String params) {

		HttpHeaders requestHeaders = new HttpHeaders();
		requestHeaders.set("Content-Type", "application/" + appType);

		if ("".equals(params) || (params == null))
			return new HttpEntity<Object>(requestHeaders);
		else
			return new HttpEntity<Object>(params, requestHeaders);
	}
	
	
}
