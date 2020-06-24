package com.k4m.dx.tcontrol.scale.service;

/**
* @author 
* @see aws scale vo
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일                 수정자                   수정내용
*  -------     --------    ---------------------------
*  2020.03.24              최초 생성
*      </pre>
*/
public class InstanceScaleVO {
	private int rownum;
	private String RequesterId;
	private int db_svr_id;
	private int db_svr_ipadr_id;
	private String scale_id;
	private String login_id;
	private String wrk_strt_dtm;
	private String wrk_end_dtm;
	private String exe_rslt_cd;
	private String scale_type_cd;
	private String wrk_type_Cd;
	private String process_id_set;
	private String fix_rsltcd;
	private String hist_gbn;
	private String execute_type_cd;
	private String policy_type_cd;
	private int scale_wrk_sn;
	private String auto_policy_set_div;
	private int auto_policy_time;
	private String auto_level;
	private String expansion_clusters;
	private String min_clusters;
	private String max_clusters;
	private String wrk_id;
	private String wrk_id_Rows;
	private String title_gbn;
	private String auto_run_cycle;
	private String useyn;

	public String getUseyn() {
		return useyn;
	}
	public void setUseyn(String useyn) {
		this.useyn = useyn;
	}
	public String getAuto_run_cycle() {
		return auto_run_cycle;
	}
	public void setAuto_run_cycle(String auto_run_cycle) {
		this.auto_run_cycle = auto_run_cycle;
	}
	public String getTitle_gbn() {
		return title_gbn;
	}
	public void setTitle_gbn(String title_gbn) {
		this.title_gbn = title_gbn;
	}
	public String getWrk_id_Rows() {
		return wrk_id_Rows;
	}
	public void setWrk_id_Rows(String wrk_id_Rows) {
		this.wrk_id_Rows = wrk_id_Rows;
	}
	public String getExpansion_clusters() {
		return expansion_clusters;
	}
	public void setExpansion_clusters(String expansion_clusters) {
		this.expansion_clusters = expansion_clusters;
	}
	public String getWrk_id() {
		return wrk_id;
	}
	public void setWrk_id(String wrk_id) {
		this.wrk_id = wrk_id;
	}
	public String getMin_clusters() {
		return min_clusters;
	}
	public void setMin_clusters(String min_clusters) {
		this.min_clusters = min_clusters;
	}
	public String getMax_clusters() {
		return max_clusters;
	}
	public void setMax_clusters(String max_clusters) {
		this.max_clusters = max_clusters;
	}
	public String getAuto_policy_set_div() {
		return auto_policy_set_div;
	}
	public void setAuto_policy_set_div(String auto_policy_set_div) {
		this.auto_policy_set_div = auto_policy_set_div;
	}
	public int getAuto_policy_time() {
		return auto_policy_time;
	}
	public void setAuto_policy_time(int auto_policy_time) {
		this.auto_policy_time = auto_policy_time;
	}
	public String getAuto_level() {
		return auto_level;
	}
	public void setAuto_level(String auto_level) {
		this.auto_level = auto_level;
	}
	public int getScale_wrk_sn() {
		return scale_wrk_sn;
	}
	public void setScale_wrk_sn(int scale_wrk_sn) {
		this.scale_wrk_sn = scale_wrk_sn;
	}
	public String getExecute_type_cd() {
		return execute_type_cd;
	}
	public void setExecute_type_cd(String execute_type_cd) {
		this.execute_type_cd = execute_type_cd;
	}
	public String getPolicy_type_cd() {
		return policy_type_cd;
	}
	public void setPolicy_type_cd(String policy_type_cd) {
		this.policy_type_cd = policy_type_cd;
	}
	public String getHist_gbn() {
		return hist_gbn;
	}
	public void setHist_gbn(String hist_gbn) {
		this.hist_gbn = hist_gbn;
	}
	public String getWrk_strt_dtm() {
		return wrk_strt_dtm;
	}
	public void setWrk_strt_dtm(String wrk_strt_dtm) {
		this.wrk_strt_dtm = wrk_strt_dtm;
	}
	public String getWrk_end_dtm() {
		return wrk_end_dtm;
	}
	public void setWrk_end_dtm(String wrk_end_dtm) {
		this.wrk_end_dtm = wrk_end_dtm;
	}
	public String getExe_rslt_cd() {
		return exe_rslt_cd;
	}
	public void setExe_rslt_cd(String exe_rslt_cd) {
		this.exe_rslt_cd = exe_rslt_cd;
	}
	public String getScale_type_cd() {
		return scale_type_cd;
	}
	public void setScale_type_cd(String scale_type_cd) {
		this.scale_type_cd = scale_type_cd;
	}
	public String getWrk_type_Cd() {
		return wrk_type_Cd;
	}
	public void setWrk_type_Cd(String wrk_type_Cd) {
		this.wrk_type_Cd = wrk_type_Cd;
	}
	public String getProcess_id_set() {
		return process_id_set;
	}
	public void setProcess_id_set(String process_id_set) {
		this.process_id_set = process_id_set;
	}
	public String getFix_rsltcd() {
		return fix_rsltcd;
	}
	public void setFix_rsltcd(String fix_rsltcd) {
		this.fix_rsltcd = fix_rsltcd;
	}
	public int getDb_svr_ipadr_id() {
		return db_svr_ipadr_id;
	}
	public void setDb_svr_ipadr_id(int db_svr_ipadr_id) {
		this.db_svr_ipadr_id = db_svr_ipadr_id;
	}

	public String getLogin_id() {
		return login_id;
	}
	public void setLogin_id(String login_id) {
		this.login_id = login_id;
	}

	public int getRownum() {
		return rownum;
	}
	public void setRownum(int rownum) {
		this.rownum = rownum;
	}

	public String getRequesterId() {
		return RequesterId;
	}
	public void setRequesterId(String RequesterId) {
		this.RequesterId = RequesterId;
	}

	public int getDb_svr_id() {
		return db_svr_id;
	}
	public void setDb_svr_id(int db_svr_id) {
		this.db_svr_id = db_svr_id;
	}

	public String getScale_id() {
		return scale_id;
	}
	public void setScale_id(String scale_id) {
		this.scale_id = scale_id;
	}
}