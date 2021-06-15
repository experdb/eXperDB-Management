package com.experdb.management.backup.policy.service;

import java.io.Serializable;

public class VolumeVO implements Serializable {
	private static final long serialVersionUID = 2370122367264065584L;
	private String mountOn;
	private String fileSystem;
	private String type;
	private long size;
	private boolean isNecessary = false;

	public String getMountOn() {
		return mountOn;
	}

	public void setMountOn(String mountOn) {
		this.mountOn = mountOn;
	}

	public String getFileSystem() {
		return fileSystem;
	}

	public void setFileSystem(String fileSystem) {
		this.fileSystem = fileSystem;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public long getSize() {
		return size;
	}

	public void setSize(long size) {
		this.size = size;
	}

	public boolean isNecessary() {
		return isNecessary;
	}

	public void setNecessary(boolean isNecessary) {
		this.isNecessary = isNecessary;
	}
	
	@Override
	public String toString() {
		return "VolumeVO [mountOn=" + mountOn + ", fileSystem=" + fileSystem + ", type=" + type + ", size=" + size
				+ ", isNecessary=" + isNecessary + "]";
	}

}
