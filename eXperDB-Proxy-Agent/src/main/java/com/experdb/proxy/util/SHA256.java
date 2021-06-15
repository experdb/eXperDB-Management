package com.experdb.proxy.util;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Properties;
import java.util.Random;

import org.springframework.util.ResourceUtils;

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
	
	public static String setSHA256(String str, String salt_value){
		String SHA = ""; 

		try{
			//salt값 setting
			MessageDigest md = MessageDigest.getInstance("SHA-256");
			md.update(salt_value.getBytes());
			md.update(str.getBytes());
			byte byteData[] = md.digest();
	
			StringBuffer sb = new StringBuffer(); 
			for(int i = 0 ; i < byteData.length ; i++){
				sb.append(Integer.toString((byteData[i]&0xff) + 0x100, 16).substring(1));
			}
			SHA = sb.toString();
		}catch(NoSuchAlgorithmException e){
			e.printStackTrace(); 
			SHA = null; 
		}catch(Exception e){
			e.printStackTrace(); 
			SHA = null; 
		}

		return SHA;

	}

	public static void main(String[] args) {
		String password = getSHA256("11111");
		System.out.println("password = "+password);
	}
	
	public static String getSalt() {
		Random random = new Random();
		byte[] salt = new byte[10];

		random.nextBytes(salt);     

		StringBuffer sb = new StringBuffer();

		for(int i=0; i<salt.length; i++) {
			sb.append(String.format("%02x", salt[i]));
		}

		return sb.toString();
	}
}