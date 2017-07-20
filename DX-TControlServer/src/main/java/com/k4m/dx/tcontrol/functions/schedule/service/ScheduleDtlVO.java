package com.k4m.dx.tcontrol.functions.schedule.service;

public class ScheduleDtlVO {

	private int rownum;
	private int idx;
	private int scd_id;
	private int wrk_id;
	private int exe_ord;
	private String nxt_exe_yn;
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

	public int getScd_id() {
		return scd_id;
	}

	public void setScd_id(int scd_id) {
		this.scd_id = scd_id;
	}

	public int getWrk_id() {
		return wrk_id;
	}

	public void setWrk_id(int wrk_id) {
		this.wrk_id = wrk_id;
	}

	public int getExe_ord() {
		return exe_ord;
	}

	public void setExe_ord(int exe_ord) {
		this.exe_ord = exe_ord;
	}

	public String getNxt_exe_yn() {
		return nxt_exe_yn;
	}

	public void setNxt_exe_yn(String nxt_exe_yn) {
		this.nxt_exe_yn = nxt_exe_yn;
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
