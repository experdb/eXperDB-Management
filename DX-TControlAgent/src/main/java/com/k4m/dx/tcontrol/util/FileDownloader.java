package com.k4m.dx.tcontrol.util;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

/**
 * File Download Util
 * @author thpark
 *
 */
public class FileDownloader {

	private static final String IMAGE_GIF = "image/gif";
	private static final String IMAGE_JPEG = "image/jpeg";
	private static final String IMAGE_BMP = "image/bmp";
	private static final String IMAGE_PNG = "image/png";
	private static final String APPLICATION_ZIP = "application/zip";
	private static final String APPLICATION_OCTETSTREM = "application/octet-stream";
	private static final String APPLICATION_EXCEL = "application/vnd.ms-excel";
	private static final String TEXT_HTML = "text/html";
	private static final String TEXT_PLAIN = "text/plain";
	private static final String TEXT_JS = "text/js";
	private static final String TEXT_CSS = "text/css";

	private String filePath;

	public FileDownloader(String absoluteFilePath) {
		this.filePath  = absoluteFilePath;
	}
	
	public FileDownloader(String rootDirPath, String relativeFilePath) {
		this.filePath = rootDirPath + relativeFilePath;	
	}

	public void download(OutputStream outputstream) throws IOException {
		File realFile = new File(filePath);
		byte readByte[] = new byte[4096];
		BufferedInputStream bufferedinputstream = null;
		try {
			bufferedinputstream = new BufferedInputStream(new FileInputStream(realFile));
			int readCount;
			while ((readCount = bufferedinputstream.read(readByte, 0, 4096)) != -1) {
				outputstream.write(readByte, 0, readCount);
			}
			outputstream.flush();
		} catch (IOException e) {
			throw e;
		} finally {
			if (bufferedinputstream != null) {
				try {
					bufferedinputstream.close();
				} catch (Exception e) {
				}
			}
		}
	}
	
	public int getContentLength(){
		return (int) new File(filePath).length();
	}

	public static String getContentType(String filename) {
		try {
			String ext = filename.toLowerCase();
			if (ext.endsWith(".gif")) {
				return IMAGE_GIF;
			} else if (ext.endsWith(".jpg")) {
				return IMAGE_JPEG;
			} else if (ext.endsWith(".bmp")) {
				return IMAGE_BMP;
			} else if (ext.endsWith(".png")) {
				return IMAGE_PNG;
			} else if (ext.endsWith(".zip")) {
				return APPLICATION_ZIP;
			} else if (ext.endsWith(".exe")) {
				return APPLICATION_OCTETSTREM;
			} else if (ext.endsWith(".xls")) {
				return APPLICATION_EXCEL;
			} else if (ext.endsWith(".htm")) {
				return TEXT_HTML;
			} else if (ext.endsWith(".html")) {
				return TEXT_HTML;
			} else if (ext.endsWith(".txt")) {
				return TEXT_PLAIN;
			} else if (ext.endsWith(".wma")) {
				return TEXT_PLAIN;
			} else if (ext.endsWith(".wma")) {
				return TEXT_PLAIN;
			} else if (ext.endsWith(".avi")) {
				return "video/avi";
			} else if (ext.endsWith(".js")) {
				return TEXT_JS;
			} else if (ext.endsWith(".css")) {
				return TEXT_CSS;
			} else {
				return APPLICATION_ZIP;
			}
		} catch (Exception e) {
			return APPLICATION_ZIP;
		}
	}
}
