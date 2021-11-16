package com.k4m.dx.tcontrol.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.Socket;
import java.util.List;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;

import com.k4m.dx.tcontrol.db.repository.service.TransServiceImpl;
import com.k4m.dx.tcontrol.db.repository.vo.TransVO;
import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;
import com.k4m.dx.tcontrol.socket.client.ClientProtocolID;
import com.k4m.dx.tcontrol.util.CustomProperties;
import com.k4m.dx.tcontrol.util.FileUtil;
import com.k4m.dx.tcontrol.util.RunCommandExec;

/**
 * confluent properties 파일생성
 *
 * @author
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2021.11.11    최초 생성
 *      </pre>
 */	

public class DxT045 extends SocketCtl {
	
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	ApplicationContext context;

	public DxT045(Socket socket, BufferedInputStream is, BufferedOutputStream os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		socketLogger.info("DxT045.execute : " + strDxExCode);
		
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";

		JSONObject SERVERObj = (JSONObject) jObj.get(ProtocolID.SERVER_INFO);
		JSONObject CONNECTObj = (JSONObject) jObj.get(ProtocolID.CONNECT_INFO);
		JSONObject MAPPObj = (JSONObject) jObj.get(ProtocolID.MAPP_INFO);
		
		context = new ClassPathXmlApplicationContext(new String[] { "context-tcontrol.xml" });
		TransServiceImpl transService = (TransServiceImpl) context.getBean("TransService");

		JSONObject outputObj = new JSONObject();
		
	   	TransVO commonInfo = null;
	   	TransVO searchTransVO = new TransVO();

		try {
			int trans_id = Integer.parseInt((String) CONNECTObj.get("TRANS_ID"));
			
			//구분
			String login_id = "";
			if (SERVERObj.get("LOGIN_ID") != null) {
				login_id = SERVERObj.get("LOGIN_ID").toString();
			}

			String serverIp = String.valueOf(SERVERObj.get(ClientProtocolID.SERVER_IP));
			String kc_ip = String.valueOf(CONNECTObj.get(ClientProtocolID.KC_IP));
			String regi_ip = String.valueOf(CONNECTObj.get(ClientProtocolID.REGI_IP));
			String regi_port = String.valueOf(CONNECTObj.get(ClientProtocolID.REGI_PORT));
			String hdfs_ip = String.valueOf(CONNECTObj.get(ClientProtocolID.DBMS_IP));
			String hdfs_port = String.valueOf(CONNECTObj.get(ClientProtocolID.DBMS_PORT));
			String properties_dir = String.valueOf(CONNECTObj.get(ClientProtocolID.FILE_DIRECTORY));
			String connect_nm = String.valueOf(CONNECTObj.get(ClientProtocolID.CONNECT_NM));
			String file_name = String.valueOf(CONNECTObj.get(ClientProtocolID.FILE_NAME));
			String trans_kc_ip = (String)CONNECTObj.get(ClientProtocolID.KC_IP);
			
			String exrt_trg_tb_nm = String.valueOf(MAPPObj.get(ClientProtocolID.EXRT_TRG_TB_NM));
			
			String strCmd = "";
			
			if (!kc_ip.equals(serverIp)) {
				strCmd = "ssh -o StrictHostKeyChecking=no ec2-user@" + kc_ip + " ";
			}
			
			strCmd += "confluent local services connect connector load ";
			strCmd += connect_nm + " --config " + properties_dir + file_name;

			String regi_url = "http://" + regi_ip + ":" + regi_port; //scema registry 경로
			String hdfs_url = "hdfs://" + hdfs_ip + ":" + hdfs_port; //hdfs 설치 경로

			socketLogger.info("DxT045.strCmd : " + strCmd);
			socketLogger.info("DxT045.regi_url : " + regi_url);
			socketLogger.info("DxT045.hdfs_url : " + hdfs_url);
			socketLogger.info("DxT045.properties_dir : " + properties_dir);
			socketLogger.info("DxT045.file_name : " + file_name);
			
			//파일 생성 관련 properties 값 setting
			CustomProperties properties = new CustomProperties();
			properties.setProperty("name", connect_nm);
			properties.setProperty("connector.class", "io.confluent.connect.hdfs.HdfsSinkConnector");
			properties.setProperty("tasks.max","1");
			properties.setProperty("topics", exrt_trg_tb_nm);
			properties.setProperty("hdfs.url", hdfs_url);
			properties.setProperty("flush.size","3");
			properties.setProperty("key.converter","io.confluent.connect.json.JsonSchemaConverter");
			properties.setProperty("key.converter.schema.registry.url", regi_url);
			properties.setProperty("value.converter","io.confluent.connect.json.JsonSchemaConverter");
			properties.setProperty("value.converter.schema.registry.url", regi_url);
			
			/////////local 파일 디렉토리 생성 start
			String kafkaPath = FileUtil.getPropertyValue("context.properties", "agent.trans_path");
			String propertiesDirectory = "con_properties/"; //local 파일디렉토리 생성
			socketLogger.info("propertiesDirectory : " + propertiesDirectory);

			// confluent properties 파일 디렉토리 생성
			if (!new File(kafkaPath + "/" + propertiesDirectory).exists()) {
				new File(kafkaPath + "/" + propertiesDirectory).mkdirs();
			}
			/////////local 파일 디렉토리 생성 end

			/////////local confluent properties 파일 생성
			String FilePath = kafkaPath + "/" + propertiesDirectory + file_name;
			try {
				FileOutputStream fos = new FileOutputStream(FilePath);
				properties.store(fos, FilePath);
			} catch (IOException e) {
				e.printStackTrace();
			}
			/////////local confluent properties 파일 생성
			
			//파일 경로 설정
			String fileCmd = "scp -o StrictHostKeyChecking=no " + FilePath + " ec2-user@" + kc_ip +":"+ properties_dir;
			socketLogger.info("fileCmd : " + fileCmd);

			//schema registry 서버 파일 복제
			RunCommandExec file_r = new RunCommandExec(fileCmd);

			//명령어 실행 
			file_r.start();
			try {
				file_r.join();
			} catch (InterruptedException ie) {
				ie.printStackTrace();
			}

			String retVal = "";
			String strResultMessge = "";
			String strProRetVal = file_r.call();
			String strProResultMessge = file_r.getMessage();
			String strConRetVal = "fail";
			String strConResultMessge = "";

			//정상시 실행
			if (strProRetVal.equals("success")) {
				//conflueunt 실행
				RunCommandExec con_r = new RunCommandExec(strCmd);

				//명령어 실행 
				con_r.start();
				try {
					con_r.join();
				} catch (InterruptedException ie) {
					ie.printStackTrace();
				}
				
				strConRetVal = con_r.call();
				strConResultMessge = con_r.getMessage();
			}
	
			if("success".equals(strProRetVal) && "success".equals(strConRetVal)){
				retVal = "success";
				strResultMessge = strConResultMessge;
			} else {
				retVal = "fail";
				strResultMessge = "fail";
			}
			
			socketLogger.info("[PROPERTIES RESULT] " + strProRetVal);
			socketLogger.info("[PROPERTIES MSG] " + strProResultMessge);
			socketLogger.info("##### 파일 전송 결과 : " + strProRetVal + " message : " +strProResultMessge);	

			socketLogger.info("[CONFLUENT RESULT] " + strConRetVal);
			socketLogger.info("[CONFLUENT MSG] " + strConResultMessge);
			socketLogger.info("##### 파일 전송 결과 : " + strConRetVal + " message : " +strConResultMessge);	

			String insResult = "";
			
			//정상시 update
			if (retVal.equals("success")) {
				//param 등록
				TransVO transVO = new TransVO();
				transVO.setTrans_id(trans_id);
				transVO.setExe_status("TC001501");
				transVO.setKc_ip(trans_kc_ip);
				transVO.setLogin_id(login_id);

				transService.updateTransTargetExe(transVO);
				transVO.setConnector_type("target");
			}

			outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
			outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
			outputObj.put(ProtocolID.RESULT_DATA, retVal);
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);		
			 
		} catch (Exception e) {
			errLogger.error("DxT045 {} ", e.toString());

			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT045);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT045);
			outputObj.put(ProtocolID.ERR_MSG, "DxT045 Error [" + e.toString() + "]");
			
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