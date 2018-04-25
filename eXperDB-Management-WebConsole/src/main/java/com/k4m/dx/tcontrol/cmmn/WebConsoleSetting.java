package com.k4m.dx.tcontrol.cmmn;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;
import java.util.Scanner;

import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;

public class WebConsoleSetting {
	
	public static void main(String[] args) throws Exception {
		
		/**
		 * 1. database.url
		 * 2. database.port
		 * 3. database.username
		 * 4. database.password

		 */
		String strDatabaseIp = "";
		String strDatabasePort = "";
		String strDatabaseUsername = "";
		String strDatabasePassword = "";
		String strDatabaseUrl = "";
		
		String strLanguage ="";
		String strVersion ="eXperDB-Management-WebConsole-9.6.1.0";
		
		String strEncryptYN="";
		
		String strEncryptServerUrl = "";
		String strEncryptServerPort = "";
		
		String strPropertiesPath ="egovframework" + File.separator + "tcontrolProps" + File.separator +"globals.properties";
		String strPropertiesNm ="globals.properties";
		
		Scanner scan = new Scanner(System.in);
		
		System.out.println("Language(ko(한글), en(영문)) :");
		
		strLanguage = scan.nextLine();

		while (true) {
			if(strLanguage.equals("")) {
				System.out.println("Please enter your eXperDB-Management-WebConsole language. ");
				
				System.out.println("eXperDB-Management-WebConsole language :");
				
				strLanguage = scan.nextLine();
			} else {
				break;
			}
		}	
					
		System.out.println("Repository database IP :");
		
		strDatabaseIp = scan.nextLine();
		
		while (true) {
			if(strDatabaseIp.equals("")) {
				System.out.println("Please enter the Repository database IP address. ");
				
				System.out.println("Repository database IP :");
				
				strDatabaseIp = scan.nextLine();
			} else {
				break;
			}
		}
		
		
		System.out.println("Repository database Port :");
				
				strDatabasePort = scan.nextLine();
				
				while (true) {
					if(strDatabasePort.equals("")) {
						System.out.println("Please enter a Repository database Port. ");
						
						System.out.println("Repository the database Port :");
						
						strDatabasePort = scan.nextLine();
					} else {
						break;
					}
				}
		
		
		System.out.println("Repository database.username :");
		
		strDatabaseUsername = scan.nextLine();
		
		while (true) {
			if(strDatabaseUsername.equals("")) {
				System.out.println("Please enter your Repository database username. ");
				
				System.out.println("Repository database.username :");
				
				strDatabaseUsername = scan.nextLine();
			} else {
				break;
			}
		}
		
		
		System.out.println("Repository database.password :");
		
		strDatabasePassword = scan.nextLine();

		while (true) {
			if(strDatabasePassword.equals("")) {
				System.out.println("Please enter your Repository database password. ");
				
				System.out.println("Repository database.password :");
				
				strDatabasePassword = scan.nextLine();
			} else {
				break;
			}
		}	
		
		
		
		
		/* eXperDB-Encrypt 설치 */
		System.out.println("eXperDB-Encrypt 사용여부? (y, n)");
	
		String strEnctyptYn = scan.nextLine();
		
		strEnctyptYn = strEnctyptYn.toUpperCase();
		
		if(strEnctyptYn.equals("Y")) {
		
			System.out.println("eXperDB-Encrypt server.url :");
			
			strEncryptServerUrl = scan.nextLine();
			
			while (true) {
				if(strEncryptServerUrl.equals("")) {
					System.out.println("Please enter your eXperDB-Encrypt server.url. ");
					
					System.out.println("eXperDB-Encrypt server.url :");
					
					strEncryptServerUrl = scan.nextLine();
				} else {
					break;
				}
			}

			System.out.println("eXperDB-Encrypt server.port :");
			
			strEncryptServerPort = scan.nextLine();
			
			while (true) {
				if(strEncryptServerPort.equals("")) {
					System.out.println("Please enter your eXperDB-Encrypt server.port. ");
					
					System.out.println("eXperDB-Encrypt server.port :");
					
					strEncryptServerPort = scan.nextLine();
				} else {
					break;
				}
			}
			
			
			strDatabaseUrl = "jdbc:postgresql://" + strDatabaseIp + ":" + strDatabasePort + "/" + strDatabaseUsername;
			
			System.out.println("################Repository database##################");
			System.out.println("Repository database IP address :" + strDatabaseIp);
			System.out.println("Repository database port :" + strDatabasePort);		
			System.out.println("Repository database username :" + strDatabaseUsername);
			System.out.println("Repository database password :" + strDatabasePassword);
			System.out.println("Repository database 접속정보 :" + strDatabaseUrl);
			System.out.println("#################################################");
			System.out.println("###################eXperDB-Encrypt##################");
			System.out.println("eXperDB-Encrypt server.url :" + strEncryptServerUrl);
			System.out.println("eXperDB-Encrypt server.port :" + strEncryptServerPort);		
			System.out.println("##################################################");	
		}else{
			
			strDatabaseUrl = "jdbc:postgresql://" + strDatabaseIp + ":" + strDatabasePort + "/" + strDatabaseUsername;
			
			System.out.println("################Repository database##################");
			System.out.println("Repository database IP address :" + strDatabaseIp);
			System.out.println("Repository database port :" + strDatabasePort);		
			System.out.println("Repository database username :" + strDatabaseUsername);
			System.out.println("Repository database password :" + strDatabasePassword);
			System.out.println("Repository database 접속정보 :" + strDatabaseUrl);
			System.out.println("#################################################");
		}
		
		/*		
		strDatabaseUrl = "jdbc:postgresql://" + strDatabaseIp + ":" + strDatabasePort + "/" + strDatabaseUsername;
		
		System.out.println("#####################################################");
		System.out.println("Repository database IP address :" + strDatabaseIp);
		System.out.println("Repository database port :" + strDatabasePort);		
		System.out.println("Repository database username :" + strDatabaseUsername);
		System.out.println("Repository database password :" + strDatabasePassword);
		System.out.println("Repository database 접속정보 :" + strDatabaseUrl);
		System.out.println("#####################################################");*/
		
		System.out.println("입력한 내용으로 적용하시겠습니까? (y, n)");
		
		
		String strApply = scan.nextLine();
		
		if(strApply.equals("y")) {
			
		    StandardPBEStringEncryptor pbeEnc = new StandardPBEStringEncryptor();
		    pbeEnc.setPassword("k4mda"); // PBE 값(XML PASSWORD설정)
			
		    String url = pbeEnc.encrypt(strDatabaseUrl);
		    String username = pbeEnc.encrypt(strDatabaseUsername);
		    String password = pbeEnc.encrypt(strDatabasePassword);
		    
		    Properties prop = new Properties();
		    
		    ClassLoader loader = Thread.currentThread().getContextClassLoader();
		    File file = new File(loader.getResource(strPropertiesPath).getFile());
		    
		    String path = file.getParent() + File.separator;
		    
		    //System.out.println(path);
		    Connection conn = null;
			
			try {
				Class.forName("org.postgresql.Driver");
				
				Properties props = new Properties();
				props.setProperty("user", strDatabaseUsername);
				props.setProperty("password", strDatabasePassword);
				
				String strConnUrl = strDatabaseUrl;

				conn = DriverManager.getConnection(strConnUrl, props);

				System.out.println("Repository database Connection success !!");
				
			} catch (Exception e) {
				System.out.println("Exit(0) Error : database Connection failed !! " + e.toString());
				System.exit(0);
			} finally {
				if(conn != null) conn.close();
			}	
		    

		    try {
		    	System.out.println(path + strPropertiesNm);
		    	prop.load(new FileInputStream(path + strPropertiesNm));
		    } catch(FileNotFoundException e) {
		    	System.out.println("Exit(0) File Not Found ");
		    	System.exit(0);
		    } catch(Exception e) {
		    	System.out.println("Exit(0) Error : " + e.toString());
		    	System.exit(0);
		    }
		     
		    prop.setProperty("database.url", "ENC(" + url + ")");
		    prop.setProperty("database.username", "ENC(" + username + ")");
		    prop.setProperty("database.password", "ENC(" + password + ")");
		    prop.setProperty("lang", strLanguage);
		    prop.setProperty("version", strVersion);
		    

		    if(strEnctyptYn.equals("Y")){
		    	prop.setProperty("encrypt.useyn", strEnctyptYn);
		    	prop.setProperty("encrypt.server.url", strEncryptServerUrl);
			    prop.setProperty("encrypt.server.port", strEncryptServerPort);
		    }else{
		    	prop.setProperty("encrypt.useyn", strEnctyptYn);
		    }

		    try {	    	
		    	prop.store(new FileOutputStream(path + strPropertiesNm), "");		    	
		    } catch(FileNotFoundException e) {
		    	System.out.println("Exit(0) Error : File Not Found ");
		    	System.exit(0);
		    } catch(Exception e) {
		    	System.out.println("Exit(0) Error : " + e.toString());
		    	System.exit(0);
		    }

		    System.out.println("#### WebConsole Setting success !! #####");
		} else {
			System.out.println("#### Exit(0) Cancel WebConsole Setting  #####");
		}
	}


}
