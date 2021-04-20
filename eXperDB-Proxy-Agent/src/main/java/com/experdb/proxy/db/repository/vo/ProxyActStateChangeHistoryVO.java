package com.experdb.proxy.db.repository.vo;

import java.util.HashMap;
import java.util.Map;

import org.json.simple.JSONObject;

public class ProxyActStateChangeHistoryVO {
	private int pry_act_exe_sn;
	private int pry_svr_id;
	private String sys_type;
	private String act_type;
	private String act_exe_type;
	private String wrk_dtm;
	private String exe_rslt_cd;
	private String rslt_msg;
	private String frst_regr_id;
	private String frst_reg_dtm;
	private String lst_mdfr_id;
	private String lst_mdf_dtm;
	
	public int getPry_act_exe_sn() {
		return pry_act_exe_sn;
	}

	public void setPry_act_exe_sn(int pry_act_exe_sn) {
		this.pry_act_exe_sn = pry_act_exe_sn;
	}

	public int getPry_svr_id() {
		return pry_svr_id;
	}

	public void setPry_svr_id(int pry_svr_id) {
		this.pry_svr_id = pry_svr_id;
	}

	public String getSys_type() {
		return sys_type;
	}

	public void setSys_type(String sys_type) {
		this.sys_type = sys_type;
	}

	public String getAct_type() {
		return act_type;
	}

	public void setAct_type(String act_type) {
		this.act_type = act_type;
	}

	public String getAct_exe_type() {
		return act_exe_type;
	}

	public void setAct_exe_type(String act_exe_type) {
		this.act_exe_type = act_exe_type;
	}

	public String getWrk_dtm() {
		return wrk_dtm;
	}

	public void setWrk_dtm(String wrk_dtm) {
		this.wrk_dtm = wrk_dtm;
	}

	public String getExe_rslt_cd() {
		return exe_rslt_cd;
	}

	public void setExe_rslt_cd(String exe_rslt_cd) {
		this.exe_rslt_cd = exe_rslt_cd;
	}

	public String getRslt_msg() {
		return rslt_msg;
	}

	public void setRslt_msg(String rslt_msg) {
		this.rslt_msg = rslt_msg;
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
	
	public Map<String, Object> toMap(){
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pry_act_exe_sn", pry_act_exe_sn);
		map.put("pry_svr_id", pry_svr_id);
		map.put("sys_type", sys_type);
		map.put("act_type", act_type);
		map.put("act_exe_type", act_exe_type);
		map.put("wrk_dtm", wrk_dtm);
		map.put("act_exe_type", exe_rslt_cd);
		map.put("rslt_msg", rslt_msg);
		map.put("frst_regr_id", frst_regr_id);
		map.put("frst_reg_dtm", frst_reg_dtm);
		map.put("lst_mdfr_id", lst_mdfr_id);
		map.put("lst_mdf_dtm", lst_mdf_dtm);
		
		return map;
	}
	
	public JSONObject toJSONObject(){
		JSONObject jobj = new JSONObject();
		jobj.put("pry_act_exe_sn", pry_act_exe_sn);
		jobj.put("pry_svr_id", pry_svr_id);
		jobj.put("sys_type", sys_type);
		jobj.put("act_type", act_type);
		jobj.put("act_exe_type", act_exe_type);
		jobj.put("wrk_dtm", wrk_dtm);
		jobj.put("exe_rslt_cd", exe_rslt_cd);
		jobj.put("rslt_msg", rslt_msg);
		jobj.put("frst_regr_id", frst_regr_id);
		jobj.put("frst_reg_dtm", frst_reg_dtm);
		jobj.put("lst_mdfr_id", lst_mdfr_id);
		jobj.put("lst_mdf_dtm", lst_mdf_dtm);
		
		return jobj;
	}

}