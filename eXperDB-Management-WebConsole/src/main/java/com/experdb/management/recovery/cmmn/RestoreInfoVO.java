package com.experdb.management.recovery.cmmn;

import java.util.List;

import com.experdb.management.backup.policy.service.VolumeVO;

public class RestoreInfoVO {
	private String jobName;
	private String machineId;
	private String storageLocation;
	private String storageType;
	private String sourceNode;
	private String recoveryPoint;
	private String encryptionPassword;
	private String restoreTarget;
	private String guestNetwork;
	private String guestIp;
	private String guestNetmask;
	private String guestGateway;
	private String guestDns;
	private String guestMac;
	private String guestSubnetmask;
	private List<VolumeVO> volumes;
	
	private String bmr;
	
	
	
	
	public String getStorageType() {
		return storageType;
	}

	public void setStorageType(String storageType) {
		this.storageType = storageType;
	}

	public String getBmr() {
		return bmr;
	}

	public void setBmr(String bmr) {
		this.bmr = bmr;
	}

	public String getMachineId() {
		return machineId;
	}

	public void setMachineId(String machineId) {
		this.machineId = machineId;
	}

	public String getGuestSubnetmask() {
		return guestSubnetmask;
	}

	public void setGuestSubnetmask(String guestSubnetmask) {
		this.guestSubnetmask = guestSubnetmask;
	}

	public String getGuestMac() {
		return guestMac;
	}

	public void setGuestMac(String guestMac) {
		this.guestMac = guestMac;
	}

	public List<VolumeVO> getVolumes() {
		return volumes;
	}

	public void setVolumes(List<VolumeVO> volumeList) {
		this.volumes = volumeList;
	}

	public String getJobName() {
		return jobName;
	}

	public void setJobName(String jobName) {
		this.jobName = jobName;
	}

	public String getStorageLocation() {
		return storageLocation;
	}

	public void setStorageLocation(String storageLocation) {
		this.storageLocation = storageLocation;
	}

	public String getSourceNode() {
		return sourceNode;
	}

	public void setSourceNode(String sourceNode) {
		this.sourceNode = sourceNode;
	}

	public String getRecoveryPoint() {
		return recoveryPoint;
	}

	public void setRecoveryPoint(String recoveryPoint) {
		this.recoveryPoint = recoveryPoint;
	}

	public String getEncryptionPassword() {
		return encryptionPassword;
	}

	public void setEncryptionPassword(String encryptionPassword) {
		this.encryptionPassword = encryptionPassword;
	}

	public String getRestoreTarget() {
		return restoreTarget;
	}

	public void setRestoreTarget(String restoreTarget) {
		this.restoreTarget = restoreTarget;
	}

	public String getGuestNetwork() {
		return guestNetwork;
	}

	public void setGuestNetwork(String guestNetwork) {
		this.guestNetwork = guestNetwork;
	}

	public String getGuestIp() {
		return guestIp;
	}

	public void setGuestIp(String guestIp) {
		this.guestIp = guestIp;
	}

	public String getGuestNetmask() {
		return guestNetmask;
	}

	public void setGuestNetmask(String guestNetmask) {
		this.guestNetmask = guestNetmask;
	}

	public String getGuestGateway() {
		return guestGateway;
	}

	public void setGuestGateway(String guestGateway) {
		this.guestGateway = guestGateway;
	}

	public String getGuestDns() {
		return guestDns;
	}

	public void setGuestDns(String guestDns) {
		this.guestDns = guestDns;
	}

	@Override
	public String toString() {
		return "RestoreInfoVO [jobName=" + jobName + ", machineId=" + machineId + ", storageLocation=" + storageLocation
				+ ", sourceNode=" + sourceNode + ", recoveryPoint=" + recoveryPoint + ", encryptionPassword="
				+ encryptionPassword + ", restoreTarget=" + restoreTarget + ", guestNetwork=" + guestNetwork
				+ ", guestIp=" + guestIp + ", guestNetmask=" + guestNetmask + ", guestGateway=" + guestGateway
				+ ", guestDns=" + guestDns + ", guestMac=" + guestMac + ", guestSubnetmask=" + guestSubnetmask
				+ ", volumes=" + volumes + ", bmr=" + bmr + "]";
	}

	
}
