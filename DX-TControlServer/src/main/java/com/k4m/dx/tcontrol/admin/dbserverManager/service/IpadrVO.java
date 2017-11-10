package com.k4m.dx.tcontrol.admin.dbserverManager.service;

public class IpadrVO {
	private int rownum;
	private int idx;
	private int db_svr_ipadr_id;
	private int db_svr_id;
	private String ipadr;
	private int portno;
	private String master_gbn;
	private String frst_regr_id;
	private String frst_reg_dtm;
	private String lst_mdfr_id;
	private String lst_mdf_dtm;

	public int getRownum() {
		return rownum;
	}

	public void setRownum(int rownum) {
		this.rownum = rownum;
	}

	public int getIdx() {
		return idx;
	}

	public void setIdx(int idx) {
		this.idx = idx;
	}

	public int getDb_svr_ipadr_id() {
		return db_svr_ipadr_id;
	}

	public void setDb_svr_ipadr_id(int db_svr_ipadr_id) {
		this.db_svr_ipadr_id = db_svr_ipadr_id;
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

	public void setIPadr(String ipadr) {
		this.ipadr = ipadr;
	}

	public int getPortno() {
		return portno;
	}

	public void setPortno(int portno) {
		this.portno = portno;
	}

	public String getMaster_gbn() {
		return master_gbn;
	}

	public void setMaster_gbn(String master_gbn) {
		this.master_gbn = master_gbn;
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
