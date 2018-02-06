/**
 * <pre>
 * Copyright (c) 2015 K4M, Inc.
 * All right reserved.
 *
 * This software is the confidential and proprietary information of K4M, Inc. 
 * You shall not disclose such confidential information and
 * shall use it only in accordance with the terms of the license agreement
 * you entered into with K4M.
 * </pre>
 */
package com.k4m.dx.tcontrol.cmmn.serviceproxy.vo;

import com.google.gson.annotations.Expose;

/**
 * @brief
 * 
 *        TODO add description
 * @date 2015. 1. 23.
 * @author Kim, Sunho
 */

public class ProfileAclSpec extends AbstractManagedModel {

	@Expose
	private String	profileUid;

	@Expose
	private String	profileName;

	@Expose
	private int		specIndex;

	@Expose
	private long	aclSpecSequence;

	@Expose
	private int		specOrder;

	@Expose
	private String	specName;

	@Expose
	private String	serverInstanceId;

	@Expose
	private String	serverLoginId;

	@Expose
	private String	adminLoginId;

	@Expose
	private String	osLoginId;

	@Expose
	private String	applicationName;

	@Expose
	private String	extraName;

	@Expose
	private String	hostName;

	@Expose
	private String	accessAddress;

	@Expose
	private String	accessAddressMask;

	@Expose
	private String	accessMacAddress;

	@Expose
	private String	startDateTime;

	@Expose
	private String	endDateTime;

	@Expose
	private String	startTime;

	@Expose
	private String	endTime;

	@Expose
	private int		workDay;

	@Expose
	private int		massiveTimeInterval;

	@Expose
	private int		massiveThreshold;

	@Expose
	private String	whitelistYesNo;

	public String getProfileUid() {
		return profileUid;
	}

	public void setProfileUid(String profileUid) {
		this.profileUid = profileUid;
	}

	public String getProfileName() {
		return profileName;
	}

	public void setProfileName(String profileName) {
		this.profileName = profileName;
	}

	public int getSpecIndex() {
		return specIndex;
	}

	public void setSpecIndex(int specIndex) {
		this.specIndex = specIndex;
	}

	public long getAclSpecSequence() {
		return aclSpecSequence;
	}

	public void setAclSpecSequence(long aclSpecSequence) {
		this.aclSpecSequence = aclSpecSequence;
	}

	public int getSpecOrder() {
		return specOrder;
	}

	public void setSpecOrder(int specOrder) {
		this.specOrder = specOrder;
	}

	public String getSpecName() {
		return specName;
	}

	public void setSpecName(String specName) {
		this.specName = specName;
	}

	public String getServerInstanceId() {
		return serverInstanceId;
	}

	public void setServerInstanceId(String serverInstanceId) {
		this.serverInstanceId = serverInstanceId;
	}

	public String getServerLoginId() {
		return serverLoginId;
	}

	public void setServerLoginId(String serverLoginId) {
		this.serverLoginId = serverLoginId;
	}

	public String getAdminLoginId() {
		return adminLoginId;
	}

	public void setAdminLoginId(String adminLoginId) {
		this.adminLoginId = adminLoginId;
	}

	public String getOsLoginId() {
		return osLoginId;
	}

	public void setOsLoginId(String osLoginId) {
		this.osLoginId = osLoginId;
	}

	public String getApplicationName() {
		return applicationName;
	}

	public void setApplicationName(String applicationName) {
		this.applicationName = applicationName;
	}

	public String getAccessAddress() {
		return accessAddress;
	}

	public void setAccessAddress(String accessAddress) {
		this.accessAddress = accessAddress;
	}

	public String getAccessAddressMask() {
		return accessAddressMask;
	}

	public void setAccessAddressMask(String accessAddressMask) {
		this.accessAddressMask = accessAddressMask;
	}

	public String getStartDateTime() {
		return startDateTime;
	}

	public void setStartDateTime(String startDateTime) {
		this.startDateTime = startDateTime;
	}

	public String getEndDateTime() {
		return endDateTime;
	}

	public void setEndDateTime(String endDateTime) {
		this.endDateTime = endDateTime;
	}

	public String getStartTime() {
		return startTime;
	}

	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}

	public String getEndTime() {
		return endTime;
	}

	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

	public int getWorkDay() {
		return workDay;
	}

	public void setWorkDay(int workDay) {
		this.workDay = workDay;
	}

	public int getMassiveTimeInterval() {
		return massiveTimeInterval;
	}

	public void setMassiveTimeInterval(int massiveTimeInterval) {
		this.massiveTimeInterval = massiveTimeInterval;
	}

	public int getMassiveThreshold() {
		return massiveThreshold;
	}

	public void setMassiveThreshold(int massiveThreshold) {
		this.massiveThreshold = massiveThreshold;
	}

	public String getWhitelistYesNo() {
		return whitelistYesNo;
	}

	public void setWhitelistYesNo(String whitelistYesNo) {
		this.whitelistYesNo = whitelistYesNo;
	}

	public static ProfileAclSpec fromString(String jsonString) {
		return fromString(jsonString, ProfileAclSpec.class);
	}

	public String getAccessMacAddress() {
		return accessMacAddress;
	}

	public void setAccessMacAddress(String accessMacAddress) {
		this.accessMacAddress = accessMacAddress;
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
}
