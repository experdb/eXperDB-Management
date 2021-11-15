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
import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.client.ClientProtocolID;
import com.k4m.dx.tcontrol.util.CustomProperties;
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
		
		String strCmd = (String) jObj.get(ProtocolID.REQ_CMD);
		
		JSONObject CONNECTObj = (JSONObject) jObj.get(ProtocolID.CONNECT_INFO);
		JSONObject MAPPObj = (JSONObject) jObj.get(ProtocolID.MAPP_INFO);
		
		TransServiceImpl transService = (TransServiceImpl) context.getBean("TransService");
		
		/*
		name=타겟커넥터네임
				connector.class=io.confluent.connect.hdfs.HdfsSinkConnector
				tasks.max=1
				topics=토픽이름
				hdfs.url=hdfs://localhost:9000
				flush.size=3
				key.converter=io.confluent.connect.json.JsonSchemaConverter
				key.converter.schema.registry.url=http://localhost:8081
				value.converter=io.confluent.connect.json.JsonSchemaConverter
				value.converter.schema.registry.url=http://localhost:8081
			
		*/
		CustomProperties properties = new CustomProperties();
		properties.setProperty("name", String.valueOf(CONNECTObj.get("connect_nm")));
		properties.setProperty("connector.class", "io.confluent.connect.hdfs.HdfsSinkConnector");
		properties.setProperty("tasks.max","1");
		properties.setProperty("topics",String.valueOf(MAPPObj.get("exrt_trg_tb_nm")));
		properties.setProperty("hdfs.url","hdfs://localhost:9000");
		properties.setProperty("flush.size","3");
		properties.setProperty("key.converter","io.confluent.connect.json.JsonSchemaConverter");
		properties.setProperty("key.converter.schema.registry.url","http://localhost:8081");
		properties.setProperty("value.converter","io.confluent.connect.json.JsonSchemaConverter");
		properties.setProperty("value.converter.schema.registry.url","http://localhost:8081");
		
		String FilePath = "/home/ec2-user/programs/confluent-6.2.1/etc/kafka-connect-hdfs/" + String.valueOf(CONNECTObj.get(ClientProtocolID.FILE_NAME));
		try {
			FileOutputStream fos = new FileOutputStream(FilePath);
			properties.store(fos, FilePath);
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		// FILE 보내 ... - 키를 넣어서 보내야함... 넣어도...?
		
		// CMD 실행
	}
	
	public static void main(String args[]){
//		Properties properties = new Properties();
		CustomProperties properties = new CustomProperties();
		properties.setProperty("name", "target_test3");
		properties.setProperty("connector.class", "io.confluent.connect.hdfs.HdfsSinkConnector");
		properties.setProperty("tasks.max","1");
		properties.setProperty("topics","trans_test");
		properties.setProperty("hdfs.url",String.valueOf("hdfs://localhost:9000"));
		properties.setProperty("flush.size","3");
		properties.setProperty("key.converter","io.confluent.connect.json.JsonSchemaConverter");
		properties.setProperty("key.converter.schema.registry.url","http://localhost:8081");
		properties.setProperty("value.converter","io.confluent.connect.json.JsonSchemaConverter");
		properties.setProperty("value.converter.schema.registry.url","http://localhost:8081");
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