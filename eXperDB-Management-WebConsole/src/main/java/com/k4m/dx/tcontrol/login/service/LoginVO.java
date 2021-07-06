package com.k4m.dx.tcontrol.login.service;

public class LoginVO {
	private String usr_id;
	private String usr_nm;
	private String ip;

	private String backup_use_yn;
	private String encp_use_yn;
	private String version;
	private String pg_audit;
	private String transfer;
	private int aut_id;

	private String restIp;
	private int restPort;
	private String tockenValue;
	private String ectityUid;
	private String loginChkTime;

	private String proxy_use_yn;
	private String proxy_menu_use_yn;

	public String getProxy_menu_use_yn() {
		return proxy_menu_use_yn;
	}

	public void setProxy_menu_use_yn(String proxy_menu_use_yn) {
		this.proxy_menu_use_yn = proxy_menu_use_yn;
	}

	public String getProxy_use_yn() {
		return proxy_use_yn;
	}

	public void setProxy_use_yn(String proxy_use_yn) {
		this.proxy_use_yn = proxy_use_yn;
	}

	public String getBackup_use_yn() {
		return backup_use_yn;
	}

	public void setBackup_use_yn(String backup_use_yn) {
		this.backup_use_yn = backup_use_yn;
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

	public String getIp() {
		return ip;
	}

	public void setIp(String ip) {
		this.ip = ip;
	}

	public String getEncp_use_yn() {
		return encp_use_yn;
	}

	public void setEncp_use_yn(String encp_use_yn) {
		this.encp_use_yn = encp_use_yn;
	}

	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}

	public String getPg_audit() {
		return pg_audit;
	}

	public void setPg_audit(String pg_audit) {
		this.pg_audit = pg_audit;
	}

	public int getAut_id() {
		return aut_id;
	}

	public void setAut_id(int aut_id) {
		this.aut_id = aut_id;
	}

	public String getTransfer() {
		return transfer;
	}

	public void setTransfer(String transfer) {
		this.transfer = transfer;
	}

	public String getRestIp() {
		return restIp;
	}

	public void setRestIp(String restIp) {
		this.restIp = restIp;
	}

	public int getRestPort() {
		return restPort;
	}

	public void setRestPort(int restPort) {
		this.restPort = restPort;
	}

	public String getTockenValue() {
		return tockenValue;
	}

	public void setTockenValue(String tockenValue) {
		this.tockenValue = tockenValue;
	}

	public String getEctityUid() {
		return ectityUid;
	}

	public void setEctityUid(String ectityUid) {
		this.ectityUid = ectityUid;
	}

	public String getLoginChkTime() {
		return loginChkTime;
	}

	public void setLoginChkTime(String loginChkTime) {
		this.loginChkTime = loginChkTime;
	}
}