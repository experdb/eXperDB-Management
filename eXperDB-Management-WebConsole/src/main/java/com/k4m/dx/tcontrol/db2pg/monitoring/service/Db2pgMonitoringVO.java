package com.k4m.dx.tcontrol.db2pg.monitoring.service;

public class Db2pgMonitoringVO {

	private String wrk_nm;
	private String table_nm;
	private long total_cnt;
	private long mig_cnt;
	private String start_time;
	private String end_time;
	private String elapsed_time;
	private String status;

	public String getWrk_nm() {
		return wrk_nm;
	}

	public void setWrk_nm(String wrk_nm) {
		this.wrk_nm = wrk_nm;
	}

	public String getTable_nm() {
		return table_nm;
	}

	public void setTable_nm(String table_nm) {
		this.table_nm = table_nm;
	}

	public long getTotal_cnt() {
		return total_cnt;
	}

	public void setTotal_cnt(long total_cnt) {
		this.total_cnt = total_cnt;
	}

	public long getMig_cnt() {
		return mig_cnt;
	}

	public void setMig_cnt(long mig_cnt) {
		this.mig_cnt = mig_cnt;
	}

	public String getStart_time() {
		return start_time;
	}

	public void setStart_time(String start_time) {
		this.start_time = start_time;
	}

	public String getEnd_time() {
		return end_time;
	}

	public void setEnd_time(String end_time) {
		this.end_time = end_time;
	}

	public String getElapsed_time() {
		return elapsed_time;
	}

	public void setElapsed_time(String elapsed_time) {
		this.elapsed_time = elapsed_time;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

}
