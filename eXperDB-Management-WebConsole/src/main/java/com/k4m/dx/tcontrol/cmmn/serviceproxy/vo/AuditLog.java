package com.k4m.dx.tcontrol.cmmn.serviceproxy.vo;

import com.google.gson.annotations.Expose;

/**
 * 
 *
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
public class AuditLog extends AbstractPageModel {

	@Expose
	private String	logDateTime;

	@Expose
	private String	remoteAddress;

	@Expose
	private String	requestUid;

	@Expose
	private String	requestPath;

	@Expose
	private String	auditTypeCode;

	@Expose
	private String	entityUid;

	@Expose
	private String	entityName;

	@Expose
	private String	entityTypeCode;

	@Expose
	private String	auditTypeName;

	@Expose
	private String	entityTypeName;

	@Expose
	private String	header;

	@Expose
	private String	parameter;

	@Expose
	private String	resourceUid;

	@Expose
	private String	profileUid;

	@Expose
	private String	resultCode;

	@Expose
	private String	resultMessage;

	@Expose
	private String	searchLogDateTimeFrom;

	@Expose
	private String	searchLogDateTimeTo;

	@Expose
	private boolean	keyAccessOnly;

	public String getLogDateTime() {
		return logDateTime;
	}

	public void setLogDateTime(String logDateTime) {
		this.logDateTime = logDateTime;
	}

	public String getRemoteAddress() {
		return remoteAddress;
	}

	public void setRemoteAddress(String remoteAddress) {
		this.remoteAddress = remoteAddress;
	}

	public String getRequestUid() {
		return requestUid;
	}

	public void setRequestUid(String requestUid) {
		this.requestUid = requestUid;
	}

	public String getRequestPath() {
		return requestPath;
	}

	public void setRequestPath(String requestPath) {
		this.requestPath = requestPath;
	}

	public String getAuditTypeCode() {
		return auditTypeCode;
	}

	public void setAuditTypeCode(String auditTypeCode) {
		this.auditTypeCode = auditTypeCode;
	}

	public String getEntityUid() {
		return entityUid;
	}

	public void setEntityUid(String entityUid) {
		this.entityUid = entityUid;
	}

	public String getEntityName() {
		return entityName;
	}

	public void setEntityName(String entityName) {
		this.entityName = entityName;
	}

	public String getEntityTypeCode() {
		return entityTypeCode;
	}

	public void setEntityTypeCode(String entityTypeCode) {
		this.entityTypeCode = entityTypeCode;
	}

	public String getAuditTypeName() {
		return auditTypeName;
	}

	public void setAuditTypeName(String auditTypeName) {
		this.auditTypeName = auditTypeName;
	}

	public String getEntityTypeName() {
		return entityTypeName;
	}

	public void setEntityTypeName(String entityTypeName) {
		this.entityTypeName = entityTypeName;
	}

	public String getHeader() {
		return header;
	}

	public void setHeader(String header) {
		this.header = header;
	}

	public String getParameter() {
		return parameter;
	}

	public void setParameter(String parameter) {
		this.parameter = parameter;
	}

	public String getResourceUid() {
		return resourceUid;
	}

	public void setResourceUid(String resourceUid) {
		this.resourceUid = resourceUid;
	}

	public String getProfileUid() {
		return profileUid;
	}

	public void setProfileUid(String profileUid) {
		this.profileUid = profileUid;
	}

	public String getResultCode() {
		return resultCode;
	}

	public void setResultCode(String resultCode) {
		this.resultCode = resultCode;
	}

	public String getResultMessage() {
		return resultMessage;
	}

	public void setResultMessage(String resultMessage) {
		this.resultMessage = resultMessage;
	}

	public static AuditLog fromString(String jsonString) {
		return fromString(jsonString, AuditLog.class);
	}

	public String getSearchLogDateTimeFrom() {
		return searchLogDateTimeFrom;
	}

	public void setSearchLogDateTimeFrom(String searchLogDateTimeFrom) {
		this.searchLogDateTimeFrom = searchLogDateTimeFrom;
	}

	public String getSearchLogDateTimeTo() {
		return searchLogDateTimeTo;
	}

	public void setSearchLogDateTimeTo(String searchLogDateTimeTo) {
		this.searchLogDateTimeTo = searchLogDateTimeTo;
	}

	public boolean isKeyAccessOnly() {
		return keyAccessOnly;
	}

	public void setKeyAccessOnly(boolean keyAccessOnly) {
		this.keyAccessOnly = keyAccessOnly;
	}

}
