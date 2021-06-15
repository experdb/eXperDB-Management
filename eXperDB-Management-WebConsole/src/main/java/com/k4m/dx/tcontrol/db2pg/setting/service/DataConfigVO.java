package com.k4m.dx.tcontrol.db2pg.setting.service;

public class DataConfigVO {
	private int rownum;
	private int idx;
	private int db2pg_trsf_wrk_id;
	private String db2pg_trsf_wrk_nm;
	private String db2pg_trsf_wrk_exp;
	private int db2pg_src_sys_id;
	private int db2pg_trg_sys_id;
	private int exrt_dat_cnt;
	private int db2pg_exrt_trg_tb_wrk_id;
	private int db2pg_exrt_exct_tb_wrk_id;
	private int exrt_dat_ftch_sz;
	private int dat_ftch_bff_sz;
	private int exrt_prl_prcs_ecnt;
	private int lob_dat_bff_sz;
	private boolean usr_qry_use_tf;
	private int db2pg_usr_qry_id;
	private String ins_opt_cd;
	private boolean tb_rbl_tf;
	private boolean cnst_cnd_exrt_tf;
	private String frst_regr_id;
	private String frst_reg_dtm;
	private String lst_mdfr_id;
	private String lst_mdf_dtm;
	private String trans_save_pth;
	private String src_cnd_qry;
	private String db2pg_uchr_lchr_val;

	private String source_dbms_dscd;
	private String source_ipadr;
	private String source_dtb_nm;
	private String source_scm_nm;
	private String target_dbms_dscd;
	private String target_ipadr;
	private String target_dtb_nm;
	private String target_scm_nm;
	private int wrk_id;

	private String source_dbms_nm;
	private String target_dbms_nm;

	private String exrt_trg_tb_nm;
	private String exrt_trg_tb_cnt;
	private String exrt_exct_tb_nm;
	private String exrt_exct_tb_cnt;

	private int exrt_trg_tb_total_cnt;
	private int exrt_exct_tb_total_cnt;

	
	@Override
	public String toString() {
		return "DataConfigVO [idx=" + idx + ", db2pg_trsf_wrk_id=" + db2pg_trsf_wrk_id + ", db2pg_trsf_wrk_nm="
				+ db2pg_trsf_wrk_nm + ", db2pg_trsf_wrk_exp=" + db2pg_trsf_wrk_exp + ", frst_regr_id=" + frst_regr_id
				+ ", frst_reg_dtm=" + frst_reg_dtm + ", lst_mdfr_id=" + lst_mdfr_id + ", lst_mdf_dtm=" + lst_mdf_dtm
				+ ", trans_save_pth=" + trans_save_pth + ", wrk_id=" + wrk_id + "]";
	}

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

	public String getSource_dbms_nm() {
		return source_dbms_nm;
	}

	public void setSource_dbms_nm(String source_dbms_nm) {
		this.source_dbms_nm = source_dbms_nm;
	}

	public String getTarget_dbms_nm() {
		return target_dbms_nm;
	}

	public void setTarget_dbms_nm(String target_dbms_nm) {
		this.target_dbms_nm = target_dbms_nm;
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

	public int getDb2pg_trsf_wrk_id() {
		return db2pg_trsf_wrk_id;
	}

	public void setDb2pg_trsf_wrk_id(int db2pg_trsf_wrk_id) {
		this.db2pg_trsf_wrk_id = db2pg_trsf_wrk_id;
	}

	public String getDb2pg_trsf_wrk_nm() {
		return db2pg_trsf_wrk_nm;
	}

	public void setDb2pg_trsf_wrk_nm(String db2pg_trsf_wrk_nm) {
		this.db2pg_trsf_wrk_nm = db2pg_trsf_wrk_nm;
	}

	public String getDb2pg_trsf_wrk_exp() {
		return db2pg_trsf_wrk_exp;
	}

	public void setDb2pg_trsf_wrk_exp(String db2pg_trsf_wrk_exp) {
		this.db2pg_trsf_wrk_exp = db2pg_trsf_wrk_exp;
	}

	public int getDb2pg_src_sys_id() {
		return db2pg_src_sys_id;
	}

	public void setDb2pg_src_sys_id(int db2pg_src_sys_id) {
		this.db2pg_src_sys_id = db2pg_src_sys_id;
	}

	public int getDb2pg_trg_sys_id() {
		return db2pg_trg_sys_id;
	}

	public void setDb2pg_trg_sys_id(int db2pg_trg_sys_id) {
		this.db2pg_trg_sys_id = db2pg_trg_sys_id;
	}

	public int getExrt_dat_cnt() {
		return exrt_dat_cnt;
	}

	public void setExrt_dat_cnt(int exrt_dat_cnt) {
		this.exrt_dat_cnt = exrt_dat_cnt;
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

	public int getExrt_dat_ftch_sz() {
		return exrt_dat_ftch_sz;
	}

	public void setExrt_dat_ftch_sz(int exrt_dat_ftch_sz) {
		this.exrt_dat_ftch_sz = exrt_dat_ftch_sz;
	}

	public int getDat_ftch_bff_sz() {
		return dat_ftch_bff_sz;
	}

	public void setDat_ftch_bff_sz(int dat_ftch_bff_sz) {
		this.dat_ftch_bff_sz = dat_ftch_bff_sz;
	}

	public int getExrt_prl_prcs_ecnt() {
		return exrt_prl_prcs_ecnt;
	}

	public void setExrt_prl_prcs_ecnt(int exrt_prl_prcs_ecnt) {
		this.exrt_prl_prcs_ecnt = exrt_prl_prcs_ecnt;
	}

	public int getLob_dat_bff_sz() {
		return lob_dat_bff_sz;
	}

	public void setLob_dat_bff_sz(int lob_dat_bff_sz) {
		this.lob_dat_bff_sz = lob_dat_bff_sz;
	}

	public boolean getUsr_qry_use_tf() {
		return usr_qry_use_tf;
	}

	public void setUsr_qry_use_tf(boolean usr_qry_use_tf) {
		this.usr_qry_use_tf = usr_qry_use_tf;
	}

	public int getDb2pg_usr_qry_id() {
		return db2pg_usr_qry_id;
	}

	public void setDb2pg_usr_qry_id(int db2pg_usr_qry_id) {
		this.db2pg_usr_qry_id = db2pg_usr_qry_id;
	}

	public String getIns_opt_cd() {
		return ins_opt_cd;
	}

	public void setIns_opt_cd(String ins_opt_cd) {
		this.ins_opt_cd = ins_opt_cd;
	}

	public boolean getTb_rbl_tf() {
		return tb_rbl_tf;
	}

	public void setTb_rbl_tf(boolean tb_rbl_tf) {
		this.tb_rbl_tf = tb_rbl_tf;
	}

	public boolean getCnst_cnd_exrt_tf() {
		return cnst_cnd_exrt_tf;
	}

	public void setCnst_cnd_exrt_tf(boolean cnst_cnd_exrt_tf) {
		this.cnst_cnd_exrt_tf = cnst_cnd_exrt_tf;
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

	public String getSource_dbms_dscd() {
		return source_dbms_dscd;
	}

	public void setSource_dbms_dscd(String source_dbms_dscd) {
		this.source_dbms_dscd = source_dbms_dscd;
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

	public String getSource_scm_nm() {
		return source_scm_nm;
	}

	public void setSource_scm_nm(String source_scm_nm) {
		this.source_scm_nm = source_scm_nm;
	}

	public String getTarget_dbms_dscd() {
		return target_dbms_dscd;
	}

	public void setTarget_dbms_dscd(String target_dbms_dscd) {
		this.target_dbms_dscd = target_dbms_dscd;
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

	public String getTarget_scm_nm() {
		return target_scm_nm;
	}

	public void setTarget_scm_nm(String target_scm_nm) {
		this.target_scm_nm = target_scm_nm;
	}

	public int getWrk_id() {
		return wrk_id;
	}

	public void setWrk_id(int wrk_id) {
		this.wrk_id = wrk_id;
	}

	public String getTrans_save_pth() {
		return trans_save_pth;
	}

	public void setTrans_save_pth(String trans_save_pth) {
		this.trans_save_pth = trans_save_pth;
	}

	public String getSrc_cnd_qry() {
		return src_cnd_qry;
	}

	public void setSrc_cnd_qry(String src_cnd_qry) {
		this.src_cnd_qry = src_cnd_qry;
	}
	public String getDb2pg_uchr_lchr_val() {
		return db2pg_uchr_lchr_val;
	}

	public void setDb2pg_uchr_lchr_val(String db2pg_uchr_lchr_val) {
		this.db2pg_uchr_lchr_val = db2pg_uchr_lchr_val;
	}

}
