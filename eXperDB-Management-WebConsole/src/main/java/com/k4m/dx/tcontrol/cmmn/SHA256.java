package com.k4m.dx.tcontrol.cmmn;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Properties;

import org.springframework.util.ResourceUtils;


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

public class SHA256 {

	public static String getSHA256(String str){

		String SHA = ""; 
		String saltValue = "";
		byte[] saltValueByte = null;

		try{
			Properties props = new Properties();
			props.load(new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));
			
			if (props.get("password_solt") != null) {
				saltValue = props.get("password_solt").toString();
			}
			
			saltValueByte = saltValue.getBytes();
			byte[] passwordBytes = str.getBytes();
			byte[] totBytes = new byte[passwordBytes.length + saltValueByte.length];
			
			MessageDigest sh = MessageDigest.getInstance("SHA-256");
			sh.update(totBytes);

			byte byteData[] = sh.digest();
	
			StringBuffer sb = new StringBuffer(); 
			for(int i = 0 ; i < byteData.length ; i++){
				sb.append(Integer.toString((byteData[i]&0xff) + 0x100, 16).substring(1));
			}
			SHA = sb.toString();

		}catch(NoSuchAlgorithmException e){
			e.printStackTrace(); 
			SHA = null; 
		}catch(FileNotFoundException e){
			e.printStackTrace(); 
			SHA = null; 
		}catch(IOException e){
			e.printStackTrace(); 
			SHA = null; 
		}

		return SHA;

	}

	public static void main(String[] args) {
		String password = getSHA256("11111");
		System.out.println("password = "+password);
	}
}