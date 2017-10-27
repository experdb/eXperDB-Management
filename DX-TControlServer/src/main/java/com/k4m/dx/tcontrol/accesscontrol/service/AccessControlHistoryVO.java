package com.k4m.dx.tcontrol.accesscontrol.service;

public class AccessControlHistoryVO {
	private int rownum;
	private int svr_acs_cntr_his_id; //서버_접근_제어_이력_ID
	private int svr_acs_cntr_id;//서버_접근_제어_ID
	private int db_svr_id;//DB_서버_ID
	private String dtb;//DATABASE
	private String prms_ipadr;//허용_IP주소
	private String prms_ipmaskadr;//허용_IPMASK주소
	private String prms_usr_id;//허용_사용자_ID
	private int prms_seq;//허용순번
	private String prms_set;//인증사용여부
	private String ctf_mth_nm;//인증_방법_명
	private String ctf_tp_nm;//인증_유형_명
	private String opt_nm;//옵션_명
	private String cmd_cnts;//명령어_내용
	private String lst_mdf_dtm;//최종_수정_일시
	private int his_grp_id;//이력_그룹_ID
	
	public int getRownum() {
		return rownum;
	}
	public void setRownum(int rownum) {
		this.rownum = rownum;
	}
	public int getSvr_acs_cntr_his_id() {
		return svr_acs_cntr_his_id;
	}
	public void setSvr_acs_cntr_his_id(int svr_acs_cntr_his_id) {
		this.svr_acs_cntr_his_id = svr_acs_cntr_his_id;
	}
	public int getSvr_acs_cntr_id() {
		return svr_acs_cntr_id;
	}
	public void setSvr_acs_cntr_id(int svr_acs_cntr_id) {
		this.svr_acs_cntr_id = svr_acs_cntr_id;
	}
	public int getDb_svr_id() {
		return db_svr_id;
	}
	public void setDb_svr_id(int db_svr_id) {
		this.db_svr_id = db_svr_id;
	}
	public String getDtb() {
		return dtb;
	}
	public void setDtb(String dtb) {
		this.dtb = dtb;
	}
	public String getPrms_ipadr() {
		return prms_ipadr;
	}
	public void setPrms_ipadr(String prms_ipadr) {
		this.prms_ipadr = prms_ipadr;
	}
	public String getPrms_ipmaskadr() {
		return prms_ipmaskadr;
	}
	public void setPrms_ipmaskadr(String prms_ipmaskadr) {
		this.prms_ipmaskadr = prms_ipmaskadr;
	}
	public String getPrms_usr_id() {
		return prms_usr_id;
	}
	public void setPrms_usr_id(String prms_usr_id) {
		this.prms_usr_id = prms_usr_id;
	}
	public int getPrms_seq() {
		return prms_seq;
	}
	public void setPrms_seq(int prms_seq) {
		this.prms_seq = prms_seq;
	}
	public String getPrms_set() {
		return prms_set;
	}
	public void setPrms_set(String prms_set) {
		this.prms_set = prms_set;
	}
	public String getCtf_mth_nm() {
		return ctf_mth_nm;
	}
	public void setCtf_mth_nm(String ctf_mth_nm) {
		this.ctf_mth_nm = ctf_mth_nm;
	}
	public String getCtf_tp_nm() {
		return ctf_tp_nm;
	}
	public void setCtf_tp_nm(String ctf_tp_nm) {
		this.ctf_tp_nm = ctf_tp_nm;
	}
	public String getOpt_nm() {
		return opt_nm;
	}
	public void setOpt_nm(String opt_nm) {
		this.opt_nm = opt_nm;
	}
	public String getCmd_cnts() {
		return cmd_cnts;
	}
	public void setCmd_cnts(String cmd_cnts) {
		this.cmd_cnts = cmd_cnts;
	}
	public String getLst_mdf_dtm() {
		return lst_mdf_dtm;
	}
	public void setLst_mdf_dtm(String lst_mdf_dtm) {
		this.lst_mdf_dtm = lst_mdf_dtm;
	}
	public int getHis_grp_id() {
		return his_grp_id;
	}
	public void setHis_grp_id(int his_grp_id) {
		this.his_grp_id = his_grp_id;
	}

	
	
	
}
