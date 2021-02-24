package com.experdb.management.backup.cmmn;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.sql.PreparedStatement;
import java.util.Date;
import java.util.UUID;

import org.json.simple.JSONObject;

import com.experdb.management.backup.service.BackupLocationInfoVO;
import com.k4m.dx.tcontrol.cmmn.client.ClientProtocolID;
import com.k4m.dx.tcontrol.db2pg.cmmn.DBCPPoolManager;

public class Backuploaction{
	
	
	static String sql = "";
	
	
	
	
	
	
	
	/**
	 * insertBackuploaction 노드리스트 조회
	 * @param serverObj
	 */
	public static void insertBackuploaction(BackupLocationInfoVO backupLocInfo) throws Exception {
		
		JSONObject serverObj = new JSONObject();
		
		//Arcserve repoDB 정보
		serverObj.put(ClientProtocolID.SERVER_NAME, "Postgresql");
		serverObj.put(ClientProtocolID.SERVER_IP, "192.168.20.145");
		serverObj.put(ClientProtocolID.SERVER_PORT, "5431");
		serverObj.put(ClientProtocolID.DATABASE_NAME, "ARCserveLinuxD2D");
		serverObj.put(ClientProtocolID.USER_ID, "d2duser");
		serverObj.put(ClientProtocolID.USER_PWD, "");
		serverObj.put(ClientProtocolID.DB_TYPE, "TC002204");
		
		java.sql.Connection conn = null;
	
		try{
			
			conn  = DBCPPoolManager.makeConnection(serverObj);
			
			PreparedStatement prep = conn.prepareStatement("insert into BackupLocation ( Location,Username,Password,Free,Total,Type,Time,IsRunScript,Script,FreeAlert,FreeAlertUnit,UUID,JobLimit,rpsServer,rpsUserName,rpsPassword,rpsProtocol,rpsPort,dsUuid,dsName,enableDedup) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);");
			
			   prep.setString(1, backupLocInfo.getBackupDestLocation());
			   prep.setString(2, backupLocInfo.getBackupDestUser());
			   prep.setString(3, backupLocInfo.getBackupDestPasswd());
			   prep.setLong(4, backupLocInfo.getFreeSize());
			   prep.setLong(5, backupLocInfo.getTotalSize());
			   prep.setInt(6, backupLocInfo.getType());
			   prep.setLong(7, (new Date()).getTime());
			   //prep.setInt(8, (backupLocInfo.isRunScript() == true) ? 1 : 0);
			   prep.setString(9, backupLocInfo.getScript());
			   prep.setLong(10, backupLocInfo.getFreeSizeAlert());
			   prep.setInt(11, backupLocInfo.getFreeSizeAlertUnit());
			   prep.setString(12, UUID.randomUUID().toString());
			   prep.setInt(13, backupLocInfo.getJobLimit());
			   prep.setString(14, backupLocInfo.getServerInfo().getName());
			   prep.setString(15, backupLocInfo.getServerInfo().getUser());
			   prep.setString(16, backupLocInfo.getServerInfo().getPassword());
			   prep.setString(17, backupLocInfo.getServerInfo().getProtocol());
			   prep.setInt(18, backupLocInfo.getServerInfo().getPort());
			   prep.setString(19, backupLocInfo.getDataStoreInfo().getUuid());
			   prep.setString(20, backupLocInfo.getDataStoreInfo().getName());
			   prep.setInt(21, backupLocInfo.getDataStoreInfo().getEnableDedup());
			   prep.addBatch();
			   prep.executeBatch();
			   prep.close();

		}catch(Exception e){
			e.printStackTrace();
		}				
	}
	

	
	/**
	 * BackupLoaction validateCifs
	 * @param  BackupLocationInfoVO backupLocationInfo
	 * @return 
	 */
	public static JSONObject validateCifs(BackupLocationInfoVO backupLocationInfo) {
		
		JSONObject result = new JSONObject();		
		CmmnUtil cmmUtil = new CmmnUtil();
		
	     String smd = "echo -e "+backupLocationInfo.getBackupDestPasswd()+"| smbclient -U " +backupLocationInfo.getBackupDestUser()+" "+backupLocationInfo.getBackupDestLocation().replaceAll("\\\\", "/");
		
	     System.out.println(smd);
		try {
			result = cmmUtil.execute(smd.toString());												
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	     

	

	public static void main(String[] args) {
		
		BackupLocationInfoVO backuplocation = new BackupLocationInfoVO();
		Backuploaction bl = new Backuploaction();
		
		backuplocation.setBackupDestLocation("//192.168.50.1130/backup");
		backuplocation.setBackupDestUser("root");
		backuplocation.setBackupDestPasswd("root");
		
		validateCifs(backuplocation);
		
		//System.out.println(UUID.randomUUID().toString());
		//UUID.randomUUID().toString();
/*		BackupLocationInfoVO backupLocInfo = new BackupLocationInfoVO();
		
		backupLocInfo.setBackupDestLocation("//192.168.50.130/backup");
		backupLocInfo.setBackupDestUser("root");
		backupLocInfo.setBackupDestPasswd(backupDestPasswd);
		
		prep.setLong(4, backupLocInfo.getFreeSize());
	    prep.setLong(5, backupLocInfo.getTotalSize());

		backupLocInfo.setType(2);  // NFS = 1 , CIFS = 2
*/		
		
	}


	
}
