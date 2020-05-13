package com.k4m.dx.tcontrol.db2pg.history.service;

public class Db2pgHistoryVO {
	private int rownum;
	private int idx;
	private int mig_exe_sn;
	private String wrk_strt_dtm;
	private String wrk_end_dtm;
	private String wrk_dtm;
	private String exe_rslt_cd;
	private String exe_rslt_nm;
	private int wrk_id;
	private String wrk_nm;
	private String wrk_exp;
	private String source_dbms_dscd;
	private String source_dbms_dscd_nm;
	private String source_ipadr;
	private String source_dtb_nm;
	private String target_ipadr;
	private String target_dtb_nm;
	private String frst_regr_id;
	private String frst_reg_dtm;
	private String lst_mdfr_id;
	private String lst_mdf_dtm;

	private String rslt_msg;
	private String trans_save_pth;
	private String ddl_save_pth;

	private String save_pth;

	public String getSave_pth() {
		return save_pth;
	}

	public void setSave_pth(String save_pth) {
		this.save_pth = save_pth;
	}

	public String getDdl_save_pth() {
		return ddl_save_pth;
	}

	public void setDdl_save_pth(String ddl_save_pth) {
		this.ddl_save_pth = ddl_save_pth;
	}

	public String getTrans_save_pth() {
		return trans_save_pth;
	}

	public void setTrans_save_pth(String trans_save_pth) {
		this.trans_save_pth = trans_save_pth;
	}

	public String getRslt_msg() {
		return rslt_msg;
	}

	public void setRslt_msg(String rslt_msg) {
		this.rslt_msg = rslt_msg;
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

	public int getMig_exe_sn() {
		return mig_exe_sn;
	}

	public void setMig_exe_sn(int mig_exe_sn) {
		this.mig_exe_sn = mig_exe_sn;
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

	public String getWrk_dtm() {
		return wrk_dtm;
	}

	public void setWrk_dtm(String wrk_dtm) {
		this.wrk_dtm = wrk_dtm;
	}

	public String getExe_rslt_cd() {
		return exe_rslt_cd;
	}

	public void setExe_rslt_cd(String exe_rslt_cd) {
		this.exe_rslt_cd = exe_rslt_cd;
	}

	public String getExe_rslt_nm() {
		return exe_rslt_nm;
	}

	public void setExe_rslt_nm(String exe_rslt_nm) {
		this.exe_rslt_nm = exe_rslt_nm;
	}

	public int getWrk_id() {
		return wrk_id;
	}

	public void setWrk_id(int wrk_id) {
		this.wrk_id = wrk_id;
	}

	public String getWrk_nm() {
		return wrk_nm;
	}

	public void setWrk_nm(String wrk_nm) {
		this.wrk_nm = wrk_nm;
	}

	public String getWrk_exp() {
		return wrk_exp;
	}

	public void setWrk_exp(String wrk_exp) {
		this.wrk_exp = wrk_exp;
	}

	public String getSource_dbms_dscd() {
		return source_dbms_dscd;
	}

	public void setSource_dbms_dscd(String source_dbms_dscd) {
		this.source_dbms_dscd = source_dbms_dscd;
	}

	public String getSource_dbms_dscd_nm() {
		return source_dbms_dscd_nm;
	}

	public void setSource_dbms_dscd_nm(String source_dbms_dscd_nm) {
		this.source_dbms_dscd_nm = source_dbms_dscd_nm;
	}

	public String getSource_ipadr() {
		return source_ipadr;
	}

	public void setSource_ipadr(String source_ipadr) {
		this.source_ipadr = source_ipadr;
	}

	public String getSource_dtb_nm() {
		return source_dtb_nm;
	}

	public void setSource_dtb_nm(String source_dtb_nm) {
		this.source_dtb_nm = source_dtb_nm;
	}

	public String getTarget_ipadr() {
		return target_ipadr;
	}

	public void setTarget_ipadr(String target_ipadr) {
		this.target_ipadr = target_ipadr;
	}

	public String getTarget_dtb_nm() {
		return target_dtb_nm;
	}

	public void setTarget_dtb_nm(String target_dtb_nm) {
		this.target_dtb_nm = target_dtb_nm;
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
