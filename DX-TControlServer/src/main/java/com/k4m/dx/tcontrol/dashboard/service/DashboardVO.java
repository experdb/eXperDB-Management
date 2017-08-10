package com.k4m.dx.tcontrol.dashboard.service;

public class DashboardVO {
	
	private int run_cnt;
	private int stop_cnt;
	private int today_cnt;
	private int fail_cnt;
	
	private int server_cnt;
	private int backup_cnt;
	private int unregistered_cnt;
	
	private int db_svr_id;
	private String db_svr_nm;
	private int db_cnt;
	private int wrk_cnt;
	private int schedule_cnt;
	private int success_cnt;
	private int access_cnt;
	private String agt_cndt_cd;
	
	
	public int getDb_cnt() {
		return db_cnt;
	}
	public void setDb_cnt(int db_cnt) {
		this.db_cnt = db_cnt;
	}
	public String getDb_svr_nm() {
		return db_svr_nm;
	}
	public void setDb_svr_nm(String db_svr_nm) {
		this.db_svr_nm = db_svr_nm;
	}
	public int getRun_cnt() {
		return run_cnt;
	}
	public void setRun_cnt(int run_cnt) {
		this.run_cnt = run_cnt;
	}
	public int getStop_cnt() {
		return stop_cnt;
	}
	public void setStop_cnt(int stop_cnt) {
		this.stop_cnt = stop_cnt;
	}
	public int getToday_cnt() {
		return today_cnt;
	}
	public void setToday_cnt(int today_cnt) {
		this.today_cnt = today_cnt;
	}
	public int getFail_cnt() {
		return fail_cnt;
	}
	public void setFail_cnt(int fail_cnt) {
		this.fail_cnt = fail_cnt;
	}
	public int getServer_cnt() {
		return server_cnt;
	}
	public void setServer_cnt(int server_cnt) {
		this.server_cnt = server_cnt;
	}
	public int getBackup_cnt() {
		return backup_cnt;
	}
	public void setBackup_cnt(int backup_cnt) {
		this.backup_cnt = backup_cnt;
	}
	public int getUnregistered_cnt() {
		return unregistered_cnt;
	}
	public void setUnregistered_cnt(int unregistered_cnt) {
		this.unregistered_cnt = unregistered_cnt;
	}
	public int getDb_svr_id() {
		return db_svr_id;
	}
	public void setDb_svr_id(int db_svr_id) {
		this.db_svr_id = db_svr_id;
	}
	public int getWrk_cnt() {
		return wrk_cnt;
	}
	public void setWrk_cnt(int wrk_cnt) {
		this.wrk_cnt = wrk_cnt;
	}
	public int getSchedule_cnt() {
		return schedule_cnt;
	}
	public void setSchedule_cnt(int schedule_cnt) {
		this.schedule_cnt = schedule_cnt;
	}
	public int getSuccess_cnt() {
		return success_cnt;
	}
	public void setSuccess_cnt(int success_cnt) {
		this.success_cnt = success_cnt;
	}
	public int getAccess_cnt() {
		return access_cnt;
	}
	public void setAccess_cnt(int access_cnt) {
		this.access_cnt = access_cnt;
	}
	public String getAgt_cndt_cd() {
		return agt_cndt_cd;
	}
	public void setAgt_cndt_cd(String agt_cndt_cd) {
		this.agt_cndt_cd = agt_cndt_cd;
	}
	
	
	
	
}
