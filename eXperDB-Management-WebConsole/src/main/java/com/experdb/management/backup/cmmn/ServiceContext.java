package com.experdb.management.backup.cmmn;

import java.io.File;

public class ServiceContext {

	private static final ServiceContext instance = new ServiceContext();
	private String homePath = CmmnUtil.PATH_D2D_SERVER_HOME;
	private String tempFolder = this.homePath + File.separator + "tmp";

	public String getTempFolder() {
		return this.tempFolder;
	}

	public void setTempFolder(String tempFolder) {
		this.tempFolder = tempFolder;
	}

	public static ServiceContext getInstance() {
		return instance;
	}

	public static boolean checkWritePermission(String folder) {
		File file = new File(folder);
		return file.canWrite();
	}

	public String getHomePath() {
		return this.homePath;
	}

	public void setHomePath(String homePath) {
		this.homePath = homePath;
	}
}
