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
 * 	테이블 스페이스 정보
 *
 * @author 변승우
 * @see <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2020.08.26   변승우 최초 생성
 * </pre>
 */

public class DxT040 extends SocketCtl{
	
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	private String[] arrCmd = {
				                "df  $PGDATA -h" //pgdata마운트 용량
								, "echo $PGDATA/pg_wal" //wal 경로
			                    , "du -s $PGDATA/pg_wal" //wal로그 용량
								, "ls $PGDATA/pg_wal | wc -l" //wal로그 갯수								
								, " psql -t -c \"select setting from pg_settings where name = 'wal_keep_segments'\"" //wal_keep_segments 갯수															
								, "echo $PGALOG" //아카이브 경로		
								, "du -s $PGALOG" //아카이브로그 용량															
								, "echo $PGDATA/backup" //백업경로
								, "df $PGDATA/backup -h" //백업 마운트 용량
								, "du -sh $PGDATA/backup" //백업 용량					
								, "echo $PGDATA/log"	//PG_LOG 경로				
								, "du -s $PGDATA/log" //PG_LOG 용량	
								, "ls $PGALOG | wc -l"
								, "ls $PGDATA/log | wc -l"
							   };
	
	public DxT040(Socket socket, BufferedInputStream is, BufferedOutputStream	os) {
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
	
		JSONObject outputObj = null;
	
		String pgwal_path = "";
		String pgwal_v = "";
		String pgwal_cnt = "";
		String wal_keep_segments = "";
		String pgalog_path = "";		
		String pgarc_v = "";
		String backup_path = "";
		String backup_v = "";
		String log_path = "";
		String log_v = "";
		
		String pgalog_cnt;
		String log_cnt="";
		

		byte[] sendBuff = null;
		
				
		try {
			HashMap resultHP = new HashMap();

			CommonUtil util = new CommonUtil();


			
			pgwal_path = util.getPidExec(arrCmd[1]);
			resultHP.put(ProtocolID.PGWAL_PATH, pgwal_path);
			
			pgwal_v = util.getPidExec(arrCmd[2]);
			String[] arrPgwal_v = pgwal_v.split("\t");
			resultHP.put(ProtocolID.PGWAL_V, arrPgwal_v[0].toString());	
					
			pgwal_cnt = util.getPidExec(arrCmd[3]);
			resultHP.put(ProtocolID.PGWAL_CNT, pgwal_cnt);	
				
			wal_keep_segments = util.getPidExec(arrCmd[4]);
			resultHP.put(ProtocolID.WAL_KEEP_SEGMENTS, wal_keep_segments);
			
			
			pgalog_path = util.getPidExec(arrCmd[5]);
			resultHP.put(ProtocolID.PGALOG_PATH, pgalog_path);
			
			
			pgarc_v = util.getPidExec(arrCmd[6]);
			String[] arrPgarc_v = pgarc_v.split("\t");
			resultHP.put(ProtocolID.PGALOG_V, arrPgarc_v[0].toString());	
			
			
			backup_path = util.getPidExec(arrCmd[7]);
			resultHP.put(ProtocolID.BACKUP_PATH, backup_path);

			
			backup_v = util.getPidExec(arrCmd[9]);
			String[] arrBackup_v = backup_v.split("\t");
			resultHP.put(ProtocolID.BACKUP_V, arrBackup_v[0].toString());	
			
			
			log_path = util.getPidExec(arrCmd[10]);
			resultHP.put(ProtocolID.LOG_PATH, log_path);	
			
			log_v = util.getPidExec(arrCmd[11]);
			String[] arrLog_v = log_v.split("\t");
			resultHP.put(ProtocolID.LOG_V, arrLog_v[0].toString());	
			
			pgalog_cnt = util.getPidExec(arrCmd[12]);
			resultHP.put(ProtocolID.PGALOG_CNT, pgalog_cnt);	
			
			log_cnt = util.getPidExec(arrCmd[13]);
			resultHP.put(ProtocolID.LOG_CNT, log_cnt);	
			
			setShowData(serverInfoObj, resultHP);
			

			outputObj = new JSONObject();
			
			outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
			outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
			
			outputObj.put(ProtocolID.RESULT_DATA, resultHP);


			
			sendBuff = outputObj.toString().getBytes();
			
			//WeakReference<byte[]> bRef = new WeakReference<byte[]>(sendBuff);
			
			resultHP = null;
			util = null;
			serverInfoObj = null;
			outputObj = null;
			
			
			send(4, sendBuff);
			
			sendBuff = null;

			
		} catch (Exception e) {
			errLogger.error("DxT040 {} ", e.toString());
			
			outputObj = new JSONObject();
			
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT040);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT040);
			outputObj.put(ProtocolID.ERR_MSG, "DxT040 Error [" + e.toString() + "]");
			outputObj.put(ProtocolID.RESULT_DATA, "failed");
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);

		} finally {
			//socketLogger.info("outputObj finally call");
		}	    
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
	
	
	
	private HashMap  setShowData(JSONObject serverInfoObj, HashMap resultHP) throws Exception {

		
		try {
		
			//파일시스템정보
			CommonUtil util = new CommonUtil();
			String strFileSystem = util.getCmdExec(arrCmd[0]);
			
			String strBackupSystem = util.getCmdExec(arrCmd[8]);
			util = null;
			
			ArrayList<HashMap<String, String>> flist = fileSystemList(strFileSystem);
			
			ArrayList<HashMap<String, String>> bakup_mount = fileSystemList(strFileSystem);
			
			ArrayList<HashMap<String, String>> mappingList = mappingSystem(flist);
			
			ArrayList<HashMap<String, String>> bakup_m = mappingSystem(bakup_mount);
			
			resultHP.put(ProtocolID.CMD_TABLESPACE_INFO, mappingList);
			
			resultHP.put(ProtocolID.CMD_BACKUPSPACE_INFO, bakup_m);
			
			flist = null;
			mappingList = null;

		} catch(Exception e) {
			throw e;
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
			) throws Exception {
		
		ArrayList<HashMap<String, String>> arrMapping = new ArrayList<HashMap<String, String>>();
		
		for(HashMap hp:flist) {
			
			String mounton = (String) hp.get("mounton");
			String use = (String) hp.get("use");
			String avail = (String) hp.get("avail");
			String used = (String) hp.get("used");
			String filesystem = (String) hp.get("filesystem");
			String fsize = (String) hp.get("size");
			
	
			HashMap hpMapping = new HashMap();
			
			hpMapping.put("mounton", mounton);
			hpMapping.put("use", use);
			hpMapping.put("avail", avail);
			hpMapping.put("used", used);
			hpMapping.put("filesystem", filesystem);
			hpMapping.put("fsize", fsize);
			
			arrMapping.add(hpMapping);
		}

		return arrMapping;
	}

}


