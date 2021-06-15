package com.experdb.proxy.db.repository.vo;

public class ProxyListenerVO {
	
	private int lsn_id; 
	private int pry_svr_id; 
	private String lsn_nm; 
	private String con_bind_port; 
	private String lsn_desc; 
	private String db_usr_id; 
	private int db_id; 
	private String db_nm; 
	private String con_sim_query; 
	private String field_val; 
	private String field_nm; 
	private String frst_regr_id; 
	private String frst_reg_dtm; 
	private String lst_mdfr_id; 
	private String lst_mdf_dtm;
	private int db_svr_id;
	private String lsn_exe_status;
	
	public String getLsn_exe_status() {
		return lsn_exe_status;
	}
	public void setLsn_exe_status(String lsn_exe_status) {
		this.lsn_exe_status = lsn_exe_status;
	}
	public int getDb_svr_id() {
		return db_svr_id;
	}
	public void setDb_svr_id(int db_svr_id) {
		this.db_svr_id = db_svr_id;
	}
	public int getLsn_id() {
		return lsn_id;
	}
	public void setLsn_id(int lsn_id) {
		this.lsn_id = lsn_id;
	}
	public int getPry_svr_id() {
		return pry_svr_id;
	}
	public void setPry_svr_id(int pry_svr_id) {
		this.pry_svr_id = pry_svr_id;
	}
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
	public String getLsn_desc() {
		return lsn_desc;
	}
	public void setLsn_desc(String lsn_desc) {
		this.lsn_desc = lsn_desc;
	}
	public String getDb_usr_id() {
		return db_usr_id;
	}
	public void setDb_usr_id(String db_usr_id) {
		this.db_usr_id = db_usr_id;
	}
	public int getDb_id() {
		return db_id;
	}
	public void setDb_id(int db_id) {
		this.db_id = db_id;
	}
	public String getDb_nm() {
		return db_nm;
	}
	public void setDb_nm(String db_nm) {
		this.db_nm = db_nm;
	}
	public String getCon_sim_query() {
		return con_sim_query;
	}
	public void setCon_sim_query(String con_sim_query) {
		this.con_sim_query = con_sim_query;
	}
	public String getField_val() {
		return field_val;
	}
	public void setField_val(String field_val) {
		this.field_val = field_val;
	}
	public String getField_nm() {
		return field_nm;
	}
	public void setField_nm(String field_nm) {
		this.field_nm = field_nm;
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