package com.experdb.management.backup.service;

import java.io.Serializable;

public class BackupServerInfoVO implements Serializable {
	private static final long serialVersionUID = 2540068444589140096L;
	private CIDRNetworkVO cidrNetwork = new CIDRNetworkVO();
	private int enableDesignateBackupNetWork = 0;
	private int id;
	private boolean isLocal;
	private int port;
	private int serverType;

	// 원본 xml에 포함되어 있지 않음
	private String name;
	private String user;
	private String password;
	private Integer authType;
	private String description;
	private String authKey;
	private String uuid;
	private String protocol;

	public CIDRNetworkVO getCidrNetwork() {
		return cidrNetwork;
	}

	public void setCidrNetwork(CIDRNetworkVO cidrNetwork) {
		this.cidrNetwork = cidrNetwork;
	}

	public int getEnableDesignateBackupNetWork() {
		return enableDesignateBackupNetWork;
	}

	public void setEnableDesignateBackupNetWork(int enableDesignateBackupNetWork) {
		this.enableDesignateBackupNetWork = enableDesignateBackupNetWork;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public boolean isLocal() {
		return isLocal;
	}

	public void setLocal(boolean isLocal) {
		this.isLocal = isLocal;
	}

	public int getPort() {
		return port;
	}

	public void setPort(int port) {
		this.port = port;
	}

	public int getServerType() {
		return serverType;
	}

	public void setServerType(int serverType) {
		this.serverType = serverType;
	}

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

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public Integer getAuthType() {
		return authType;
	}

	public void setAuthType(Integer authType) {
		this.authType = authType;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getAuthKey() {
		return authKey;
	}

	public void setAuthKey(String authKey) {
		this.authKey = authKey;
	}

	public String getUuid() {
		return uuid;
	}

	public void setUuid(String uuid) {
		this.uuid = uuid;
	}

	public String getProtocol() {
		return protocol;
	}

	public void setProtocol(String protocol) {
		this.protocol = protocol;
	}

}
