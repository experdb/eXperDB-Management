package com.k4m.dx.tcontrol.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.lang.ref.WeakReference;
import java.net.Socket;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.k4m.dx.tcontrol.db.SqlSessionManager;
import com.k4m.dx.tcontrol.db.repository.vo.ServerInfoVO;
import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;
import com.k4m.dx.tcontrol.util.CommonUtil;
import com.k4m.dx.tcontrol.util.NetworkUtil;

/**
 * 26.	database server 정보 조회
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

public class DxT021 extends SocketCtl{
	
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	private String[] arrCmd = {
				                "echo $HOSTNAME" //호스트명
			                    , "cat /etc/*-release | awk 'NR==1{print;}'" //버젼
								, "uname -r" //커널
								, "grep -c processor /proc/cpuinfo" //cpu
								, "free -h | awk 'NR>1&&NR<3{print $2}'" //메모리
								, "echo $PGHOME"
								, "echo $PGRBAK"
								, "df -P -h"
								, "echo $PGDBAK"
							   };
	
	public DxT021(Socket socket, BufferedInputStream is, BufferedOutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}
	
	
	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		
		
		JSONObject serverInfoObj = (JSONObject) jObj.get(ProtocolID.SERVER_INFO);
		
		socketLogger.info("execute : " + strDxExCode);
		//byte[] sendBuff;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
	
		//JSONObject outputObj = new JSONObject();
		
		String CMD_HOSTNAME = "";
		String CMD_OS_VERSION = "";
		String CMD_OS_KERNUL =  "";
		String CMD_CPU = "";
		String CMD_MEMORY = "";
		//ArrayList<HashMap<String, String>> ipList = new ArrayList<HashMap<String, String>>();
		//List<ServerInfoVO> serverInfoList = new ArrayList<ServerInfoVO>();
		String CMD_DBMS_PATH = "";
		String CMD_BACKUP_PATH = "";
		String PGDBAK = "";
		
		
				
		try {
			HashMap resultHP = new HashMap();
			
			//test(resultHP);
			
			CommonUtil util = new CommonUtil();

		//호스트명
			CMD_HOSTNAME = util.getPidExec(arrCmd[0]);
			resultHP.put(ProtocolID.CMD_HOSTNAME, CMD_HOSTNAME);
			
			//OS 정보
			//String CMD_OS_VERSION = System.getProperty("os.name") + System.getProperty("os.version");
			CMD_OS_VERSION = util.getPidExec(arrCmd[1]);
			resultHP.put(ProtocolID.CMD_OS_VERSION, CMD_OS_VERSION);
			
			//커널
			CMD_OS_KERNUL = util.getPidExec(arrCmd[2]);
			resultHP.put(ProtocolID.CMD_OS_KERNUL, CMD_OS_KERNUL);
			
			//CPU
			CMD_CPU =  util.getPidExec(arrCmd[3]);
			resultHP.put(ProtocolID.CMD_CPU, CMD_CPU);
			
			//메모리
			CMD_MEMORY =  util.getPidExec(arrCmd[4]);
			resultHP.put(ProtocolID.CMD_MEMORY, CMD_MEMORY);
			
			
			//network정보
			ArrayList<HashMap<String, String>> ipList = NetworkUtil.getNetworkInfo();
			resultHP.put(ProtocolID.CMD_NETWORK, ipList);
			
			//printGetMemory(1) ;
			//PostgreSQL 버젼, DATA 경로, LOG 경로, ARCHIVE 경로
			List<ServerInfoVO> serverInfoList = selectPostgreSqlServerInfo(serverInfoObj);
			
			//printGetMemory(2) ;
			
			for(ServerInfoVO vo:serverInfoList) {
				resultHP.put(vo.getSKEY(), vo.getSDATA());
			}
			
			serverInfoList = null;

			//printGetMemory(3) ;
			
			setShowData(serverInfoObj, resultHP);

			//printGetMemory(4) ;
			//tablespace
			//ArrayList list = (ArrayList)selectTablespaceInfo(serverInfoObj);
			//resultHP.put(ProtocolID.CMD_TABLESPACE_INFO, list);
			

			//DBMS 경로
			CMD_DBMS_PATH = util.getPidExec(arrCmd[5]);
			resultHP.put(ProtocolID.CMD_DBMS_PATH, CMD_DBMS_PATH);
			
			//백업경로 
			CMD_BACKUP_PATH = util.getPidExec(arrCmd[6]);
			resultHP.put(ProtocolID.CMD_BACKUP_PATH, CMD_BACKUP_PATH);
			
			PGDBAK = util.getPidExec(arrCmd[8]);
			resultHP.put(ProtocolID.PGDBAK, PGDBAK);

			JSONObject outputObj = new JSONObject();
			
			outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
			outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
			
			outputObj.put(ProtocolID.RESULT_DATA, resultHP);

			//printGetMemory(5) ;
			
			byte[] sendBuff = outputObj.toString().getBytes();
			
			//WeakReference<byte[]> bRef = new WeakReference<byte[]>(sendBuff);
			
			send(4, sendBuff);

			//printGetMemory(6) ;
			
			resultHP = null;
			outputObj = null;
			sendBuff = null;
			util = null;
			serverInfoObj = null;
			
			//printGetMemory(7) ;
			
			//System.gc();

			//printGetMemory(8) ;

			
		} catch (Exception e) {
			errLogger.error("DxT021 {} ", e.toString());
			
			JSONObject outputObj = new JSONObject();
			
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT021);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT021);
			outputObj.put(ProtocolID.ERR_MSG, "DxT021 Error [" + e.toString() + "]");
			outputObj.put(ProtocolID.RESULT_DATA, "failed");
			
			byte[] sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);

		} finally {
			//printGetMemory(9) ;
		}	    
	}
	
	private void printGetMemory(int no) throws Exception {
		long totalMemory = Runtime.getRuntime().totalMemory();
		long memory = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
		socketLogger.info(no + " totalMemory : " + totalMemory + " memory : " + memory);
	}
	

/*	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		
		
		JSONObject serverInfoObj = (JSONObject) jObj.get(ProtocolID.SERVER_INFO);
		
		socketLogger.info("execute : " + strDxExCode);
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
	
		JSONObject outputObj = new JSONObject();
		JSONArray arrOut = new JSONArray();
		
		String CMD_HOSTNAME = "";
		String CMD_OS_VERSION = "";
		String CMD_OS_KERNUL =  "";
		String CMD_CPU = "";
		String CMD_MEMORY = "";
		ArrayList<HashMap<String, String>> ipList = null;
		List<ServerInfoVO> serverInfoList = null;
		String CMD_DBMS_PATH = "";
		String CMD_BACKUP_PATH = "";
		String PGDBAK = "";
		
		
				
		try {
			HashMap resultHP = new HashMap();
			
			test(resultHP);
			
		//호스트명
			CMD_HOSTNAME = CommonUtil.getPidExec(arrCmd[0]);
			resultHP.put(ProtocolID.CMD_HOSTNAME, CMD_HOSTNAME);
			
			//OS 정보
			//String CMD_OS_VERSION = System.getProperty("os.name") + System.getProperty("os.version");
			CMD_OS_VERSION = CommonUtil.getPidExec(arrCmd[1]);
			resultHP.put(ProtocolID.CMD_OS_VERSION, CMD_OS_VERSION);
			
			//커널
			CMD_OS_KERNUL = CommonUtil.getPidExec(arrCmd[2]);
			resultHP.put(ProtocolID.CMD_OS_KERNUL, CMD_OS_KERNUL);
			
			//CPU
			CMD_CPU =  CommonUtil.getPidExec(arrCmd[3]);
			resultHP.put(ProtocolID.CMD_CPU, CMD_CPU);
			
			//메모리
			CMD_MEMORY =  CommonUtil.getPidExec(arrCmd[4]);
			resultHP.put(ProtocolID.CMD_MEMORY, CMD_MEMORY);
			
			
			//network정보
			ipList = NetworkUtil.getNetworkInfo();


			resultHP.put(ProtocolID.CMD_NETWORK, ipList);
			
	
			//PostgreSQL 버젼, DATA 경로, LOG 경로, ARCHIVE 경로
			serverInfoList = selectPostgreSqlServerInfo(serverInfoObj);
			
			for(ServerInfoVO vo:serverInfoList) {
				resultHP.put(vo.getSKEY(), vo.getSDATA());
			}
			
			setShowData(serverInfoObj, resultHP);

			//tablespace
			//ArrayList list = (ArrayList)selectTablespaceInfo(serverInfoObj);
			//resultHP.put(ProtocolID.CMD_TABLESPACE_INFO, list);
			

			//DBMS 경로
			CMD_DBMS_PATH = CommonUtil.getPidExec(arrCmd[5]);
			resultHP.put(ProtocolID.CMD_DBMS_PATH, CMD_DBMS_PATH);
			
			//백업경로 
			CMD_BACKUP_PATH = CommonUtil.getPidExec(arrCmd[6]);
			resultHP.put(ProtocolID.CMD_BACKUP_PATH, CMD_BACKUP_PATH);
			
			PGDBAK = CommonUtil.getPidExec(arrCmd[8]);
			resultHP.put(ProtocolID.PGDBAK, PGDBAK);

			outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
			outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
			
			outputObj.put(ProtocolID.RESULT_DATA, resultHP);

			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
			
			resultHP = null;
			outputObj = null;
			
		} catch (Exception e) {
			errLogger.error("DxT021 {} ", e.toString());
			
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT021);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT021);
			outputObj.put(ProtocolID.ERR_MSG, "DxT021 Error [" + e.toString() + "]");
			outputObj.put(ProtocolID.RESULT_DATA, "failed");
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);

		} finally {

		}	    
	}
	*/
	private void test(HashMap resultHP) throws Exception {


		resultHP.put(ProtocolID.CMD_LISTEN_ADDRESSES, "");

		resultHP.put(ProtocolID.CMD_PORT, "");

		resultHP.put(ProtocolID.CMD_MAX_CONNECTIONS,  "");

		resultHP.put(ProtocolID.CMD_SHARED_BUFFERS,  "");

		resultHP.put(ProtocolID.CMD_EFFECTIVE_CACHE_SIZE,  "");

		resultHP.put(ProtocolID.CMD_WORK_MEM,  "");

		resultHP.put(ProtocolID.CMD_MAINTENANCE_WORK_MEM,  "");

		resultHP.put(ProtocolID.CMD_MIN_WAL_SIZE,  "");
;
		resultHP.put(ProtocolID.CMD_MAX_WAL_SIZE,  "");

		resultHP.put(ProtocolID.CMD_WAL_LEVEL,  "");

		resultHP.put(ProtocolID.CMD_WAL_BUFFERS,  "");

		resultHP.put(ProtocolID.CMD_WAL_KEEP_SEGMENTS,  "");

		resultHP.put(ProtocolID.CMD_ARCHIVE_MODE,  "");

		resultHP.put(ProtocolID.CMD_ARCHIVE_COMMAND,  "");

		resultHP.put(ProtocolID.CMD_CONFIG_FILE,  "");

		resultHP.put(ProtocolID.CMD_DATA_DIRECTORY,  "");

		resultHP.put(ProtocolID.CMD_HOT_STANDBY,  "");

		resultHP.put(ProtocolID.CMD_TIMEZONE,  "");

		resultHP.put(ProtocolID.CMD_SHARED_PRELOAD_LIBRARIES, "");

		resultHP.put(ProtocolID.CMD_DATABASE_INFO, null);

		

		resultHP.put(ProtocolID.CMD_DBMS_INFO, null);

		resultHP.put(ProtocolID.CMD_TABLESPACE_INFO, null);

		resultHP.put(ProtocolID.CMD_HOSTNAME, "");
		
		//OS 정보

		resultHP.put(ProtocolID.CMD_OS_VERSION, "");
		
		//커널

		resultHP.put(ProtocolID.CMD_OS_KERNUL, "");
		
		//CPU

		resultHP.put(ProtocolID.CMD_CPU, "");
		
		//메모리

		resultHP.put(ProtocolID.CMD_MEMORY, "");
		
		
		//network정보

		resultHP.put(ProtocolID.CMD_NETWORK, null);

		//DBMS 경로

		resultHP.put(ProtocolID.CMD_DBMS_PATH, "");
		
		//백업경로 

		resultHP.put(ProtocolID.CMD_BACKUP_PATH, "");
		

		resultHP.put(ProtocolID.PGDBAK, "");
	}
	
	private ArrayList fileSystemList(String strFileSystem) throws Exception {
		ArrayList<HashMap<String, String>> list = new ArrayList<HashMap<String, String>>();
		
		System.out.println("### strFileSystem : " + strFileSystem);
		
		if(strFileSystem.length() > 0) {
			String[] arrFileSystem = strFileSystem.split("\n");
			int intFileI = 0;
			for(String st: arrFileSystem) {
				//System.out.println("### intFileI : " + intFileI);
				if(intFileI > 0) {
					HashMap hp = new HashMap();
			    	  String[] arrStr = st.split(" ");
			    	  int lineT = 0;
			    	  for(int i=0; i<arrStr.length; i++) {
			    		  //System.out.println(arrStr[i].toString());
			    		  
			    		  if(!arrStr[i].toString().trim().equals("")) {
			    			  //System.out.println(lineT + " :: " + arrStr[i].toString());
				    		  if(lineT == 0) {
				    			  hp.put("filesystem", arrStr[i].toString());
				    		  } else if(lineT == 1) {
				    			  hp.put("size", arrStr[i].toString());
				    		  } else if(lineT == 2) {
				    			  hp.put("used", arrStr[i].toString());
				    		  } else if(lineT == 3) {
				    			  hp.put("avail", arrStr[i].toString());
				    		  } else if(lineT == 4) {
				    			  hp.put("use", arrStr[i].toString());
				    		  } else if(lineT == 5) {
				    			  hp.put("mounton", arrStr[i].toString());
				    		  }
				    		  
				    		  lineT = lineT + 1;
				    		  
				    		 // System.out.println("lineT : " + lineT);
			    		  }
			    	  }
			    	  list.add(hp);
				}
				
				intFileI++;
			}
		}
		
		return list;
	}
	
	private ArrayList selectTablespaceInfo(JSONObject serverInfoObj) throws Exception {
		
		
		SqlSessionFactory sqlSessionFactory = null;
		
		sqlSessionFactory = SqlSessionManager.getInstance();
		
		String poolName = "" + serverInfoObj.get(ProtocolID.SERVER_IP) + "_" + serverInfoObj.get(ProtocolID.DATABASE_NAME) + "_" + serverInfoObj.get(ProtocolID.SERVER_PORT);
		//+ "_" + (String)serverInfoObj.get(ProtocolID.USER_ID)
		//+ "_" + (String)serverInfoObj.get(ProtocolID.USER_PWD);
		
		Connection connDB = null;
		SqlSession sessDB = null;
		
		ArrayList list = null;
		
		try {
			
			SocketExt.setupDriverPool(serverInfoObj, poolName);

			//DB 컨넥션을 가져온다.
			connDB = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);

			sessDB = sqlSessionFactory.openSession(connDB);
			
			list =  (ArrayList) sessDB.selectList("system.selectTablespaceInfo");
				

		} catch(Exception e) {
			errLogger.error("selectDatabaseInfo {} ", e.toString());
			throw e;
		} finally {
			sessDB.close();
			connDB.close();
		}	
		
		return list;
		
	}
	
	
	private List<ServerInfoVO> selectPostgreSqlServerInfo(JSONObject serverInfoObj) throws Exception {
		
		//printGetMemory(11) ;
		SqlSessionFactory sqlSessionFactory = null;
		
		sqlSessionFactory = SqlSessionManager.getInstance();
		
		String poolName = "" + serverInfoObj.get(ProtocolID.SERVER_IP) + "_" + serverInfoObj.get(ProtocolID.DATABASE_NAME) + "_" + serverInfoObj.get(ProtocolID.SERVER_PORT);
		//+ "_" + (String)serverInfoObj.get(ProtocolID.USER_ID)
		//+ "_" + (String)serverInfoObj.get(ProtocolID.USER_PWD);
		
		Connection connDB = null;
		SqlSession sessDB = null;
		
		ArrayList list = new ArrayList<ServerInfoVO>();
		
		//printGetMemory(12) ;
		
		try {
			
			SocketExt.setupDriverPool(serverInfoObj, poolName);
			
			//printGetMemory(13) ;
			
			//DB 컨넥션을 가져온다.
			connDB = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);
			//printGetMemory(14) ;
			sessDB = sqlSessionFactory.openSession(connDB);
			
			//printGetMemory(15) ;
			
			list =  (ArrayList) sessDB.selectList("system.selectPostgreSqlServerInfo");
			
			//printGetMemory(16) ;

		} catch(Exception e) {
			errLogger.error("selectDatabaseInfo {} ", e.toString());
			throw e;
		} finally {
			sessDB.close();
			connDB.close();
		}	
		//printGetMemory(17) ;
		return list;
		
	}
	
	private HashMap  setShowData(JSONObject serverInfoObj, HashMap resultHP) throws Exception {
		//HashMap resultHP = new HashMap();
		
		//printGetMemory(33) ;
		SqlSessionFactory sqlSessionFactory = null;
		
		sqlSessionFactory = SqlSessionManager.getInstance();
		
		String poolName = "" + serverInfoObj.get(ProtocolID.SERVER_IP) + "_" + serverInfoObj.get(ProtocolID.DATABASE_NAME) + "_" + serverInfoObj.get(ProtocolID.SERVER_PORT);
		//+ "_" + (String)serverInfoObj.get(ProtocolID.USER_ID)
		//+ "_" + (String)serverInfoObj.get(ProtocolID.USER_PWD);
		
		Connection connDB = null;
		SqlSession sessDB = null;
		
		String strResult = "";
		
		try {
			
			SocketExt.setupDriverPool(serverInfoObj, poolName);
			
			//printGetMemory(34) ;

			//DB 컨넥션을 가져온다.
			connDB = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);

			sessDB = sqlSessionFactory.openSession(connDB);
			
			
			String listen_addresses = sessDB.selectOne("system.selectListen_addresses");
			resultHP.put(ProtocolID.CMD_LISTEN_ADDRESSES, listen_addresses);
			String port =  sessDB.selectOne("system.selectPort");
			resultHP.put(ProtocolID.CMD_PORT, port);
			String max_connections = sessDB.selectOne("system.selectMax_connections");
			resultHP.put(ProtocolID.CMD_MAX_CONNECTIONS, max_connections);
			String shared_buffers = sessDB.selectOne("system.selectShared_buffers");
			resultHP.put(ProtocolID.CMD_SHARED_BUFFERS, shared_buffers);
			String effective_cache_size = sessDB.selectOne("system.selectEffective_cache_size");
			resultHP.put(ProtocolID.CMD_EFFECTIVE_CACHE_SIZE, effective_cache_size);
			String work_mem = sessDB.selectOne("system.selectWork_mem");
			resultHP.put(ProtocolID.CMD_WORK_MEM, work_mem);
			String maintenance_work_mem = sessDB.selectOne("system.selectMaintenance_work_mem");
			resultHP.put(ProtocolID.CMD_MAINTENANCE_WORK_MEM, maintenance_work_mem);
			String min_wal_size = sessDB.selectOne("system.selectMin_wal_size");
			resultHP.put(ProtocolID.CMD_MIN_WAL_SIZE, min_wal_size);
			String max_wal_size = sessDB.selectOne("system.selectMax_wal_size");
			
			//printGetMemory(35) ;
			
			resultHP.put(ProtocolID.CMD_MAX_WAL_SIZE, max_wal_size);
			String wal_level = sessDB.selectOne("system.selectWal_level");
			resultHP.put(ProtocolID.CMD_WAL_LEVEL, wal_level);
			String wal_buffers = sessDB.selectOne("system.selectWal_buffers");
			resultHP.put(ProtocolID.CMD_WAL_BUFFERS, wal_buffers);
			String wal_keep_segments = sessDB.selectOne("system.selectWal_keep_segments");
			resultHP.put(ProtocolID.CMD_WAL_KEEP_SEGMENTS, wal_keep_segments);
			String archive_mode = sessDB.selectOne("system.selectArchive_mode");
			resultHP.put(ProtocolID.CMD_ARCHIVE_MODE, archive_mode);
			String archive_command = sessDB.selectOne("system.selectArchive_command");
			resultHP.put(ProtocolID.CMD_ARCHIVE_COMMAND, archive_command);
			String config_file = sessDB.selectOne("system.selectConfig_file");
			resultHP.put(ProtocolID.CMD_CONFIG_FILE, config_file);
			String data_directory = sessDB.selectOne("system.selectData_directory");
			resultHP.put(ProtocolID.CMD_DATA_DIRECTORY, data_directory);
			String hot_standby = sessDB.selectOne("system.selectHot_standby");
			resultHP.put(ProtocolID.CMD_HOT_STANDBY, hot_standby);
			String timezone = sessDB.selectOne("system.selectTimezone");
			resultHP.put(ProtocolID.CMD_TIMEZONE, timezone);
			String shared_preload_libraries = sessDB.selectOne("system.selectShared_preload_libraries");
			resultHP.put(ProtocolID.CMD_SHARED_PRELOAD_LIBRARIES, shared_preload_libraries);
			
			//printGetMemory(36) ;
			
			ArrayList databaseInfoList = (ArrayList)sessDB.selectList("system.selectDatabaseInfo");
			resultHP.put(ProtocolID.CMD_DATABASE_INFO, databaseInfoList);
			
			//printGetMemory(37) ;
			
			//TableSpace 정보
			ArrayList<HashMap<String, String>> listTableSpaceInfo = (ArrayList)sessDB.selectList("system.selectTablespaceInfo");
			//resultHP.put(ProtocolID.CMD_TABLESPACE_INFO, listTableSpaceInfo);
			
			//printGetMemory(38) ;
			
			ArrayList<HashMap<String, String>> dbmsInfo = (ArrayList)sessDB.selectList("system.selectDbmsInfo");
			
			ArrayList<HashMap<String, String>> dbmsInfo2 = dbmsInfo;
			
			resultHP.put(ProtocolID.CMD_DBMS_INFO, dbmsInfo2);

			
			//printGetMemory(39) ;
			//파일시스템정보
			CommonUtil util = new CommonUtil();
			String strFileSystem = util.getCmdExec(arrCmd[7]);
			util = null;
			
			ArrayList<HashMap<String, String>> flist = fileSystemList(strFileSystem);
			
			ArrayList<HashMap<String, String>> mappingList = mappingSystem(flist, listTableSpaceInfo, data_directory);
			
			resultHP.put(ProtocolID.CMD_TABLESPACE_INFO, mappingList);
			
			flist = null;
			mappingList = null;
			
			
			//printGetMemory(40) ;
		} catch(Exception e) {
			errLogger.error("selectDatabaseInfo {} ", e.toString());
			throw e;
		} finally {
			sessDB.close();
			connDB.close();
			
			//printGetMemory(41) ;
		}	
		
		return resultHP;
		
	}
	
	/**
	 * 파일시스템 정보, 테이블스페이스 정보 매핑
	 * @param flist
	 * @param listTableSpaceInfo
	 * @return
	 * @throws Exception
	 */
	private ArrayList<HashMap<String, String>> mappingSystem(ArrayList<HashMap<String, String>> flist
			, ArrayList<HashMap<String, String>> listTableSpaceInfo
			, String data_directory) throws Exception {
		
		String pg_default = data_directory + "/base";
		String pg_global = data_directory + "/global";
		
		ArrayList<HashMap<String, String>> arrMapping = new ArrayList<HashMap<String, String>>();
		

		String default_mounton = "";
		String default_use = "";
		String default_avail = "";
		String default_used = "";
		String default_filesystem = "";
		String default_fsize = "";
		
		//socketLogger.info("##################### system mapping start ");
		
		for(HashMap hp:flist) {
			
			String mounton = (String) hp.get("mounton");
			String use = (String) hp.get("use");
			String avail = (String) hp.get("avail");
			String used = (String) hp.get("used");
			String filesystem = (String) hp.get("filesystem");
			String fsize = (String) hp.get("size");
			
			
			if(mounton.equals("/")) {
				
				default_mounton = mounton;
				default_use = use;
				default_avail = avail;
				default_used = used;
				default_filesystem = filesystem;
				default_fsize = fsize;
				
				HashMap hpMapping = new HashMap();
				
				hpMapping.put("mounton", mounton);
				hpMapping.put("use", use);
				hpMapping.put("avail", avail);
				hpMapping.put("used", used);
				hpMapping.put("filesystem", filesystem);
				hpMapping.put("fsize", fsize);
				
				hpMapping.put("name", "");
				hpMapping.put("owner", "");
				hpMapping.put("location", "");
				hpMapping.put("options", "");
				hpMapping.put("size", "");
				hpMapping.put("description", "");
				
				arrMapping.add(hpMapping);
				
			} else {
				
				int intMappTs = 0;
				for(HashMap hpSpace: listTableSpaceInfo) {
					String Name = (String) hpSpace.get("Name");
					String Owner = (String) hpSpace.get("Owner");
					String Location = (String) hpSpace.get("Location");
					String Options = (String) hpSpace.get("Options");
					String Size = (String) hpSpace.get("Size");
					String Description = (String) hpSpace.get("Description");
					
					if(Name.equals("pg_default")) Location = pg_default;
					if(Name.equals("pg_global")) Location = pg_global;
					
					if(!mounton.equals("/") && Location.contains(mounton)) {
						HashMap hpMapping = new HashMap();
						
						hpMapping.put("mounton", mounton);
						hpMapping.put("use", use);
						hpMapping.put("avail", avail);
						hpMapping.put("used", used);
						hpMapping.put("filesystem", filesystem);
						hpMapping.put("fsize", fsize);
						
						hpMapping.put("name", Name);
						hpMapping.put("owner", Owner);
						hpMapping.put("location", Location);
						hpMapping.put("options", Options);
						hpMapping.put("size", Size);
						hpMapping.put("description", Description);
						
						arrMapping.add(hpMapping);
						
						intMappTs ++;
					}
	
				}
				
			
				if(intMappTs == 0) {
					

					HashMap hpMapping = new HashMap();
					
					hpMapping.put("mounton", mounton);
					hpMapping.put("use", use);
					hpMapping.put("avail", avail);
					hpMapping.put("used", used);
					hpMapping.put("filesystem", filesystem);
					hpMapping.put("fsize", fsize);
					
					hpMapping.put("name", "");
					hpMapping.put("owner", "");
					hpMapping.put("location", "");
					hpMapping.put("options", "");
					hpMapping.put("size", "");
					hpMapping.put("description", "");
					
					arrMapping.add(hpMapping);

				}
			}
		}

		
		for(HashMap hpSpace: listTableSpaceInfo) {
			
			
			String Name = (String) hpSpace.get("Name");
			String Owner = (String) hpSpace.get("Owner");
			String Location = (String) hpSpace.get("Location");
			String Options = (String) hpSpace.get("Options");
			String Size = (String) hpSpace.get("Size");
			String Description = (String) hpSpace.get("Description");
			
			if(Name.equals("pg_default")) Location = pg_default;
			if(Name.equals("pg_global")) Location = pg_global;
			
			int intContainCnt = 0;
			for(HashMap hp:flist) {
				String mounton = (String) hp.get("mounton");
				String filesystem = (String) hp.get("filesystem");
				
				if(!mounton.equals("/") && Location.contains(mounton)) {
					intContainCnt++;
				}
			}
			
			if(intContainCnt == 0) {
				HashMap hpMapping = new HashMap();

				hpMapping.put("mounton", default_mounton);
				hpMapping.put("use", default_use);
				hpMapping.put("avail", default_avail);
				hpMapping.put("used", default_used);
				hpMapping.put("filesystem", default_filesystem);
				hpMapping.put("fsize", default_fsize);
				
				hpMapping.put("name", Name);
				hpMapping.put("owner", Owner);
				hpMapping.put("location", Location);
				hpMapping.put("options", Options);
				hpMapping.put("size", Size);
				hpMapping.put("description", Description);
				
				arrMapping.add(hpMapping);
			}
			
		}
		
		//socketLogger.info("################### system mapping end ");
		
		return arrMapping;
	}

}


