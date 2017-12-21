package com.k4m.dx.tcontrol.util;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

/**
 * 요청한 디렉토리의 파일 목록을 조회하여 리턴한다.
 * @author thpark
 *
 */
public class FileListSearcher {

	private final String path;
	
	public FileListSearcher(String path){
		this.path = path;
	}
	
	public List<FileEntry> getSearchFiles(){
		List<FileEntry> fileList = new ArrayList<FileEntry>();
		
		File directory = new File(path);
		
		if(directory.isDirectory()){
			File[] files = directory.listFiles();
			if(files != null){
				for(int i=0; i<files.length; i++){
					File file = files[i];
					if(file.isFile()){
						fileList.add(new FileEntry(path, file.getName(), file.length(), file.lastModified()));
					}
				}
			}
		}
		return fileList;
	}
	
	public static void main(String[] args){
		FileListSearcher searcher = new FileListSearcher("D:/TEMP/log");
		searcher.getSearchFiles();
	}
}
