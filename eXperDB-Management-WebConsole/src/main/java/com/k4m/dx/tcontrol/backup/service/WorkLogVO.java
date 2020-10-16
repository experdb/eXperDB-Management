package com.k4m.dx.tcontrol.backup.service;

public class WorkLogVO {
	private int rownum;
	private int exe_sn;
	private int scd_id;
	private String scd_nm;
	private int wrk_id;
	private String wrk_nm;
	private String wrk_exp;
	private String wrk_strt_dtm;
	private String wrk_end_dtm;
	private String exe_rslt_cd;
	private String exe_rslt_cd_nm;
	private String bck_opt_cd;
	private String bck_opt_cd_nm;
	private int tli;
	private long file_sz;
	private int db_id;
	private String db_nm;
	private String bck_file_pth;
	private String bck_filenm;
	private String frst_regr_id;
	private String frst_reg_dtm;
	private String lst_mdfr_id;
	private String lst_mdf_dtm;
	private String bck_bsn_dscd;
	private String wrk_dtm;
	private String rslt_msg;
	private String ipadr;
	private String db_svr_id;
	private String fix_rsltcd;
	private String fix_rslt_msg;
	private String file_fmt_cd_nm;
	private String file_fmt_cd;
	private String usr_role_nm;
	private String bck_wrk_id;

	public String getBck_wrk_id() {
		return bck_wrk_id;
	}

	public void setBck_wrk_id(String bck_wrk_id) {
		this.bck_wrk_id = bck_wrk_id;
	}

	public String getFix_rsltcd() {
		return fix_rsltcd;
	}

	public void setFix_rsltcd(String fix_rsltcd) {
		this.fix_rsltcd = fix_rsltcd;
	}

	public String getFix_rslt_msg() {
		return fix_rslt_msg;
	}

	public void setFix_rslt_msg(String fix_rslt_msg) {
		this.fix_rslt_msg = fix_rslt_msg;
	}

	public String getDb_svr_id() {
		return db_svr_id;
	}

	public void setDb_svr_id(String db_svr_id) {
		this.db_svr_id = db_svr_id;
	}

	public String getIpadr() {
		return ipadr;
	}

	public void setIpadr(String ipadr) {
		this.ipadr = ipadr;
	}

	public String getRslt_msg() {
		return rslt_msg;
	}

	public void setRslt_msg(String rslt_msg) {
		this.rslt_msg = rslt_msg;
	}

	public String getWrk_dtm() {
		return wrk_dtm;
	}

	public void setWrk_dtm(String wrk_dtm) {
		this.wrk_dtm = wrk_dtm;
	}

	public String getWrk_exp() {
		return wrk_exp;
	}

	public void setWrk_exp(String wrk_exp) {
		this.wrk_exp = wrk_exp;
	}

	public String getBck_filenm() {
		return bck_filenm;
	}

	public void setBck_filenm(String bck_filenm) {
		this.bck_filenm = bck_filenm;
	}

	public String getScd_nm() {
		return scd_nm;
	}

	public void setScd_nm(String scd_nm) {
		this.scd_nm = scd_nm;
	}

	public String getWrk_nm() {
		return wrk_nm;
	}

	public void setWrk_nm(String wrk_nm) {
		this.wrk_nm = wrk_nm;
	}

	public String getExe_rslt_cd_nm() {
		return exe_rslt_cd_nm;
	}

	public void setExe_rslt_cd_nm(String exe_rslt_cd_nm) {
		this.exe_rslt_cd_nm = exe_rslt_cd_nm;
	}

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

	public long getFile_sz() {
		return file_sz;
	}

	public void setFile_sz(long file_sz) {
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

	public String getFile_fmt_cd_nm() {
		return file_fmt_cd_nm;
	}

	public void setFile_fmt_cd_nm(String file_fmt_cd_nm) {
		this.file_fmt_cd_nm = file_fmt_cd_nm;
	}

	public String getFile_fmt_cd() {
		return file_fmt_cd;
	}

	public void setFile_fmt_cd(String file_fmt_cd) {
		this.file_fmt_cd = file_fmt_cd;
	}

	public String getUsr_role_nm() {
		return usr_role_nm;
	}

	public void setUsr_role_nm(String usr_role_nm) {
		this.usr_role_nm = usr_role_nm;
	}

}
