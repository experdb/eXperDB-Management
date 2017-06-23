package com.k4m.dx.tcontrol.db.test;

import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;

public class DBPasswordCreate {
	
	public static void main(String args[]) {
		try {
		StandardPBEStringEncryptor standardPBEStringEncryptor = new StandardPBEStringEncryptor();  
/*		standardPBEStringEncryptor.setAlgorithm("PBEWithMD5AndDES");  
		standardPBEStringEncryptor.setPassword("SMAILGW_PASS");  
		
		String userName = standardPBEStringEncryptor.encrypt("edcsusr");
		String password = standardPBEStringEncryptor.encrypt("edcsusr");
		
		System.out.println("userName : "+userName);
		System.out.println("password : "+password);*/
		
	    StandardPBEStringEncryptor pbeEnc = new StandardPBEStringEncryptor();
	    pbeEnc.setPassword("k4mda"); // PBE 값(XML PASSWORD설정)
	    
	    //운영
	    String url = pbeEnc.encrypt("jdbc:postgresql://222.110.153.162:6432/postgres");
	    String username = pbeEnc.encrypt("tcontrol");
	    String password = pbeEnc.encrypt("tcontrol");
	 
	    System.out.println(url);
	    System.out.println(username);
	    System.out.println(password);
	    
	  
	    
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

}
