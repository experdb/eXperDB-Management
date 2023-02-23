package com.experdb.proxy.db.repository.vo;

public class ProxyListenerServerListVO {
	
	private int lsn_svr_id; 
	private String db_con_addr; 
	private int pry_svr_id; 
	private int lsn_id; 
	private int chk_portno; 
	private String chk_portno_val; 
	private String backup_yn; 
	private String frst_regr_id; 
	private String frst_reg_dtm; 
	private String lst_mdfr_id; 
	private String lst_mdf_dtm;
	private String con_bind_port; 
	private String lsn_nm; 

	public String getLsn_nm() {
		return lsn_nm;
	}
	public void setLsn_nm(String lsn_nm) {
		this.lsn_nm = lsn_nm;
	}
	public String getCon_bind_port() {
		return con_bind_port;
	}
	public void setCon_bind_port(String con_bind_port) {
		this.con_bind_port = con_bind_port;
	}
	public String getChk_portno_val() {
		return chk_portno_val;
	}
	public void setChk_portno_val(String chk_portno_val) {
		this.chk_portno_val = chk_portno_val;
	}
	public int getLsn_svr_id() {
		return lsn_svr_id;
	}
	public void setLsn_svr_id(int lsn_svr_id) {
		this.lsn_svr_id = lsn_svr_id;
	}
	public String getDb_con_addr() {
		return db_con_addr;
	}
	public void setDb_con_addr(String db_con_addr) {
		this.db_con_addr = db_con_addr;
	}
	public int getPry_svr_id() {
		return pry_svr_id;
	}
	public void setPry_svr_id(int pry_svr_id) {
		this.pry_svr_id = pry_svr_id;
	}
	public int getLsn_id() {
		return lsn_id;
	}
	public void setLsn_id(int lsn_id) {
		this.lsn_id = lsn_id;
	}
	public int getChk_portno() {
		return chk_portno;
	}
	public void setChk_portno(int chk_portno) {
		this.chk_portno = chk_portno;
	}
	public String getBackup_yn() {
		return backup_yn;
	}
	public void setBackup_yn(String backup_yn) {
		this.backup_yn = backup_yn;
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