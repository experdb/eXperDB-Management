package com.k4m.dx.tcontrol.cmmn;

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
	    
	    //개발
	    //String url = pbeEnc.encrypt("jdbc:oracle:thin:@192.168.10.253:1521/DEVDB");
	    //String username = pbeEnc.encrypt("edcsusr");
	   // String password = pbeEnc.encrypt("edcsusr");
	    
	    //운영
	    String url = pbeEnc.encrypt("jdbc:postgresql://222.110.153.162:6432/postgres");
	    String username = pbeEnc.encrypt("tcontrol");
	    String password = pbeEnc.encrypt("tcontrol");
	 
	    System.out.println(url);
	    System.out.println(username);
	    System.out.println(password);
	    
	    System.out.println(pbeEnc.decrypt("MmhDrnt2SFbQU/+8g/AKV39tHQMILggXdmNu64JQTw/dTFoWvLoAmrJOySq6UGr5LuzAsXmvDKI="));
	    System.out.println(pbeEnc.decrypt("t7H2IA527cOXhtefsQYbTC84krKCdG2P"));
	    System.out.println(pbeEnc.decrypt("VIQnbfng4J+P7dESt4TJO49hfKTIuhPf"));
	    
	    
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

}
