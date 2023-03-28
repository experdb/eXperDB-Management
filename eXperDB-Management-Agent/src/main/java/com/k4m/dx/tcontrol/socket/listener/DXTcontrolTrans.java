package com.k4m.dx.tcontrol.socket.listener;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.json.simple.JSONObject;
import org.quartz.Scheduler;
import org.quartz.SchedulerFactory;
import org.quartz.impl.StdSchedulerFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.k4m.dx.tcontrol.db.SqlSessionManager;
import com.k4m.dx.tcontrol.db.repository.service.SystemServiceImpl;
import com.k4m.dx.tcontrol.db.repository.vo.DbServerInfoVO;
import com.k4m.dx.tcontrol.server.SocketExt;
import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.util.AES256;
import com.k4m.dx.tcontrol.util.AES256_KEY;
import com.k4m.dx.tcontrol.util.FileUtil;
import com.k4m.dx.tcontrol.util.PgHbaConfigLine;
 
public class DXTcontrolTrans extends SocketCtl {
	private SchedulerFactory schedulerFactory = null;
	private Scheduler scheduler = null;
	private static ApplicationContext context;
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
    public static void main(String[] args) {   
    	DXTcontrolTrans dXTcontrolScale = new DXTcontrolTrans();
    	dXTcontrolScale.start();
    }
    
    public DXTcontrolTrans() {
        try {
	    	schedulerFactory = new StdSchedulerFactory();
	    	scheduler = schedulerFactory.getScheduler();
        } catch(Exception e) {
            e.printStackTrace();
        }
    }

    public void start() {
		context = new ClassPathXmlApplicationContext(new String[] {"context-tcontrol.xml"});
		SystemServiceImpl service = (SystemServiceImpl) context.getBean("SystemService");

		try {
			String strIpadr = FileUtil.getPropertyValue("context.properties", "agent.install.ip");

			DbServerInfoVO dbServerInfoVO = new DbServerInfoVO();
			dbServerInfoVO.setIPADR(strIpadr);
			DbServerInfoVO resultMasterGbnVO = service.selectDatabaseConnInfo(dbServerInfoVO);
			
			//pg_hbf 설정
			setPgHbaConf(resultMasterGbnVO);
			
			String strTransYN = FileUtil.getPropertyValue("context.properties", "agent.trans_yn");

			if ("Y".equals(strTransYN)) {
				//postgresql 설정
				setPostgresql(resultMasterGbnVO);
			} else {
				//postgresql 설정
				setNotPostgresql(resultMasterGbnVO);
			}
			

		//String poolName = "" + dbInfoObj.get(ProtocolID.SERVER_IP) + "_" + dbInfoObj.get(ProtocolID.DATABASE_NAME) + "_" + dbInfoObj.get(ProtocolID.SERVER_PORT);
        } catch(Exception e) {
            e.printStackTrace();
        } 
    }
    
    //pg_hbf 설정
	public String setPgHbaConf(DbServerInfoVO resultMasterGbnVO) throws Exception {
		String result ="true";
    	List<LinkedHashMap<String, String>> arrResult = new ArrayList<LinkedHashMap<String, String>>();
		SqlSessionFactory sqlSessionFactory = null;
		sqlSessionFactory = SqlSessionManager.getInstance();

		Connection connDB = null;
		SqlSession sessDB = null;
		List<Object> selectList = new ArrayList<Object>();
		
		JSONObject serverObj = new JSONObject();
		AES256 dec = new AES256(AES256_KEY.ENC_KEY);

		try {
			if (resultMasterGbnVO != null) {
				String poolName = "" + resultMasterGbnVO.getIPADR() + "_" + resultMasterGbnVO.getDFT_DB_NM() + "_" + resultMasterGbnVO.getPORTNO();

				serverObj.put(ProtocolID.SERVER_NAME, resultMasterGbnVO.getDB_SVR_NM());
				serverObj.put(ProtocolID.SERVER_IP, resultMasterGbnVO.getIPADR());
				serverObj.put(ProtocolID.SERVER_PORT, resultMasterGbnVO.getPORTNO());
				serverObj.put(ProtocolID.DATABASE_NAME, resultMasterGbnVO.getDFT_DB_NM());
				serverObj.put(ProtocolID.USER_ID, resultMasterGbnVO.getSVR_SPR_USR_ID());
				serverObj.put(ProtocolID.USER_PWD, dec.aesDecode(resultMasterGbnVO.getSVR_SPR_SCM_PWD()));

				SocketExt.setupDriverPool(serverObj, poolName);

				//DB 컨넥션을 가져온다.
				connDB = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);
				sessDB = sqlSessionFactory.openSession(connDB);
				
				selectList = sessDB.selectList("app.selectAuthentication");

				sessDB.close();
				connDB.close();
		
				String[] arrData = null;
/*				
				for(int i=0; i<selectList.size(); i++) {
					arrData = selectList.get(0).toString().split("\n");
				}
				*/
				if (selectList.size() > 0) {
					String strData = selectList.get(0).toString();
					arrData = strData.split("\n");
					
					if (!"".equals(strData)) {
						strData = strData.replace("{pg_read_file=", "");
						String lastCharacter = strData.substring(strData.length() - 1);
						if ("}".equals(lastCharacter)) {
							strData = strData.substring(0,strData.length() - 1);
						}
					}
					arrData = strData.split("\n");
				}
				
				int localAll = 0;
				int hostAll_local = 0;
				int hostAll_128 = 0;
				int hostAllTot = 3;
				
				for(int i=0; i<arrData.length; i++) {
				    PgHbaConfigLine config = new PgHbaConfigLine(arrData[i]);

					if(config.isValid() || (!config.isValid() && !config.isComment()) && !(config.getText()).isEmpty()){
						
						//  local all
						if ("local".equals(config.getConnectType()) && "replication".equals(config.getDatabase()) && ("all".equals(config.getUser()) || "postgres".equals(config.getUser()) || "experdb".equals(config.getUser()))
							&& "trust".equals(config.getMethod())
							) {
							localAll = localAll +1;
						}
						
						//  host all 127.0.0.1/32
						if ("host".equals(config.getConnectType()) && "replication".equals(config.getDatabase()) && ("all".equals(config.getUser()) || "postgres".equals(config.getUser()) || "experdb".equals(config.getUser()))
							&& "127.0.0.1/32".equals(config.getIpaddress()) && "trust".equals(config.getMethod())
							) {
							hostAll_local = hostAll_local +1;
						}
						
						//  host all 127.0.0.1/32
						if ("host".equals(config.getConnectType()) && "replication".equals(config.getDatabase()) && ("all".equals(config.getUser()) || "postgres".equals(config.getUser()) || "experdb".equals(config.getUser()))
							&& "::1/128".equals(config.getIpaddress()) && "trust".equals(config.getMethod())
							) {
							hostAll_128 = hostAll_128 +1;
						}
					}
				}
				
				hostAllTot = hostAllTot - (localAll + hostAll_local + hostAll_128);
				
				//값이 없는 경우 데이터 추가
				if (hostAllTot > 0) {
					String buffer = "";
					String bufferNew = "";
					List<Object> selectListChk = new ArrayList<Object>();
					String[] arrDataChk = null;
					
					for(int i=0; i<hostAllTot; i++){
						PgHbaConfigLine config =  new PgHbaConfigLine(null);

						config.setChanged(true);
						config.setComment(false);

						if (localAll <= 0) {
							config.setConnectType("local");
							config.setDatabase("replication");
							config.setUser("all");
							config.setIpaddress("");
							config.setIpmask("");
							config.setMethod("trust");
							config.setOption("");
						}
						
						if (hostAll_local <= 0) {
							config.setConnectType("host");
							config.setDatabase("replication");
							config.setUser("all");
							config.setIpaddress("127.0.0.1/32");
							config.setIpmask("");
							config.setMethod("trust");
							config.setOption("");
						}
						
						if (hostAll_128 <= 0) {
							config.setConnectType("host");
							config.setDatabase("replication");
							config.setUser("all");
							config.setIpaddress("::1/128");
							config.setIpmask("");
							config.setMethod("trust");
							config.setOption("");
						}
						
						bufferNew += config.getText() + "\n";
					}

					sqlSessionFactory = SqlSessionManager.getInstance();
					
					connDB = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);
					sessDB = sqlSessionFactory.openSession(connDB);
					

					selectListChk = sessDB.selectList("app.selectAuthentication");

					if(selectListChk.size() > 0) {
						HashMap hp = new HashMap();
						hp = (HashMap) selectList.get(0);
						
						String strPgHbaData = (String) hp.get("pg_read_file");
						arrDataChk = strPgHbaData.split("\n");

						for(int j=0; j<arrDataChk.length; j++) {
							buffer += arrData[j].toString() + "\n";
						}
						
						buffer += bufferNew;
					}
					
					if (!"".equals(buffer)) {
						buffer = buffer.replace("{pg_read_file=", "");

						String lastCharacter = buffer.substring(buffer.length() - 1);
						if ("}".equals(lastCharacter)) {
							buffer = buffer.substring(0,buffer.length() - 1);
						}
					}

					HashMap hp = new HashMap();
					hp.put("hbadata", buffer);
					
					sessDB.selectList("app.selectPgConfUnlink");
					sessDB.selectList("app.selectPgConfWrite", hp);
					sessDB.selectList("app.selectPgConfRename");
					sessDB.selectList("app.selectPgConfReload");
				}

				socketLogger.info("DXTcontrolScaleAwsExecute.localAll : " + localAll);
				socketLogger.info("DXTcontrolScaleAwsExecute.hostAll_local : " + hostAll_local);
				socketLogger.info("DXTcontrolScaleAwsExecute.hostAll_128 : " + hostAll_128);
			}

			sessDB.close();
			connDB.close();
		} catch (Exception e) {
		//	errLogger.error("selectAuthentication {} ", e.toString());
			//throw e;
			result = "false";
			return result;
		} finally {

			if(sessDB !=null) sessDB.close();
			if(connDB !=null) connDB.close();
		}	
		return result;
	}

    //pg_hbf 설정
	public String setPostgresql(DbServerInfoVO resultMasterGbnVO) throws Exception {
		String result = "true";

		SqlSessionFactory sqlSessionFactory = null;
		sqlSessionFactory = SqlSessionManager.getInstance();

		JSONObject serverObj = new JSONObject();
		AES256 dec = new AES256(AES256_KEY.ENC_KEY);
		List<Object> selectList = new ArrayList<Object>();
		
		Connection connDB = null;
		SqlSession sessDB = null;

		try {
			if (resultMasterGbnVO != null) {
				String poolName = "" + resultMasterGbnVO.getIPADR() + "_" + resultMasterGbnVO.getDFT_DB_NM() + "_" + resultMasterGbnVO.getPORTNO();

				serverObj.put(ProtocolID.SERVER_NAME, resultMasterGbnVO.getDB_SVR_NM());
				serverObj.put(ProtocolID.SERVER_IP, resultMasterGbnVO.getIPADR());
				serverObj.put(ProtocolID.SERVER_PORT, resultMasterGbnVO.getPORTNO());
				serverObj.put(ProtocolID.DATABASE_NAME, resultMasterGbnVO.getDFT_DB_NM());
				serverObj.put(ProtocolID.USER_ID, resultMasterGbnVO.getSVR_SPR_USR_ID());
				serverObj.put(ProtocolID.USER_PWD, dec.aesDecode(resultMasterGbnVO.getSVR_SPR_SCM_PWD()));

				SocketExt.setupDriverPool(serverObj, poolName);

				//DB 컨넥션을 가져온다.
				connDB = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);
				
				sessDB = sqlSessionFactory.openSession(connDB);

				selectList = sessDB.selectList("app.selectPostgresql");

				sessDB.close();
				connDB.close();

				String[] arrData = null;
/*				
				for(int i=0; i<selectList.size(); i++) {
					arrData = selectList.get(0).toString().split("\n");
				}
				*/
				if (selectList.size() > 0) {
					String strData = selectList.get(0).toString();
					arrData = strData.split("\n");
					
					if (!"".equals(strData)) {
						strData = strData.replace("{pg_read_file=", "");

						String lastCharacter = strData.substring(strData.length() - 1);
						if ("}".equals(lastCharacter)) {
							strData = strData.substring(0,strData.length() - 1);
						}
					}
					
					arrData = strData.split("\n");
				}
				
				
				if (arrData != null) {
					sqlSessionFactory = SqlSessionManager.getInstance();
					
					connDB = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);
					sessDB = sqlSessionFactory.openSession(connDB);
					
					String buffer = "";

					if (arrData.length > 0) {
						for(int i=0; i<arrData.length; i++) {
							String rowData = arrData[i].toString();

							if (rowData.matches(".*shared_preload_libraries.*")) { //shared_preload_libraries
								if (rowData.matches(".*wal2json.*")) {
									buffer += rowData.trim() + "\n";
								} else {
									String strShared = rowData.trim();

									if(!strShared.substring(strShared.length()-2 , strShared.length()-1).equals("\'")) {
										buffer += strShared.substring(0 , strShared.length()-1) + ",wal2json\'" + "\n"; 
									} else {
										buffer += strShared.substring(0 , strShared.length()-1) + "wal2json\'" + "\n"; 
									}
								}
							} else  if (rowData.matches(".*wal_level.*")) {
								if (rowData.matches(".*logical.*")) {
									buffer += rowData.trim() + "\n";
								} else {
									buffer += "wal_level = logical" + "\n";
								}
							} else  if (rowData.matches(".*max_wal_senders.*")) {
								String maxWalSenders = rowData.replaceAll("\\s", "");
								maxWalSenders = maxWalSenders.substring(maxWalSenders.lastIndexOf("=") + 1 , maxWalSenders.length());

								int maxWalSendersCnt = 0;

								if (!"".equals(maxWalSenders)) {
									maxWalSendersCnt = Integer.parseInt(maxWalSenders);

									if (maxWalSendersCnt < 4) {
										buffer += "max_wal_senders = 4" + "\n";
									} else {
										if (rowData.trim().charAt(0) == '#') {
											buffer +=  maxWalSenders.substring(1 , maxWalSenders.length());
										} else {
											buffer += rowData.trim() + "\n";
										}
									}
								} else {
									buffer += "max_wal_senders = 4" + "\n";
								}
								
							} else  if (rowData.matches(".*max_replication_slots.*")) {
								String maxReplicationSlots = rowData.replaceAll("\\s", "");
								maxReplicationSlots = maxReplicationSlots.substring(maxReplicationSlots.lastIndexOf("=") + 1 , maxReplicationSlots.length());

								int maxReplicationSlotsCnt = 0;

								if (!"".equals(maxReplicationSlots)) {
									maxReplicationSlotsCnt = Integer.parseInt(maxReplicationSlots);

									if (maxReplicationSlotsCnt < 4) {
										buffer += "max_replication_slots = 4" + "\n";
									} else {
										if (rowData.trim().charAt(0) == '#') {
											buffer +=  maxReplicationSlots.substring(1 , maxReplicationSlots.length());
										} else {
											buffer += rowData.trim() + "\n";
										}
									}
									
								} else {
									buffer += "max_replication_slots = 4" + "\n";
								}
								
							} else {
								buffer += rowData.trim() + "\n";
							}
						}
					}

					HashMap hp = new HashMap();
					hp.put("hbadata", buffer);
					
					sessDB.selectList("app.selectPostgresqlUnlink");
					sessDB.selectList("app.selectPostgresqlWrite", hp);
					sessDB.selectList("app.selectPostgresqlRename");
					sessDB.selectList("app.selectPgConfReload");
					
					socketLogger.info("DXTcontrolScaleAwsExecute.bufferbufferbufferbuffer : " + buffer);
				}
			}

			sessDB.close();
			connDB.close();
		} catch (Exception e) {
		//	errLogger.error("selectAuthentication {} ", e.toString());
			//throw e;
			result = "false";
			return result;
		} finally {

			if(sessDB !=null) sessDB.close();
			if(connDB !=null) connDB.close();
		}	
		return result;
	}
	
	   
    //pg_hbf 설정
	public String setNotPostgresql(DbServerInfoVO resultMasterGbnVO) throws Exception {
		String result = "true";

		SqlSessionFactory sqlSessionFactory = null;
		sqlSessionFactory = SqlSessionManager.getInstance();

		JSONObject serverObj = new JSONObject();
		AES256 dec = new AES256(AES256_KEY.ENC_KEY);
		List<Object> selectList = new ArrayList<Object>();
		
		Connection connDB = null;
		SqlSession sessDB = null;

		try {
			if (resultMasterGbnVO != null) {
				String poolName = "" + resultMasterGbnVO.getIPADR() + "_" + resultMasterGbnVO.getDFT_DB_NM() + "_" + resultMasterGbnVO.getPORTNO();

				serverObj.put(ProtocolID.SERVER_NAME, resultMasterGbnVO.getDB_SVR_NM());
				serverObj.put(ProtocolID.SERVER_IP, resultMasterGbnVO.getIPADR());
				serverObj.put(ProtocolID.SERVER_PORT, resultMasterGbnVO.getPORTNO());
				serverObj.put(ProtocolID.DATABASE_NAME, resultMasterGbnVO.getDFT_DB_NM());
				serverObj.put(ProtocolID.USER_ID, resultMasterGbnVO.getSVR_SPR_USR_ID());
				serverObj.put(ProtocolID.USER_PWD, dec.aesDecode(resultMasterGbnVO.getSVR_SPR_SCM_PWD()));

				SocketExt.setupDriverPool(serverObj, poolName);

				//DB 컨넥션을 가져온다.
				connDB = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);
				
				sessDB = sqlSessionFactory.openSession(connDB);

				selectList = sessDB.selectList("app.selectPostgresql");

				sessDB.close();
				connDB.close();

				String[] arrData = null;
				
/*				for(int i=0; i<selectList.size(); i++) {
					arrData = selectList.get(0).toString().split("\n");
				}*/
				
				if (selectList.size() > 0) {
					String strData = selectList.get(0).toString();
					arrData = strData.split("\n");
					
					if (!"".equals(strData)) {
						strData = strData.replace("{pg_read_file=", "");

						String lastCharacter = strData.substring(strData.length() - 1);
						if ("}".equals(lastCharacter)) {
							strData = strData.substring(0,strData.length() - 1);
						}
					}
					
					arrData = strData.split("\n");
				}
				
				if (arrData != null) {
					sqlSessionFactory = SqlSessionManager.getInstance();
					
					connDB = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);
					sessDB = sqlSessionFactory.openSession(connDB);
					
					String buffer = "";

					if (arrData.length > 0) {
						for(int i=0; i<arrData.length; i++) {
							String rowData = arrData[i].toString();

							if (rowData.matches(".*shared_preload_libraries.*")) { //shared_preload_libraries
								if (rowData.matches(".*wal2json.*")) {
									
									String strShared = rowData.trim();
									
									if(strShared.contains(",wal2json") == true) {
										strShared = strShared.replace(",wal2json", "");
									} else {
										strShared = strShared.replace("wal2json", "");
									}

									buffer += strShared + "\n";
								} else {
									buffer += rowData.trim() + "\n";
								}
							} else  if (rowData.matches(".*wal_level.*")) {
								if (rowData.matches(".*logical.*")) {
									buffer += "wal_level = replica" + "\n";
								} else {
									buffer += rowData.trim() + "\n";
								}
							} else {
								buffer += rowData.trim() + "\n";
							}
						}
					}

					HashMap hp = new HashMap();
					hp.put("hbadata", buffer);
					
					sessDB.selectList("app.selectPostgresqlUnlink");
					sessDB.selectList("app.selectPostgresqlWrite", hp);
					sessDB.selectList("app.selectPostgresqlRename");
					sessDB.selectList("app.selectPgConfReload");
				}
			}

			sessDB.close();
			connDB.close();
		} catch (Exception e) {
		//	errLogger.error("selectAuthentication {} ", e.toString());
			//throw e;
			result = "false";
			return result;
		} finally {

			if(sessDB !=null) sessDB.close();
			if(connDB !=null) connDB.close();
		}	
		return result;
	}
}