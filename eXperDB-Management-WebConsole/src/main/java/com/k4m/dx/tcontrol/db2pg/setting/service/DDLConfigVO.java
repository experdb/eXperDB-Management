package com.k4m.dx.tcontrol.db2pg.setting.service;

public class DDLConfigVO {
	private int rownum;
	private int idx;
	private int db2pg_ddl_wrk_id;
	private String db2pg_ddl_wrk_nm;
	private String db2pg_ddl_wrk_exp;
	private int db2pg_sys_id;
	private String db2pg_uchr_lchr_val;
	private boolean src_tb_ddl_exrt_tf;
	private String ddl_save_pth;
	private int db2pg_exrt_trg_tb_wrk_id;
	private int db2pg_exrt_exct_tb_wrk_id;
	private String frst_regr_id;
	private String frst_reg_dtm;
	private String lst_mdfr_id;
	private String lst_mdf_dtm;

	private String dbms_dscd;
	private String ipadr;
	private String dtb_nm;
	private String scm_nm;

	private String db2pg_sys_nm;

	private String exrt_trg_tb_nm;
	private String exrt_trg_tb_cnt;
	private String exrt_exct_tb_nm;
	private String exrt_exct_tb_cnt;
	private int wrk_id;

	private int exrt_trg_tb_total_cnt;
	private int exrt_exct_tb_total_cnt;

	public int getExrt_trg_tb_total_cnt() {
		return exrt_trg_tb_total_cnt;
	}

	public void setExrt_trg_tb_total_cnt(int exrt_trg_tb_total_cnt) {
		this.exrt_trg_tb_total_cnt = exrt_trg_tb_total_cnt;
	}

	public int getExrt_exct_tb_total_cnt() {
		return exrt_exct_tb_total_cnt;
	}

	public void setExrt_exct_tb_total_cnt(int exrt_exct_tb_total_cnt) {
		this.exrt_exct_tb_total_cnt = exrt_exct_tb_total_cnt;
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

	public int getDb2pg_ddl_wrk_id() {
		return db2pg_ddl_wrk_id;
	}

	public void setDb2pg_ddl_wrk_id(int db2pg_ddl_wrk_id) {
		this.db2pg_ddl_wrk_id = db2pg_ddl_wrk_id;
	}

	public String getDb2pg_ddl_wrk_nm() {
		return db2pg_ddl_wrk_nm;
	}

	public void setDb2pg_ddl_wrk_nm(String db2pg_ddl_wrk_nm) {
		this.db2pg_ddl_wrk_nm = db2pg_ddl_wrk_nm;
	}

	public String getDb2pg_ddl_wrk_exp() {
		return db2pg_ddl_wrk_exp;
	}

	public void setDb2pg_ddl_wrk_exp(String db2pg_ddl_wrk_exp) {
		this.db2pg_ddl_wrk_exp = db2pg_ddl_wrk_exp;
	}

	public int getDb2pg_sys_id() {
		return db2pg_sys_id;
	}

	public void setDb2pg_sys_id(int db2pg_sys_id) {
		this.db2pg_sys_id = db2pg_sys_id;
	}

	public String getDb2pg_uchr_lchr_val() {
		return db2pg_uchr_lchr_val;
	}

	public void setDb2pg_uchr_lchr_val(String db2pg_uchr_lchr_val) {
		this.db2pg_uchr_lchr_val = db2pg_uchr_lchr_val;
	}

	public boolean getSrc_tb_ddl_exrt_tf() {
		return src_tb_ddl_exrt_tf;
	}

	public void setSrc_tb_ddl_exrt_tf(boolean src_tb_ddl_exrt_tf) {
		this.src_tb_ddl_exrt_tf = src_tb_ddl_exrt_tf;
	}

	public String getDdl_save_pth() {
		return ddl_save_pth;
	}

	public void setDdl_save_pth(String ddl_save_pth) {
		this.ddl_save_pth = ddl_save_pth;
	}

	public int getDb2pg_exrt_trg_tb_wrk_id() {
		return db2pg_exrt_trg_tb_wrk_id;
	}

	public void setDb2pg_exrt_trg_tb_wrk_id(int db2pg_exrt_trg_tb_wrk_id) {
		this.db2pg_exrt_trg_tb_wrk_id = db2pg_exrt_trg_tb_wrk_id;
	}

	public int getDb2pg_exrt_exct_tb_wrk_id() {
		return db2pg_exrt_exct_tb_wrk_id;
	}

	public void setDb2pg_exrt_exct_tb_wrk_id(int db2pg_exrt_exct_tb_wrk_id) {
		this.db2pg_exrt_exct_tb_wrk_id = db2pg_exrt_exct_tb_wrk_id;
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

	public String getDbms_dscd() {
		return dbms_dscd;
	}

	public void setDbms_dscd(String dbms_dscd) {
		this.dbms_dscd = dbms_dscd;
	}

	public String getIpadr() {
		return ipadr;
	}

	public void setIpadr(String ipadr) {
		this.ipadr = ipadr;
	}

	public String getDtb_nm() {
		return dtb_nm;
	}

	public void setDtb_nm(String dtb_nm) {
		this.dtb_nm = dtb_nm;
	}

	public String getScm_nm() {
		return scm_nm;
	}

	public void setScm_nm(String scm_nm) {
		this.scm_nm = scm_nm;
	}

	public String getDb2pg_sys_nm() {
		return db2pg_sys_nm;
	}

	public void setDb2pg_sys_nm(String db2pg_sys_nm) {
		this.db2pg_sys_nm = db2pg_sys_nm;
	}

	public String getExrt_trg_tb_nm() {
		return exrt_trg_tb_nm;
	}

	public void setExrt_trg_tb_nm(String exrt_trg_tb_nm) {
		this.exrt_trg_tb_nm = exrt_trg_tb_nm;
	}

	public String getExrt_trg_tb_cnt() {
		return exrt_trg_tb_cnt;
	}

	public void setExrt_trg_tb_cnt(String exrt_trg_tb_cnt) {
		this.exrt_trg_tb_cnt = exrt_trg_tb_cnt;
	}

	public String getExrt_exct_tb_nm() {
		return exrt_exct_tb_nm;
	}

	public void setExrt_exct_tb_nm(String exrt_exct_tb_nm) {
		this.exrt_exct_tb_nm = exrt_exct_tb_nm;
	}

	public String getExrt_exct_tb_cnt() {
		return exrt_exct_tb_cnt;
	}

	public void setExrt_exct_tb_cnt(String exrt_exct_tb_cnt) {
		this.exrt_exct_tb_cnt = exrt_exct_tb_cnt;
	}

	public int getWrk_id() {
		return wrk_id;
	}

	public void setWrk_id(int wrk_id) {
		this.wrk_id = wrk_id;
	}

}
