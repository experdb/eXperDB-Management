package com.k4m.dx.tcontrol.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.net.InetAddress;
import java.net.Socket;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.k4m.dx.tcontrol.db.SqlSessionManager;
import com.k4m.dx.tcontrol.db.repository.vo.ServerInfoVO;
import com.k4m.dx.tcontrol.db.repository.vo.TablespaceVO;
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
	
	private static Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private static Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	private String[] arrCmd = {
				                "echo $HOSTNAME" //호스트명
			                    , "cat /etc/*-release | awk 'NR==1{print;}'" //버젼
								, "uname -r" //커널
								, "grep -c processor /proc/cpuinfo" //cpu
								, "free -h | awk 'NR>1&&NR<3{print $2}'" //메모리
								, "echo $PGHOME"
								, "echo $PGRBAK"
								, "df -P -h"
							   };
	
	public DxT021(Socket socket, BufferedInputStream is, BufferedOutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		
		
		JSONObject serverInfoObj = (JSONObject) jObj.get(ProtocolID.SERVER_INFO);
		
		socketLogger.info("execute : " + strDxExCode);
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
	
		JSONObject outputObj = new JSONObject();
		JSONArray arrOut = new JSONArray();

		try {
			HashMap resultHP = new HashMap();
			
		//호스트명
			String CMD_HOSTNAME = CommonUtil.getPidExec(arrCmd[0]);
			resultHP.put(ProtocolID.CMD_HOSTNAME, CMD_HOSTNAME);
			
			//OS 정보
			//String CMD_OS_VERSION = System.getProperty("os.name") + System.getProperty("os.version");
			String CMD_OS_VERSION = CommonUtil.getPidExec(arrCmd[1]);
			resultHP.put(ProtocolID.CMD_OS_VERSION, CMD_OS_VERSION);
			
			//커널
			String CMD_OS_KERNUL = CommonUtil.getPidExec(arrCmd[2]);
			resultHP.put(ProtocolID.CMD_OS_KERNUL, CMD_OS_KERNUL);
			
			//CPU
			String CMD_CPU =  CommonUtil.getPidExec(arrCmd[3]);
			resultHP.put(ProtocolID.CMD_CPU, CMD_CPU);
			
			//메모리
			String CMD_MEMORY =  CommonUtil.getPidExec(arrCmd[4]);
			resultHP.put(ProtocolID.CMD_MEMORY, CMD_MEMORY);
			
			
			//network정보
			ArrayList<HashMap<String, String>> ipList = NetworkUtil.getNetworkInfo();


			resultHP.put(ProtocolID.CMD_NETWORK, ipList);
			
			
			//PostgreSQL 버젼, DATA 경로, LOG 경로, ARCHIVE 경로
			List<ServerInfoVO> serverInfoList = selectPostgreSqlServerInfo(serverInfoObj);
			
			for(ServerInfoVO vo:serverInfoList) {
				resultHP.put(vo.getSKEY(), vo.getSDATA());
			}
			
			setShowData(serverInfoObj, resultHP);

			//tablespace
			//ArrayList list = (ArrayList)selectTablespaceInfo(serverInfoObj);
			//resultHP.put(ProtocolID.CMD_TABLESPACE_INFO, list);
			

			//DBMS 경로
			String CMD_DBMS_PATH = CommonUtil.getPidExec(arrCmd[5]);
			resultHP.put(ProtocolID.CMD_DBMS_PATH, CMD_DBMS_PATH);
			
			//백업경로 
			String CMD_BACKUP_PATH = CommonUtil.getPidExec(arrCmd[6]);
			resultHP.put(ProtocolID.CMD_BACKUP_PATH, CMD_BACKUP_PATH);
			

			outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
			outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
			
			outputObj.put(ProtocolID.RESULT_DATA, resultHP);

			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
			
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
	
	private ArrayList fileSystemList(String strFileSystem) throws Exception {
		ArrayList<HashMap<String, String>> list = new ArrayList<HashMap<String, String>>();
		
		System.out.println("### strFileSystem : " + strFileSystem);
		
		if(strFileSystem.length() > 0) {
			String[] arrFileSystem = strFileSystem.split("\n");
			int intFileI = 0;
			for(String st: arrFileSystem) {
				System.out.println("### intFileI : " + intFileI);
				if(intFileI > 0) {
					HashMap hp = new HashMap();
			    	  String[] arrStr = st.split(" ");
			    	  int lineT = 0;
			    	  for(int i=0; i<arrStr.length; i++) {
			    		  //System.out.println(arrStr[i].toString());
			    		  
			    		  if(!arrStr[i].toString().trim().equals("")) {
			    			  System.out.println(lineT + " :: " + arrStr[i].toString());
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
				    		  
				    		  System.out.println("lineT : " + lineT);
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
		
		String poolName = "" + serverInfoObj.get(ProtocolID.SERVER_IP) + "_" + serverInfoObj.get(ProtocolID.DATABASE_NAME) + "_" + serverInfoObj.get(ProtocolID.SERVER_PORT)
		+ "_" + (String)serverInfoObj.get(ProtocolID.USER_ID)
		+ "_" + (String)serverInfoObj.get(ProtocolID.USER_PWD);
		
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
		
		
		SqlSessionFactory sqlSessionFactory = null;
		
		sqlSessionFactory = SqlSessionManager.getInstance();
		
		String poolName = "" + serverInfoObj.get(ProtocolID.SERVER_IP) + "_" + serverInfoObj.get(ProtocolID.DATABASE_NAME) + "_" + serverInfoObj.get(ProtocolID.SERVER_PORT)
		+ "_" + (String)serverInfoObj.get(ProtocolID.USER_ID)
		+ "_" + (String)serverInfoObj.get(ProtocolID.USER_PWD);
		
		Connection connDB = null;
		SqlSession sessDB = null;
		
		List<ServerInfoVO> list = null;
		
		try {
			
			SocketExt.setupDriverPool(serverInfoObj, poolName);

			//DB 컨넥션을 가져온다.
			connDB = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);

			sessDB = sqlSessionFactory.openSession(connDB);
			
			list =  sessDB.selectList("system.selectPostgreSqlServerInfo");
				

		} catch(Exception e) {
			errLogger.error("selectDatabaseInfo {} ", e.toString());
			throw e;
		} finally {
			sessDB.close();
			connDB.close();
		}	
		
		return list;
		
	}
	
	private void setShowData(JSONObject serverInfoObj, HashMap resultHP) throws Exception {
		
		
		SqlSessionFactory sqlSessionFactory = null;
		
		sqlSessionFactory = SqlSessionManager.getInstance();
		
		String poolName = "" + serverInfoObj.get(ProtocolID.SERVER_IP) + "_" + serverInfoObj.get(ProtocolID.DATABASE_NAME) + "_" + serverInfoObj.get(ProtocolID.SERVER_PORT)
		+ "_" + (String)serverInfoObj.get(ProtocolID.USER_ID)
		+ "_" + (String)serverInfoObj.get(ProtocolID.USER_PWD);
		
		Connection connDB = null;
		SqlSession sessDB = null;
		
		String strResult = "";
		
		try {
			
			SocketExt.setupDriverPool(serverInfoObj, poolName);

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
			
			
			ArrayList databaseInfoList = (ArrayList)sessDB.selectList("system.selectDatabaseInfo");
			resultHP.put(ProtocolID.CMD_DATABASE_INFO, databaseInfoList);
			
			
			//TableSpace 정보
			ArrayList<HashMap<String, String>> listTableSpaceInfo = (ArrayList)sessDB.selectList("system.selectTablespaceInfo");
			//resultHP.put(ProtocolID.CMD_TABLESPACE_INFO, listTableSpaceInfo);
			
			ArrayList<HashMap<String, String>> dbmsInfo = (ArrayList)sessDB.selectList("system.selectDbmsInfo");
			resultHP.put(ProtocolID.CMD_DBMS_INFO, dbmsInfo);
			
			//파일시스템정보
			String strFileSystem = CommonUtil.getCmdExec(arrCmd[7]);
			ArrayList<HashMap<String, String>> flist = fileSystemList(strFileSystem);
			
			ArrayList<HashMap<String, String>> mappingList = mappingSystem(flist, listTableSpaceInfo, data_directory);
			
			resultHP.put(ProtocolID.CMD_TABLESPACE_INFO, mappingList);
			
			
		} catch(Exception e) {
			errLogger.error("selectDatabaseInfo {} ", e.toString());
			throw e;
		} finally {
			sessDB.close();
			connDB.close();
		}	
		
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
		
		socketLogger.info("##################### system mapping start ");
		
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
		
		socketLogger.info("################### system mapping end ");
		
		return arrMapping;
	}

}


