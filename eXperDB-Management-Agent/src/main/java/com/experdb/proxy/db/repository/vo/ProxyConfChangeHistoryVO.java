package com.experdb.proxy.db.repository.vo;

import java.util.HashMap;
import java.util.Map;

import org.json.simple.JSONObject;

public class ProxyConfChangeHistoryVO {
	private int pry_svr_id;
	private int pry_chg_sn;
	private String pry_pth;
	private String kal_pth;
	private String exe_rst_cd;
	private String frst_regr_id;
	private String frst_reg_dtm;
	private String lst_mdfr_id;
	private String lst_mdf_dtm;
	
	public int getPry_svr_id() {
		return pry_svr_id;
	}
	public void setPry_svr_id(int pry_svr_id) {
		this.pry_svr_id = pry_svr_id;
	}
	public int getPry_chg_sn() {
		return pry_chg_sn;
	}
	public void setPry_chg_sn(int pry_chg_sn) {
		this.pry_chg_sn = pry_chg_sn;
	}
	public String getPry_pth() {
		return pry_pth;
	}
	public void setPry_pth(String pry_pth) {
		this.pry_pth = pry_pth;
	}
	public String getKal_pth() {
		return kal_pth;
	}
	public void setKal_pth(String kal_pth) {
		this.kal_pth = kal_pth;
	}
	public String getExe_rst_cd() {
		return exe_rst_cd;
	}
	public void setExe_rst_cd(String exe_rst_cd) {
		this.exe_rst_cd = exe_rst_cd;
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
		map.put("pry_svr_id", pry_svr_id);
		map.put("pry_chg_sn", pry_chg_sn);
		map.put("pry_pth", pry_pth);
		map.put("kal_pth", kal_pth);
		map.put("exe_rst_cd", exe_rst_cd);
		map.put("frst_regr_id", frst_regr_id);
		map.put("frst_reg_dtm", frst_reg_dtm);
		map.put("lst_mdfr_id", lst_mdfr_id);
		map.put("lst_mdf_dtm", lst_mdf_dtm);
		
		return map;
	}
	
	public JSONObject toJSONObject(){
		JSONObject jobj = new JSONObject();
		jobj.put("pry_svr_id", pry_svr_id);
		jobj.put("pry_chg_sn", pry_chg_sn);
		jobj.put("pry_pth", pry_pth);
		jobj.put("kal_pth", kal_pth);
		jobj.put("exe_rst_cd", exe_rst_cd);
		jobj.put("frst_regr_id", frst_regr_id);
		jobj.put("frst_reg_dtm", frst_reg_dtm);
		jobj.put("lst_mdfr_id", lst_mdfr_id);
		jobj.put("lst_mdf_dtm", lst_mdf_dtm);
		
		return jobj;
	}

}