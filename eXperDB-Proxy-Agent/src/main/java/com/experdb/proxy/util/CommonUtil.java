package com.experdb.proxy.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.lang.management.ManagementFactory;
import java.math.BigDecimal;

import javax.xml.bind.DatatypeConverter;

import org.apache.commons.codec.DecoderException;
import org.apache.commons.codec.binary.Hex;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.experdb.proxy.socket.ProtocolID;

/**
* @author 최정환
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2021.02.24   최정환 	최초 생성
*      </pre>
*/
public class CommonUtil {

	private Logger invokeLogger = LoggerFactory.getLogger("consoleToFile");
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");

	public  String getProcessID() {
		String name = ManagementFactory.getRuntimeMXBean().getName();
		System.out.println(name);
		String pidNumber = name.substring(0, name.indexOf("@")); // PID 번호 :
																	// 윈도/유닉스 공통
		return pidNumber;
	}

	public  String getStackTrace(final Throwable throwable) {
		if (throwable == null)
			return null;
		final StringWriter sw = new StringWriter();
		final PrintWriter pw = new PrintWriter(sw, true);

		// if (DXConfig.LOG_ERR_LEVEL == 1){
		// return throwable.getMessage();
		// }else{
		throwable.printStackTrace(pw);
		String msg = sw.getBuffer().toString();

		if (msg == null) {
			return throwable.getMessage();
		} else {
			return sw.getBuffer().toString();
		}
		// }
	}

	public  Integer BigDecimalToInt(Object value) {
		if (value != null && value instanceof BigDecimal) {
			return ((BigDecimal) value).intValue();
		} else {
			return (Integer) value;
		}
	}

	public  Long BigDecimalToLong(Object value) {
		if (value instanceof BigDecimal) {
			return ((BigDecimal) value).longValue();
		} else {
			return (long) value;
		}
	}

	public  byte[] intToByteArray(int value) {
		byte[] byteArray = new byte[4];
		byteArray[0] = (byte) (value >> 24);
		byteArray[1] = (byte) (value >> 16);
		byteArray[2] = (byte) (value >> 8);
		byteArray[3] = (byte) (value);
		return byteArray;
	}

	public  String getPidExec(String command) throws Exception {

		String strResult = "";

		Runtime runtime = Runtime.getRuntime();

		Process process = runtime.exec(new String[] { "/bin/sh", "-c", command });

		strResult = getPid(process);
		
		process.destroy();
		process = null;

		return strResult;
	}

	public  String getPid(Process p) throws Exception {
		
		String strResult = "";
		StringBuffer sb = new StringBuffer();

		BufferedReader in = new BufferedReader(new InputStreamReader(p.getInputStream()));
		String cl = null;
		while ((cl = in.readLine()) != null) {
			sb.append(cl);
			break;
		}

		in.close();
		
		strResult = sb.toString();
		
		sb = null;
		
		p.destroy();
		p = null;

		return strResult;
	}

	public  String getCmdExec(String command) throws Exception {

		String strResult = "";

		Runtime runtime = Runtime.getRuntime();

		Process process = runtime.exec(new String[] { "/bin/sh", "-c", command });

		strResult = getResultCmdData(process);

		
		process.destroy();
		process = null;
		
		return strResult;
	}

	public  String getResultCmdData(Process p) throws Exception {

		StringBuffer sb = new StringBuffer();

		BufferedReader in = new BufferedReader(new InputStreamReader(p.getInputStream()));
		String cl = null;
		while ((cl = in.readLine()) != null) {
			sb.append(cl + "\n");
			// break;
		}
		
		p.destroy();
		p = null;
		in.close();

		return sb.toString();
	}
	
	public String getPoolName(JSONObject serverInfoObj) throws Exception {
		return "" + serverInfoObj.get(ProtocolID.SERVER_IP) + "_" + serverInfoObj.get(ProtocolID.DATABASE_NAME) + "_" + serverInfoObj.get(ProtocolID.SERVER_PORT);
	}
	

	/**
	 * getHexToString hex--> string 변환
	 * 
	 * @return String
	 * @throws UnsupportedEncodingException  
	 */
	public String getHexToString(String testHex) throws UnsupportedEncodingException, DecoderException {
		// https://mvnrepository.com/artifact/commons-codec/commons-codec/1.10
		byte[] testBytes = Hex.decodeHex(testHex.toCharArray());
		return new String(testBytes, "UTF-8").replaceAll("\u0000", "");
	}


	/**
	 * getStringToHex string--> hex 변환
	 * 
	 * @return String
	 * @throws UnsupportedEncodingException  
	 */
	public String getStringToHex(String testStr) throws UnsupportedEncodingException {
		byte[] testBytes = testStr.getBytes("UTF-8");
		return DatatypeConverter.printHexBinary(testBytes);
	}
	
	/**
	 * lpad 
	 * 
	 * @return String
	 * @throws UnsupportedEncodingException  
	 */
	public String lpad(int totalLen, String pad, String data) throws Exception{
		String temp = "";
		int padCnt = totalLen - data.length();
		for(int i=0; i< padCnt; i++){
			temp = pad+temp;
		}
		return temp+data;
	}

	/**
	 * 초 -> 년월 시분초 변환
	 * 
	 * @return String
	 * @throws UnsupportedEncodingException  
	 */
	public String getLongTimeToString(long realTime) throws UnsupportedEncodingException {
		String returnTime = "";

		Long day = realTime / (60 * 60 * 24);
		Long hour = (realTime - day * 60 * 60 * 24) / (60 * 60); 
		Long minute = (realTime - day * 60 * 60 * 24 - hour * 3600) / 60; 
		Long second = realTime % 60;
		
		if (day != null && day != 0) {
			returnTime = day + "d " + hour + "h";
		} else {
			if (hour != null && hour != 0) {
				returnTime = hour + "h " + minute + "m";
			} else {
				if (hour != null && hour != 0) {
					returnTime = minute + "m " + second + "s";
				} else {
					returnTime = second + "s";
				}
			}
		}

		return returnTime;
	}
	
	/**
	 * packet length 구하기
	 * 
	 * @return String
	 * @throws UnsupportedEncodingException  
	 */
	public String getPacketLength(int total, String data) throws Exception{
		int dataLen = getStringToHex(data).length()/2;
		String result = Integer.toHexString(total+dataLen); 
		return lpad(8, "0", result);
	}
	
	/**
	 * 파일을 읽어 String으로 반환
	 * 
	 * @return String
	 * @throws
	 */
	public String readTemplateFile(String filename, String TEMPLATE_DIR)
	{   	
		String content = null;
 	   	File file = new File(getClass().getClassLoader().getResource(TEMPLATE_DIR+filename).getFile()); 
 	   	try {
 	   		InputStreamReader reader= new InputStreamReader(new FileInputStream(file),"UTF8"); 
 	   		char[] chars = new char[(int) file.length()];
 	   		reader.read(chars);
 	   		content = new String(chars);
 	   		reader.close();
 	   	} catch (IOException e) {
 		   e.printStackTrace();
 	   	}
 	   	return content;
	}
}
