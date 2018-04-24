package com.k4m.dx.tcontrol.cmmn;

import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;

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
	    String url = pbeEnc.encrypt("jdbc:postgresql://222.110.153.251:5433/experdb");
	    String username = pbeEnc.encrypt("experdb");
	    String password = pbeEnc.encrypt("experdb");
	 
	    System.out.println(url);
	    System.out.println(username);
	    System.out.println(password);
	    
	    System.out.println(pbeEnc.decrypt("OdWrmRiT7caQNhkgGcZlATrVnBy6Xwskp46CVxlP/CK1HPn7GT6Ex9RjF97SnrC/L0B9OMzwTME="));
	    System.out.println(pbeEnc.decrypt("HMKCoKjqSqrwCGspGtv4Tw=="));
	    System.out.println(pbeEnc.decrypt("x6P0Om4GPszgt4+Whx1f7Q=="));
	    
	    
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

}
