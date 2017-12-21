package com.k4m.dx.tcontrol.db.repository.vo;

public class PgAuditVO {
	private String session_id;
	private String session_line_num;
	private String log_time;
	private String user_name;
	private String statement_id;
	private String audit_state;
	private String error_session_line_num;
	private String substatement_id;
	private String substatement;
	private String audit_type;
	private String audit_class;
	private String audit_command;
	private String object_type;
	private String object_name;
	private String start_date;
	private String end_date;
	
	
	
	public String getStart_date() {
		return start_date;
	}
	public void setStart_date(String start_date) {
		this.start_date = start_date;
	}
	public String getEnd_date() {
		return end_date;
	}
	public void setEnd_date(String end_date) {
		this.end_date = end_date;
	}
	public String getSession_id() {
		return session_id;
	}
	public void setSession_id(String session_id) {
		this.session_id = session_id;
	}
	public String getSession_line_num() {
		return session_line_num;
	}
	public void setSession_line_num(String session_line_num) {
		this.session_line_num = session_line_num;
	}
	public String getLog_time() {
		return log_time;
	}
	public void setLog_time(String log_time) {
		this.log_time = log_time;
	}
	public String getUser_name() {
		return user_name;
	}
	public void setUser_name(String user_name) {
		this.user_name = user_name;
	}
	public String getStatement_id() {
		return statement_id;
	}
	public void setStatement_id(String statement_id) {
		this.statement_id = statement_id;
	}
	public String getAudit_state() {
		return audit_state;
	}
	public void setAudit_state(String audit_state) {
		this.audit_state = audit_state;
	}
	public String getError_session_line_num() {
		return error_session_line_num;
	}
	public void setError_session_line_num(String error_session_line_num) {
		this.error_session_line_num = error_session_line_num;
	}
	public String getSubstatement_id() {
		return substatement_id;
	}
	public void setSubstatement_id(String substatement_id) {
		this.substatement_id = substatement_id;
	}
	public String getSubstatement() {
		return substatement;
	}
	public void setSubstatement(String substatement) {
		this.substatement = substatement;
	}
	public String getAudit_type() {
		return audit_type;
	}
	public void setAudit_type(String audit_type) {
		this.audit_type = audit_type;
	}
	public String getAudit_class() {
		return audit_class;
	}
	public void setAudit_class(String audit_class) {
		this.audit_class = audit_class;
	}
	public String getAudit_command() {
		return audit_command;
	}
	public void setAudit_command(String audit_command) {
		this.audit_command = audit_command;
	}
	public String getObject_type() {
		return object_type;
	}
	public void setObject_type(String object_type) {
		this.object_type = object_type;
	}
	public String getObject_name() {
		return object_name;
	}
	public void setObject_name(String object_name) {
		this.object_name = object_name;
	}
	
	
}
