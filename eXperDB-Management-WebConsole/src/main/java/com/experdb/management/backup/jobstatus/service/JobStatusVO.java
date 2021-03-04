package com.experdb.management.backup.jobstatus.service;

public class JobStatusVO {

	private String uudi;
	private String targetname;
	private int jobtype;
	private int jobstatus;
	private long executeTime;
	private long elapsedtime;
	private int jobPhase;
	private long processedData;
	private long throughput;
	private long writeThroughput;
	private String backuplocation;

	public String getUudi() {
		return uudi;
	}

	public void setUudi(String uudi) {
		this.uudi = uudi;
	}

	public String getTargetname() {
		return targetname;
	}

	public void setTargetname(String targetname) {
		this.targetname = targetname;
	}

	public int getJobtype() {
		return jobtype;
	}

	public void setJobtype(int jobtype) {
		this.jobtype = jobtype;
	}

	public int getJobstatus() {
		return jobstatus;
	}

	public void setJobstatus(int jobstatus) {
		this.jobstatus = jobstatus;
	}

	public long getExecuteTime() {
		return executeTime;
	}

	public void setExecuteTime(long executeTime) {
		this.executeTime = executeTime;
	}

	public long getElapsedtime() {
		return elapsedtime;
	}

	public void setElapsedtime(long elapsedtime) {
		this.elapsedtime = elapsedtime;
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

	public String getBackuplocation() {
		return backuplocation;
	}

	public void setBackuplocation(String backuplocation) {
		this.backuplocation = backuplocation;
	}

}
