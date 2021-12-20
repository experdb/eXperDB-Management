package com.k4m.dx.tcontrol.socket.listener;

import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.k4m.dx.tcontrol.db.repository.service.ScaleServiceImpl;
import com.k4m.dx.tcontrol.db.SqlSessionManager;
import com.k4m.dx.tcontrol.server.SocketExt;
import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.util.AES256;
import com.k4m.dx.tcontrol.util.AES256_KEY;
import com.k4m.dx.tcontrol.util.FileUtil;
/**
* @author 박태혁
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2018.04.23   박태혁 최초 생성
*      </pre>
*/
public class ScaleCheckListener extends Thread {

	// private SystemServiceImpl service;
	ApplicationContext context = null;
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");

	public ScaleCheckListener(ApplicationContext context) throws Exception {
		this.context = context;
	}

	@Override
	public void run() {
		int i = 0;
		socketLogger.info("Thread.interrupted() : " + Thread.interrupted());
		while (!Thread.interrupted()) {

			try {
				DXTcontrolScale rSet = new DXTcontrolScale();
				rSet.start();
				
				i++;

				try {
					Thread.sleep(600000); //10분에 한번
				} catch (InterruptedException ex) {
					this.interrupt();
					continue;
				}

			} catch (Exception e) {
				e.printStackTrace();
			}
		}

	}

	private String selectConnectInfo(JSONObject serverInfoObj) throws Exception {

		SqlSessionFactory sqlSessionFactory = null;

		sqlSessionFactory = SqlSessionManager.getInstance();

		String poolName = "" + serverInfoObj.get(ProtocolID.SERVER_IP) + "_" + serverInfoObj.get(ProtocolID.DATABASE_NAME) + "_" + serverInfoObj.get(ProtocolID.SERVER_PORT);

		Connection connDB = null;
		SqlSession sessDB = null;

		String strMasterGbn = "";

		try {

			SocketExt.setupDriverPool(serverInfoObj, poolName);

			// DB 컨넥션을 가져온다.
			connDB = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);

			sessDB = sqlSessionFactory.openSession(connDB);

			HashMap hp = (HashMap) sessDB.selectOne("app.selectMasterGbm");

			strMasterGbn = (String) hp.get("master_gbn");
			
			sessDB.close();
			connDB.close();

		} catch (Exception e) {
			throw e;
		} finally {

			if(sessDB !=null) sessDB.close();
			if(connDB !=null) connDB.close();
		}

		return strMasterGbn;

	}
	
	//타 서버 experdb 모니터링 repoDB 연결
	public Map<String, Object> selectMonInfo(Map<String, Object> param) {
		
		SqlSessionFactory sqlSessionFactory = null;
		sqlSessionFactory = SqlSessionManager.getInstance();

		Connection connDB = null;
		SqlSession sessDB = null;
		JSONObject serverObj = new JSONObject();

		Map<String, Object> resultObj = new HashMap<>();
		Map<String, Object> scaleCommon = new HashMap<String, Object>();
		
		StandardPBEStringEncryptor pbeEnc = new StandardPBEStringEncryptor();
		pbeEnc.setPassword("k4mda"); // PBE 값(XML PASSWORD설정)

		//접속정보 setting
		String mon_ip = "";
		String mon_port = "";
		String mon_database = "";
		String enc_user = "";
		String enc_passwd = "";
		
		//복호화 정보 setting
		String mon_user = "";
		String mon_password = "";

		try {
			//DB 조회 필요
			socketLogger.info("ScaleCheckListener.selectMonInfo.mon_db_search : ");

			context = new ClassPathXmlApplicationContext(new String[] {"context-tcontrol.xml"});
			ScaleServiceImpl service = (ScaleServiceImpl) context.getBean("ScaleService");

    		param.put("db_svr_id", service.dbServerInfoSet());
    		param.put("db_svr_ipadr_id", service.dbServerIPadrInfoSet());

    		scaleCommon = service.selectAutoScaleComCngInfo(param);
    		
			if (scaleCommon != null) {
				if (scaleCommon.get("mon_ip") != null && scaleCommon.get("mon_port") != null && scaleCommon.get("mon_database") != null
					&& scaleCommon.get("mon_user") != null && scaleCommon.get("mon_password") != null) {

					mon_ip = String.valueOf(scaleCommon.get("mon_ip"));
					mon_port = String.valueOf(scaleCommon.get("mon_port"));
					mon_database = String.valueOf(scaleCommon.get("mon_database"));
					enc_user = String.valueOf(scaleCommon.get("mon_user"));
					enc_passwd = String.valueOf(scaleCommon.get("mon_password"));
				} else {
					mon_ip= FileUtil.getPropertyValue("context.properties", "agent.scale_monitoring_ip");
					mon_port = FileUtil.getPropertyValue("context.properties", "agent.scale_monitoring_port");
					mon_database = FileUtil.getPropertyValue("context.properties", "agent.scale_monitoring_database");
					enc_user = FileUtil.getPropertyValue("context.properties", "agent.scale_monitoring_user");
					enc_passwd= FileUtil.getPropertyValue("context.properties", "agent.scale_monitoring_passwd");
				}
			} else {
				mon_ip= FileUtil.getPropertyValue("context.properties", "agent.scale_monitoring_ip");
				mon_port = FileUtil.getPropertyValue("context.properties", "agent.scale_monitoring_port");
				mon_database = FileUtil.getPropertyValue("context.properties", "agent.scale_monitoring_database");
				enc_user = FileUtil.getPropertyValue("context.properties", "agent.scale_monitoring_user");
				enc_passwd= FileUtil.getPropertyValue("context.properties", "agent.scale_monitoring_passwd");
			}

			if (enc_user != null && !enc_user.isEmpty() && enc_passwd != null && !enc_passwd.isEmpty()) {
				mon_user = pbeEnc.decrypt(enc_user);
				mon_password = pbeEnc.decrypt(enc_passwd);
			}

			String poolName = "" + mon_ip + "_" + mon_database + "_" + mon_port;
			socketLogger.info("poolName : " + poolName);

			serverObj.put(ProtocolID.SERVER_IP, mon_ip);
			serverObj.put(ProtocolID.SERVER_PORT, mon_port);
			serverObj.put(ProtocolID.DATABASE_NAME, mon_database);
			serverObj.put(ProtocolID.USER_ID, mon_user);
			serverObj.put(ProtocolID.USER_PWD, mon_password);

			SocketExt.setupDriverPool(serverObj, poolName);
			socketLogger.info("ScaleCheckListener.poolName : " + poolName);

			//DB 컨넥션을 가져온다.
			connDB = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);
			sessDB = sqlSessionFactory.openSession(connDB);
			resultObj = (Map<String, Object>)sessDB.selectOne("scale.selectMonitorInfo", param);
			socketLogger.info("ScaleCheckListener.resultObj : " + resultObj.toString());

			sessDB.close();
			connDB.close();
		} catch (Exception e) {
			// TODO: handle exception
		} finally {
			try {
				if(sessDB !=null)	sessDB.close();
				if(connDB !=null)	connDB.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		return resultObj;
	}
	
	//monitoring 테스트
	/*	
	public void selectMonInfoTest() {
		
		SqlSessionFactory sqlSessionFactory = null;
		sqlSessionFactory = SqlSessionManager.getInstance();
		socketLogger.info("333333333333333333333333333333333333");
		Connection connDB = null;
		SqlSession sessDB = null;
		JSONObject serverObj = new JSONObject();
		socketLogger.info("44444444444444444444444444444444444444444444444");
		Map<String, Object> resultObj = new HashMap<>();
		Map<String, Object> param = new HashMap<>();

//		StandardPBEStringEncryptor pbeEnc = new StandardPBEStringEncryptor();
		socketLogger.info("555555555555555555555555555555555555555555555");
		try {
			socketLogger.info("666666666666666666666666666666666666666666666");
			String mon_ip= FileUtil.getPropertyValue("context.properties", "agent.scale_monitoring_ip");
			String mon_port = FileUtil.getPropertyValue("context.properties", "agent.scale_monitoring_port");
			String mon_database = FileUtil.getPropertyValue("context.properties", "agent.scale_monitoring_database");
			String enc_user = FileUtil.getPropertyValue("context.properties", "agent.scale_monitoring_user");
			String enc_passwd= FileUtil.getPropertyValue("context.properties", "agent.scale_monitoring_passwd");
			String strIpadr = FileUtil.getPropertyValue("context.properties", "agent.install.ip");
//			String user = pbeEnc.decrypt(enc_user);
//			String password = pbeEnc.decrypt(enc_passwd);
			
			param.put("IPADR", strIpadr);
			String poolName = "" + mon_ip + "_experdb" + "_" + mon_port;
			
//			socketLogger.info("ScaleCheckListener.user============================= : " + user);
//			socketLogger.info("ScaleCheckListener.password============================= : " + password);
			socketLogger.info("poolName : " + poolName);
			socketLogger.info("88888888888888888888888888888888888888888888888888888888");
			serverObj.put(ProtocolID.SERVER_IP, mon_ip);
			serverObj.put(ProtocolID.SERVER_PORT, mon_port);
			serverObj.put(ProtocolID.DATABASE_NAME, "experdb");
			serverObj.put(ProtocolID.USER_ID, enc_user);
			serverObj.put(ProtocolID.USER_PWD, enc_passwd);
			SocketExt.setupDriverPool(serverObj, poolName);
			socketLogger.info("ScaleCheckListener.poolName============================= : " + poolName);
			
//			Class.forName("org.postgresql.Driver");

			String strDatabaseUrl = "jdbc:postgresql://" + mon_ip + ":" + mon_port + "/experdb";
			Properties props = new Properties();
			props.setProperty("user", "pgmon");
			props.setProperty("password", "pgmon");
//			socketLogger.info("ScaleCheckListener.strDatabaseUrl============================= : " + strDatabaseUrl);

			String strConnUrl = strDatabaseUrl;

//			socketLogger.info("ScaleCheckListener.strConnUrl============================= : " + strConnUrl);
//			connDB = DriverManager.getConnection(strConnUrl, props);
			//DB 컨넥션을 가져온다.
			connDB = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);
			socketLogger.info("ScaleCheckListener.isClosed============================= : " + connDB.isClosed());
			sessDB = sqlSessionFactory.openSession(connDB);
//			resultObj = (Map<String, Object>)sessDB.selectOne("scale.selectMonitorInfo", param);
//			resultObj = (Map<String, Object>)sessDB.selectOne("scale.selectDbServerIpadrInfo", param);
			resultObj = (Map<String, Object>)sessDB.selectOne("app.selectMasterGbm");
			socketLogger.info("ScaleCheckListener.resultObj============================= : " + resultObj.toString());

			sessDB.close();
			connDB.close();
		} catch (Exception e) {
			// TODO: handle exception
		} finally {
			try {
				if(sessDB !=null)	sessDB.close();
				if(connDB !=null)	connDB.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
//		return resultObj;
	}
	
	public static void main(String[] args) throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException {
		
		Connection connDB = null;
		SqlSession sessDB = null;
		JSONObject serverObj = new JSONObject();
		
		Map<String, Object> resultObj = new HashMap<>();
		Map<String, Object> loadParam = new HashMap<>();
		
		try {
			AES256 dec = new AES256(AES256_KEY.ENC_KEY);
			System.out.println("enc : " + dec.aesEncode("pgmon"));

			StandardPBEStringEncryptor pbeEnc = new StandardPBEStringEncryptor();
			pbeEnc.setPassword("k4mda"); // PBE 값(XML PASSWORD설정)
			System.out.println("enc : " + pbeEnc.decrypt("8hHJN7w4zxfWHgdB6oCdmA\\=\\="));
		
//			String mon_ip= FileUtil.getPropertyValue("context.properties", "agent.scale_monitoring_ip");
//			String mon_port = FileUtil.getPropertyValue("context.properties", "agent.scale_monitoring_port");
//			String mon_database = FileUtil.getPropertyValue("context.properties", "agent.scale_monitoring_database");
//			String enc_user = FileUtil.getPropertyValue("context.properties", "agent.scale_monitoring_user");
//			String enc_passwd= FileUtil.getPropertyValue("context.properties", "agent.scale_monitoring_passwd");
			String mon_ip= "192.168.99.5";
			String mon_port = "5432";
			String mon_database = "pgmon";
			String enc_user = "HeCTLG0sChegqz/880R9Lg==";
			String enc_passwd= "HeCTLG0sChegqz/880R9Lg==";
			
			
			
			String user = dec.aesDecode(enc_user);
			String password = dec.aesDecode(enc_passwd);
			
			String poolName = "" + mon_ip + "_" + mon_database + "_" + mon_port;
			
			loadParam.put("IPADR", "192.168.99.5");
//			loadParam.put("REPOIP", "");
			System.out.println("ScaleCheckListener.poolName============================= : " + poolName);
			System.out.println("ScaleCheckListener.user============================= : " + user);
			System.out.println("ScaleCheckListener.user============================= : " + password);
//			socketLogger.info("ScaleCheckListener.user============================= : " + user);
//			socketLogger.info("ScaleCheckListener.password============================= : " + user);


			serverObj.put(ProtocolID.SERVER_IP, mon_ip);
			serverObj.put(ProtocolID.SERVER_PORT, mon_port);
			serverObj.put(ProtocolID.DATABASE_NAME, mon_database);
			serverObj.put(ProtocolID.USER_ID, user);
			serverObj.put(ProtocolID.USER_PWD, password);

//			SocketExt.setupDriverPool(serverObj, poolName);
//			socketLogger.info("ScaleCheckListener.poolName============================= : " + poolName);
			//DB 컨넥션을 가져온다.
//			connDB = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);
//			sessDB = sqlSessionFactory.openSession(connDB);
//			resultObj = (Map<String, Object>)sessDB.selectOne("scale.selectMonitorInfo", loadParam);
//			socketLogger.info("ScaleCheckListener.resultObj============================= : " + resultObj.toString());
//			System.out.println(resultObj.toString());
//			sessDB.close();
//			connDB.close();
		} catch (Exception e) {
			// TODO: handle exception
		} finally {
			try {
				if(sessDB !=null)	sessDB.close();
				if(connDB !=null)	connDB.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
*/
	
}