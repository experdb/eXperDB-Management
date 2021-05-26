package com.experdb.proxy.db.repository.vo;

public class ProxyServerVO {
	private int pry_svr_id;
	private String ipadr;
	private int agt_sn;
	private String pry_svr_nm;
	private String pry_pth;
	private String kal_pth;
	private String use_yn;
	private String exe_status;
	private String kal_exe_status;
	private String master_gbn;
	private int master_svr_id;
	private int db_svr_id;
	private int day_data_del_term;
	private int min_data_del_term;
	private String frst_regr_id;
	private String frst_reg_dtm;
	private String lst_mdfr_id;
	private String lst_mdf_dtm;
	private String master_svr_id_chk;
	private String back_peer_id;
	private String old_master_gbn;
	private int old_pry_svr_id;
	private String old_master_svr_id_chk;
	private String sel_query_gbn;
	private String kal_install_yn;
	private String master_svr_nm;
	private int master_exe_cnt;
	private String upd_master_gbn;

	private String day_data_del_val;
	private String min_data_del_val;
	
	private String log_type_min;
	private String log_type_day;
	
	public String getUpd_master_gbn() {
		return upd_master_gbn;
	}
	public void setUpd_master_gbn(String upd_master_gbn) {
		this.upd_master_gbn = upd_master_gbn;
	}
	public int getMaster_exe_cnt() {
		return master_exe_cnt;
	}
	public void setMaster_exe_cnt(int master_exe_cnt) {
		this.master_exe_cnt = master_exe_cnt;
	}
	public String getMaster_svr_nm() {
		return master_svr_nm;
	}
	public void setMaster_svr_nm(String master_svr_nm) {
		this.master_svr_nm = master_svr_nm;
	}
	public String getLog_type_min() {
		return log_type_min;
	}
	public void setLog_type_min(String log_type_min) {
		this.log_type_min = log_type_min;
	}
	public String getLog_type_day() {
		return log_type_day;
	}
	public void setLog_type_day(String log_type_day) {
		this.log_type_day = log_type_day;
	}
	public String getDay_data_del_val() {
		return day_data_del_val;
	}
	public void setDay_data_del_val(String day_data_del_val) {
		this.day_data_del_val = day_data_del_val;
	}
	public String getMin_data_del_val() {
		return min_data_del_val;
	}
	public void setMin_data_del_val(String min_data_del_val) {
		this.min_data_del_val = min_data_del_val;
	}
	public String getKal_install_yn() {
		return kal_install_yn;
	}
	public void setKal_install_yn(String kal_install_yn) {
		this.kal_install_yn = kal_install_yn;
	}
	public String getSel_query_gbn() {
		return sel_query_gbn;
	}
	public void setSel_query_gbn(String sel_query_gbn) {
		this.sel_query_gbn = sel_query_gbn;
	}
	public String getOld_master_svr_id_chk() {
		return old_master_svr_id_chk;
	}
	public void setOld_master_svr_id_chk(String old_master_svr_id_chk) {
		this.old_master_svr_id_chk = old_master_svr_id_chk;
	}
	public int getOld_pry_svr_id() {
		return old_pry_svr_id;
	}
	public void setOld_pry_svr_id(int old_pry_svr_id) {
		this.old_pry_svr_id = old_pry_svr_id;
	}
	public String getOld_master_gbn() {
		return old_master_gbn;
	}
	public void setOld_master_gbn(String old_master_gbn) {
		this.old_master_gbn = old_master_gbn;
	}
	public String getBack_peer_id() {
		return back_peer_id;
	}
	public void setBack_peer_id(String back_peer_id) {
		this.back_peer_id = back_peer_id;
	}
	public int getPry_svr_id() {
		return pry_svr_id;
	}
	public void setPry_svr_id(int pry_svr_id) {
		this.pry_svr_id = pry_svr_id;
	}
	public String getIpadr() {
		return ipadr;
	}
	public void setIpadr(String ipadr) {
		this.ipadr = ipadr;
	}
	public int getAgt_sn() {
		return agt_sn;
	}
	public void setAgt_sn(int agt_sn) {
		this.agt_sn = agt_sn;
	}
	public String getPry_svr_nm() {
		return pry_svr_nm;
	}
	public void setPry_svr_nm(String pry_svr_nm) {
		this.pry_svr_nm = pry_svr_nm;
	}
	public String getPry_pth() {
		return pry_pth;
	}
	public void setPry_pth(String pry_pth) {
		this.pry_pth = pry_pth;
	}
	public String getKal_pth() {
		return kal_pth;
	}
	public void setKal_pth(String kal_pth) {
		this.kal_pth = kal_pth;
	}
	public String getUse_yn() {
		return use_yn;
	}
	public void setUse_yn(String use_yn) {
		this.use_yn = use_yn;
	}
	public String getExe_status() {
		return exe_status;
	}
	public void setExe_status(String exe_status) {
		this.exe_status = exe_status;
	}
	public String getKal_exe_status() {
		return kal_exe_status;
	}
	public void setKal_exe_status(String kal_exe_status) {
		this.kal_exe_status = kal_exe_status;
	}
	public String getMaster_gbn() {
		return master_gbn;
	}
	public void setMaster_gbn(String master_gbn) {
		this.master_gbn = master_gbn;
	}
	public int getMaster_svr_id() {
		return master_svr_id;
	}
	public void setMaster_svr_id(int master_svr_id) {
		this.master_svr_id = master_svr_id;
	}
	public int getDb_svr_id() {
		return db_svr_id;
	}
	public void setDb_svr_id(int db_svr_id) {
		this.db_svr_id = db_svr_id;
	}
	public int getDay_data_del_term() {
		return day_data_del_term;
	}
	public void setDay_data_del_term(int day_data_del_term) {
		this.day_data_del_term = day_data_del_term;
	}
	public int getMin_data_del_term() {
		return min_data_del_term;
	}
	public void setMin_data_del_term(int min_data_del_term) {
		this.min_data_del_term = min_data_del_term;
	}
	public String getFrst_regr_id() {
		return frst_regr_id;
	}
	public void setFrst_regr_id(String frst_regr_id) {
		this.frst_regr_id = frst_regr_id;
	}
	public String getFrst_reg_dtm() {
		return frst_reg_dtm;
	}
	public void setFrst_reg_dtm(String frst_reg_dtm) {
		this.frst_reg_dtm = frst_reg_dtm;
	}
	public String getLst_mdfr_id() {
		return lst_mdfr_id;
	}
	public void setLst_mdfr_id(String lst_mdfr_id) {
		this.lst_mdfr_id = lst_mdfr_id;
	}
	public String getLst_mdf_dtm() {
		return lst_mdf_dtm;
	}
	public void setLst_mdf_dtm(String lst_mdf_dtm) {
		this.lst_mdf_dtm = lst_mdf_dtm;
	}
	public String getMaster_svr_id_chk() {
		return master_svr_id_chk;
	}
	public void setMaster_svr_id_chk(String master_svr_id_chk) {
		this.master_svr_id_chk = master_svr_id_chk;
	}
}