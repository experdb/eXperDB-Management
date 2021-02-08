package com.experdb.management.backup.service;

import java.io.Serializable;

public class CIDRNetworkVO implements Serializable {

	private static final long serialVersionUID = -8131790595980008075L;
	private String ipaddress;
	private String mask;

	public CIDRNetworkVO() {
	}

	public CIDRNetworkVO(String ipaddress, String mask) {
		this.ipaddress = ipaddress;
		this.mask = mask;
	}

	public String getIpaddress() {
		return ipaddress;
	}

	public void setIpaddress(String ipaddress) {
		this.ipaddress = ipaddress;
	}

	public String getMask() {
		return mask;
	}

	public void setMask(String mask) {
		this.mask = mask;
	}


}
