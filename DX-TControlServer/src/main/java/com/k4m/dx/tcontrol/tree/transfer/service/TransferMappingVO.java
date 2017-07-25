package com.k4m.dx.tcontrol.tree.transfer.service;

public class TransferMappingVO {
	private int trf_tb_id;            //전송_테이블_ID
	private int trf_trg_mpp_id;       //전송_대상_매핑_ID
	private String scm_nm;            //스키마_명
	private String tb_engl_nm;        //테이블_영문_명
	private String frst_regr_id;      //최초_등록자_ID
	private String frst_reg_dtm;      //최초_등록_일시
	private String lst_mdfr_id;       //최종_수정자_ID
	private String lst_mdf_dtm;       //최종_수정_일시
	
	public int getTrf_tb_id() {
		return trf_tb_id;
	}
	public void setTrf_tb_id(int trf_tb_id) {
		this.trf_tb_id = trf_tb_id;
	}
	public int getTrf_trg_mpp_id() {
		return trf_trg_mpp_id;
	}
	public void setTrf_trg_mpp_id(int trf_trg_mpp_id) {
		this.trf_trg_mpp_id = trf_trg_mpp_id;
	}
	public String getScm_nm() {
		return scm_nm;
	}
	public void setScm_nm(String scm_nm) {
		this.scm_nm = scm_nm;
	}
	public String getTb_engl_nm() {
		return tb_engl_nm;
	}
	public void setTb_engl_nm(String tb_engl_nm) {
		this.tb_engl_nm = tb_engl_nm;
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
