package com.experdb.proxy.util;

import java.util.Date;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

/**
* @author 박태혁
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2018.04.23   박태혁 최초 생성
*      </pre>
*/
public class FileEntryBean {
	private String sysToken;
	private MultipartFile file;
	
	private FileEntry fileEntry;
	
	private List<FileEntry> fileEntryList; 
	
	public FileEntryBean(){
		fileEntry = new FileEntry();
	}
	

	public MultipartFile getFile() {
		return file;
	}

	public void setFile(MultipartFile file) {
		this.file = file;
	}

	public String getSysToken() {
		return sysToken;
	}
	public void setSysToken(String sysToken) {
		this.sysToken = sysToken;
	}


	public String getFilePath() {
		return fileEntry.getFilePath();
	}


	public void setFilePath(String filePath) {
		fileEntry.setFilePath(filePath);
	}


	public String getFileName() {
		return fileEntry.getFileName();
	}


	public void setFileName(String fileName) {
		fileEntry.setFileName(fileName);
	}


	public long getFileSize() {
		return fileEntry.getFileSize();
	}


	public void setFileSize(long fileSize) {
		fileEntry.setFileSize(fileSize);
	}


	public long getFileSizeKb() {
		return fileEntry.getFileSizeKb();
	}


	public long getFileSizeMb() {
		return fileEntry.getFileSizeMb();
	}


	public long getLastModified() {
		return fileEntry.getLastModified();
	}


	public void setLastModified(long lastModified) {
		fileEntry.setLastModified(lastModified);
	}


	public Date getLastModifiedDate() {
		return fileEntry.getLastModifiedDate();
	}


	public List<FileEntry> getFileEntryList() {
		return fileEntryList;
	}


	public void setFileEntryList(List<FileEntry> fileEntryList) {
		this.fileEntryList = fileEntryList;
	}
}
