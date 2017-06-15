package com.k4m.dx.tcontrol.common.service;

import java.io.Serializable;

public class CmmnCodeVO implements Serializable {

	private int rownum;
	private int idx;
	private String usr_id;
	private String grp_cd;	
	private String grp_cd_nm;
	private String grp_cd_exp;
	private String use_yn;
	private String sys_cd;
	private String sys_cd_nm;
	private String sys_use_yn;
	private String frst_regr_id;
	private String frst_reg_dtm;
	private String lst_mdfr_id;
	private String lst_mdf_dtm;

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

	public String getGrp_cd() {
		return grp_cd;
	}

	public void setGrp_cd(String grp_cd) {
		this.grp_cd = grp_cd;
	}

	public String getGrp_cd_nm() {
		return grp_cd_nm;
	}

	public void setGrp_cd_nm(String grp_cd_nm) {
		this.grp_cd_nm = grp_cd_nm;
	}

	public String getGrp_cd_exp() {
		return grp_cd_exp;
	}

	public void setGrp_cd_exp(String grp_cd_exp) {
		this.grp_cd_exp = grp_cd_exp;
	}

	public String getUse_yn() {
		return use_yn;
	}

	public void setUse_yn(String use_yn) {
		this.use_yn = use_yn;
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

	public String getSys_use_yn() {
		return sys_use_yn;
	}

	public void setSys_use_yn(String sys_use_yn) {
		this.sys_use_yn = sys_use_yn;
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
