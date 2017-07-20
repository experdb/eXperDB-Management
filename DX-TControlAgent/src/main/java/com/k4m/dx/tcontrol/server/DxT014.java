package com.k4m.dx.tcontrol.server;

import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.dbcp.PoolingDriver;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.k4m.dx.tcontrol.db.DBCPPoolManager;
import com.k4m.dx.tcontrol.db.SqlSessionManager;
import com.k4m.dx.tcontrol.socket.ErrCodeMng;
import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;
import com.k4m.dx.tcontrol.socket.client.ClientProtocolID;
import com.k4m.dx.tcontrol.util.KafkaRestApi;

/**
 * kafka-connect CRUD
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

public class DxT014 extends SocketCtl{
	
	private static Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private static Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	public DxT014(Socket socket, InputStream is, OutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		
		socketLogger.info("DxT014.execute : " + strDxExCode);
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
		
		JSONObject objSERVER_INFO = (JSONObject) jObj.get(ProtocolID.SERVER_INFO);
		String strCommandCode = (String) jObj.get(ProtocolID.COMMAND_CODE);
		JSONObject kafkaConnectorObj = (JSONObject) jObj.get(ProtocolID.CONNECTOR_INFO);

		List<Map<String, Object>> outputArray = new ArrayList<Map<String, Object>>();
		
		String strIP = (String) objSERVER_INFO.get(ProtocolID.SERVER_IP);
		String strPort =  (String) objSERVER_INFO.get(ProtocolID.SERVER_PORT);
		
		
		KafkaRestApi kafkaRestApi = new KafkaRestApi(strIP, Integer.parseInt(strPort));
		
		JSONObject outputObj = new JSONObject();
		
		String strName = (String) kafkaConnectorObj.get(ProtocolID.CONNECTOR_NAME);
		String strConnector_class = (String) kafkaConnectorObj.get(ProtocolID.CONNECTOR_CLASS); 
		String strTasks_max = (String) kafkaConnectorObj.get(ProtocolID.TASK_MAX);
		String strTopics = (String) kafkaConnectorObj.get(ProtocolID.TOPIC); 
		String strHdfs_url = (String) kafkaConnectorObj.get(ProtocolID.HDFS_URL);
		String strHadoop_conf_dir = (String) kafkaConnectorObj.get(ProtocolID.HADOOP_CONF_DIR); 
		String strHadoop_home = (String) kafkaConnectorObj.get(ProtocolID.HADOOP_HOOM);
		String strFlush_size = (String) kafkaConnectorObj.get(ProtocolID.FLUSH_SIZE); 
		String strRotate_interval_ms = (String) kafkaConnectorObj.get(ProtocolID.ROTATE_INTERVAL_MS);
		
		try {
			//등록
			if(strCommandCode.equals(ProtocolID.COMMAND_CODE_C)) {
				
				
				boolean blnSuccess = kafkaRestApi.createKafkaConnect(strName, strConnector_class, strTasks_max, strTopics, strHdfs_url,
						strHadoop_conf_dir, strHadoop_home, strFlush_size, strRotate_interval_ms);
				
				if(!blnSuccess) {
					strSuccessCode = "1";
					strErrCode = "ERR_" + ProtocolID.DX_EX_CODE + "_" + ProtocolID.COMMAND_CODE_C;
					strErrMsg = "ERR_" + ProtocolID.DX_EX_CODE + "_" + ProtocolID.COMMAND_CODE_C;
				}
				
				outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
				outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
				outputObj.put(ProtocolID.ERR_CODE, strErrCode);
				outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
				outputObj.put(ProtocolID.RESULT_DATA, "");
			
			//조회
			} else if(strCommandCode.equals(ProtocolID.COMMAND_CODE_R)) {
				
				
				outputArray =  kafkaRestApi.searchKafkaConnect(strName);
				
				outputObj = DxT014ResultJSON(outputArray, strDxExCode, strSuccessCode, strErrCode, strErrMsg);
			
			//수정
			} else if(strCommandCode.equals(ProtocolID.COMMAND_CODE_U)) {
				//updateAuthentication(jObj);
				
				
				boolean blnSuccess = kafkaRestApi.updateKafkaConnect(strName, strConnector_class, strTasks_max, strTopics, strHdfs_url,
						strHadoop_conf_dir, strHadoop_home, strFlush_size, strRotate_interval_ms);
				
				if(!blnSuccess) {
					strSuccessCode = "1";
					strErrCode = "ERR_" + ProtocolID.DX_EX_CODE + "_" + ProtocolID.COMMAND_CODE_U;
					strErrMsg = "ERR_" + ProtocolID.DX_EX_CODE + "_" + ProtocolID.COMMAND_CODE_U;
				}
				
				outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
				outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
				outputObj.put(ProtocolID.ERR_CODE, strErrCode);
				outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
				outputObj.put(ProtocolID.RESULT_DATA, "");
				
			//삭제
			} else if(strCommandCode.equals(ProtocolID.COMMAND_CODE_D)) {
				//deleteAuthentication(jObj);
				
				boolean blnSuccess = kafkaRestApi.deleteKafkaConnect(strName);
				
				if(!blnSuccess) {
					strSuccessCode = "1";
					strErrCode = "ERR_" + ProtocolID.DX_EX_CODE + "_" + ProtocolID.COMMAND_CODE_D;
					strErrMsg = "ERR_" + ProtocolID.DX_EX_CODE + "_" + ProtocolID.COMMAND_CODE_D;
				}
				
				outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
				outputObj.put(ProtocolID.RESULT_CODE, "0");
				outputObj.put(ProtocolID.ERR_CODE, "");
				outputObj.put(ProtocolID.ERR_MSG, "");
				outputObj.put(ProtocolID.RESULT_DATA, "success");
			}
			
			send(TotalLengthBit, outputObj.toString().getBytes());
		} catch (Exception e) {
			errLogger.error("DxT014 {} ", e.toString());
			
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT014);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT014);
			outputObj.put(ProtocolID.ERR_MSG, "DxT014 Error [" + e.toString() + "]");
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);

		} finally {

		}	    
		

	}
}
