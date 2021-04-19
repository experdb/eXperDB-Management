package com.experdb.proxy.socket.listener;

import java.sql.Connection;
import java.sql.DriverManager;
import java.util.HashMap;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;

import com.experdb.proxy.db.SqlSessionManager;
import com.experdb.proxy.db.repository.service.SystemServiceImpl;
import com.experdb.proxy.db.repository.vo.DbServerInfoVO;
import com.experdb.proxy.server.SocketExt;
import com.experdb.proxy.socket.ProtocolID;
import com.experdb.proxy.util.AES256;
import com.experdb.proxy.util.AES256_KEY;
import com.experdb.proxy.util.FileUtil;

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
public class ServerCheckListener extends Thread {

	// private SystemServiceImpl service;
	ApplicationContext context = null;
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");

	public ServerCheckListener(ApplicationContext context) throws Exception {
		this.context = context;
	}

	@Override
	public void run() {
		int i = 0;

		while (!Thread.interrupted()) {

			SystemServiceImpl service = (SystemServiceImpl) context.getBean("SystemService");

			try {
//이부분은 체크들이 들어가면 될듯함
				String strIpadr = FileUtil.getPropertyValue("context.properties", "agent.install.ip");

				DbServerInfoVO vo = new DbServerInfoVO();
				vo.setIPADR(strIpadr);
/*
				DbServerInfoVO dbServerInfoVO = service.selectDatabaseConnInfo(vo);
*/
/*				String IPADR = dbServerInfoVO.getIPADR();
				int PORTNO = dbServerInfoVO.getPORTNO();
				String DB_SVR_NM = dbServerInfoVO.getDB_SVR_NM();
				String DFT_DB_NM = dbServerInfoVO.getDFT_DB_NM();
				String SVR_SPR_USR_ID = dbServerInfoVO.getSVR_SPR_USR_ID();
				String SVR_SPR_SCM_PWD = dbServerInfoVO.getSVR_SPR_SCM_PWD();
*/
/*				AES256 aes = new AES256(AES256_KEY.ENC_KEY);

				JSONObject serverObj = new JSONObject();

				serverObj.put(ProtocolID.SERVER_NAME, DB_SVR_NM);
				serverObj.put(ProtocolID.SERVER_IP, IPADR);
				serverObj.put(ProtocolID.SERVER_PORT, PORTNO);
				serverObj.put(ProtocolID.DATABASE_NAME, DFT_DB_NM);
				serverObj.put(ProtocolID.USER_ID, SVR_SPR_USR_ID);
				serverObj.put(ProtocolID.USER_PWD, aes.aesDecode(SVR_SPR_SCM_PWD));
*/
				String strMasterGbn = "";
				String strIsMasterGbn = "";

				// socketLogger.info("@@@@@@ before : " + strMasterGbn + " @@@@
				// after : " + strMasterGbn);

				try {
/*					strMasterGbn = selectConnectInfo(serverObj);
*/
					DbServerInfoVO masterGbnVo = new DbServerInfoVO();
					masterGbnVo.setIPADR(strIpadr);
/*					DbServerInfoVO resultMasterGbnVO = service.selectISMasterGbm(masterGbnVo);
*/
/*					strIsMasterGbn = resultMasterGbnVO.getMASTER_GBN();*/
/*
					dbServerInfoVO.setMASTER_GBN(strMasterGbn);
					dbServerInfoVO.setDB_CNDT("Y");*/
/*
					if (resultMasterGbnVO.getDB_CNDT().equals("N")) {
						service.updateDB_CNDT(dbServerInfoVO);
					}*/

					 //socketLogger.info("@@@@@@ before : " + strMasterGbn + " @@@@ after : " + strMasterGbn);

					if (!strIsMasterGbn.equals(strMasterGbn)) {
/*						if (strMasterGbn.equals("M")) {
							service.updateDBSlaveAll(dbServerInfoVO);
						}*/

/*						service.updateDB_CNDT(dbServerInfoVO);*/
					}

				} catch (Exception e) {

					errLogger.error("Master/Slave Check Error {}", e.toString());
					// socketLogger.info("@@@@@@ err : " + e.toString());
					strMasterGbn = "S";
/*					dbServerInfoVO.setMASTER_GBN(strMasterGbn);
					dbServerInfoVO.setDB_CNDT("N");*/

/*					service.updateDB_CNDT(dbServerInfoVO);*/
				}
/*
				serverObj = null;
				aes = null;
*/
				i++;

				try {
					Thread.sleep(3000);
				} catch (InterruptedException ex) {
					this.interrupt();
					continue;
				}

			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				service = null;
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

}
