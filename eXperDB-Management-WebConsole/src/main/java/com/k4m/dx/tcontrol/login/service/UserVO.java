package com.k4m.dx.tcontrol.login.service;

import java.util.Date;

public class UserVO {
	
	private int idx; //idx
	private String usr_id;//사용자_ID
	private String usr_nm;//사용자_명
	private String pwd;//비밀번호
	private String bln_nm;//소속_명
	private String dept_nm;//부서_명
	private String rsp_bsn_nm;//담당_업무_명
	private String pst_nm;//직급_명
	private int aut_id;//권한_ID
	private String cpn;//휴대폰번호
	private String usr_expr_dt;//사용자_만료_일자
	private String use_yn;//사용_여부
	private String encp_use_yn;//암호화 사용유무
	private String frst_regr_id; //최초_등록자_ID
	private String frst_reg_dtm;//최초_등록_일시
	private String lst_mdfr_id;//최종_수정자_ID
	private String lst_mdf_dtm;//최종_수정_일시
	private String loginChkYn;//로그인 유지체크

	private int mnu_id;

	//로그인 이력
	private String lgi_crrno;//로그인_이력번호
	private String lgi_dtm;//로그인 일시
	private String lgi_ipadr;//아이피주소
	private String lgi_dtm_date;//로그인 일시(일자)
	private String lgi_dtm_hour;//로그인 일시(시간)
	private String log_out_dtm_date; //로그아웃 일시(일자)
	private String log_out_dtm_hour; //로그아웃 일시(시간)
	
	private String pwd_edc;//비밀번호
	private String salt_value; //salt 값

	private Date sessionDate;
	private String prmId;

	public String getSalt_value() {
		return salt_value;
	}
	public void setSalt_value(String salt_value) {
		this.salt_value = salt_value;
	}
	public String getPwd_edc() {
		return pwd_edc;
	}
	public void setPwd_edc(String pwd_edc) {
		this.pwd_edc = pwd_edc;
	}
	public Date getSessionDate() {
		return sessionDate;
	}
	public void setSessionDate(Date sessionDate) {
		this.sessionDate = sessionDate;
	}
	public String getPrmId() {
		return prmId;
	}
	public void setPrmId(String prmId) {
		this.prmId = prmId;
	}
	private int rownum; //rownum
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
	public String getUsr_id() {
		return usr_id;
	}
	public void setUsr_id(String usr_id) {
		this.usr_id = usr_id;
	}
	public String getUsr_nm() {
		return usr_nm;
	}
	public void setUsr_nm(String usr_nm) {
		this.usr_nm = usr_nm;
	}
	public String getPwd() {
		return pwd;
	}
	public void setPwd(String pwd) {
		this.pwd = pwd;
	}
	public String getBln_nm() {
		return bln_nm;
	}
	public void setBln_nm(String bln_nm) {
		this.bln_nm = bln_nm;
	}
	public String getDept_nm() {
		return dept_nm;
	}
	public void setDept_nm(String dept_nm) {
		this.dept_nm = dept_nm;
	}
	public String getRsp_bsn_nm() {
		return rsp_bsn_nm;
	}
	public void setRsp_bsn_nm(String rsp_bsn_nm) {
		this.rsp_bsn_nm = rsp_bsn_nm;
	}
	public String getPst_nm() {
		return pst_nm;
	}
	public void setPst_nm(String pst_nm) {
		this.pst_nm = pst_nm;
	}
	public int getAut_id() {
		return aut_id;
	}
	public void setAut_id(int aut_id) {
		this.aut_id = aut_id;
	}
	public String getCpn() {
		return cpn;
	}
	public void setCpn(String cpn) {
		this.cpn = cpn;
	}
	public String getUsr_expr_dt() {
		return usr_expr_dt;
	}
	public void setUsr_expr_dt(String usr_expr_dt) {
		this.usr_expr_dt = usr_expr_dt;
	}
	public String getUse_yn() {
		return use_yn;
	}
	public void setUse_yn(String use_yn) {
		this.use_yn = use_yn;
	}
	public String getEncp_use_yn() {
		return encp_use_yn;
	}
	public void setEncp_use_yn(String encp_use_yn) {
		this.encp_use_yn = encp_use_yn;
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
	public String getLgi_crrno() {
		return lgi_crrno;
	}
	public void setLgi_crrno(String lgi_crrno) {
		this.lgi_crrno = lgi_crrno;
	}
	public String getLgi_dtm() {
		return lgi_dtm;
	}
	public void setLgi_dtm(String lgi_dtm) {
		this.lgi_dtm = lgi_dtm;
	}
	public String getLgi_ipadr() {
		return lgi_ipadr;
	}
	public void setLgi_ipadr(String lgi_ipadr) {
		this.lgi_ipadr = lgi_ipadr;
	}
	public String getLgi_dtm_date() {
		return lgi_dtm_date;
	}
	public void setLgi_dtm_date(String lgi_dtm_date) {
		this.lgi_dtm_date = lgi_dtm_date;
	}
	public String getLgi_dtm_hour() {
		return lgi_dtm_hour;
	}
	public void setLgi_dtm_hour(String lgi_dtm_hour) {
		this.lgi_dtm_hour = lgi_dtm_hour;
	}
	public String getLog_out_dtm_date() {
		return log_out_dtm_date;
	}
	public void setLog_out_dtm_date(String log_out_dtm_date) {
		this.log_out_dtm_date = log_out_dtm_date;
	}
	public String getLog_out_dtm_hour() {
		return log_out_dtm_hour;
	}
	public void setLog_out_dtm_hour(String log_out_dtm_hour) {
		this.log_out_dtm_hour = log_out_dtm_hour;
	}
	
	public int getMnu_id() {
		return mnu_id;
	}
	public void setMnu_id(int mnu_id) {
		this.mnu_id = mnu_id;
	}
	public String getLoginChkYn() {
		return loginChkYn;
	}
	public void setLoginChkYn(String loginChkYn) {
		this.loginChkYn = loginChkYn;
	}

	
}
