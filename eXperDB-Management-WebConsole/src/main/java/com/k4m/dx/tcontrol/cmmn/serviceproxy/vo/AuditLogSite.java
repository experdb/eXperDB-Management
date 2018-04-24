package com.k4m.dx.tcontrol.cmmn.serviceproxy.vo;

import com.google.gson.annotations.Expose;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.SystemCode;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.TypeUtility;


/**
* AuditLogSite
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

public class AuditLogSite extends AbstractPageModel {
	
	@Expose
	private String	agentLogDateTime;

	@Expose
	private String	agentRemoteAddress;

	@Expose
	private String	agentUid;

	@Expose
	private String	agentName;

	@Expose
	private String	profileName;

	@Expose
	private String	osLoginId;

	@Expose
	private String	macAddr;

	@Expose
	private String	locationInfo;

	@Expose
	private String	moduleInfo;

	@Expose
	private String	serverLoginId;

	@Expose
	private String	instanceId;

	@Expose
	private String	adminLoginId;

	@Expose
	private String	applicationName;

	@Expose
	private String	extraName;

	@Expose
	private String	hostName;

	@Expose
	private String	siteAccessAddress;

	@Expose
	private int		weekday;

	@Expose
	private Boolean	encryptTrueFalse;

	@Expose
	private Boolean	successTrueFalse;

	@Expose
	private String	siteResultCode;

	@Expose
	private long	count;

	@Expose
	private String	denyReason;

	@Expose
	private String	searchAgentLogDateTimeFrom;

	@Expose
	private String	searchAgentLogDateTimeTo;

	@Expose
	private String	siteIntegrityResult;

	@Expose
	private String	serverIntegrityResult;

	@Expose
	private String	integrityValue;

	private String	agentLogDateTimeString;

	@Expose
	private String	searchFieldName;

	@Expose
	private String	searchFieldValueString;

	@Expose
	private String	searchOperator;

	@Override
	public String toString() {
		return this.getClass().getSimpleName();
	}

	public String getAgentLogDateTime() {
		return agentLogDateTime;
	}

	public String getAgentLogDateTimeFormatted() {
		return String.format("%s-%s-%s %s:%s:%s"
				, agentLogDateTime.substring(0, 4)
				, agentLogDateTime.substring(4, 6)
				, agentLogDateTime.substring(6, 8)
				, agentLogDateTime.substring(8, 10)
				, agentLogDateTime.substring(10, 12)
				, agentLogDateTime.substring(12)
				);
	}

	public void setAgentLogDateTime(String agentLogDateTime) {
		this.agentLogDateTime = agentLogDateTime;
	}

	public String getAgentLogDateTimeString() {
		if (TypeUtility.isEmpty(agentLogDateTimeString)) {
			return getAgentLogDateTime();
		}
		else {
			return agentLogDateTimeString;
		}

	}

	public void setAgentLogDateTimeString(String agentLogDateTimeString) {
		this.agentLogDateTimeString = agentLogDateTimeString;
	}

	public String getAgentRemoteAddress() {
		return agentRemoteAddress;
	}

	public void setAgentRemoteAddress(String agentRemoteAddress) {
		this.agentRemoteAddress = agentRemoteAddress;
	}

	public String getAgentUid() {
		return agentUid;
	}

	public void setAgentUid(String agentUid) {
		this.agentUid = agentUid;
	}

	public String getAgentName() {
		return agentName;
	}

	public void setAgentName(String agentName) {
		this.agentName = agentName;
	}

	public String getProfileName() {
		return profileName;
	}

	public void setProfileName(String profileName) {
		this.profileName = profileName;
	}

	public String getOsLoginId() {
		return osLoginId;
	}

	public void setOsLoginId(String osLoginId) {
		this.osLoginId = osLoginId;
	}

	public String getMacAddr() {
		return macAddr;
	}

	public void setMacAddr(String macAddr) {
		this.macAddr = macAddr;
	}

	public String getLocationInfo() {
		return locationInfo;
	}

	public void setLocationInfo(String locationInfo) {
		this.locationInfo = locationInfo;
	}

	public String getModuleInfo() {
		return moduleInfo;
	}

	public void setModuleInfo(String moduleInfo) {
		this.moduleInfo = moduleInfo;
	}

	public String getServerLoginId() {
		return serverLoginId;
	}

	public void setServerLoginId(String serverLoginId) {
		this.serverLoginId = serverLoginId;
	}

	public String getInstanceId() {
		return instanceId;
	}

	public void setInstanceId(String instanceId) {
		this.instanceId = instanceId;
	}

	public String getAdminLoginId() {
		return adminLoginId;
	}

	public void setAdminLoginId(String adminLoginId) {
		this.adminLoginId = adminLoginId;
	}

	public String getApplicationName() {
		return applicationName;
	}

	public void setApplicationName(String applicationName) {
		this.applicationName = applicationName;
	}

	public String getExtraName() {
		return extraName;
	}

	public void setExtraName(String extraName) {
		this.extraName = extraName;
	}

	public String getHostName() {
		return hostName;
	}

	public void setHostName(String hostName) {
		this.hostName = hostName;
	}

	public String getSiteAccessAddress() {
		return siteAccessAddress;
	}

	public void setSiteAccessAddress(String siteAccessAddress) {
		this.siteAccessAddress = siteAccessAddress;
	}

	public int getWeekday() {
		return weekday;
	}

	public void setWeekday(int weekday) {
		this.weekday = weekday;
	}

	public Boolean getEncryptTrueFalse() {
		return encryptTrueFalse;
	}

	public void setEncryptTrueFalse(Boolean encryptTrueFalse) {
		this.encryptTrueFalse = encryptTrueFalse;
	}

	public Boolean getSuccessTrueFalse() {
		return successTrueFalse;
	}

	public void setSuccessTrueFalse(Boolean successTrueFalse) {
		this.successTrueFalse = successTrueFalse;
	}

	public String getSiteResultCode() {
		return siteResultCode;
	}

	public void setSiteResultCode(String siteResultCode) {
		this.siteResultCode = siteResultCode;
	}

	public String getDenyReason() {
		return denyReason;
	}

	public void setDenyReason(String denyReason) {
		this.denyReason = denyReason;
	}

	public long getCount() {
		return count;
	}

	public void setCount(long count) {
		this.count = count;
	}

	public static AuditLogSite fromString(String jsonString) {
		return fromString(jsonString, AuditLogSite.class);
	}

	public String getSearchAgentLogDateTimeFrom() {
		return searchAgentLogDateTimeFrom;
	}

	public void setSearchAgentLogDateTimeFrom(String searchAgentLogDateTimeFrom) {
		this.searchAgentLogDateTimeFrom = searchAgentLogDateTimeFrom;
	}

	public String getSearchAgentLogDateTimeTo() {
		return searchAgentLogDateTimeTo;
	}

	public void setSearchAgentLogDateTimeTo(String searchAgentLogDateTimeTo) {
		this.searchAgentLogDateTimeTo = searchAgentLogDateTimeTo;
	}

	public String getIntegrityValue() {
		return integrityValue;
	}

	public void setIntegrityValue(String integrityValue) {
		this.integrityValue = integrityValue;
	}

	public String getIntegritySourceValue() {
		return getAgentLogDateTimeString() + getAgentRemoteAddress() + getAgentUid() + getProfileName() + getOsLoginId() + getServerLoginId()
				+ getInstanceId() + getAdminLoginId() + getApplicationName() + getExtraName() + getHostName() + String.valueOf(getWeekday())
				+ String.valueOf(getEncryptTrueFalse())
				+ String.valueOf(getSuccessTrueFalse()) + getSiteResultCode() + getSiteIntegrityResult();
	}

	public String calculateIntegrityValue() {
		return "";
	}

	private boolean isServerIntegrity() {
		if (TypeUtility.isEqual(getIntegrityValue(), calculateIntegrityValue())) {
			return true;
		}
		else {
			return false;
		}
	}

	public String getSiteIntegrityResult() {
		return siteIntegrityResult;
	}

	public void setSiteIntegrityResult(String siteIntegrityResult) {
		this.siteIntegrityResult = siteIntegrityResult;
	}

	public String getServerIntegrityResult() {

		if (!TypeUtility.isEmpty(getIntegrityValue())) {
			if (isServerIntegrity()) {
				return SystemCode.IntegrityResult.NORMAL;
			}
			else {
				return SystemCode.IntegrityResult.SERVER_INTEGRITY_ERROR;
			}
		} else {
			return serverIntegrityResult;
		}
	}

	public void setServerIntegrityResult(String serverIntegrityResult) {
		this.serverIntegrityResult = serverIntegrityResult;
	}



	public String getSearchFieldName() {
		return searchFieldName;
	}

	public void setSearchFieldName(String searchFieldName) {
		this.searchFieldName = searchFieldName;
	}

	public String getSearchFieldValueString() {
		return searchFieldValueString;
	}

	public void setSearchFieldValueString(String searchFieldValueString) {
		this.searchFieldValueString = searchFieldValueString;
	}

	public String getSearchOperator() {
		return searchOperator;
	}

	public void setSearchOperator(String searchOperator) {
		this.searchOperator = searchOperator;
	}
	
	
}
