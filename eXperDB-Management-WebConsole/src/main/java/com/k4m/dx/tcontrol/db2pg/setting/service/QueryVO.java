package com.k4m.dx.tcontrol.db2pg.setting.service;

public class QueryVO {
	private int db2pg_usr_qry_id;
	private int db2pg_trsf_wrk_id;
	private String tar_tb_name;
	private String usr_qry_exp;
	private String frst_regr_id;
	private String frst_reg_dtm;
	private String lst_mdfr_id;
	private String lst_mdf_dtm;
	
	public int getDb2pg_usr_qry_id() {
		return db2pg_usr_qry_id;
	}
	public void setDb2pg_usr_qry_id(int db2pg_usr_qry_id) {
		this.db2pg_usr_qry_id = db2pg_usr_qry_id;
	}
	public int getDb2pg_trsf_wrk_id() {
		return db2pg_trsf_wrk_id;
	}
	public void setDb2pg_trsf_wrk_id(int db2pg_trsf_wrk_id) {
		this.db2pg_trsf_wrk_id = db2pg_trsf_wrk_id;
	}
	public String getTar_tb_name() {
		return tar_tb_name;
	}
	public void setTar_tb_name(String tar_tb_name) {
		this.tar_tb_name = tar_tb_name;
	}
	public String getUsr_qry_exp() {
		return usr_qry_exp;
	}
	public void setUsr_qry_exp(String usr_qry_exp) {
		this.usr_qry_exp = usr_qry_exp;
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
