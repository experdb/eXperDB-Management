package com.experdb.management.backup.service;

public class ServerInfoVO {

	private String userId;
	private String dbSvrId;
	private String ipadr;
	private String masterGbn;
	private String hostName;
	private String portno;
	private String db_cndt;
	
	@Override
	public String toString() {
		return "ServerInfoVO [userId=" + userId + ", dbSvrId=" + dbSvrId + ", ipadr=" + ipadr + ", masterGbn="
				+ masterGbn + ", hostName=" + hostName + ", portno=" + portno + ", db_cndt=" + db_cndt + "]";
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getDbSvrId() {
		return dbSvrId;
	}
	public void setDbSvrId(String dbSvrId) {
		this.dbSvrId = dbSvrId;
	}
	public String getIpadr() {
		return ipadr;
	}
	public void setIpadr(String ipadr) {
		this.ipadr = ipadr;
	}
	public String getMasterGbn() {
		return masterGbn;
	}
	public void setMasterGbn(String masterGbn) {
		this.masterGbn = masterGbn;
	}
	public String getHostName() {
		return hostName;
	}
	public void setHostName(String hostName) {
		this.hostName = hostName;
	}
	public String getPortno() {
		return portno;
	}
	public void setPortno(String portno) {
		this.portno = portno;
	}
	public String getDb_cndt() {
		return db_cndt;
	}
	public void setDb_cndt(String db_cndt) {
		this.db_cndt = db_cndt;
	}
	
	

}
