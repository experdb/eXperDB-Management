package com.k4m.dx.tcontrol.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.lang.management.ManagementFactory;
import java.math.BigDecimal;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.xml.sax.SAXException;

import com.k4m.dx.tcontrol.db.datastructure.DataTable;
import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.db.Constant;

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
		String strPoolName = "";
		
		return "" + serverInfoObj.get(ProtocolID.SERVER_IP) + "_" + serverInfoObj.get(ProtocolID.DATABASE_NAME) + "_" + serverInfoObj.get(ProtocolID.SERVER_PORT);
	}
	
}
