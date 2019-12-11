package com.k4m.dx.tcontrol.db2pg.setting.service;

public class SrcTableVO {
	// 추출대상테이블
	private int db2pg_exrt_trg_tb_wrk_id;
	private String exrt_trg_tb_nm;
	private String exrt_trg_scm_nm;

	// 추출제외테이블
	private int db2pg_exrt_exct_tb_wrk_id;
	private String exrt_exct_tb_nm;
	private String exrt_exct_scm_nm;

	// 총테이블수
	private int src_table_total_cnt;

	private String frst_regr_id;
	private String frst_reg_dtm;

	public int getSrc_table_total_cnt() {
		return src_table_total_cnt;
	}

	public void setSrc_table_total_cnt(int src_table_total_cnt) {
		this.src_table_total_cnt = src_table_total_cnt;
	}

	public int getDb2pg_exrt_trg_tb_wrk_id() {
		return db2pg_exrt_trg_tb_wrk_id;
	}

	public void setDb2pg_exrt_trg_tb_wrk_id(int db2pg_exrt_trg_tb_wrk_id) {
		this.db2pg_exrt_trg_tb_wrk_id = db2pg_exrt_trg_tb_wrk_id;
	}

	public String getExrt_trg_tb_nm() {
		return exrt_trg_tb_nm;
	}

	public void setExrt_trg_tb_nm(String exrt_trg_tb_nm) {
		this.exrt_trg_tb_nm = exrt_trg_tb_nm;
	}

	public String getExrt_trg_scm_nm() {
		return exrt_trg_scm_nm;
	}

	public void setExrt_trg_scm_nm(String exrt_trg_scm_nm) {
		this.exrt_trg_scm_nm = exrt_trg_scm_nm;
	}

	public int getDb2pg_exrt_exct_tb_wrk_id() {
		return db2pg_exrt_exct_tb_wrk_id;
	}

	public void setDb2pg_exrt_exct_tb_wrk_id(int db2pg_exrt_exct_tb_wrk_id) {
		this.db2pg_exrt_exct_tb_wrk_id = db2pg_exrt_exct_tb_wrk_id;
	}

	public String getExrt_exct_tb_nm() {
		return exrt_exct_tb_nm;
	}

	public void setExrt_exct_tb_nm(String exrt_exct_tb_nm) {
		this.exrt_exct_tb_nm = exrt_exct_tb_nm;
	}

	public String getExrt_exct_scm_nm() {
		return exrt_exct_scm_nm;
	}

	public void setExrt_exct_scm_nm(String exrt_exct_scm_nm) {
		this.exrt_exct_scm_nm = exrt_exct_scm_nm;
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

}
