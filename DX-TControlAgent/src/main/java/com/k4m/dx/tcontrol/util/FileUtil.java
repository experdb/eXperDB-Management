package com.k4m.dx.tcontrol.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.HashMap;
import java.util.Properties;

import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;

/**
 * File Handle Utils
 * @author thpark
 *
 */
public class FileUtil {

	/**
	 * 프로퍼티 get value
	 * 
	 * @param strPropertyFileName
	 * @param strKey
	 * @return
	 * @throws Exception
	 */
	public static String getPropertyValue(String strPropertyFileName, String strKey) throws Exception {
		Resource resource = new ClassPathResource(strPropertyFileName);
		Properties properties = new Properties();
		properties.load(resource.getInputStream());

		return properties.getProperty(strKey);
	}

	/**
	 * 특정 디렉터리의 파일 리스트
	 * 
	 * @param strPath(파일경로)
	 * @return
	 */
	public static File[] getFileList(String strPath) throws Exception {
		File dirFile = new File(strPath);

		File[] fileList = dirFile.listFiles();

		return fileList;
	}

	/**
	 * 특정 디렉터리 존재하지 않으면 생성
	 * 
	 * @param strPath
	 */
	public static void createFileDir(String strPath) throws Exception {
		File dirFile = new File(strPath);

		if (!dirFile.isDirectory()) {
			dirFile.mkdirs();
		}
	}

	/**
	 * file Name HashMap
	 * 
	 * @param fileList
	 * @return
	 */
	public static HashMap<String, String> getFileNames(File[] fileList) throws Exception {
		HashMap<String, String> map = new HashMap<String, String>();

		for (File file : fileList) {
			map.put("fileName", file.getName());
		}

		return map;
	}

	/**
	 * Original File Name 추출
	 * 
	 * @param fileName
	 * @return
	 * @throws Exception
	 */
	public static String fileNameSubString(String fileName) throws Exception {
		String strOrgFileName = "";

		int Idx = fileName.lastIndexOf(".");

		if (Idx > 0) {
			strOrgFileName = fileName.substring(0, Idx);
		}

		return strOrgFileName;
	}
	
	/**
	 * 파일 확장자 추출
	 * @param fileName
	 * @return
	 * @throws Exception
	 */
	public static String fileExtenderSubString(String fileName) throws Exception {
		String strExtFileName = "";

		int Idx = fileName.lastIndexOf(".");

		if (Idx > 0) {
			strExtFileName = fileName.substring(Idx + 1);
		}

		return strExtFileName;
	}

	/**
	 * file Move
	 * 
	 * @param inFileName
	 * @param outFileName
	 * @throws Exception
	 */
	public static void fileMove(String inFileName, String outFileName) throws Exception {

		FileInputStream fis = new FileInputStream(inFileName);
		FileOutputStream fos = new FileOutputStream(outFileName);

		int data = 0;
		while ((data = fis.read()) != -1) {
			fos.write(data);
		}
		
		fis.close();
		fos.close();

		// 복사한뒤 원본파일을 삭제함
		fileDelete(inFileName);

	}
	
	/**
	 * File Copy
	 * @param inFileName
	 * @param outFileName
	 * @throws Exception
	 */
	public static void fileCopy(String inFileName, String outFileName) throws Exception {

		FileInputStream fis = new FileInputStream(inFileName);
		FileOutputStream fos = new FileOutputStream(outFileName);

		int data = 0;
		while ((data = fis.read()) != -1) {
			fos.write(data);
		}
		
		fis.close();
		fos.close();

	}

	/**
	 * file Delete
	 * 
	 * @param deleteFileName
	 */
	public static void fileDelete(String deleteFileName)  throws Exception {
		File file = new File(deleteFileName);
		file.delete();
	}
	
	public static void main(String args[]) {
		
		try {
		//pdf.end 파일Test
		String strPdfFileName = "1000088_1.pdf.end";
		String strExtFileName = fileNameSubString(strPdfFileName);
		
		if(strExtFileName.indexOf(".") > 0) {
			System.out.println(fileExtenderSubString(strExtFileName));
		}

		
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

}
