package com.k4m.dx.tcontrol.server;

/**
 * 락 파일이 이미 존재할 때 발생하는 예외
* @author 박태혁
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2018.04.23   박태혁 최초 생성
*      </pre>
*/

public class AuditVO {


	private String auditLog;
	private String auditLevel;
	private String auditCatalog;
	private String auditParameter;
	private String auditRelation;
	private String auditStatementOnce;
	private String auditRole;
	public String getAuditLog() {
		return auditLog;
	}
	public void setAuditLog(String auditLog) {
		this.auditLog = auditLog;
	}
	public String getAuditLevel() {
		return auditLevel;
	}
	public void setAuditLevel(String auditLevel) {
		this.auditLevel = auditLevel;
	}
	public String getAuditCatalog() {
		return auditCatalog;
	}
	public void setAuditCatalog(String auditCatalog) {
		this.auditCatalog = auditCatalog;
	}
	public String getAuditParameter() {
		return auditParameter;
	}
	public void setAuditParameter(String auditParameter) {
		this.auditParameter = auditParameter;
	}
	public String getAuditRelation() {
		return auditRelation;
	}
	public void setAuditRelation(String auditRelation) {
		this.auditRelation = auditRelation;
	}
	public String getAuditStatementOnce() {
		return auditStatementOnce;
	}
	public void setAuditStatementOnce(String auditStatementOnce) {
		this.auditStatementOnce = auditStatementOnce;
	}
	public String getAuditRole() {
		return auditRole;
	}
	public void setAuditRole(String auditRole) {
		this.auditRole = auditRole;
	}
	
	
	
	
}
