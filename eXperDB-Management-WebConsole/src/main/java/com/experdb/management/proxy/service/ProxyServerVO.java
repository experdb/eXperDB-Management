package com.experdb.management.proxy.service;

import java.util.List;

public class ProxyServerVO {
	
	private String rownum;
	
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
	private String kal_install_yn;
	private String state_chk;	

	private ProxyGlobalVO pry_global;
	private List<ProxyVipConfigVO> pry_conf_list; 
	private List<ProxyListenerVO> pry_lsn_list;
	
	public String getState_chk() {
		return state_chk;
	}
	public void setState_chk(String state_chk) {
		this.state_chk = state_chk;
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
	public ProxyGlobalVO getPry_global() {
		return pry_global;
	}
	public void setPry_global(ProxyGlobalVO pry_global) {
		this.pry_global = pry_global;
	}
	public List<ProxyVipConfigVO> getPry_conf_list() {
		return pry_conf_list;
	}
	public void setPry_conf_list(List<ProxyVipConfigVO> pry_conf_list) {
		this.pry_conf_list = pry_conf_list;
	}
	public List<ProxyListenerVO> getPry_lsn_list() {
		return pry_lsn_list;
	}
	public void setPry_lsn_list(List<ProxyListenerVO> pry_lsn_list) {
		this.pry_lsn_list = pry_lsn_list;
	}
	public String getKal_exe_status() {
		return kal_exe_status;
	}
	public void setKal_exe_status(String kal_exe_status) {
		this.kal_exe_status = kal_exe_status;
	}
	public String getRownum() {
		return rownum;
	}
	public void setRownum(String rownum) {
		this.rownum = rownum;
	}
	public String getKal_install_yn() {
		return kal_install_yn;
	}
	public void setKal_install_yn(String kal_install_yn) {
		this.kal_install_yn = kal_install_yn;
	}
}