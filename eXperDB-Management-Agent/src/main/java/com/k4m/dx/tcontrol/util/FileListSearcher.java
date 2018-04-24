package com.k4m.dx.tcontrol.util;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

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
			files = null;
		}
		return fileList;
	}
	
	public static void main(String[] args){
		FileListSearcher searcher = new FileListSearcher("D:/TEMP/log");
		searcher.getSearchFiles();
	}
}
