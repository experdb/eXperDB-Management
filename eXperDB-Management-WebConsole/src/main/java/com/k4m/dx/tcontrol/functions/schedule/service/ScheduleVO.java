package com.k4m.dx.tcontrol.functions.schedule.service;

public class ScheduleVO {

	private int rownum;
	private int idx;
	private int scd_id;
	private String scd_nm;
	private String scd_exp;
	private String scd_cndt;
	private String exe_perd_cd;
	private String exe_dt;
	private String exe_month;
	private String exe_day;
	private String exe_h;
	private String exe_m;
	private String exe_s;
	private String exe_hms;
	private String prev_exe_dtm;
	private String nxt_exe_dtm;
	private String frst_regr_id;
	private String frst_reg_dtm;
	private String lst_mdfr_id;
	private String lst_mdf_dtm;
	private String status;
	private String nxt_exe_from;
	private String nxt_exe_to;
	private String wrk_nm;
	
	
	public String getWrk_nm() {
		return wrk_nm;
	}

	public void setWrk_nm(String wrk_nm) {
		this.wrk_nm = wrk_nm;
	}

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

	public String getScd_nm() {
		return scd_nm;
	}

	public void setScd_nm(String scd_nm) {
		this.scd_nm = scd_nm;
	}

	public String getScd_exp() {
		return scd_exp;
	}

	public void setScd_exp(String scd_exp) {
		this.scd_exp = scd_exp;
	}

	public String getExe_perd_cd() {
		return exe_perd_cd;
	}

	public void setExe_perd_cd(String exe_perd_cd) {
		this.exe_perd_cd = exe_perd_cd;
	}

	public String getExe_dt() {
		return exe_dt;
	}

	public void setExe_dt(String exe_dt) {
		this.exe_dt = exe_dt;
	}

	public String getExe_month() {
		return exe_month;
	}

	public void setExe_month(String exe_month) {
		this.exe_month = exe_month;
	}

	public String getExe_day() {
		return exe_day;
	}

	public void setExe_day(String exe_day) {
		this.exe_day = exe_day;
	}

	public String getExe_h() {
		return exe_h;
	}

	public void setExe_h(String exe_h) {
		this.exe_h = exe_h;
	}

	public String getExe_m() {
		return exe_m;
	}

	public void setExe_m(String exe_m) {
		this.exe_m = exe_m;
	}

	public String getExe_s() {
		return exe_s;
	}

	public void setExe_s(String exe_s) {
		this.exe_s = exe_s;
	}

	public String getExe_hms() {
		return exe_hms;
	}

	public void setExe_hms(String exe_hms) {
		this.exe_hms = exe_hms;
	}

	public String getPrev_exe_dtm() {
		return prev_exe_dtm;
	}

	public void setPrev_exe_dtm(String prev_exe_dtm) {
		this.prev_exe_dtm = prev_exe_dtm;
	}

	public String getNxt_exe_dtm() {
		return nxt_exe_dtm;
	}

	public void setNxt_exe_dtm(String nxt_exe_dtm) {
		this.nxt_exe_dtm = nxt_exe_dtm;
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

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getScd_cndt() {
		return scd_cndt;
	}

	public void setScd_cndt(String scd_cndt) {
		this.scd_cndt = scd_cndt;
	}

	public String getNxt_exe_from() {
		return nxt_exe_from;
	}

	public void setNxt_exe_from(String nxt_exe_from) {
		this.nxt_exe_from = nxt_exe_from;
	}

	public String getNxt_exe_to() {
		return nxt_exe_to;
	}

	public void setNxt_exe_to(String nxt_exe_to) {
		this.nxt_exe_to = nxt_exe_to;
	}

}
