package com.k4m.dx.tcontrol.tree.transfer.service;

public class TransferRelationVO {
	private int trf_trg_mpp_id; // 전송_대상_매핑_ID
	private int trf_trg_id; // 전송_대상_ID
	private int db_id; // DB_ID
	private int cnr_id; // 커넥터_ID
	private String frst_regr_id; // 최초_등록자_ID
	private String frst_reg_dtm; // 최초_등록_일시
	private String lst_mdfr_id; // 최종_수정자_ID
	private String lst_mdf_dtm; // 최종_수정_일시
	
	public int getTrf_trg_mpp_id() {
		return trf_trg_mpp_id;
	}
	public void setTrf_trg_mpp_id(int trf_trg_mpp_id) {
		this.trf_trg_mpp_id = trf_trg_mpp_id;
	}
	public int getTrf_trg_id() {
		return trf_trg_id;
	}
	public void setTrf_trg_id(int trf_trg_id) {
		this.trf_trg_id = trf_trg_id;
	}
	public int getDb_id() {
		return db_id;
	}
	public void setDb_id(int db_id) {
		this.db_id = db_id;
	}
	public int getCnr_id() {
		return cnr_id;
	}
	public void setCnr_id(int cnr_id) {
		this.cnr_id = cnr_id;
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
