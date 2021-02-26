package com.experdb.management.backup.history.service;

public class BackupActivityLogVO {

	private int recordid;
	private String servername;
	private String targetname;
	private String jobname;
	private String jobuuid;
	private int jobid;
	private int jobtype;
	private int type;
	private String time;
	private String message;
	private String sourcemachinename;
	private String sourcemachineuuid;
	private String errorcode;

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

	public int getType() {
		return type;
	}

	public void setType(int type) {
		this.type = type;
	}

	public String getTime() {
		return time;
	}

	public void setTime(String time) {
		this.time = time;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
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

	public String getErrorcode() {
		return errorcode;
	}

	public void setErrorcode(String errorcode) {
		this.errorcode = errorcode;
	}

}
