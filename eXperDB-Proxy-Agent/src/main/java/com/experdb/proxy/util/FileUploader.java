package com.experdb.proxy.util;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

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
public class FileUploader {
	
	private Logger logger = LoggerFactory.getLogger(FileUploader.class);
	
	protected static String BACKUP_FILE_POST_FIX = ".backup";
	
	private String saveFilePath;
	private String backupFilePath;
	
	public FileUploader(String absoluteFilePath){
		this.saveFilePath = absoluteFilePath;
	}
	
	public FileUploader(String rootDirPath, String relativeFilePath) {
		this.saveFilePath = rootDirPath + relativeFilePath;	
	}
	
	public boolean upload(InputStream input){
		File targetFile = new File(saveFilePath);
		File parentFile = targetFile.getParentFile();
		if( parentFile.exists()){
			if( targetFile.exists()){
				backupFilePath = targetFile.getAbsolutePath()+BACKUP_FILE_POST_FIX;
				if ( !targetFile.renameTo(new File(backupFilePath)) ){
					return false;
				}
			}
		}
		else {
			if( !parentFile.mkdirs() ){
				return false;
			}
		}
		
		boolean isSuccess = false;
		try{
			isSuccess = uploadFile(saveFilePath, input);
		}
		catch(Exception e){
			logger.error("fail uploading  file["+saveFilePath+"]", e);
			isSuccess = false;
		}
		finally{
			if( isSuccess ){
				commit();
			}
			else {
				rollback();
			}
		}
		return isSuccess;
	}
	
	private void commit(){
		if( !StringUtils.isBlank(backupFilePath)){
			new File(backupFilePath).delete();
		}
	}
	
	private void rollback(){
		File saveFile = new File(saveFilePath);
		if( saveFile.exists()){
			saveFile.delete();
		}
		if( !StringUtils.isBlank(backupFilePath)){
			new File(backupFilePath).renameTo(new File(saveFilePath));
		}
	}
	
	private boolean uploadFile(String path, InputStream input){
		File targetFile = new File(path);
		FileOutputStream output = null;
		try {
			output =  new FileOutputStream(targetFile);
			byte[] readBytes = new byte[1024];
			while(true){
				int readCount = input.read(readBytes, 0, readBytes.length);
				if( readCount == -1){
					break;
				}
				output.write(readBytes, 0, readCount);
			}
			output.flush();
		}
		catch(Exception e){
			logger.error("error uploading file["+path+"]", e);
			return false;	
		}
		finally{
			if(output != null){
				try{ output.close(); }catch(Exception e){}
			}
		}
		return true;
	}
}
