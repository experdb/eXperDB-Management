package com.k4m.dx.tcontrol.functions.transfer.service;

public class TransferVO {
	private int rownum; //rownum
	private int idx; //idx
	private int trf_cng_id; //전송_설정_ID
	private String trf_svr_nm;//전송_서버_명
	private String ipadr;//IP주소
	private int portno;//포트번호
	private String frst_regr_id;//최초_등록자_ID
	private String frst_reg_dtm;//최초_등록_일시
	private String lst_mdfr_id;//최종_수정자_ID
	private String lst_mdf_dtm;//최종_수정_일시
	
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
	public int getTrf_cng_id() {
		return trf_cng_id;
	}
	public void setTrf_cng_id(int trf_cng_id) {
		this.trf_cng_id = trf_cng_id;
	}
	public String getTrf_svr_nm() {
		return trf_svr_nm;
	}
	public void setTrf_svr_nm(String trf_svr_nm) {
		this.trf_svr_nm = trf_svr_nm;
	}
	public String getIpadr() {
		return ipadr;
	}
	public void setIpadr(String ipadr) {
		this.ipadr = ipadr;
	}
	public int getPortno() {
		return portno;
	}
	public void setPortno(int portno) {
		this.portno = portno;
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
