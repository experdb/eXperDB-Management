package com.experdb.management.backup.cmmn;

import java.util.UUID;

import org.json.simple.JSONObject;

import com.experdb.management.backup.service.BackupLocationInfoVO;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;

public class Backuploaction {

	/**
	 * BackupLoaction validateCifs
	 * 
	 * @param BackupLocationInfoVO
	 *            backupLocationInfo
	 * @return
	 */
	public static JSONObject validateCifs(BackupLocationInfoVO backupLocationInfo) {

		JSONObject result = new JSONObject();
		CmmnUtil cmmUtil = new CmmnUtil();

		String smd = "echo -e " + backupLocationInfo.getBackupDestPasswd() + "| smbclient -U "
				+ backupLocationInfo.getBackupDestUser() + " "
				+ backupLocationInfo.getBackupDestLocation().replaceAll("\\\\", "/")+"; echo $?";

		System.out.println("CIFS CMD="+smd);
		
		try {
			result = cmmUtil.execute(smd.toString(),"cifs");
		} catch (Exception e) {
			e.printStackTrace();
		}
		System.out.println("RESULT_CODE = "+result.get("RESULT_CODE"));
		System.out.println("RESULT_DATA = "+result.get("RESULT_DATA"));
		return result;
	}

	/**
	 * BackupLoaction validate Nfs
	 * 
	 * @param BackupLocationInfoVO
	 *            backupLocationInfo
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static JSONObject validateNfs(BackupLocationInfoVO backupLocationInfo) {

		JSONObject result = new JSONObject();
		CmmnUtil cmmUtil = new CmmnUtil();

		String mountPoint = getMountPointPath().replaceAll("\\\\", "/");
		 
			 try {
				cmmUtil.execute("mkdir "+mountPoint,"nfs");
			} catch (FileNotFoundException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			 
			
		 String cmd = "mount " + backupLocationInfo.getBackupDestLocation() + " "+mountPoint + " -o timeo=50,retry=0; echo $?" ;

		 System.out.println("MOUNT CMD = " +cmd);
		 
		try {
			result = cmmUtil.execute(cmd.toString(), "nfs");
			
			//mount 후  ->  umount 명령어 실행
			if (result.get("RESULT_CODE").equals(0)) {
				result = unmountNfs(mountPoint);
			}

			// file.delete();
			 try {
					cmmUtil.execute("rm -rf "+mountPoint, "nfs");
				} catch (FileNotFoundException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				} catch (IOException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	
	
	public static int executeCommand(String cmd, boolean block) throws Exception {
		System.out.println("excute cmd: " + cmd);
		System.out.println("block: " + block);
		if (block) {
			Process proc = Runtime.getRuntime().exec(cmd);
			int result = proc.waitFor();
			if (result != 0) {
				System.out.println("execute  block command " + cmd + ", return : " + result);
			}
			return result;
		}
		try {
			Process proc = Runtime.getRuntime().exec(cmd);
			if (proc == null) {
				System.out.println("fail to execute unblock command : " + cmd);
				return -1;
			}
			System.out.println("success to execute unblock command : " + cmd);
			return 0;
		} catch (IOException e) {
			System.out.println("fail to execute unblock command " + cmd + " " + e);
			return -2;
		}
	}

	private static String getMountPointPath() {
		return ServiceContext.getInstance().getTempFolder() + File.separator + "ws_" + UUID.randomUUID();
	}

	
	
	/**
	 * BackupLoaction unmount Nfs
	 * @param mountPoint 
	 * 
	 * @param BackupLocationInfoVO
	 *            backupLocationInfo
	 * @return
	 */
	public static JSONObject unmountNfs(String mountPoint) {

		JSONObject result = new JSONObject();
		CmmnUtil cmmUtil = new CmmnUtil();

		 String smd = "umount -l " +mountPoint+"; echo $?";
		 System.out.println("CMD = "+smd);
		 
		try {
			result = cmmUtil.execute(smd.toString(), "nfs");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	
	
	
	public static void main(String[] args) {

		BackupLocationInfoVO backuplocation = new BackupLocationInfoVO();
		Backuploaction bl = new Backuploaction();

		 backuplocation.setBackupDestLocation("//192.168.50.145/arcbackup");
		//backuplocation.setBackupDestLocation("192.168.50.130:/nfstest");
		backuplocation.setBackupDestUser("r1oot");
		backuplocation.setBackupDestPasswd("root");

		 validateCifs(backuplocation);
		
		// validateNfs(backuplocation);
		 
		// System.out.println(nfs);

		//unmountNfs(backuplocation);

		// System.out.println(UUID.randomUUID().toString());
		// UUID.randomUUID().toString();
		/*
		 * BackupLocationInfoVO backupLocInfo = new BackupLocationInfoVO();
		 * 
		 * backupLocInfo.setBackupDestLocation("//192.168.50.130/backup");
		 * backupLocInfo.setBackupDestUser("root");
		 * backupLocInfo.setBackupDestPasswd(backupDestPasswd);
		 * 
		 * prep.setLong(4, backupLocInfo.getFreeSize()); prep.setLong(5,
		 * backupLocInfo.getTotalSize());
		 * 
		 * backupLocInfo.setType(2); // NFS = 1 , CIFS = 2
		 */

	}

}
