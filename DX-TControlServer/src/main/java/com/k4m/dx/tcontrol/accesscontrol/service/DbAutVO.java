package com.k4m.dx.tcontrol.accesscontrol.service;

public class DbAutVO {
	private int usr_db_aut_id; //사용자_DB_권한_ID
	private int db_svr_id; //DB_서버_ID
	private int db_id; //DB_ID
	private String usr_id; //사용자_ID
	private String aut_yn; //권한_여부
	private String frst_regr_id; //최초_등록자_ID
	private String frst_reg_dtm; //최초_등록_일시
	private String lst_mdfr_id; //최종_수정자_ID
	private String lst_mdf_dtm; //최종_수정_일시
	
	private String db_svr_nm;
	
	public String getDb_svr_nm() {
		return db_svr_nm;
	}
	public void setDb_svr_nm(String db_svr_nm) {
		this.db_svr_nm = db_svr_nm;
	}
	public int getUsr_db_aut_id() {
		return usr_db_aut_id;
	}
	public void setUsr_db_aut_id(int usr_db_aut_id) {
		this.usr_db_aut_id = usr_db_aut_id;
	}
	public int getDb_svr_id() {
		return db_svr_id;
	}
	public void setDb_svr_id(int db_svr_id) {
		this.db_svr_id = db_svr_id;
	}
	public int getDb_id() {
		return db_id;
	}
	public void setDb_id(int db_id) {
		this.db_id = db_id;
	}
	public String getUsr_id() {
		return usr_id;
	}
	public void setUsr_id(String usr_id) {
		this.usr_id = usr_id;
	}
	public String getAut_yn() {
		return aut_yn;
	}
	public void setAut_yn(String aut_yn) {
		this.aut_yn = aut_yn;
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
