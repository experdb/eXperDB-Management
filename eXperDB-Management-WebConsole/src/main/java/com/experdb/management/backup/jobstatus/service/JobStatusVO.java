package com.experdb.management.backup.jobstatus.service;

public class JobStatusVO {

	private static final long serialVersionUID = -7332909400957745807L;
	public static final int READY = -1;
	public static final int IDLE = 0;
	public static final int FINISHED = 1;
	public static final int CANCELLED = 2;
	public static final int FAILED = 3;
	public static final int INCOMPLETE = 4;
	public static final int ACTIVE = 5;
	public static final int WAITING = 6;
	public static final int CRASHED = 7;
	public static final int NEEDREBOOT = 8;
	public static final int FAILED_NO_LICENSE = 9;
	public static final int WAITING_IN_JOBQUEUE = 10;
	public static final int DONE = 100;
	public static final int JOB_PHASE_READY_TO_USE = 84;
	public static final int JOB_PHASE_RUNNING = 85;
	public static final int JOB_PHASE_READY_TO_USE_SCRIPT_SUCCEED = 86;
	public static final int JOB_PHASE_READY_TO_USE_SCRIPT_FAILED = 87;
	public static final int JOB_PHASE_COLLECT_SYSTEM_INFO = 9;
	public static final int JOB_PHASE_BACKUP_VOLUME = 11;

	private String uuid;
	private String jobname;
	private int jobType;
	private String targetname;
	private String backuplocation;
	private int isrepeat;

	private int jobstatus;
	private int lastresult;
	private String templateid;
	private int jobMethod;
	private String location;
	private String rpsserver;
	private String dsname;
	private int type;

	private long jobID = -1L;
	private long executeTime;
	private long elapsedTime;
	private int lastResult;
	private long finishTime;
	private long throughput;
	private long writeThroughput;
	private long writeData;
	private int progress;
	private int status = -1;
	private int jobPhase;
	private long processedData;
	private String volume;
	private boolean dedupeEnabled;
	private long totalSizeRead;
	private long totalSizeWritten;
	private long totalUniqueData;
	private boolean isBackupToRps;

	private String jobtype_nm;
	private String jobstatus_nm;

	private boolean repeat = false;

	public boolean isRepeat() {
		return this.repeat;
	}

	public void setRepeat(boolean repeat) {
		this.repeat = repeat;
	}

	public String getJobtype_nm() {
		return jobtype_nm;
	}

	public void setJobtype_nm(String jobtype_nm) {
		this.jobtype_nm = jobtype_nm;
	}

	public String getJobstatus_nm() {
		return jobstatus_nm;
	}

	public void setJobstatus_nm(String jobstatus_nm) {
		this.jobstatus_nm = jobstatus_nm;
	}

	public String getUuid() {
		return uuid;
	}

	public void setUuid(String uuid) {
		this.uuid = uuid;
	}

	public String getJobname() {
		return jobname;
	}

	public void setJobname(String jobname) {
		this.jobname = jobname;
	}

	public int getJobType() {
		return jobType;
	}

	public void setJobType(int jobType) {
		this.jobType = jobType;
	}

	public String getTargetname() {
		return targetname;
	}

	public void setTargetname(String targetname) {
		this.targetname = targetname;
	}

	public String getBackuplocation() {
		return backuplocation;
	}

	public void setBackuplocation(String backuplocation) {
		this.backuplocation = backuplocation;
	}

	public int getIsrepeat() {
		return isrepeat;
	}

	public void setIsrepeat(int isrepeat) {
		this.isrepeat = isrepeat;
	}

	public int getJobstatus() {
		return jobstatus;
	}

	public void setJobstatus(int jobstatus) {
		this.jobstatus = jobstatus;
	}

	public int getLastresult() {
		return lastresult;
	}

	public void setLastresult(int lastresult) {
		this.lastresult = lastresult;
	}

	public String getTemplateid() {
		return templateid;
	}

	public void setTemplateid(String templateid) {
		this.templateid = templateid;
	}

	public int getJobMethod() {
		return jobMethod;
	}

	public void setJobMethod(int jobMethod) {
		this.jobMethod = jobMethod;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public String getRpsserver() {
		return rpsserver;
	}

	public void setRpsserver(String rpsserver) {
		this.rpsserver = rpsserver;
	}

	public String getDsname() {
		return dsname;
	}

	public void setDsname(String dsname) {
		this.dsname = dsname;
	}

	public int getType() {
		return type;
	}

	public void setType(int type) {
		this.type = type;
	}

	public long getJobID() {
		return jobID;
	}

	public void setJobID(long jobID) {
		this.jobID = jobID;
	}

	public long getExecuteTime() {
		return executeTime;
	}

	public void setExecuteTime(long executeTime) {
		this.executeTime = executeTime;
	}

	public long getElapsedTime() {
		return elapsedTime;
	}

	public void setElapsedTime(long elapsedTime) {
		this.elapsedTime = elapsedTime;
	}

	public int getLastResult() {
		return lastResult;
	}

	public void setLastResult(int lastResult) {
		this.lastResult = lastResult;
	}

	public long getFinishTime() {
		return finishTime;
	}

	public void setFinishTime(long finishTime) {
		this.finishTime = finishTime;
	}

	public long getThroughput() {
		return throughput;
	}

	public void setThroughput(long throughput) {
		this.throughput = throughput;
	}

	public long getWriteThroughput() {
		return writeThroughput;
	}

	public void setWriteThroughput(long writeThroughput) {
		this.writeThroughput = writeThroughput;
	}

	public long getWriteData() {
		return writeData;
	}

	public void setWriteData(long writeData) {
		this.writeData = writeData;
	}

	public int getProgress() {
		return progress;
	}

	public void setProgress(int progress) {
		this.progress = progress;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	public int getJobPhase() {
		return jobPhase;
	}

	public void setJobPhase(int jobPhase) {
		this.jobPhase = jobPhase;
	}

	public long getProcessedData() {
		return processedData;
	}

	public void setProcessedData(long processedData) {
		this.processedData = processedData;
	}

	public String getVolume() {
		return volume;
	}

	public void setVolume(String volume) {
		this.volume = volume;
	}

	public boolean isDedupeEnabled() {
		return dedupeEnabled;
	}

	public void setDedupeEnabled(boolean dedupeEnabled) {
		this.dedupeEnabled = dedupeEnabled;
	}

	public long getTotalSizeRead() {
		return totalSizeRead;
	}

	public void setTotalSizeRead(long totalSizeRead) {
		this.totalSizeRead = totalSizeRead;
	}

	public long getTotalSizeWritten() {
		return totalSizeWritten;
	}

	public void setTotalSizeWritten(long totalSizeWritten) {
		this.totalSizeWritten = totalSizeWritten;
	}

	public long getTotalUniqueData() {
		return totalUniqueData;
	}

	public void setTotalUniqueData(long totalUniqueData) {
		this.totalUniqueData = totalUniqueData;
	}

	public boolean isBackupToRps() {
		return isBackupToRps;
	}

	public void setBackupToRps(boolean isBackupToRps) {
		this.isBackupToRps = isBackupToRps;
	}

	public boolean isJobComplete() {
		if (this.status == 1 || this.status == 2 || this.status == 3 || this.status == -1 || this.status == 4
				|| this.status == 7 || this.status == 8 || this.status == 9 || this.status == 100) {
			return true;
		}
		return false;
	}

	public static boolean isStandbyJob(int jobType) {
		if (jobType == 40 || jobType == 41) {
			return true;
		}
		return false;
	}

	public static boolean isRestoreJob(int jobType) {
		if (jobType == 2 || jobType == 21 || jobType == 23 || jobType == 22 || jobType == 24 || jobType == 28
				|| jobType == 26 || jobType == 27) {
			return true;
		}
		return false;
	}

	public static boolean isBackupJob(int jobType) {
	     if (jobType == 1 || jobType == 3 || jobType == 4 || jobType == 5)
	    {
	       return true;
	     }
	     return false;
	  }
	
	public static boolean isReadyToUse(int jobPhase) {
		return (jobPhase == 84 || jobPhase == 85 || jobPhase == 86 || jobPhase == 87);
	}
}
