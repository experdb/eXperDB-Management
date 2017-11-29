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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.xml.sax.SAXException;

import com.k4m.dx.tcontrol.db.datastructure.DataTable;
import com.k4m.dx.tcontrol.db.Constant;


public class CommonUtil {
	
	private static Logger invokeLogger = LoggerFactory.getLogger("consoleToFile");
	private static Logger errLogger = LoggerFactory.getLogger("errorToFile");
	
	public static String GetDataFromXml(String FilePath, String FuncName, String DbType, String DbVer, String Attr) throws SAXException, IOException, ParserConfigurationException, XPathExpressionException{
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		DocumentBuilder builder = factory.newDocumentBuilder();
		
		InputStream input = Thread.currentThread().getContextClassLoader().getResourceAsStream(FilePath);
		
		Document doc = builder.parse(input);
		
        XPathFactory xpathFactory = XPathFactory.newInstance();
        XPath xpath = xpathFactory.newXPath();
        
		String Path = String.format("/root/function[@id='%s']/%s[@min_ver<='%s' and @max_ver>='%s']/%s", FuncName, DbType, DbVer,DbVer,Attr);
        Element list = (Element) xpath.evaluate(Path, doc, XPathConstants.NODE);
        
        if (list == null || !list.hasChildNodes()){
        	return null;
        }
        
		Node node = list.getLastChild();

		String sql = node.getNodeValue();
		return sql;
	}
	/*
	public static String GetDataFromXml(String FilePath, String FuncName, String DbType, String DbVer, String Attr) throws SAXException, IOException, ParserConfigurationException, XPathExpressionException{
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		DocumentBuilder builder = factory.newDocumentBuilder();
		
		Document doc = builder.parse(new File(FilePath));
		
        XPathFactory xpathFactory = XPathFactory.newInstance();
        XPath xpath = xpathFactory.newXPath();
        
		String Path = String.format("/root/function[@id='%s']/%s[@min_ver<='%s' and @max_ver>='%s']/%s", FuncName, DbType, DbVer,DbVer,Attr);
		//String Path = String.format("/root/function[@id='%s']/%s[@min_ver<='%s']/%s", FuncName, DbType, DbVer,Attr);
        Element list = (Element) xpath.evaluate(Path, doc, XPathConstants.NODE);
        
        if (list == null || !list.hasChildNodes()){
        	return null;
        }
        
		Node node = list.getLastChild();

		String sql = node.getNodeValue();
		return sql;
	}
	*/
	public static String getProcessID(){
		String name = ManagementFactory.getRuntimeMXBean().getName(); 
		System.out.println(name);
		String pidNumber = name.substring(0, name.indexOf("@"));	 // PID 번호 : 윈도/유닉스 공통
		return pidNumber;
	}
	
	public static String getStackTrace(final Throwable throwable) {
		if(throwable == null) return null;
	     final StringWriter sw = new StringWriter();
	     final PrintWriter pw = new PrintWriter(sw, true);
	     
	     //if (DXConfig.LOG_ERR_LEVEL == 1){
	    	// return throwable.getMessage();
	     //}else{
		     throwable.printStackTrace(pw);
		     String msg = sw.getBuffer().toString();
		     
		     if (msg == null){
		    	 return throwable.getMessage();
		     }else{
			     return sw.getBuffer().toString();
		     }
	    // }	     
	}
	
	public static Integer BigDecimalToInt(Object value) {
		 if (value != null && value instanceof BigDecimal){
			 return ((BigDecimal)value).intValue();
		 }else{
			 return (Integer)value;
		 }	     
	}
	
	public static Long BigDecimalToLong(Object value) {
		 if (value instanceof BigDecimal){
			 return ((BigDecimal)value).longValue();
		 }else{
			 return (long)value;
		 }	     
	}
	
	public  static byte[] intToByteArray(int value) {
		byte[] byteArray = new byte[4];
		byteArray[0] = (byte)(value >> 24);
		byteArray[1] = (byte)(value >> 16);
		byteArray[2] = (byte)(value >> 8);
		byteArray[3] = (byte)(value);
		return byteArray;
	}
	
	public static void printResult(DataTable dt){
		try{
			for(String columnNm : dt.getColumns()){
				System.out.print(StringUtils.rightPad(columnNm, 40, " "));
			}
			invokeLogger.info(StringUtils.leftPad("", dt.getColumns().size() * 40, "="));
			
			for(Map<String, Object> map: dt.getRows()){
				for(String columnNm : dt.getColumns()){
					invokeLogger.info(StringUtils.rightPad(String.valueOf(map.get(columnNm)), 40, " "));
				}
				invokeLogger.info(Constant.R);
			}
		}catch(Exception e){
			
		}

	}
	
	public static String SetDoubleQuote(String DB_TYPE, String Obj){
		switch(DB_TYPE){
			case Constant.DB_TYPE.ASE:
				return Obj;
			default:
				Obj = "\"" + Obj + "\"";
				break;
		}
		return Obj;
	}
	
	   public static String getPidExec(String command) throws Exception {
		   

		   String strResult = "";

           Runtime runtime = Runtime.getRuntime();

           Process process = runtime.exec(new String[]{"/bin/sh", "-c", command});
           
           strResult = getPid(process);

           
          return strResult;
	   }
	   
	   public static String  getPid(Process p) throws Exception{

		   StringBuffer sb = new StringBuffer();

		   BufferedReader in = new BufferedReader(new InputStreamReader(p.getInputStream()));
           String cl = null;
           while((cl=in.readLine())!=null){
               sb.append(cl);
               break;
           }

           in.close();

		   return sb.toString();
		}
	   
	   
	   public static String getCmdExec(String command) throws Exception {
		   

		   String strResult = "";

           Runtime runtime = Runtime.getRuntime();

           Process process = runtime.exec(new String[]{"/bin/sh", "-c", command});
           
           strResult = getResultCmdData(process);

           
          return strResult;
	   }
	   
	   public static String  getResultCmdData(Process p) throws Exception{

		   StringBuffer sb = new StringBuffer();

		   BufferedReader in = new BufferedReader(new InputStreamReader(p.getInputStream()));
           String cl = null;
           while((cl=in.readLine())!=null){
               sb.append(cl + "\n");
               //break;
           }

           in.close();

		   return sb.toString();
		}
}
