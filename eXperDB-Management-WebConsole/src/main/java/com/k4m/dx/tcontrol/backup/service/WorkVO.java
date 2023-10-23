package com.k4m.dx.tcontrol.backup.service;

public class WorkVO {
	private int rownum;
	private int idx;
	private String db_svr_nm;
	private int wrk_id;
	private int db_svr_id;
	private int db_id;
	private String db_nm;
	private String bck_bsn_dscd;
	private String wrk_nm;
	private String wrk_exp;
	private String bck_opt_cd;
	private int bck_mtn_ecnt;
	private String cps_yn;
	private Double cprt;
	private String save_pth;
	private String file_fmt_cd;
	private String file_fmt_cd_nm;
	private int file_stg_dcnt;
	private String encd_mth_nm;
	private String encd_mth_cd;
	private String usr_role_nm;
	private String frst_regr_id;
	private String frst_reg_dtm;
	private String lst_mdfr_id;
	private String lst_mdf_dtm;
	private String log_file_bck_yn;
	private int log_file_stg_dcnt;
	private int log_file_mtn_ecnt;
	private String bck_bsn_dscd_nm;
	private String bck_opt_cd_nm;
	private String bck_filenm;
	private String data_pth;
	private String bck_pth;
	private int acv_file_stgdt;
	private int acv_file_mtncnt;
	private String usr_id;
	private int bck_wrk_id;
	private String bsn_dscd;
	private String bsn_dscd_nm;
	private String log_file_pth;
	private int db_svr_ipadr_id;
	private String backrest_gbn;
	private String db_svr_ipadr;
	private String remote_ip;
	private String remote_port;
	private String remote_usr;
	private String remote_pw;
	private String remote_use;
	private int bck_target_ipadr_id;
	private String bck_target_ipadr;
	
	
	public String getEncd_mth_cd() {
		return encd_mth_cd;
	}

	public void setEncd_mth_cd(String encd_mth_cd) {
		this.encd_mth_cd = encd_mth_cd;
	}

	public String getLog_file_pth() {
		return log_file_pth;
	}

	public void setLog_file_pth(String log_file_pth) {
		this.log_file_pth = log_file_pth;
	}

	public String getBsn_dscd_nm() {
		return bsn_dscd_nm;
	}

	public void setBsn_dscd_nm(String bsn_dscd_nm) {
		this.bsn_dscd_nm = bsn_dscd_nm;
	}

	public String getBsn_dscd() {
		return bsn_dscd;
	}

	public void setBsn_dscd(String bsn_dscd) {
		this.bsn_dscd = bsn_dscd;
	}

	public int getBck_wrk_id() {
		return bck_wrk_id;
	}

	public void setBck_wrk_id(int bck_wrk_id) {
		this.bck_wrk_id = bck_wrk_id;
	}

	public String getUsr_id() {
		return usr_id;
	}

	public void setUsr_id(String usr_id) {
		this.usr_id = usr_id;
	}

	public String getBck_filenm() {
		return bck_filenm;
	}

	public void setBck_filenm(String bck_filenm) {
		this.bck_filenm = bck_filenm;
	}

	public String getData_pth() {
		return data_pth;
	}

	public void setData_pth(String data_pth) {
		this.data_pth = data_pth;
	}

	public String getBck_pth() {
		return bck_pth;
	}

	public void setBck_pth(String bck_pth) {
		this.bck_pth = bck_pth;
	}

	public int getAcv_file_stgdt() {
		return acv_file_stgdt;
	}

	public void setAcv_file_stgdt(int acv_file_stgdt) {
		this.acv_file_stgdt = acv_file_stgdt;
	}

	public int getAcv_file_mtncnt() {
		return acv_file_mtncnt;
	}

	public void setAcv_file_mtncnt(int acv_file_mtncnt) {
		this.acv_file_mtncnt = acv_file_mtncnt;
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

	public String getDb_svr_nm() {
		return db_svr_nm;
	}

	public void setDb_svr_nm(String db_svr_nm) {
		this.db_svr_nm = db_svr_nm;
	}

	public String getFile_fmt_cd_nm() {
		return file_fmt_cd_nm;
	}

	public void setFile_fmt_cd_nm(String file_fmt_cd_nm) {
		this.file_fmt_cd_nm = file_fmt_cd_nm;
	}

	public String getBck_bsn_dscd_nm() {
		return bck_bsn_dscd_nm;
	}

	public void setBck_bsn_dscd_nm(String bck_bsn_dscd_nm) {
		this.bck_bsn_dscd_nm = bck_bsn_dscd_nm;
	}

	public String getBck_opt_cd_nm() {
		return bck_opt_cd_nm;
	}

	public void setBck_opt_cd_nm(String bck_opt_cd_nm) {
		this.bck_opt_cd_nm = bck_opt_cd_nm;
	}

	public int getBck_mtn_ecnt() {
		return bck_mtn_ecnt;
	}

	public void setBck_mtn_ecnt(int bck_mtn_ecnt) {
		this.bck_mtn_ecnt = bck_mtn_ecnt;
	}

	public int getFile_stg_dcnt() {
		return file_stg_dcnt;
	}

	public void setFile_stg_dcnt(int file_stg_dcnt) {
		this.file_stg_dcnt = file_stg_dcnt;
	}

	public int getLog_file_stg_dcnt() {
		return log_file_stg_dcnt;
	}

	public void setLog_file_stg_dcnt(int log_file_stg_dcnt) {
		this.log_file_stg_dcnt = log_file_stg_dcnt;
	}

	public int getLog_file_mtn_ecnt() {
		return log_file_mtn_ecnt;
	}

	public void setLog_file_mtn_ecnt(int log_file_mtn_ecnt) {
		this.log_file_mtn_ecnt = log_file_mtn_ecnt;
	}

	public String getDb_nm() {
		return db_nm;
	}

	public void setDb_nm(String db_nm) {
		this.db_nm = db_nm;
	}

	public String getLog_file_bck_yn() {
		return log_file_bck_yn;
	}

	public void setLog_file_bck_yn(String log_file_bck_yn) {
		this.log_file_bck_yn = log_file_bck_yn;
	}

	public int getWrk_id() {
		return wrk_id;
	}

	public void setWrk_id(int wrk_id) {
		this.wrk_id = wrk_id;
	}

	public int getDb_svr_id() {
		return db_svr_id;
	}

	public void setDb_svr_id(int db_svr_id) {
		this.db_svr_id = db_svr_id;
	}

	public int getDb_id() {
		return db_id;
	}

	public void setDb_id(int db_id) {
		this.db_id = db_id;
	}

	public String getBck_bsn_dscd() {
		return bck_bsn_dscd;
	}

	public void setBck_bsn_dscd(String bck_bsn_dscd) {
		this.bck_bsn_dscd = bck_bsn_dscd;
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

	public String getBck_opt_cd() {
		return bck_opt_cd;
	}

	public void setBck_opt_cd(String bck_opt_cd) {
		this.bck_opt_cd = bck_opt_cd;
	}

	public String getCps_yn() {
		return cps_yn;
	}

	public void setCps_yn(String cps_yn) {
		this.cps_yn = cps_yn;
	}

	public Double getCprt() {
		return cprt;
	}

	public void setCprt(Double cprt) {
		this.cprt = cprt;
	}

	public String getSave_pth() {
		return save_pth;
	}

	public void setSave_pth(String save_pth) {
		this.save_pth = save_pth;
	}

	public String getFile_fmt_cd() {
		return file_fmt_cd;
	}

	public void setFile_fmt_cd(String file_fmt_cd) {
		this.file_fmt_cd = file_fmt_cd;
	}

	public String getEncd_mth_nm() {
		return encd_mth_nm;
	}

	public void setEncd_mth_nm(String encd_mth_nm) {
		this.encd_mth_nm = encd_mth_nm;
	}

	public String getUsr_role_nm() {
		return usr_role_nm;
	}

	public void setUsr_role_nm(String usr_role_nm) {
		this.usr_role_nm = usr_role_nm;
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

	public int getDb_svr_ipadr_id() {
		return db_svr_ipadr_id;
	}

	public void setDb_svr_ipadr_id(int db_svr_ipadr_id) {
		this.db_svr_ipadr_id = db_svr_ipadr_id;
	}

	public String getBackrest_gbn() {
		return backrest_gbn;
	}

	public void setBackrest_gbn(String backrest_gbn) {
		this.backrest_gbn = backrest_gbn;
	}

	public String getDb_svr_ipadr() {
		return db_svr_ipadr;
	}

	public void setDb_svr_ipadr(String db_svr_ipadr) {
		this.db_svr_ipadr = db_svr_ipadr;
	}

	public String getRemote_ip() {
		return remote_ip;
	}

	public void setRemote_ip(String remote_ip) {
		this.remote_ip = remote_ip;
	}

	public String getRemote_port() {
		return remote_port;
	}

	public void setRemote_port(String remote_port) {
		this.remote_port = remote_port;
	}

	public String getRemote_usr() {
		return remote_usr;
	}

	public void setRemote_usr(String remote_usr) {
		this.remote_usr = remote_usr;
	}

	public String getRemote_pw() {
		return remote_pw;
	}

	public void setRemote_pw(String remote_pw) {
		this.remote_pw = remote_pw;
	}

	public String getRemote_use() {
		return remote_use;
	}

	public void setRemote_use(String remote_use) {
		this.remote_use = remote_use;
	}

	public int getBck_target_ipadr_id() {
		return bck_target_ipadr_id;
	}

	public void setBck_target_ipadr_id(int bck_target_ipadr_id) {
		this.bck_target_ipadr_id = bck_target_ipadr_id;
	}

	public String getBck_target_ipadr() {
		return bck_target_ipadr;
	}

	public void setBck_target_ipadr(String bck_target_ipadr) {
		this.bck_target_ipadr = bck_target_ipadr;
	}
	
	
	
	
}
