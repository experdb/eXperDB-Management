package com.experdb.management.backup.service;

import java.io.Serializable;

public class BackupLocationInfoVO implements Serializable {
	private static final long serialVersionUID = 1977487073968292441L;
	public static final int BACKLOCATION_TYPE_NFS = 1;
	public static final int BACKLOCATION_TYPE_CIFS = 2;

	private String isArchiveType = "false";
	private String uuid;
	private int type;  // 1: NFS share, 2: CIFS share, 3: Source Local, 6:* Amazone S3 
	private String backupDestLocation;
	private String backupDestPasswd;
	private String backupDestUser;
	private long freeSize;
	private long totalSize;	
	private int isRunScript;
	private String script;
	private long freeSizeAlert ;
	private int freeSizeAlertUnit;
	private int jobLimit;	
	private int currentJobCount = 0;
	private int waitingJobCount = 0;
	private long time;
	private int enablededup;
	
	private String rpsserver;
	private String rpspassword;
	private String rpsuuid;
	private String rpsprotocol;

	private DataStoreInfoVO dataStoreInfo;
	private String enableS3CifsShare = "false"; // 아마존 s3 445포트랑 다를 경우(false) 같으면 (true)
	private int s3CifsSharePort = 445; // 아마존 S3공유포트 디폴트 
	private String s3CifsShareUser = "root"; // 아마존 S3루트계정 디폴트 
	private BackupServerInfoVO serverInfo;
	// 원본 xml에 포함되어 있지 않음
	private String s3CifsSharePassword;
	
	

	public String getBackupDestLocation() {
		return backupDestLocation;
	}

	public void setBackupDestLocation(String backupDestLocation) {
		this.backupDestLocation = backupDestLocation;
	}

	public String getBackupDestPasswd() {
		return backupDestPasswd;
	}

	public void setBackupDestPasswd(String backupDestPasswd) {
		this.backupDestPasswd = backupDestPasswd;
	}

	public String getBackupDestUser() {
		return backupDestUser;
	}

	public void setBackupDestUser(String backupDestUser) {
		this.backupDestUser = backupDestUser;
	}

	public int getCurrentJobCount() {
		return currentJobCount;
	}

	public void setCurrentJobCount(int currentJobCount) {
		this.currentJobCount = currentJobCount;
	}

	public DataStoreInfoVO getDataStoreInfo() {
		return dataStoreInfo;
	}

	public void setDataStoreInfo(DataStoreInfoVO dataStoreInfo) {
		this.dataStoreInfo = dataStoreInfo;
	}

	public long getFreeSize() {
		return freeSize;
	}

	public void setFreeSize(long freeSize) {
		this.freeSize = freeSize;
	}

	public long getFreeSizeAlert() {
		return freeSizeAlert;
	}

	public void setFreeSizeAlert(long freeSizeAlert) {
		this.freeSizeAlert = freeSizeAlert;
	}

	public int getFreeSizeAlertUnit() {
		return freeSizeAlertUnit;
	}

	public void setFreeSizeAlertUnit(int freeSizeAlertUnit) {
		this.freeSizeAlertUnit = freeSizeAlertUnit;
	}

	public int getJobLimit() {
		return jobLimit;
	}

	public void setJobLimit(int jobLimit) {
		this.jobLimit = jobLimit;
	}

	public int getS3CifsSharePort() {
		return s3CifsSharePort;
	}

	public void setS3CifsSharePort(int s3CifsSharePort) {
		this.s3CifsSharePort = s3CifsSharePort;
	}

	public String getS3CifsShareUser() {
		return s3CifsShareUser;
	}

	public void setS3CifsShareUser(String s3CifsShareUser) {
		this.s3CifsShareUser = s3CifsShareUser;
	}

	public long getTotalSize() {
		return totalSize;
	}

	public void setTotalSize(long totalSize) {
		this.totalSize = totalSize;
	}

	public int getType() {
		return type;
	}

	public void setType(int type) {
		this.type = type;
	}

	public String getUuid() {
		return uuid;
	}

	public void setUuid(String uuid) {
		this.uuid = uuid;
	}

	public int getWaitingJobCount() {
		return waitingJobCount;
	}

	public void setWaitingJobCount(int waitingJobCount) {
		this.waitingJobCount = waitingJobCount;
	}

	public String getScript() {
		return script;
	}

	public void setScript(String script) {
		this.script = script;
	}

	public String getS3CifsSharePassword() {
		return s3CifsSharePassword;
	}

	public void setS3CifsSharePassword(String s3CifsSharePassword) {
		this.s3CifsSharePassword = s3CifsSharePassword;
	}

	public BackupServerInfoVO getServerInfo() {
		return serverInfo;
	}

	public void setServerInfo(BackupServerInfoVO serverInfo) {
		this.serverInfo = serverInfo;
	}

	public String getIsArchiveType() {
		return isArchiveType;
	}

	public void setIsArchiveType(String isArchiveType) {
		this.isArchiveType = isArchiveType;
	}

	public String getEnableS3CifsShare() {
		return enableS3CifsShare;
	}

	public void setEnableS3CifsShare(String enableS3CifsShare) {
		this.enableS3CifsShare = enableS3CifsShare;
	}

	public int getIsRunScript() {
		return isRunScript;
	}

	public void setIsRunScript(int isRunScript) {
		this.isRunScript = isRunScript;
	}

	public String getRpsserver() {
		return rpsserver;
	}

	public void setRpsserver(String rpsserver) {
		this.rpsserver = rpsserver;
	}

	public String getRpspassword() {
		return rpspassword;
	}

	public void setRpspassword(String rpspassword) {
		this.rpspassword = rpspassword;
	}

	public String getRpsuuid() {
		return rpsuuid;
	}

	public void setRpsuuid(String rpsuuid) {
		this.rpsuuid = rpsuuid;
	}

	public String getRpsprotocol() {
		return rpsprotocol;
	}

	public void setRpsprotocol(String rpsprotocol) {
		this.rpsprotocol = rpsprotocol;
	}
	
	public long getTime() {
		return time;
	}

	public void setTime(long time) {
		this.time = time;
	}
	
	public int getEnablededup() {
		return enablededup;
	}

	public void setEnablededup(int enablededup) {
		this.enablededup = enablededup;
	}

	@Override
	public String toString() {
		return "BackupLocationInfoVO [isArchiveType=" + isArchiveType + ", uuid=" + uuid + ", type=" + type
				+ ", backupDestLocation=" + backupDestLocation + ", backupDestPasswd=" + backupDestPasswd
				+ ", backupDestUser=" + backupDestUser + ", freeSize=" + freeSize + ", totalSize=" + totalSize
				+ ", isRunScript=" + isRunScript + ", script=" + script + ", freeSizeAlert=" + freeSizeAlert
				+ ", freeSizeAlertUnit=" + freeSizeAlertUnit + ", jobLimit=" + jobLimit + ", currentJobCount="
				+ currentJobCount + ", waitingJobCount=" + waitingJobCount + ", time=" + time + ", enablededup="
				+ enablededup + ", rpsserver=" + rpsserver + ", rpspassword=" + rpspassword + ", rpsuuid=" + rpsuuid
				+ ", rpsprotocol=" + rpsprotocol + ", dataStoreInfo=" + dataStoreInfo + ", enableS3CifsShare="
				+ enableS3CifsShare + ", s3CifsSharePort=" + s3CifsSharePort + ", s3CifsShareUser=" + s3CifsShareUser
				+ ", serverInfo=" + serverInfo + ", s3CifsSharePassword=" + s3CifsSharePassword + "]";
	}

}
