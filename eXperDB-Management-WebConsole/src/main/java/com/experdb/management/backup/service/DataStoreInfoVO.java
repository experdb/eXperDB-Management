package com.experdb.management.backup.service;

import java.io.Serializable;

public class DataStoreInfoVO implements Serializable {
	private static final long serialVersionUID = 726011023567240049L;
	private int compressLevel;
	private int enableDedup= 0;
	private String sharePath;
	private String sharePathPassword;
	private String sharePathUsername;

	// 원본 xml에 존재하지 않음
	private String uuid;
	private String name;

	public int getCompressLevel() {
		return compressLevel;
	}

	public void setCompressLevel(int compressLevel) {
		this.compressLevel = compressLevel;
	}

	public int getEnableDedup() {
		return enableDedup;
	}

	public void setEnableDedup(int enableDedup) {
		this.enableDedup = enableDedup;
	}

	public String getSharePath() {
		return sharePath;
	}

	public void setSharePath(String sharePath) {
		this.sharePath = sharePath;
	}

	public String getSharePathPassword() {
		return sharePathPassword;
	}

	public void setSharePathPassword(String sharePathPassword) {
		this.sharePathPassword = sharePathPassword;
	}

	public String getSharePathUsername() {
		return sharePathUsername;
	}

	public void setSharePathUsername(String sharePathUsername) {
		this.sharePathUsername = sharePathUsername;
	}

	public String getUuid() {
		return uuid;
	}

	public void setUuid(String uuid) {
		this.uuid = uuid;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

}
