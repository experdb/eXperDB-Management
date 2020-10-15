package com.k4m.dx.tcontrol.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.net.Socket;
import java.util.List;

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
		String pk_value = "";
		String table_param = "";
		String[] pk_list = null;
		String pk_tot_value = "";

		//구분
		String con_start_gbn = (String)objCONNECT_INFO.get("CON_START_GBN");

		String trans_com_id = String.valueOf((Long)objCONNECT_INFO.get("TRANS_COM_ID"));

		JSONObject outputObj = new JSONObject();
		
	   	TransVO commonInfo = null;
	   	TransVO searchTransVO = new TransVO();

		try {
			if (trans_com_id == null || "".equals(trans_com_id)) {
				trans_com_id = "1";
			}
			
			searchTransVO.setTrans_com_id(trans_com_id);
			commonInfo = service.selectTransComSettingInfo(searchTransVO);
			
			JSONObject config = new JSONObject();
			
			if ("source".equals(con_start_gbn)) {
				config.put("connector.class", "io.debezium.connector.postgresql.PostgresConnector");
				config.put("tasks.max", "1");
				config.put("database.hostname", objSERVER_INFO.get("SERVER_IP"));
				config.put("database.port", objSERVER_INFO.get("SERVER_PORT"));
				config.put("database.user", objSERVER_INFO.get("USER_ID"));
				config.put("database.password", objSERVER_INFO.get("USER_PWD"));
				config.put("database.server.name", objCONNECT_INFO.get("CONNECT_NM"));
				config.put("database.dbname", objCONNECT_INFO.get("DB_NM"));
				config.put("table.whitelist", objMAPP_INFO.get("EXRT_TRG_TB_NM"));
				config.put("slot.drop.on.stop", "true");
				config.put("snapshot.mode", objCONNECT_INFO.get("SNAPSHOT_MODE"));
				config.put("slot.name", objCONNECT_INFO.get("CONNECT_NM"));
				config.put("schema.whitelist", objMAPP_INFO.get("EXRT_TRG_SCM_NM"));
				config.put("compression.type", objCONNECT_INFO.get("COMPRESSION_TYPE").toString().toLowerCase());
				
				if (commonInfo != null) {
					config.put("plugin.name", commonInfo.getPlugin_name());
					config.put("heartbeat.interval.ms", commonInfo.getHeartbeat_interval_ms());
					config.put("heartbeat.action.query", commonInfo.getHeartbeat_action_query());
					config.put("max.batch.size", commonInfo.getMax_batch_size());
					config.put("max.queue.size", commonInfo.getMax_queue_size());
					config.put("offset.flush.interval.ms", commonInfo.getOffset_flush_interval_ms());
					config.put("offset.flush.timeout.ms", commonInfo.getOffset_flush_timeout_ms());
					
					String transforms_yn = commonInfo.getTransforms_yn();
					if (transforms_yn != null && "Y".equals(transforms_yn)) {
						config.put("transforms", "route");
						config.put("transforms.route.type", "org.apache.kafka.connect.transforms.RegexRouter");
						config.put("transforms.route.regex", "([^.]+)\\.([^.]+)\\.([^.]+)");
						config.put("transforms.route.replacement", "$3");
					}
				} else {
					config.put("plugin.name", "decoderbufs");
					config.put("heartbeat.interval.ms", "10000");
					config.put("heartbeat.action.query", "");
					config.put("max.batch.size", "16384");
					config.put("max.queue.size", "65536");
					config.put("offset.flush.interval.ms", "1000");
					config.put("offset.flush.timeout.ms", "10000");
				}
			} else {
				if (objMAPP_INFO.get("EXRT_TRG_TB_NM") != null) {
					pk_value = objMAPP_INFO.get("EXRT_TRG_TB_NM").toString();
					pk_list = pk_value.split(",");
				}
				
				if (pk_list != null) {
					for(int i=0; i<pk_list.length; i++){
						socketLogger.info("DxT038.execute123123 : " + pk_list[i]);
						table_param = pk_list[i].toString();
						int indexOf = table_param.lastIndexOf(".");
						if (indexOf > 0) {
							indexOf = indexOf + 1;
						} else {
							indexOf = 0;
						}
						
socketLogger.info("DxT038.indexOf" + indexOf);
socketLogger.info("DxT038.indexOf : " + table_param.substring(indexOf, table_param.length()));
						searchTransVO.setTable_name(table_param.substring(indexOf, table_param.length()));
						
						List<TransVO> tableList = service.selectTablePkInfo(searchTransVO);
						
						int ichkCnt = 0;

						if (tableList != null) {
							for(int j=0; j<tableList.size(); j++){
								ichkCnt = ichkCnt + 1;
								pk_tot_value = tableList.get(j).getColumn_name();
								
								if (ichkCnt != tableList.size()) {
									pk_tot_value = pk_tot_value + ",";
								}
							}
						}
					}
				}

				socketLogger.info("DxT038.pk_tot_valuepk_tot_valuepk_tot_valuepk_tot_value : " + pk_tot_value);
				
				if (pk_tot_value == null || "".equals(pk_tot_value)) {
					pk_tot_value = "id";
				}

				config.put("connector.class", "io.confluent.connect.jdbc.JdbcSinkConnector");
				config.put("tasks.max", "1");
				config.put("pk.mode", "record_key");
				config.put("pk.fields", pk_tot_value);
				config.put("delete.enabled", "true");
				config.put("insert.mode", "upsert");
				
				if (commonInfo != null) {
					config.put("auto.create", commonInfo.getAuto_create());
				} else {
					config.put("auto.create", "true");	
				}

				config.put("transforms.unwrap.drop.tombstones", "false");
				config.put("transforms.unwrap.type", "io.debezium.transforms.ExtractNewRecordState");
				config.put("transforms", "unwrap");
				config.put("connection.password", objCONNECT_INFO.get("CONNECTION_PWD"));
				config.put("connection.user", objCONNECT_INFO.get("SPR_USR_ID"));
				config.put("connection.url", objCONNECT_INFO.get("CONNECTION_URL"));
				config.put("topics", objMAPP_INFO.get("EXRT_TRG_TB_NM"));
			}

			JSONObject parameters = new JSONObject();
			parameters.put("name", objCONNECT_INFO.get("CONNECT_NM"));
			parameters.put("config", config);
			
			HttpEntity<?> requestEntity = apiClientHttpEntity("json", parameters.toString());
			
			String strCmd = cmd + requestEntity.getBody()+"'";
			socketLogger.info("[Connect실행 명령어12] =" + strCmd);
			
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
			
			//정상시 update
			if (retVal.equals("success")) {
				TransVO transVO = new TransVO();
				transVO.setTrans_id(trans_id);
				transVO.setExe_status("TC001501");
				
				if ("source".equals(con_start_gbn)) {
					service.updateTransExe(transVO);
				} else {
					service.updateTransTargetExe(transVO);
				}
				
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