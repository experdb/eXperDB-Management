package com.k4m.dx.tcontrol.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Properties;

import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;

/**
 * File Handle Utils
 * 
 * @author thpark
 *
 */
public class FileUtil {

	public static String getFileView(File file) throws Exception {
		String strView = "";
		BufferedReader br = null;
		try {
			br = new BufferedReader(new FileReader(file));
			char[] c = new char[(int) file.length()];
			br.read(c);
			strView = new String(c);
			/*
			 * String line; while ((line = br.readLine()) != null) { strView +=
			 * line + "\r\n"; }
			 */
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (br != null)
				try {
					br.close();
				} catch (IOException e) {
				}
		}

		return strView;
	}
	
	
	public static HashMap getFileView(File file, int intStartLength, int intDwlenCount) throws Exception {
		String strView = "";
		BufferedReader br = null;
		HashMap hp = new HashMap();
		try {
			br = new BufferedReader(new FileReader(file));
			char[] c = new char[(int) file.length()];
			br.read(c);
			
			int intBufLength = c.length;
			
			int intLastLength = intStartLength;
			int intFirstLength = 0;
			if(intBufLength < intStartLength) {
				intLastLength = intBufLength;
			} else {
				int intFirstDwlen = 0;
				if(intDwlenCount > 1 ) intFirstDwlen = intDwlenCount -1;
				
				intFirstLength = intLastLength * intFirstDwlen;
				intLastLength = intLastLength * intDwlenCount;
			}
			
			String strEndFlag = "0";

			if(intBufLength <= intLastLength) {
				//intFirstLength = buffer.length;
				intLastLength = intBufLength ;
				strEndFlag = "1";
			} else {
				intDwlenCount = intDwlenCount + 1;
			}
			
			strView = new String(c, intFirstLength, intLastLength - intFirstLength);
			
			hp.put("file_desc", strView);
			hp.put("file_size", c.length);
			hp.put("dw_len", intDwlenCount);
			hp.put("end_flag", strEndFlag);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (br != null)
				try {
					br.close();
				} catch (IOException e) {
				}
		}

		return hp;
	}

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
	 * 
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
	 * 
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
	public static void fileDelete(String deleteFileName) throws Exception {
		File file = new File(deleteFileName);
		file.delete();
	}


	/**
	 * 파일크기 추출
	 * @param filesize
	 * @param type
	 * @return
	 */
	public static String getFileSize(long filesize, int Cutlength) {
		String size = "";

		if (filesize < 1024)
			size = filesize + " Byte";
		else if (filesize > 1024 && filesize < (1024 * 1024)) {
			double longtemp = filesize / (double) 1024;
			int len = Double.toString(longtemp).indexOf(".");
			size = Double.toString(longtemp).substring(0, len + Cutlength) + " Kb";
		} else if (filesize > (1024 * 1024)) {
			double longtemp = filesize / ((double) 1024 * 1024);
			int len = Double.toString(longtemp).indexOf(".");
			size = Double.toString(longtemp).substring(0, len + Cutlength) + " Mb";
		}
		return size;
	}
	
	/**
	 * 파일 최종 수정일시 조회
	 * @param fileLastModified
	 * @return
	 * @throws Exception
	 */
	public static String getFileLastModifiedDate(long fileLastModified) throws Exception {
		String strLastModified = "";
		
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.KOREA);

		Date date = new Date(fileLastModified);

		strLastModified = formatter.format(date);

		
		return strLastModified;
	}
	
	/**
	 * 디렉터리 존재 유무 검색
	 * @param strDirectory
	 * @return
	 * @throws Exception
	 */
	public static boolean isDirectory(String strDirectory) throws Exception {
		boolean blnReturn = false;
		
		File file = new File(strDirectory);
		
		if(file.isDirectory()) {
			blnReturn = true;
		}
		
		return blnReturn;
	}
	
	/**
	 * 파일 존재유무 검색
	 * @param strFile
	 * @return
	 * @throws Exception
	 */
	public static boolean isFile(String strFile) throws Exception {
		boolean blnReturn = false;
	    File f = new File(strFile);

	    // 파일 존재 여부 판단
	    if (f.isFile()) {
	    	blnReturn = true;
	    }
	    
	    return blnReturn;
	}
	
	/**
	 * 파일 size 조회
	 * @param strFile
	 * @return
	 * @throws Exception
	 */
	public static long getFileSize(String strFile) throws Exception {
		long lFileSize = 0 ;
		
		File file = new File(strFile);
		
		if(file.isDirectory()) {
			lFileSize = file.length();
		}
		
		return lFileSize;
	}
	
	/**
	 * file to byte
	 * @param file
	 * @return
	 * @throws Exception
	 */
	public static byte[] getFileToByte(File file) throws Exception {
		byte[] bytesArray = new byte[(int) file.length()];

		FileInputStream fis = new FileInputStream(file);
		fis.read(bytesArray); //read file into bytes[]
		fis.close();

		return bytesArray;
	}
	
	public static void main(String args[]) {

		try {
			// pdf.end 파일Test
			/**
			 * String strPdfFileName = "1000088_1.pdf.end"; String
			 * strExtFileName = fileNameSubString(strPdfFileName);
			 * 
			 * if(strExtFileName.indexOf(".") > 0) {
			 * System.out.println(fileExtenderSubString(strExtFileName)); }
			 * 
			 **/
			
			String strFilePath = "C:\\k4m\\01-1. DX 제폼개발\\04. 시험\\pg_log1\\";
			
			boolean blnReturn = isDirectory(strFilePath);
			
			System.out.println(blnReturn);

			// 파일읽기
			/**
			String strFilePath = "C:\\k4m\\01-1. DX 제폼개발\\04. 시험\\pg_log\\";
			String strFileName = "postgresql-2017-07-25_095614.log";

			File inFile = new File(strFilePath, strFileName);

			//String strFileTxt = FileUtil.getFileView(inFile);

			//System.out.println(strFileTxt);
			
			
			//file LastModified
			String strLastModified = FileUtil.getFileLastModifiedDate(inFile.lastModified());
			System.out.println(strLastModified);
			**
			*/
			
			//Date date = new Date("2017-07-26");

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	

}
