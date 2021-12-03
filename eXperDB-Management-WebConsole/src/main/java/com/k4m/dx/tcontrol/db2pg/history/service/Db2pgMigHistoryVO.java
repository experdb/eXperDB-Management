package com.k4m.dx.tcontrol.db2pg.history.service;

public class Db2pgMigHistoryVO {

	private int rownum;
	private int idx;
	private String exe_date;
	private String wrk_nm;
	private String mig_nm;
	private long total_table_cnt;
	private long mig_table_cnt;
	private String start_time;
	private String end_time;
	private String elapsed_time;	
	private String migStartDate;
	private String migEndDate;


	
	public String getMigStartDate() {
		return migStartDate;
	}

	public void setMigStartDate(String migStartDate) {
		this.migStartDate = migStartDate;
	}

	public String getMigEndDate() {
		return migEndDate;
	}

	public void setMigEndDate(String migEndDate) {
		this.migEndDate = migEndDate;
	}

	public int getRownum() {
		return rownum;
	}

	public void setRownum(int rownum) {
		this.rownum = rownum;
	}

	public int getIdx() {
		return idx;
	}

	public void setIdx(int idx) {
		this.idx = idx;
	}

	public String getExe_date() {
		return exe_date;
	}

	public void setExe_date(String exe_date) {
		this.exe_date = exe_date;
	}

	public String getWrk_nm() {
		return wrk_nm;
	}

	public void setWrk_nm(String wrk_nm) {
		this.wrk_nm = wrk_nm;
	}

	public String getMig_nm() {
		return mig_nm;
	}

	public void setMig_nm(String mig_nm) {
		this.mig_nm = mig_nm;
	}

	public long getTotal_table_cnt() {
		return total_table_cnt;
	}

	public void setTotal_table_cnt(long total_table_cnt) {
		this.total_table_cnt = total_table_cnt;
	}

	public long getMig_table_cnt() {
		return mig_table_cnt;
	}

	public void setMig_table_cnt(long mig_table_cnt) {
		this.mig_table_cnt = mig_table_cnt;
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

}
