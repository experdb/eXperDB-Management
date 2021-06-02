package com.experdb.management.proxy.service;

import java.util.HashMap;
import java.util.Map;

import org.json.simple.JSONObject;

public class ProxyVipConfigVO {
	private int vip_cng_id; 
	private String state_nm; 
	private int pry_svr_id; 
	private String v_ip; 
	private String v_rot_id; 
	private String v_if_nm; 
	private int priority; 
	private int chk_tm; 
	private String frst_regr_id; 
	private String frst_reg_dtm; 
	private String lst_mdfr_id; 
	private String lst_mdf_dtm;
	
	public int getVip_cng_id() {
		return vip_cng_id;
	}
	public void setVip_cng_id(int vip_cng_id) {
		this.vip_cng_id = vip_cng_id;
	}
	public String getState_nm() {
		return state_nm;
	}
	public void setState_nm(String state_nm) {
		this.state_nm = state_nm;
	}
	public int getPry_svr_id() {
		return pry_svr_id;
	}
	public void setPry_svr_id(int pry_svr_id) {
		this.pry_svr_id = pry_svr_id;
	}
	public String getV_ip() {
		return v_ip;
	}
	public void setV_ip(String v_ip) {
		this.v_ip = v_ip;
	}
	public String getV_rot_id() {
		return v_rot_id;
	}
	public void setV_rot_id(String v_rot_id) {
		this.v_rot_id = v_rot_id;
	}
	public String getV_if_nm() {
		return v_if_nm;
	}
	public void setV_if_nm(String v_if_nm) {
		this.v_if_nm = v_if_nm;
	}
	public int getPriority() {
		return priority;
	}
	public void setPriority(int priority) {
		this.priority = priority;
	}
	public int getChk_tm() {
		return chk_tm;
	}
	public void setChk_tm(int chk_tm) {
		this.chk_tm = chk_tm;
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
		map.put("vip_cng_id", vip_cng_id);
		map.put("state_nm", state_nm);
		map.put("pry_svr_id", pry_svr_id);
		map.put("v_ip", v_ip);
		map.put("v_rot_id", v_rot_id);
		map.put("v_if_nm", v_if_nm);
		map.put("priority", priority);
		map.put("chk_tm", chk_tm);
		map.put("frst_regr_id", frst_regr_id);
		map.put("frst_reg_dtm", frst_reg_dtm);
		map.put("lst_mdfr_id", lst_mdfr_id);
		map.put("lst_mdf_dtm", lst_mdf_dtm);
		
		return map;
	}
	
	public JSONObject toJSONObject(){
		JSONObject jobj = new JSONObject();
		jobj.put("vip_cng_id", vip_cng_id);
		jobj.put("state_nm", state_nm);
		jobj.put("pry_svr_id", pry_svr_id);
		jobj.put("v_ip", v_ip);
		jobj.put("v_rot_id", v_rot_id);
		jobj.put("v_if_nm", v_if_nm);
		jobj.put("priority", priority);
		jobj.put("chk_tm", chk_tm);
		jobj.put("frst_regr_id", frst_regr_id);
		jobj.put("frst_reg_dtm", frst_reg_dtm);
		jobj.put("lst_mdfr_id", lst_mdfr_id);
		jobj.put("lst_mdf_dtm", lst_mdf_dtm);
		
		return jobj;
	}
}
