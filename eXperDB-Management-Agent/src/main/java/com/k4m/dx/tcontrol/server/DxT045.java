package com.k4m.dx.tcontrol.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.Writer;
import java.net.Socket;
import java.util.Properties;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;

import com.k4m.dx.tcontrol.db.repository.service.TransServiceImpl;
import com.k4m.dx.tcontrol.db.repository.vo.TransVO;
import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;
import com.k4m.dx.tcontrol.socket.client.ClientProtocolID;
import com.k4m.dx.tcontrol.util.CustomProperties;
import com.k4m.dx.tcontrol.util.FileUtil;
import com.k4m.dx.tcontrol.util.RunCommandExec;
import com.sun.xml.internal.fastinfoset.util.StringArray;

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
		
		JSONObject CONNECTObj = (JSONObject) jObj.get(ProtocolID.CONNECT_INFO);
		JSONObject MAPPObj = (JSONObject) jObj.get(ProtocolID.MAPP_INFO);
		JSONObject SERVERObj = (JSONObject) jObj.get(ProtocolID.SERVER_INFO);
		JSONObject outputObj = new JSONObject();

		TransServiceImpl transService = (TransServiceImpl) context.getBean("TransService");
		
		String strCmd = (String) jObj.get(ProtocolID.REQ_CMD);
		
		String kc_ip = String.valueOf(CONNECTObj.get(ClientProtocolID.KC_IP));
		String regi_ip = String.valueOf(CONNECTObj.get(ClientProtocolID.REGI_IP));
		String regi_port = String.valueOf(CONNECTObj.get(ClientProtocolID.REGI_PORT));
		
		String regi_url = "http://" + regi_ip + ":" + regi_port;
		socketLogger.info("regi_url : " + regi_url);
		
		String hdfs_ip = String.valueOf(SERVERObj.get(ClientProtocolID.SERVER_IP));
		String hdfs_port = String.valueOf(SERVERObj.get(ClientProtocolID.SERVER_PORT));
		
		String hdfs_url = "hdfs://" + hdfs_ip + ":" + hdfs_port;
		String properties_dir= String.valueOf((CONNECTObj.get(ClientProtocolID.FILE_DIRECTORY)));
		
		socketLogger.info("hdfs_url : " + hdfs_url);
		socketLogger.info("properties_dir : " + properties_dir);
		
		try{
			CustomProperties properties = new CustomProperties();
			properties.setProperty("name", String.valueOf(CONNECTObj.get(ClientProtocolID.CONNECT_NM)));
			properties.setProperty("connector.class", "io.confluent.connect.hdfs.HdfsSinkConnector");
			properties.setProperty("tasks.max","1");
			properties.setProperty("topics",String.valueOf(MAPPObj.get(ClientProtocolID.EXRT_TRG_TB_NM)));
			properties.setProperty("hdfs.url", hdfs_url);
			properties.setProperty("flush.size","3");
			properties.setProperty("key.converter","io.confluent.connect.json.JsonSchemaConverter");
			properties.setProperty("key.converter.schema.registry.url", regi_url);
			properties.setProperty("value.converter","io.confluent.connect.json.JsonSchemaConverter");
			properties.setProperty("value.converter.schema.registry.url", regi_url);
	
			String kafkaPath = FileUtil.getPropertyValue("context.properties", "agent.trans_path");
			String propertiesDirectory = "con_properties/";
			
			// confluent properties 파일 디렉토리 생성
			if (!new File(kafkaPath + "/" + propertiesDirectory).exists()) {
				new File(kafkaPath + "/" + propertiesDirectory).mkdirs();
			}
			
			String strFileName = String.valueOf(CONNECTObj.get(ClientProtocolID.FILE_NAME));
			
			String FilePath = kafkaPath + "/" + propertiesDirectory + strFileName;
			
			try {
				FileOutputStream fos = new FileOutputStream(FilePath);
				properties.store(fos, FilePath);
			} catch (IOException e) {
				e.printStackTrace();
			}
			
			String fileCmd = "scp " + FilePath + " ec2-user@" + kc_ip +":"+ properties_dir;
			
			RunCommandExec file_r = new RunCommandExec(fileCmd);
			file_r.run();
			String strProRetVal = file_r.call();
			String strProResultMessge = file_r.getMessage();
			
			RunCommandExec con_r = new RunCommandExec(strCmd);
			con_r.run();
			String strConRetVal = con_r.call();
			String strConResultMessge = con_r.getMessage();
			
			//명령어 실행
//			r.start();
//			try {
//				r.join();
//			} catch (InterruptedException ie) {
//				ie.printStackTrace();
//			}
			String retVal = "";
			if("success".equals(strProRetVal) && "success".equals(strConRetVal)){
				retVal = "success";
			} else {
				retVal = "fail";
			}
//			String strResultMessge = r.getMessage();
			
			socketLogger.info("[PROPERTIES RESULT] " + strProRetVal);
			socketLogger.info("[PROPERTIES MSG] " + strProResultMessge);
			socketLogger.info("##### 파일 전송 결과 : " + strProRetVal + " message : " +strProResultMessge);	

			socketLogger.info("[CONFLUENT RESULT] " + strConRetVal);
			socketLogger.info("[CONFLUENT MSG] " + strConResultMessge);
			socketLogger.info("##### 파일 전송 결과 : " + strConRetVal + " message : " +strConResultMessge);	
			
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
	
	public static void main(String args[]){
//		Properties properties = new Properties();
		CustomProperties properties = new CustomProperties();
//		properties.setProperty("name", "hdfs-sink-dumb");
//		properties.setProperty("connector.class", "io.confluent.connect.hdfs.HdfsSinkConnector");
//		properties.setProperty("tasks.max","1");
//		properties.setProperty("topics","ha_dumb_table");
//		properties.setProperty("hdfs.url",String.valueOf("hdfs://localhost:9000"));
//		properties.setProperty("flush.size","3");
//		properties.setProperty("key.converter","io.confluent.connect.json.JsonSchemaConverter");
//		properties.setProperty("key.converter.schema.registry.url","http://localhost:8081");
//		properties.setProperty("value.converter","io.confluent.connect.json.JsonSchemaConverter");
//		properties.setProperty("value.converter.schema.registry.url","http://localhost:8081");
		
		
		properties.setProperty("name", "hdfs-sink-dumb");
		properties.setProperty("connector.class", "io.confluent.connect.hdfs.HdfsSinkConnector");
		properties.setProperty("tasks.max","1");
		properties.setProperty("topics","ha_dumb_table");
		properties.setProperty("hdfs.url", "hdfs://localhost:9000");
		properties.setProperty("flush.size","3");
		properties.setProperty("key.converter","io.confluent.connect.json.JsonSchemaConverter");
		properties.setProperty("key.converter.schema.registry.url", "http://localhost:8081");
		properties.setProperty("value.converter","io.confluent.connect.json.JsonSchemaConverter");
		properties.setProperty("value.converter.schema.registry.url", "http://localhost:8081");
//		String FilePath = System.getProperty("/home/ec2-user/programs/confluent-6.2.1/etc/kafka-connect-hdfs") + "/test3.properties";
		String FilePath = "C:\\Users\\yj402\\git\\eXperDB-Management\\eXperDB-Management-Agent\\src\\main\\resources\\" + properties.getProperty("name") +".properties";
//		if (!file.exists()){}
			try {
				FileOutputStream fos = new FileOutputStream(FilePath);
//				os_h.write(properties.save(os_h, FilePath););
//				file.createNewFile();
//				properties.save(fos, FilePath);
//				properties.storeToXML(fos, FilePath);
				properties.store(fos, FilePath);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		
			
		String test = properties.getProperty("key.converter.schema.registry.url");
		System.out.println(test);
		properties.list(System.out);
	}
	
}


//public class CustomProperties extends Properties {
//	  private static final long serialVersionUID = 1L;
//	  @Override
//	  public void store(OutputStream out, String comments) throws IOException {
//	      customStore0(new BufferedWriter(new OutputStreamWriter(out, "8859_1")),
//	                   comments, true);
//	  }
//	  //Override to stop '/' or ':' chars from being replaced by not called 
//	  //saveConvert(key, true, escUnicode)
//	  private void customStore0(BufferedWriter bw, String comments, boolean escUnicode)
//	          throws IOException {
//	      bw.write("#" + new Date().toString());
//	      bw.newLine();
//	      synchronized (this) {
//	          for (Enumeration e = keys(); e.hasMoreElements();) {
//	              String key = (String) e.nextElement();
//	              String val = (String) get(key);
//	              // Commented out to stop '/' or ':' chars being replaced
//	              //key = saveConvert(key, true, escUnicode);
//	              //val = saveConvert(val, false, escUnicode);
//	              bw.write(key + "=" + val);
//	              bw.newLine();
//	          }
//	      }
//	      bw.flush();
//	  }
//	}