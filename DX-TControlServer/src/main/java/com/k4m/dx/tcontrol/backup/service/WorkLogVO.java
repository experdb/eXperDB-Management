package com.k4m.dx.tcontrol.backup.service;

public class WorkLogVO {
	private int rownum;
	private int exe_sn;
	private int scd_id;
	private int wrk_id;
	private String wrk_strt_dtm;
	private String wrk_end_dtm;
	private String exe_rslt_cd;
	private String bck_opt_cd;
	private String bck_opt_cd_nm;
	private int tli;
	private int file_sz;
	private int db_id;
	private String db_nm;
	private String bck_file_pth;
	private String frst_regr_id;
	private String frst_reg_dtm;
	private String lst_mdfr_id;
	private String lst_mdf_dtm;
	private String bck_bsn_dscd;
	
	public String getBck_opt_cd_nm() {
		return bck_opt_cd_nm;
	}
	public void setBck_opt_cd_nm(String bck_opt_cd_nm) {
		this.bck_opt_cd_nm = bck_opt_cd_nm;
	}
	public String getDb_nm() {
		return db_nm;
	}
	public void setDb_nm(String db_nm) {
		this.db_nm = db_nm;
	}
	public String getBck_bsn_dscd() {
		return bck_bsn_dscd;
	}
	public void setBck_bsn_dscd(String bck_bsn_dscd) {
		this.bck_bsn_dscd = bck_bsn_dscd;
	}
	public String getBck_opt_cd() {
		return bck_opt_cd;
	}
	public void setBck_opt_cd(String bck_opt_cd) {
		this.bck_opt_cd = bck_opt_cd;
	}
	public int getTli() {
		return tli;
	}
	public void setTli(int tli) {
		this.tli = tli;
	}
	public int getFile_sz() {
		return file_sz;
	}
	public void setFile_sz(int file_sz) {
		this.file_sz = file_sz;
	}
	public int getDb_id() {
		return db_id;
	}
	public void setDb_id(int db_id) {
		this.db_id = db_id;
	}
	public String getBck_file_pth() {
		return bck_file_pth;
	}
	public void setBck_file_pth(String bck_file_pth) {
		this.bck_file_pth = bck_file_pth;
	}
	public int getRownum() {
		return rownum;
	}
	public void setRownum(int rownum) {
		this.rownum = rownum;
	}
	public int getExe_sn() {
		return exe_sn;
	}
	public void setExe_sn(int exe_sn) {
		this.exe_sn = exe_sn;
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
	public String getWrk_strt_dtm() {
		return wrk_strt_dtm;
	}
	public void setWrk_strt_dtm(String wrk_strt_dtm) {
		this.wrk_strt_dtm = wrk_strt_dtm;
	}
	public String getWrk_end_dtm() {
		return wrk_end_dtm;
	}
	public void setWrk_end_dtm(String wrk_end_dtm) {
		this.wrk_end_dtm = wrk_end_dtm;
	}
	public String getExe_rslt_cd() {
		return exe_rslt_cd;
	}
	public void setExe_rslt_cd(String exe_rslt_cd) {
		this.exe_rslt_cd = exe_rslt_cd;
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
