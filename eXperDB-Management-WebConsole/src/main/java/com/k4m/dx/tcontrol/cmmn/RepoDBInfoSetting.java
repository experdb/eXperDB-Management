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

public class RepoDBInfoSetting { 

	public static void main(String[] args) throws Exception {
		String strLanguage ="";
		String strVersion ="eXperDB-Management-WebConsole-13.0.2";

		String strDatabaseIp = "";
		String strDatabasePort = "";
		String strDatabaseUsername = "";
		String strDatabasePassword = "";
		String strDatabaseUrl = "";

		String strPropertiesPath ="egovframework" + File.separator + "tcontrolProps" + File.separator +"globals.properties";
		String strPropertiesNm ="globals.properties";

		Scanner scan = new Scanner(System.in);
		AES256 aes = new AES256(AES256_KEY.ENC_KEY);

		/*Repository Database IP*/
		System.out.println("Repository database IP (127.0.0.1):");
		strDatabaseIp = scan.nextLine();
		if(strDatabaseIp.equals("")) {
			strDatabaseIp ="127.0.0.1";
		}

		/*Repository Database PORT*/
		System.out.println("Repository database Port (5432) :");
		strDatabasePort = scan.nextLine();
		if(strDatabasePort.equals("")) {
			strDatabasePort = "5432";
		}

		/*Repository Database USER*/
		System.out.println("Repository database.username (experdb) :");
		strDatabaseUsername = scan.nextLine();
		if(strDatabaseUsername.equals("")) {
			strDatabaseUsername = "experdb";
		}

		/*Repository Database PASSWORD*/
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

				
		strDatabaseUrl = "jdbc:postgresql://" + strDatabaseIp + ":" + strDatabasePort + "/" + strDatabaseUsername;

		
		System.out.println("################globals.properties##################");
		System.out.println("Repository database IP address :" + strDatabaseIp);
		System.out.println("Repository database port :" + strDatabasePort);		
		System.out.println("Repository database username :" + strDatabaseUsername);
		System.out.println("Repository database password :" + strDatabasePassword);
		System.out.println("Repository database Access information :" + strDatabaseUrl);
				System.out.println("##################################################");

		System.out.println("Do you want to apply what you entered? (y, n)");
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