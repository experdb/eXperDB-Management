package com.k4m.dx.tcontrol.audit.service;

public class AuditVO {
	
	private String log;
	private String log_level;
	private String log_relation;
	private String role;
	private String log_catalog;
	private String log_parameter;
	private String log_statement_once;
	public String getLog() {
		return log;
	}
	public void setLog(String log) {
		this.log = log;
	}
	public String getLog_level() {
		return log_level;
	}
	public void setLog_level(String log_level) {
		this.log_level = log_level;
	}
	public String getLog_relation() {
		return log_relation;
	}
	public void setLog_relation(String log_relation) {
		this.log_relation = log_relation;
	}
	public String getRole() {
		return role;
	}
	public void setRole(String role) {
		this.role = role;
	}
	public String getLog_catalog() {
		return log_catalog;
	}
	public void setLog_catalog(String log_catalog) {
		this.log_catalog = log_catalog;
	}
	public String getLog_parameter() {
		return log_parameter;
	}
	public void setLog_parameter(String log_parameter) {
		this.log_parameter = log_parameter;
	}
	public String getLog_statement_once() {
		return log_statement_once;
	}
	public void setLog_statement_once(String log_statement_once) {
		this.log_statement_once = log_statement_once;
	}
	
	

}
