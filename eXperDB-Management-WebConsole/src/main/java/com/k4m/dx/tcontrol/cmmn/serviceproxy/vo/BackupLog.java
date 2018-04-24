package com.k4m.dx.tcontrol.cmmn.serviceproxy.vo;

import com.google.gson.annotations.Expose;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.SystemCode;

/**
* BackupLog
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
public class BackupLog extends AbstractPageModel {

	@Expose
	private String			logDateTime;

	@Expose
	private String			entityUid;

	@Expose
	private String			entityName;

	@Expose
	private String			remoteAddress;

	@Expose
	private String			serverAddress;

	@Expose
	private int				included;

	@Expose
	private boolean			containsCryptoKey;

	@Expose
	private boolean			containsPolicy;

	@Expose
	private boolean			containsServer;

	@Expose
	private boolean			containsAdminUser;

	@Expose
	private boolean			containsConfig;

	@Expose
	private boolean			containsSiteLog;

	@Expose
	private boolean			containsCoreLog;

	@Expose
	private boolean			containsBackupLog;

	@Expose
	private boolean			containsSystemStatusLog;

	@Expose
	private boolean			containsSystemUsageLog;

	@Expose
	private boolean			containsTableCryptLog;

	public static final int	cryptoKeyBitMask		= SystemCode.BitMask.BACKUP_INCLUDE_CRYPTO_KEY;

	public static final int	policyBitMask			= SystemCode.BitMask.BACKUP_INCLUDE_POLICY;

	public static final int	serverBitMask			= SystemCode.BitMask.BACKUP_INCLUDE_SERVER;

	public static final int	adminUserBitMask		= SystemCode.BitMask.BACKUP_INCLUDE_ADMIN_USER;

	public static final int	configBitMask			= SystemCode.BitMask.BACKUP_INCLUDE_CONFIG;

	public static final int	siteLogBitMask			= SystemCode.BitMask.BACKUP_INCLUDE_SITE_LOG;

	public static final int	coreLogBitMask			= SystemCode.BitMask.BACKUP_INCLUDE_CORE_LOG;

	public static final int	backupLogBitMask		= SystemCode.BitMask.BACKUP_INCLUDE_BACKUP_LOG;

	public static final int	systemUsageLogBitMask	= SystemCode.BitMask.BACKUP_INCLUDE_MONITOR_SYSTEM_USAGE_LOG;

	public static final int	systemStatusLogBitMask	= SystemCode.BitMask.BACKUP_INCLUDE_MONITOR_SYSTEM_USAGE_LOG;

	public static final int	tableCryptLogBitMask	= SystemCode.BitMask.BACKUP_INCLUDE_TABLE_CRYPT_LOG;

	@Expose
	private String			requestPath;

	@Expose
	private String			requestUid;

	@Expose
	private String			backupWorkType;

	@Expose
	private String			fileUid;

	@Expose
	private String			fileHeader;

	@Expose
	private String			filePath;

	@Expose
	private String			logDateTimeFrom;

	@Expose
	private String			logDateTimeTo;

	@Expose
	private String			searchLogDateTimeFrom;

	@Expose
	private String			searchLogDateTimeTo;

	@Expose
	private String			backupType;

	public String getLogDateTime() {
		return logDateTime;
	}

	public void setLogDateTime(String logDateTime) {
		this.logDateTime = logDateTime;
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

	public String getRemoteAddress() {
		return remoteAddress;
	}

	public void setRemoteAddress(String remoteAddress) {
		this.remoteAddress = remoteAddress;
	}

	public String getServerAddress() {
		return serverAddress;
	}

	public void setServerAddress(String serverAddress) {
		this.serverAddress = serverAddress;
	}

	public int getIncluded() {
		return included;
	}

	public void setIncluded(int included) {
		this.included = included;
	}

	public boolean containsCryptoKey() {
		return ((SystemCode.BitMask.BACKUP_INCLUDE_CRYPTO_KEY & getIncluded()) == SystemCode.BitMask.BACKUP_INCLUDE_CRYPTO_KEY);
	}

	public boolean containsPolicy() {
		return ((SystemCode.BitMask.BACKUP_INCLUDE_POLICY & getIncluded()) == SystemCode.BitMask.BACKUP_INCLUDE_POLICY);
	}

	public boolean containsServer() {
		return ((SystemCode.BitMask.BACKUP_INCLUDE_SERVER & getIncluded()) == SystemCode.BitMask.BACKUP_INCLUDE_SERVER);
	}

	public boolean containsAdminUser() {
		return ((SystemCode.BitMask.BACKUP_INCLUDE_ADMIN_USER & getIncluded()) == SystemCode.BitMask.BACKUP_INCLUDE_ADMIN_USER);
	}

	public boolean containsConfig() {
		return ((SystemCode.BitMask.BACKUP_INCLUDE_CONFIG & getIncluded()) == SystemCode.BitMask.BACKUP_INCLUDE_CONFIG);
	}

	public boolean containsSiteLog() {
		return ((SystemCode.BitMask.BACKUP_INCLUDE_SITE_LOG & getIncluded()) == SystemCode.BitMask.BACKUP_INCLUDE_SITE_LOG);
	}

	public boolean containsCoreLog() {
		return ((SystemCode.BitMask.BACKUP_INCLUDE_CORE_LOG & getIncluded()) == SystemCode.BitMask.BACKUP_INCLUDE_CORE_LOG);
	}

	public boolean containsBackupLog() {
		return ((SystemCode.BitMask.BACKUP_INCLUDE_BACKUP_LOG & getIncluded()) == SystemCode.BitMask.BACKUP_INCLUDE_BACKUP_LOG);
	}

	public boolean containsSystemUsageLog() {
		return ((SystemCode.BitMask.BACKUP_INCLUDE_MONITOR_SYSTEM_USAGE_LOG & getIncluded()) == SystemCode.BitMask.BACKUP_INCLUDE_MONITOR_SYSTEM_USAGE_LOG);
	}

	public boolean containsSystemStatusLog() {
		return ((SystemCode.BitMask.BACKUP_INCLUDE_MONITOR_SYSTEM_STATUS_LOG & getIncluded()) == SystemCode.BitMask.BACKUP_INCLUDE_MONITOR_SYSTEM_STATUS_LOG);
	}

	public boolean containsTableCryptLog() {
		return ((SystemCode.BitMask.BACKUP_INCLUDE_TABLE_CRYPT_LOG & getIncluded()) == SystemCode.BitMask.BACKUP_INCLUDE_TABLE_CRYPT_LOG);
	}

	public String getRequestPath() {
		return requestPath;
	}

	public void setRequestPath(String requestPath) {
		this.requestPath = requestPath;
	}

	public String getRequestUid() {
		return requestUid;
	}

	public void setRequestUid(String requestUid) {
		this.requestUid = requestUid;
	}

	public String getBackupWorkType() {
		return backupWorkType;
	}

	public void setBackupWorkType(String backupWorkType) {
		this.backupWorkType = backupWorkType;
	}

	public String getFileUid() {
		return fileUid;
	}

	public void setFileUid(String fileUid) {
		this.fileUid = fileUid;
	}

	public String getFileHeader() {
		return fileHeader;
	}

	public void setFileHeader(String fileHeader) {
		this.fileHeader = fileHeader;
	}

	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	public String getLogDateTimeFrom() {
		return logDateTimeFrom;
	}

	public void setLogDateTimeFrom(String logDateTimeFrom) {
		this.logDateTimeFrom = logDateTimeFrom;
	}

	public String getLogDateTimeTo() {
		return logDateTimeTo;
	}

	public void setLogDateTimeTo(String logDateTimeTo) {
		this.logDateTimeTo = logDateTimeTo;
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

	public String getBackupType() {
		return backupType;
	}

	public void setBackupType(String backupType) {
		this.backupType = backupType;
	}

	public static BackupLog fromString(String jsonString) {
		return fromString(jsonString, BackupLog.class);
	}

}
