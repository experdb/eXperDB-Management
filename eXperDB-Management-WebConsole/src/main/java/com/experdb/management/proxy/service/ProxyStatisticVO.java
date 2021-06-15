package com.experdb.management.proxy.service;

public class ProxyStatisticVO {
	
	private int pry_exe_status_sn;
	private String log_type;
	private int pry_svr_id;
	private String exe_dtm;
	private int cur_session;
	private int max_session;
	private int session_limit;
	private int cumt_sso_con_cnt;
	private int svr_pro_req_sel_cnt;
	private String lst_con_rec_aft_tm;
	private int byte_receive;
	private int byte_transmit;
	private String svr_status;
	private String lst_status_chk_desc;
	private int bakup_ser_cnt;
	private int fail_chk_cnt;
	private int svr_status_chg_cnt;
	private String svr_stop_tm;
	private String exe_rslt_cd;
	private String frst_regr_id;
	private String frst_reg_dtm;
	private String lst_mdfr_id;
	private String lst_mdf_dtm;
	private int lsn_id;
	private String db_con_addr;
	private int lsn_svr_id;
	
	public int getPry_exe_status_sn() {
		return pry_exe_status_sn;
	}
	public void setPry_exe_status_sn(int pry_exe_status_sn) {
		this.pry_exe_status_sn = pry_exe_status_sn;
	}
	
	public String getLog_type() {
		return log_type;
	}
	public void setLog_type(String log_type) {
		this.log_type = log_type;
	}
	
	public int getPry_svr_id() {
		return pry_svr_id;
	}
	public void setPry_svr_id(int pry_svr_id) {
		this.pry_svr_id = pry_svr_id;
	}
	
	public String getExe_dtm() {
		return exe_dtm;
	}
	public void setExe_dtm(String exe_dtm) {
		this.exe_dtm = exe_dtm;
	}
	
	public int getCur_session() {
		return cur_session;
	}
	public void setCur_session(int cur_session) {
		this.cur_session = cur_session;
	}
	
	public int getMax_session() {
		return max_session;
	}
	public void setMax_session(int max_session) {
		this.max_session = max_session;
	}
	
	public int getSession_limit() {
		return session_limit;
	}
	public void setSession_limit(int session_limit) {
		this.session_limit = session_limit;
	}
	
	public int getCumt_sso_con_cnt() {
		return cumt_sso_con_cnt;
	}
	public void setCumt_sso_con_cnt(int cumt_sso_con_cnt) {
		this.cumt_sso_con_cnt = cumt_sso_con_cnt;
	}
	
	public int getSvr_pro_req_sel_cnt() {
		return svr_pro_req_sel_cnt;
	}
	public void setSvr_pro_req_sel_cnt(int svr_pro_req_sel_cnt) {
		this.svr_pro_req_sel_cnt = svr_pro_req_sel_cnt;
	}
	
	public String getLst_con_rec_aft_tm() {
		return lst_con_rec_aft_tm;
	}
	public void setLst_con_rec_aft_tm(String lst_con_rec_aft_tm) {
		this.lst_con_rec_aft_tm = lst_con_rec_aft_tm;
	}
	
	public int getByte_receive() {
		return byte_receive;
	}
	public void setByte_receive(int byte_receive) {
		this.byte_receive = byte_receive;
	}
	
	public int getByte_transmit() {
		return byte_transmit;
	}
	public void setByte_transmit(int byte_transmit) {
		this.byte_transmit = byte_transmit;
	}
	
	public String getSvr_status() {
		return svr_status;
	}
	public void setSvr_status(String svr_status) {
		this.svr_status = svr_status;
	}
	
	public String getLst_status_chk_desc() {
		return lst_status_chk_desc;
	}
	public void setLst_status_chk_desc(String lst_status_chk_desc) {
		this.lst_status_chk_desc = lst_status_chk_desc;
	}
	
	public int getBakup_ser_cnt() {
		return bakup_ser_cnt;
	}
	public void setBakup_ser_cnt(int bakup_ser_cnt) {
		this.bakup_ser_cnt = bakup_ser_cnt;
	}
	
	public int getFail_chk_cnt() {
		return fail_chk_cnt;
	}
	public void setFail_chk_cnt(int fail_chk_cnt) {
		this.fail_chk_cnt = fail_chk_cnt;
	}
	
	public int getSvr_status_chg_cnt() {
		return svr_status_chg_cnt;
	}
	public void setSvr_status_chg_cnt(int svr_status_chg_cnt) {
		this.svr_status_chg_cnt = svr_status_chg_cnt;
	}
	
	public String getSvr_stop_tm() {
		return svr_stop_tm;
	}
	public void setSvr_stop_tm(String svr_stop_tm) {
		this.svr_stop_tm = svr_stop_tm;
	}
	
	public String getExe_rslt_cd() {
		return exe_rslt_cd;
	}
	public void setExe_rslt_cd(String exe_rslt_cd) {
		this.exe_rslt_cd = exe_rslt_cd;
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
	
	public int getLsn_id() {
		return lsn_id;
	}
	public void setLsn_id(int lsn_id) {
		this.lsn_id = lsn_id;
	}
	
	public String getDb_con_addr() {
		return db_con_addr;
	}
	public void setDb_con_addr(String db_con_addr) {
		this.db_con_addr = db_con_addr;
	}
	public int getLsn_svr_id() {
		return lsn_svr_id;
	}
	public void setLsn_svr_id(int lsn_svr_id) {
		this.lsn_svr_id = lsn_svr_id;
	}
}