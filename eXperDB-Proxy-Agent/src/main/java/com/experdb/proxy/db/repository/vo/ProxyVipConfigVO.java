package com.experdb.proxy.db.repository.vo;

public class ProxyVipConfigVO {
	private int vip_cng_id; 
	private String state_nm; 
	private int pry_svr_id; 
	private String v_ip; 
	private String v_rot_id; 
	private String v_if_nm; 
	private int priority; 
	private int chk_tm; 
	private String v_ip_exe_status; 
	private String frst_regr_id; 
	private String frst_reg_dtm; 
	private String lst_mdfr_id; 
	private String lst_mdf_dtm;
	
	public String getV_ip_exe_status() {
		return v_ip_exe_status;
	}
	public void setV_ip_exe_status(String v_ip_exe_status) {
		this.v_ip_exe_status = v_ip_exe_status;
	}
	public int getVip_cng_id() {
		return vip_cng_id;
	}
	public void setVip_cng_id(int vip_cng_id) {
		this.vip_cng_id = vip_cng_id;
	}
	public String getState_nm() {
		return state_nm;
	}
	public void setState_nm(String state_nm) {
		this.state_nm = state_nm;
	}
	public int getPry_svr_id() {
		return pry_svr_id;
	}
	public void setPry_svr_id(int pry_svr_id) {
		this.pry_svr_id = pry_svr_id;
	}
	public String getV_ip() {
		return v_ip;
	}
	public void setV_ip(String v_ip) {
		this.v_ip = v_ip;
	}
	public String getV_rot_id() {
		return v_rot_id;
	}
	public void setV_rot_id(String v_rot_id) {
		this.v_rot_id = v_rot_id;
	}
	public String getV_if_nm() {
		return v_if_nm;
	}
	public void setV_if_nm(String v_if_nm) {
		this.v_if_nm = v_if_nm;
	}
	public int getPriority() {
		return priority;
	}
	public void setPriority(int priority) {
		this.priority = priority;
	}
	public int getChk_tm() {
		return chk_tm;
	}
	public void setChk_tm(int chk_tm) {
		this.chk_tm = chk_tm;
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
}