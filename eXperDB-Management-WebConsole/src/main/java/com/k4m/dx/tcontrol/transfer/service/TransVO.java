package com.k4m.dx.tcontrol.transfer.service;

public class TransVO {

	private int rownum;
	private int idx;

	private int trans_id;
	private String kc_ip;
	private int kc_port;
	private String connect_nm;
	private String snapshot_mode;
	private String snapshot_nm;
	private int db_id;
	private String db_nm;
	private int db_svr_id;
	private String db_svr_nm;

	private String grp_cd;
	private String sys_cd;
	private String sys_cd_nm;
	private String frst_regr_id;
	private String frst_reg_dtm;
	private String lst_mdfr_id;
	private String lst_mdf_dtm;

	private String exe_status;

	private int trans_exrt_trg_tb_id;
	private int trans_exrt_exct_tb_id;
	
	private String compression_type;
	private String compression_nm;

	
	public String getCompression_type() {
		return compression_type;
	}

	public void setCompression_type(String compression_type) {
		this.compression_type = compression_type;
	}

	public String getCompression_nm() {
		return compression_nm;
	}

	public void setCompression_nm(String compression_nm) {
		this.compression_nm = compression_nm;
	}

	public int getTrans_id() {
		return trans_id;
	}

	public void setTrans_id(int trans_id) {
		this.trans_id = trans_id;
	}

	public String getKc_ip() {
		return kc_ip;
	}

	public void setKc_ip(String kc_ip) {
		this.kc_ip = kc_ip;
	}

	public int getKc_port() {
		return kc_port;
	}

	public void setKc_port(int kc_port) {
		this.kc_port = kc_port;
	}

	public String getConnect_nm() {
		return connect_nm;
	}

	public void setConnect_nm(String connect_nm) {
		this.connect_nm = connect_nm;
	}

	public String getSnapshot_mode() {
		return snapshot_mode;
	}

	public void setSnapshot_mode(String snapshot_mode) {
		this.snapshot_mode = snapshot_mode;
	}

	public String getSnapshot_nm() {
		return snapshot_nm;
	}

	public void setSnapshot_nm(String snapshot_nm) {
		this.snapshot_nm = snapshot_nm;
	}

	public int getDb_id() {
		return db_id;
	}

	public void setDb_id(int db_id) {
		this.db_id = db_id;
	}

	public String getDb_nm() {
		return db_nm;
	}

	public void setDb_nm(String db_nm) {
		this.db_nm = db_nm;
	}

	public int getDb_svr_id() {
		return db_svr_id;
	}

	public void setDb_svr_id(int db_svr_id) {
		this.db_svr_id = db_svr_id;
	}

	public String getDb_svr_nm() {
		return db_svr_nm;
	}

	public void setDb_svr_nm(String db_svr_nm) {
		this.db_svr_nm = db_svr_nm;
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

	public String getGrp_cd() {
		return grp_cd;
	}

	public void setGrp_cd(String grp_cd) {
		this.grp_cd = grp_cd;
	}

	public String getSys_cd() {
		return sys_cd;
	}

	public void setSys_cd(String sys_cd) {
		this.sys_cd = sys_cd;
	}

	public String getSys_cd_nm() {
		return sys_cd_nm;
	}

	public void setSys_cd_nm(String sys_cd_nm) {
		this.sys_cd_nm = sys_cd_nm;
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

	public int getTrans_exrt_trg_tb_id() {
		return trans_exrt_trg_tb_id;
	}

	public void setTrans_exrt_trg_tb_id(int trans_exrt_trg_tb_id) {
		this.trans_exrt_trg_tb_id = trans_exrt_trg_tb_id;
	}

	public int getTrans_exrt_exct_tb_id() {
		return trans_exrt_exct_tb_id;
	}

	public void setTrans_exrt_exct_tb_id(int trans_exrt_exct_tb_id) {
		this.trans_exrt_exct_tb_id = trans_exrt_exct_tb_id;
	}

	public String getExe_status() {
		return exe_status;
	}

	public void setExe_status(String exe_status) {
		this.exe_status = exe_status;
	}

}
