package com.experdb.management.backup.service;

public class TargetMachineVO {

	private String name;
	private String user;
	private String UUID;
	private String password;
	private String description;
	private boolean isProtected = false;
	private String jobName;
	private String operatingSystem;
	private int connectionStatus;
	private int lastResult;
	private int recoveryPointCount;
	private int recoverySetCount;
	private int backupLocationType;
	private int machineType;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getUser() {
		return user;
	}

	public void setUser(String user) {
		this.user = user;
	}

	public String getUUID() {
		return UUID;
	}

	public void setUUID(String uUID) {
		UUID = uUID;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public boolean isProtected() {
		return isProtected;
	}

	public void setProtected(boolean isProtected) {
		this.isProtected = isProtected;
	}

	public String getJobName() {
		return jobName;
	}

	public void setJobName(String jobName) {
		this.jobName = jobName;
	}

	public String getOperatingSystem() {
		return operatingSystem;
	}

	public void setOperatingSystem(String operatingSystem) {
		this.operatingSystem = operatingSystem;
	}

	public int getConnectionStatus() {
		return connectionStatus;
	}

	public void setConnectionStatus(int connectionStatus) {
		this.connectionStatus = connectionStatus;
	}

	public int getLastResult() {
		return lastResult;
	}

	public void setLastResult(int lastResult) {
		this.lastResult = lastResult;
	}

	public int getRecoveryPointCount() {
		return recoveryPointCount;
	}

	public void setRecoveryPointCount(int recoveryPointCount) {
		this.recoveryPointCount = recoveryPointCount;
	}

	public int getRecoverySetCount() {
		return recoverySetCount;
	}

	public void setRecoverySetCount(int recoverySetCount) {
		this.recoverySetCount = recoverySetCount;
	}

	public int getBackupLocationType() {
		return backupLocationType;
	}

	public void setBackupLocationType(int backupLocationType) {
		this.backupLocationType = backupLocationType;
	}

	public int getMachineType() {
		return machineType;
	}

	public void setMachineType(int machineType) {
		this.machineType = machineType;
	}

}
