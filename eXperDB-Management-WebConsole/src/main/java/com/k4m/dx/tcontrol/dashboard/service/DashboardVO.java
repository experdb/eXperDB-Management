package com.k4m.dx.tcontrol.dashboard.service;

public class DashboardVO {
	
	private int start_cnt;
	private int run_cnt;
	private int stop_cnt;
	private int today_cnt;
	private int fail_cnt;
	
	private int server_cnt;
	private int backup_cnt;
	private int unregistered_cnt;
	private int schedule_run_cnt;
	
	private int db_svr_id;
	private String ipadr;
	private String db_svr_nm;
	private String master_gbn;
	private int db_cnt;
	private int undb_cnt;
	private int wrk_cnt;
	private int schedule_cnt;
	private int success_cnt;
	private String audit_state;
	private String agt_cndt_cd;
	private String lst_mdf_dtm;
	private String svr_host_nm;
	
	private int connect_cnt;
	private int execute_cnt;
	
	private String db_nm;
	private String bck_opt_cd;
	private String bsn_dscd;
	private String lgi_dtm_start;
	private String lgi_dtm_end;
	private String bck_opt_cd_nm;

	private String pry_cnt;
	
	public String getPry_cnt() {
		return pry_cnt;
	}
	public void setPry_cnt(String pry_cnt) {
		this.pry_cnt = pry_cnt;
	}
	
	public String getBck_opt_cd_nm() {
		return bck_opt_cd_nm;
	}
	public void setBck_opt_cd_nm(String bck_opt_cd_nm) {
		this.bck_opt_cd_nm = bck_opt_cd_nm;
	}
	public String getLgi_dtm_start() {
		return lgi_dtm_start;
	}
	public void setLgi_dtm_start(String lgi_dtm_start) {
		this.lgi_dtm_start = lgi_dtm_start;
	}
	public String getLgi_dtm_end() {
		return lgi_dtm_end;
	}
	public void setLgi_dtm_end(String lgi_dtm_end) {
		this.lgi_dtm_end = lgi_dtm_end;
	}
	public String getBsn_dscd() {
		return bsn_dscd;
	}
	public void setBsn_dscd(String bsn_dscd) {
		this.bsn_dscd = bsn_dscd;
	}
	public String getSvr_host_nm() {
		return svr_host_nm;
	}
	public void setSvr_host_nm(String svr_host_nm) {
		this.svr_host_nm = svr_host_nm;
	}
	public String getBck_opt_cd() {
		return bck_opt_cd;
	}
	public void setBck_opt_cd(String bck_opt_cd) {
		this.bck_opt_cd = bck_opt_cd;
	}
	public String getDb_nm() {
		return db_nm;
	}
	public void setDb_nm(String db_nm) {
		this.db_nm = db_nm;
	}
	public int getStart_cnt() {
		return start_cnt;
	}
	public void setStart_cnt(int start_cnt) {
		this.start_cnt = start_cnt;
	}
	public int getConnect_cnt() {
		return connect_cnt;
	}
	public void setConnect_cnt(int connect_cnt) {
		this.connect_cnt = connect_cnt;
	}
	public int getExecute_cnt() {
		return execute_cnt;
	}
	public void setExecute_cnt(int execute_cnt) {
		this.execute_cnt = execute_cnt;
	}
	
	public int getSchedule_run_cnt() {
		return schedule_run_cnt;
	}
	public void setSchedule_run_cnt(int schedule_run_cnt) {
		this.schedule_run_cnt = schedule_run_cnt;
	}
	public int getDb_cnt() {
		return db_cnt;
	}
	public void setDb_cnt(int db_cnt) {
		this.db_cnt = db_cnt;
	}
	public int getUndb_cnt() {
		return undb_cnt;
	}
	public void setUndb_cnt(int undb_cnt) {
		this.undb_cnt = undb_cnt;
	}
	public String getDb_svr_nm() {
		return db_svr_nm;
	}
	public void setDb_svr_nm(String db_svr_nm) {
		this.db_svr_nm = db_svr_nm;
	}
	public String getMaster_gbn() {
		return master_gbn;
	}
	public void setMaster_gbn(String master_gbn) {
		this.master_gbn = master_gbn;
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
	public String getIpadr() {
		return ipadr;
	}
	public void setIpadr(String ipadr) {
		this.ipadr = ipadr;
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
	public String getAudit_state() {
		return audit_state;
	}
	public void setAudit_state(String audit_state) {
		this.audit_state = audit_state;
	}
	public String getAgt_cndt_cd() {
		return agt_cndt_cd;
	}
	public void setAgt_cndt_cd(String agt_cndt_cd) {
		this.agt_cndt_cd = agt_cndt_cd;
	}
	public String getLst_mdf_dtm() {
		return lst_mdf_dtm;
	}
	public void setLst_mdf_dtm(String lst_mdf_dtm) {
		this.lst_mdf_dtm = lst_mdf_dtm;
	}
	
	
	
}
