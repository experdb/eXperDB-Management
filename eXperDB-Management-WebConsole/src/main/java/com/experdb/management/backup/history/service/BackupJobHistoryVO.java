package com.experdb.management.backup.history.service;

public class BackupJobHistoryVO {

	private int recordid;
	private String servername;
	private String targetname;
	private String jobname;
	private String jobuuid;
	private int jobid;
	private int jobtype;
	private String jobtype_nm;
	private int jobmethod;
	private String destinationlocation;
	private String encryptionalgoname;
	private int compresslevel;
	private String executetime;
	private String finishtime;
	private String reducetime;
	private long throughput;
	private long writethroughput;
	private long writedata;
	private long processeddata;
	private long protecteddata;
	private String rpshostname;
	private String rpsuuid;
	private String datastorename;
	private String datastoreuuid;
	private String sourcemachinename;
	private String sourcemachineuuid;
	private int status;
	private int operationtype;
	private String sessionguid;
	private String datasize;
	private String rpoint;

	
	public String getRpoint() {
		return rpoint;
	}

	public void setRpoint(String rpoint) {
		this.rpoint = rpoint;
	}

	public int getRecordid() {
		return recordid;
	}

	public void setRecordid(int recordid) {
		this.recordid = recordid;
	}

	public String getServername() {
		return servername;
	}

	public void setServername(String servername) {
		this.servername = servername;
	}

	public String getTargetname() {
		return targetname;
	}

	public void setTargetname(String targetname) {
		this.targetname = targetname;
	}

	public String getJobname() {
		return jobname;
	}

	public void setJobname(String jobname) {
		this.jobname = jobname;
	}

	public String getJobuuid() {
		return jobuuid;
	}

	public void setJobuuid(String jobuuid) {
		this.jobuuid = jobuuid;
	}

	public int getJobid() {
		return jobid;
	}

	public void setJobid(int jobid) {
		this.jobid = jobid;
	}

	public int getJobtype() {
		return jobtype;
	}

	public void setJobtype(int jobtype) {
		this.jobtype = jobtype;
	}

	public int getJobmethod() {
		return jobmethod;
	}

	public void setJobmethod(int jobmethod) {
		this.jobmethod = jobmethod;
	}

	public String getDestinationlocation() {
		return destinationlocation;
	}

	public void setDestinationlocation(String destinationlocation) {
		this.destinationlocation = destinationlocation;
	}

	public String getEncryptionalgoname() {
		return encryptionalgoname;
	}

	public void setEncryptionalgoname(String encryptionalgoname) {
		this.encryptionalgoname = encryptionalgoname;
	}

	public int getCompresslevel() {
		return compresslevel;
	}

	public void setCompresslevel(int compresslevel) {
		this.compresslevel = compresslevel;
	}

	public String getExecutetime() {
		return executetime;
	}

	public void setExecutetime(String executetime) {
		this.executetime = executetime;
	}

	public String getFinishtime() {
		return finishtime;
	}

	public void setFinishtime(String finishtime) {
		this.finishtime = finishtime;
	}

	public long getThroughput() {
		return throughput;
	}

	public void setThroughput(long throughput) {
		this.throughput = throughput;
	}

	public long getWritethroughput() {
		return writethroughput;
	}

	public void setWritethroughput(long writethroughput) {
		this.writethroughput = writethroughput;
	}

	public long getWritedata() {
		return writedata;
	}

	public void setWritedata(long writedata) {
		this.writedata = writedata;
	}

	public long getProcesseddata() {
		return processeddata;
	}

	public void setProcesseddata(long processeddata) {
		this.processeddata = processeddata;
	}

	public long getProtecteddata() {
		return protecteddata;
	}

	public void setProtecteddata(long protecteddata) {
		this.protecteddata = protecteddata;
	}

	public String getRpshostname() {
		return rpshostname;
	}

	public void setRpshostname(String rpshostname) {
		this.rpshostname = rpshostname;
	}

	public String getRpsuuid() {
		return rpsuuid;
	}

	public void setRpsuuid(String rpsuuid) {
		this.rpsuuid = rpsuuid;
	}

	public String getDatastorename() {
		return datastorename;
	}

	public void setDatastorename(String datastorename) {
		this.datastorename = datastorename;
	}

	public String getDatastoreuuid() {
		return datastoreuuid;
	}

	public void setDatastoreuuid(String datastoreuuid) {
		this.datastoreuuid = datastoreuuid;
	}

	public String getSourcemachinename() {
		return sourcemachinename;
	}

	public void setSourcemachinename(String sourcemachinename) {
		this.sourcemachinename = sourcemachinename;
	}

	public String getSourcemachineuuid() {
		return sourcemachineuuid;
	}

	public void setSourcemachineuuid(String sourcemachineuuid) {
		this.sourcemachineuuid = sourcemachineuuid;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	public int getOperationtype() {
		return operationtype;
	}

	public void setOperationtype(int operationtype) {
		this.operationtype = operationtype;
	}

	public String getSessionguid() {
		return sessionguid;
	}

	public void setSessionguid(String sessionguid) {
		this.sessionguid = sessionguid;
	}

	public String getJobtype_nm() {
		return jobtype_nm;
	}

	public void setJobtype_nm(String jobtype_nm) {
		this.jobtype_nm = jobtype_nm;
	}

	public String getReducetime() {
		return reducetime;
	}

	public void setReducetime(String reducetime) {
		this.reducetime = reducetime;
	}

	public String getDatasize() {
		return datasize;
	}

	public void setDatasize(String datasize) {
		this.datasize = datasize;
	}

}
