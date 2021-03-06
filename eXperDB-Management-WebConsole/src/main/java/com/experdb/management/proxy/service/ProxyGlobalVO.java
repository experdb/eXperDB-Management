package com.experdb.management.proxy.service;

import java.util.HashMap;
import java.util.Map;

import org.json.simple.JSONObject;

public class ProxyGlobalVO {
	private int pry_glb_id; 
	private int pry_svr_id; 
	private int max_con_cnt; 
	private String cl_con_max_tm; 
	private String con_del_tm; 
	private String svr_con_max_tm; 
	private String chk_tm; 
	private String if_nm; 
	private String obj_ip; 
	private String peer_server_ip; 
	private String frst_regr_id; 
	private String frst_reg_dtm; 
	private String lst_mdfr_id; 
	private String lst_mdf_dtm;
	private String ipadr;
	
	public String getIpadr() {
		return ipadr;
	}
	public void setIpadr(String ipadr) {
		this.ipadr = ipadr;
	}
	public int getPry_glb_id() {
		return pry_glb_id;
	}
	public void setPry_glb_id(int pry_glb_id) {
		this.pry_glb_id = pry_glb_id;
	}
	public int getPry_svr_id() {
		return pry_svr_id;
	}
	public void setPry_svr_id(int pry_svr_id) {
		this.pry_svr_id = pry_svr_id;
	}
	public int getMax_con_cnt() {
		return max_con_cnt;
	}
	public void setMax_con_cnt(int max_con_cnt) {
		this.max_con_cnt = max_con_cnt;
	}
	public String getCl_con_max_tm() {
		return cl_con_max_tm;
	}
	public void setCl_con_max_tm(String cl_con_max_tm) {
		this.cl_con_max_tm = cl_con_max_tm;
	}
	public String getCon_del_tm() {
		return con_del_tm;
	}
	public void setCon_del_tm(String con_del_tm) {
		this.con_del_tm = con_del_tm;
	}
	public String getSvr_con_max_tm() {
		return svr_con_max_tm;
	}
	public void setSvr_con_max_tm(String svr_con_max_tm) {
		this.svr_con_max_tm = svr_con_max_tm;
	}
	public String getChk_tm() {
		return chk_tm;
	}
	public void setChk_tm(String chk_tm) {
		this.chk_tm = chk_tm;
	}
	public String getIf_nm() {
		return if_nm;
	}
	public void setIf_nm(String if_nm) {
		this.if_nm = if_nm;
	}
	public String getObj_ip() {
		return obj_ip;
	}
	public void setObj_ip(String obj_ip) {
		this.obj_ip = obj_ip;
	}
	public String getPeer_server_ip() {
		return peer_server_ip;
	}
	public void setPeer_server_ip(String peer_server_ip) {
		this.peer_server_ip = peer_server_ip;
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
		map.put("pry_glb_id", pry_glb_id);
		map.put("pry_svr_id", pry_svr_id);
		map.put("max_con_cnt", max_con_cnt);
		map.put("cl_con_max_tm", cl_con_max_tm);
		map.put("con_del_tm", con_del_tm);
		map.put("svr_con_max_tm", svr_con_max_tm);
		map.put("chk_tm", chk_tm);
		map.put("if_nm", if_nm);
		map.put("obj_ip", obj_ip);
		map.put("peer_server_ip", peer_server_ip);
		map.put("frst_regr_id", frst_regr_id);
		map.put("frst_reg_dtm", frst_reg_dtm);
		map.put("lst_mdfr_id", lst_mdfr_id);
		map.put("lst_mdf_dtm", lst_mdf_dtm);
		
		return map;
	}
	
	public JSONObject toJSONObject(){
		JSONObject jobj = new JSONObject();
		jobj.put("pry_glb_id", pry_glb_id);
		jobj.put("pry_svr_id", pry_svr_id);
		jobj.put("max_con_cnt", max_con_cnt);
		jobj.put("cl_con_max_tm", cl_con_max_tm);
		jobj.put("con_del_tm", con_del_tm);
		jobj.put("svr_con_max_tm", svr_con_max_tm);
		jobj.put("chk_tm", chk_tm);
		jobj.put("if_nm", if_nm);
		jobj.put("obj_ip", obj_ip);
		jobj.put("peer_server_ip", peer_server_ip);
		jobj.put("frst_regr_id", frst_regr_id);
		jobj.put("frst_reg_dtm", frst_reg_dtm);
		jobj.put("lst_mdfr_id", lst_mdfr_id);
		jobj.put("lst_mdf_dtm", lst_mdf_dtm);
		
		return jobj;
	}
}
