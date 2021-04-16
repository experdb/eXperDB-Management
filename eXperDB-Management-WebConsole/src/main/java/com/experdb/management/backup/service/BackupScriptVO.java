package com.experdb.management.backup.service;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class BackupScriptVO implements Serializable {

	private static final long serialVersionUID = -4603223664815414580L;
	private BackupLocationInfoVO backupLocationInfo;
	
	
	private int compressLevel;  /*Compression : max : 2, standard : 1*/
	private String encryptAlgoName ="No Encryption";
	private int encryptAlgoType = 0;
	private boolean isExclude = true;
	private int id = 0;  /*노드별로 생성되는거같음 0 고정값*/
	private int jobMethod = 0;
	private String jobName;
	private String jobType = "1";
	private String logLevel = "0";
	private int priority = 0;  /*Priority(0: High, 1: Medium, 2: Low)*/
	private String  isRepeat; /*scheduleType none일 경우 false, schedul일 경우 true*/
	private String targetServer;
	private String targetServerPwd;
	private String targetServerUser;
	private boolean isTemplate = true;
	private String templateID;
	private boolean isBackupToRps;
	private boolean isDisable;  /*scheduleType none일 경우 true, schedul일 경우 false*/
	private RetentionVO retention;
	private int scheduleType;
	private int sessionType;
	// private List<BackupTarget> settings;
	private long throttle;

	// private WeeklySchedule weeklySchedule;
	public BackupLocationInfoVO getBackupLocationInfo() {
		return backupLocationInfo;
	}

	public void setBackupLocationInfo(BackupLocationInfoVO backupLocationInfo) {
		this.backupLocationInfo = backupLocationInfo;
	}

	public int getCompressLevel() {
		return compressLevel;
	}

	public void setCompressLevel(int compressLevel) {
		this.compressLevel = compressLevel;
	}

	public String getEncryptAlgoName() {
		return encryptAlgoName;
	}

	public void setEncryptAlgoName(String encryptAlgoName) {
		this.encryptAlgoName = encryptAlgoName;
	}

	public int getEncryptAlgoType() {
		return encryptAlgoType;
	}

	public void setEncryptAlgoType(int encryptAlgoType) {
		this.encryptAlgoType = encryptAlgoType;
	}

	public boolean isExclude() {
		return isExclude;
	}

	public void setExclude(boolean isExclude) {
		this.isExclude = isExclude;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getJobMethod() {
		return jobMethod;
	}

	public void setJobMethod(int jobMethod) {
		this.jobMethod = jobMethod;
	}

	public String getJobName() {
		return jobName;
	}

	public void setJobName(String jobName) {
		this.jobName = jobName;
	}

	public String getJobType() {
		return jobType;
	}

	public void setJobType(String jobType) {
		this.jobType = jobType;
	}

	public String getLogLevel() {
		return logLevel;
	}

	public void setLogLevel(String logLevel) {
		this.logLevel = logLevel;
	}

	public int getPriority() {
		return priority;
	}

	public void setPriority(int priority) {
		this.priority = priority;
	}

	public String isRepeat() {
		return isRepeat;
	}

	public void setRepeat(String isRepeat) {
		this.isRepeat = isRepeat;
	}

	public String getTargetServer() {
		return targetServer;
	}

	public void setTargetServer(String targetServer) {
		this.targetServer = targetServer;
	}

	public String getTargetServerPwd() {
		return targetServerPwd;
	}

	public void setTargetServerPwd(String targetServerPwd) {
		this.targetServerPwd = targetServerPwd;
	}

	public String getTargetServerUser() {
		return targetServerUser;
	}

	public void setTargetServerUser(String targetServerUser) {
		this.targetServerUser = targetServerUser;
	}

	public boolean isTemplate() {
		return isTemplate;
	}

	public void setTemplate(boolean isTemplate) {
		this.isTemplate = isTemplate;
	}

	public String getTemplateID() {
		return templateID;
	}

	public void setTemplateID(String templateID) {
		this.templateID = templateID;
	}

	public boolean isBackupToRps() {
		return isBackupToRps;
	}

	public void setBackupToRps(boolean isBackupToRps) {
		this.isBackupToRps = isBackupToRps;
	}

	public boolean isDisable() {
		return isDisable;
	}

	public void setDisable(boolean isDisable) {
		this.isDisable = isDisable;
	}

	public RetentionVO getRetention() {
		return retention;
	}

	public void setRetention(RetentionVO retention) {
		this.retention = retention;
	}

	public int getScheduleType() {
		return scheduleType;
	}

	public void setScheduleType(int scheduleType) {
		this.scheduleType = scheduleType;
	}

	public int getSessionType() {
		return sessionType;
	}

	public void setSessionType(int sessionType) {
		this.sessionType = sessionType;
	}

	public long getThrottle() {
		return throttle;
	}

	public void setThrottle(long throttle) {
		this.throttle = throttle;
	}

	@Override
	public String toString() {
		return "BackupScriptVO [backupLocationInfo=" + backupLocationInfo + ", compressLevel=" + compressLevel
				+ ", encryptAlgoName=" + encryptAlgoName + ", encryptAlgoType=" + encryptAlgoType + ", isExclude="
				+ isExclude + ", id=" + id + ", jobMethod=" + jobMethod + ", jobName=" + jobName + ", jobType="
				+ jobType + ", logLevel=" + logLevel + ", priority=" + priority + ", isRepeat=" + isRepeat
				+ ", targetServer=" + targetServer + ", targetServerPwd=" + targetServerPwd + ", targetServerUser="
				+ targetServerUser + ", isTemplate=" + isTemplate + ", templateID=" + templateID + ", isBackupToRps="
				+ isBackupToRps + ", isDisable=" + isDisable + ", retention=" + retention + ", scheduleType="
				+ scheduleType + ", sessionType=" + sessionType + ", throttle=" + throttle + "]";
	}
	
	

}
