package com.k4m.dx.tcontrol.common.service;

public class HistoryVO {

private int wrk_sn; //작업_일련번호
private String usr_id; //사용자_ID
private String exe_dtl_cd; //실행_상세_코드
private String exedtm; //실행일시
private String lgi_ipadr;//로그인_IP주소
private String mnu_id;//메뉴_ID

//접근이력조회
private int rownum; //rownum
private int idx; //idx
private String exedtm_date;
private String exedtm_hour;
private String sys_cd_nm;
private String usr_nm;
private String dept_nm;
private String pst_nm;

public int getWrk_sn() {
	return wrk_sn;
}
public void setWrk_sn(int wrk_sn) {
	this.wrk_sn = wrk_sn;
}
public String getUsr_id() {
	return usr_id;
}
public void setUsr_id(String usr_id) {
	this.usr_id = usr_id;
}
public String getExe_dtl_cd() {
	return exe_dtl_cd;
}
public void setExe_dtl_cd(String exe_dtl_cd) {
	this.exe_dtl_cd = exe_dtl_cd;
}
public String getExedtm() {
	return exedtm;
}
public void setExedtm(String exedtm) {
	this.exedtm = exedtm;
}
public String getLgi_ipadr() {
	return lgi_ipadr;
}
public void setLgi_ipadr(String lgi_ipadr) {
	this.lgi_ipadr = lgi_ipadr;
}
public String getMnu_id() {
	return mnu_id;
}
public void setMnu_id(String mnu_id) {
	this.mnu_id = mnu_id;
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
public String getExedtm_date() {
	return exedtm_date;
}
public void setExedtm_date(String exedtm_date) {
	this.exedtm_date = exedtm_date;
}
public String getExedtm_hour() {
	return exedtm_hour;
}
public void setExedtm_hour(String exedtm_hour) {
	this.exedtm_hour = exedtm_hour;
}
public String getSys_cd_nm() {
	return sys_cd_nm;
}
public void setSys_cd_nm(String sys_cd_nm) {
	this.sys_cd_nm = sys_cd_nm;
}
public String getUsr_nm() {
	return usr_nm;
}
public void setUsr_nm(String usr_nm) {
	this.usr_nm = usr_nm;
}
public String getDept_nm() {
	return dept_nm;
}
public void setDept_nm(String dept_nm) {
	this.dept_nm = dept_nm;
}
public String getPst_nm() {
	return pst_nm;
}
public void setPst_nm(String pst_nm) {
	this.pst_nm = pst_nm;
}

}
