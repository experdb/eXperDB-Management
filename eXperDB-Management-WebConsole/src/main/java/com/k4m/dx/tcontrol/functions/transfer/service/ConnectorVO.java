package com.k4m.dx.tcontrol.functions.transfer.service;

public class ConnectorVO {
	private int rownum; //rownum
	private int idx; //idx
	private int cnr_id; //커넥터_ID
	private String cnr_nm;//커넥터_명
	private String cnr_ipadr;//커넥터_IP주소
	private int cnr_portno;//커넥터_포트번호
	private String cnr_cnn_tp_cd;//커넥터_연결_유형_코드
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
	public int getCnr_id() {
		return cnr_id;
	}
	public void setCnr_id(int cnr_id) {
		this.cnr_id = cnr_id;
	}
	public String getCnr_nm() {
		return cnr_nm;
	}
	public void setCnr_nm(String cnr_nm) {
		this.cnr_nm = cnr_nm;
	}
	public String getCnr_ipadr() {
		return cnr_ipadr;
	}
	public void setCnr_ipadr(String cnr_ipadr) {
		this.cnr_ipadr = cnr_ipadr;
	}
	public int getCnr_portno() {
		return cnr_portno;
	}
	public void setCnr_portno(int cnr_portno) {
		this.cnr_portno = cnr_portno;
	}
	public String getCnr_cnn_tp_cd() {
		return cnr_cnn_tp_cd;
	}
	public void setCnr_cnn_tp_cd(String cnr_cnn_tp_cd) {
		this.cnr_cnn_tp_cd = cnr_cnn_tp_cd;
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
