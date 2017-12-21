package com.k4m.dx.tcontrol.util;

import java.util.Date;

public class FileEntry {
	private String filePath; 
	private String fileName;
	private long fileSize;
	private long lastModified;
	
	public FileEntry(){}
	
	public FileEntry(String filePath){
		this.filePath = filePath;
	}
	
	public FileEntry(String filePath, String fileName, long fileSize, long lastModified){
		this.filePath = filePath;
		this.fileName = fileName;
		this.fileSize = fileSize;
		this.lastModified = lastModified;
	}

	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public long getFileSize() {
		return fileSize;
	}

	public void setFileSize(long fileSize) {
		this.fileSize = fileSize;
	}
	
	public long getFileSizeKb(){
		return fileSize/1024;
	}
	
	public long getFileSizeMb(){
		return fileSize/(1024*1024);
	}

	public long getLastModified() {
		return lastModified;
	}

	public void setLastModified(long lastModified) {
		this.lastModified = lastModified;
	}
	
	public Date getLastModifiedDate(){
		return new Date(lastModified);
	}
}
