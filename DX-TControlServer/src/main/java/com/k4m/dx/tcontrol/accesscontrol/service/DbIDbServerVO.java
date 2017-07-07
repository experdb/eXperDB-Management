package com.k4m.dx.tcontrol.accesscontrol.service;

public class DbIDbServerVO {
	private int rownum;
	private int idx;
	private int db_id; //DB_ID
	private String db_nm;//DB_NM
	private String db_usr_id;//DB_USR_ID
	private int db_svr_id; //DB_서버_ID
	private String db_svr_nm; //DB_서버_명
	private String ipadr; //IP주소
	private int portno; //포트번호
	private String dft_db_nm; //디폴트_DB_명
	private String svr_spr_usr_id; //서버_슈퍼_사용자_ID
	private String svr_spr_scm_pwd; //서버_슈퍼_스키마_비밀번호
	
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
	public String getDb_usr_id() {
		return db_usr_id;
	}
	public void setDb_usr_id(String db_usr_id) {
		this.db_usr_id = db_usr_id;
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
	public String getIpadr() {
		return ipadr;
	}
	public void setIpadr(String ipadr) {
		this.ipadr = ipadr;
	}
	public int getPortno() {
		return portno;
	}
	public void setPortno(int portno) {
		this.portno = portno;
	}
	public String getDft_db_nm() {
		return dft_db_nm;
	}
	public void setDft_db_nm(String dft_db_nm) {
		this.dft_db_nm = dft_db_nm;
	}
	public String getSvr_spr_usr_id() {
		return svr_spr_usr_id;
	}
	public void setSvr_spr_usr_id(String svr_spr_usr_id) {
		this.svr_spr_usr_id = svr_spr_usr_id;
	}
	public String getSvr_spr_scm_pwd() {
		return svr_spr_scm_pwd;
	}
	public void setSvr_spr_scm_pwd(String svr_spr_scm_pwd) {
		this.svr_spr_scm_pwd = svr_spr_scm_pwd;
	}

	

	
    
}
