package com.k4m.dx.tcontrol.db2pg.setting.service;

public class QueryVO {
	private int db2pg_usr_qry_id;
	private String usr_qry_exp;
	private String frst_regr_id;
	private String frst_reg_dtm;
	
	public int getDb2pg_usr_qry_id() {
		return db2pg_usr_qry_id;
	}
	public void setDb2pg_usr_qry_id(int db2pg_usr_qry_id) {
		this.db2pg_usr_qry_id = db2pg_usr_qry_id;
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
}
