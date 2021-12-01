package com.k4m.dx.tcontrol.cmmn.serviceproxy.vo;

import com.google.gson.GsonBuilder;
import com.google.gson.annotations.Expose;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.SystemCode;

public class BackupFileHeader extends AbstractManagedModel{
	
	@Expose
	private int includedBits;
	
	@Expose
	private String backupDateTime;
	
	@Expose
	private String serverAddress;
	
	@Expose
	private String remoteAddress;
	
	@Expose
	private String fileUid;
	
	@Expose
	private String password;
	
	@Expose
	private String backupFilename;
	
	@Expose
	private String logDateTimeFrom;
	
	@Expose
	private String logDateTimeTo;
	
	@Expose
	private String backupType;
	
	/**
	 * 입력된 JSON 문자열을 객체로 변환한다. 서비스 메소드 호출 시 객체로 매개변수를 변환 할 때 사용된다.
	 * @param - JSON 문자열
	 * @return AuthCredentialToken - 변환된 객체
	 */
	public static AuthCredentialToken fromString(String jsonString) {
		return (new GsonBuilder().disableHtmlEscaping().create()).fromJson(jsonString, AuthCredentialToken.class);
	}
	
	public int getIncludedBits() {
		return includedBits;
	}

	public void setIncludedBits(int includedBits) {
		this.includedBits = includedBits;
	}

	public String getBackupDateTime() {
		return backupDateTime;
	}

	public void setBackupDateTime(String backupDateTime) {
		this.backupDateTime = backupDateTime;
	}

	public String getServerAddress() {
		return serverAddress;
	}

	public void setServerAddress(String serverAddress) {
		this.serverAddress = serverAddress;
	}

	public String getRemoteAddress() {
		return remoteAddress;
	}

	public void setRemoteAddress(String remoteAddress) {
		this.remoteAddress = remoteAddress;
	}

	public String getFileUid() {
		return fileUid;
	}

	public void setFileUid(String fileUid) {
		this.fileUid = fileUid;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getBackupFilename() {
		return backupFilename;
	}

	public void setBackupFilename(String backupFilename) {
		this.backupFilename = backupFilename;
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

	public String getBackupType() {
		return backupType;
	}

	public void setBackupType(String backupType) {
		this.backupType = backupType;
	}

	public boolean ContainsCryptoKey(){
		return ((includedBits & SystemCode.BitMask.BACKUP_INCLUDE_CRYPTO_KEY) == SystemCode.BitMask.BACKUP_INCLUDE_CRYPTO_KEY);
	}
	
	public boolean ContainsPolicy(){
		return ((includedBits & SystemCode.BitMask.BACKUP_INCLUDE_POLICY) == SystemCode.BitMask.BACKUP_INCLUDE_POLICY);
	}
	
	public boolean ContainsServer(){
		return ((includedBits & SystemCode.BitMask.BACKUP_INCLUDE_SERVER) == SystemCode.BitMask.BACKUP_INCLUDE_SERVER);
	}
	
	public boolean ContainsAdminUser(){
		return ((includedBits & SystemCode.BitMask.BACKUP_INCLUDE_ADMIN_USER) == SystemCode.BitMask.BACKUP_INCLUDE_ADMIN_USER);
	}
	
	public boolean ContainsConfig(){
		return ((includedBits & SystemCode.BitMask.BACKUP_INCLUDE_CONFIG) == SystemCode.BitMask.BACKUP_INCLUDE_CONFIG);
	}
	
	public boolean ContainsSiteLog(){
		return((includedBits & SystemCode.BitMask.BACKUP_INCLUDE_SITE_LOG) == SystemCode.BitMask.BACKUP_INCLUDE_SITE_LOG);
	}
	
	public boolean ContainsCoreLog(){
		return((includedBits & SystemCode.BitMask.BACKUP_INCLUDE_CORE_LOG) == SystemCode.BitMask.BACKUP_INCLUDE_CORE_LOG);
	}
	
	public boolean ContainsBackupLog(){
		return((includedBits & SystemCode.BitMask.BACKUP_INCLUDE_BACKUP_LOG) == SystemCode.BitMask.BACKUP_INCLUDE_BACKUP_LOG);
	}
	
	

}
