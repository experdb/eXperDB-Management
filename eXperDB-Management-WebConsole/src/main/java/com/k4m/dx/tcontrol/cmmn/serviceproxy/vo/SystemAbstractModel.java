package com.k4m.dx.tcontrol.cmmn.serviceproxy.vo;

import com.google.gson.annotations.Expose;

/**
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
public abstract class SystemAbstractModel extends AbstractLogModel {

	@Expose
	private String	serverLogDateTime;

	@Expose
	private String	siteLogDateTime;

	@Expose
	private String	monitoredAddress;

	@Expose
	private String	siteAccessAddress;

	@Expose
	private String	monitoredUid;

	@Expose
	private String	monitoredName;

	@Expose
	private String	resultLevel;

	@Expose
	private String	logMessage;

	@Expose
	private String	searchDateTimeFrom;

	@Expose
	private String	searchDateTimeTo;

	public String getServerLogDateTime() {
		return serverLogDateTime;
	}

	public void setServerLogDateTime(String serverLogDateTime) {
		this.serverLogDateTime = serverLogDateTime;
	}

	public String getSiteLogDateTime() {
		return siteLogDateTime;
	}

	public void setSiteLogDateTime(String siteLogDateTime) {
		this.siteLogDateTime = siteLogDateTime;
	}

	public String getMonitoredAddress() {
		return monitoredAddress;
	}

	public void setMonitoredAddress(String monitoredAddress) {
		this.monitoredAddress = monitoredAddress;
	}

	public String getMonitoredUid() {
		return monitoredUid;
	}

	public void setMonitoredUid(String monitoredUid) {
		this.monitoredUid = monitoredUid;
	}

	public String getMonitoredName() {
		return monitoredName;
	}

	public void setMonitoredName(String monitoredName) {
		this.monitoredName = monitoredName;
	}

	public String getResultLevel() {
		return resultLevel;
	}

	public void setResultLevel(String resultLevel) {
		this.resultLevel = resultLevel;
	}

	public String getLogMessage() {
		return logMessage;
	}

	public void setLogMessage(String logMessage) {
		this.logMessage = logMessage;
	}

	public String getSearchDateTimeFrom() {
		return searchDateTimeFrom;
	}

	public void setSearchDateTimeFrom(String searchDateTimeFrom) {
		this.searchDateTimeFrom = searchDateTimeFrom;
	}

	public String getSearchDateTimeTo() {
		return searchDateTimeTo;
	}

	public void setSearchDateTimeTo(String searchDateTimeTo) {
		this.searchDateTimeTo = searchDateTimeTo;
	}

	public String getSiteAccessAddress() {
		return siteAccessAddress;
	}

	public void setSiteAccessAddress(String siteAccessAddress) {
		this.siteAccessAddress = siteAccessAddress;
	}
}
