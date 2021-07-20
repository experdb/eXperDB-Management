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
		String strLanguage ="";
		String strVersion ="eXperDB-Management-WebConsole-12.1.2";

		String strDatabaseIp = "";
		String strDatabasePort = "";
		String strDatabaseUsername = "";
		String strDatabasePassword = "";
		String strDatabaseUrl = "";

		String strBackupDatabaseUrl = "";
		String strActivitylogDatabaseUrl = "";
		String strJobhistoryDatabaseUrl = "";

		String strBnrLicense  = "";

		String strTransferYN ="";

		//2020.09.23 trans 컨슈머 전송 추가
		String strTransferOraYN ="";
		String strAuditYN="";

		// 2021-04-13 백업사용 유무 추가 변승우
		String strBackupYN = "";
		String strRootPw = "";
		String strSshPort = "";

		String strScaleYN="";
		String strScalePath="";
		String strScaleInCmd="";
		String strScaleOutCmd="";
		String strScaleInMultiCmd="";
		String strScaleOutMultiCmd="";
		String strScaleJsonView="";
		String strScaleChkPrgress="";

		String strDb2pgPath = "";

		String strEncryptServerUrl = "";
		String strEncryptServerPort = "";

		String strPropertiesPath ="egovframework" + File.separator + "tcontrolProps" + File.separator +"globals.properties";
		String strPropertiesNm ="globals.properties";

		Scanner scan = new Scanner(System.in);
		AES256 aes = new AES256(AES256_KEY.ENC_KEY);

		String strProxyMenuYN="";	//proxy 메뉴 사용여부
		String strProxyYN="";	//proxy 사용여부
		String strProxyPath="";

		/* 사용언어 */
		System.out.println("Language(ko:Korean), (en:English) :");
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

		/* DB2PG 설치 경로 */
		/* 순서변경, 2021-04-13 변승우 */
		System.out.println("eXperDB-DB2PG installation path : ");
		strDb2pgPath = scan.nextLine();
		while (true) {
			if(strDb2pgPath.equals("")) {
				System.out.println("Please enter your eXperDB-DB2PG installation path setting. ");
				System.out.println("eXperDB-DB2PG installation path :");
				strDb2pgPath = scan.nextLine();
			} else {
				break;
			}
		}

		/* 백업 사용여부  추가  2021-04-13  변승우 */
		System.out.println("Whether to enable eXperDB-Backup settings? (y, n)");
		strBackupYN = scan.nextLine();
		strBackupYN = strBackupYN.toUpperCase();

		while (true) {
			if(strBackupYN.equals("")) {
				System.out.println("Please enter your eXperDB-Backup setting yn. ");
				System.out.println("Whether to enable eXperDB-Backup settings? (y, n) :");
				strBackupYN = scan.nextLine();
				strBackupYN = strBackupYN.toUpperCase();
			} else {
				break;
			}
		}

		if(strBackupYN.equals("Y")){
			System.out.println("Server root password :");
			strRootPw = scan.nextLine();
			while (true) {
				if(strRootPw.equals("")) {
					System.out.println("Please enter your Server root password. ");
					System.out.println("Server root password :");
					strRootPw = scan.nextLine();
					strRootPw = strRootPw.toUpperCase();
				} else {
					break;
				}
			}

			System.out.println("Server SSH Port : ");
			strSshPort = scan.nextLine();
			while (true) {
				if(strSshPort.equals("")) {
					System.out.println("Please enter your Server SSH Port. ");
					System.out.println("Server SSH Port :");
					strSshPort = scan.nextLine();
					strSshPort = strSshPort.toUpperCase();
				} else {
					break;
				}
			}

			System.out.println("BnR License cnt : ");
			strBnrLicense = scan.nextLine(); 
			while (true) {
				if(strSshPort.equals("")) {
					System.out.println("Please enter your BnR License cnt. ");
					System.out.println("BnR License cnt :");
					strBnrLicense = scan.nextLine();
				} else {
					break;
				}
			}
		}

		/* 감사설정 사용여부 */
		System.out.println("Whether to enable auditing settings? (y, n)");
		strAuditYN = scan.nextLine();
		strAuditYN = strAuditYN.toUpperCase();
		while (true) {
			if(strAuditYN.equals("")) {
				System.out.println("Please enter your auditing setting yn. ");
				System.out.println("Whether to enable auditing settings? (y, n) :");
				strAuditYN = scan.nextLine();
				strAuditYN = strAuditYN.toUpperCase();
			} else {
				break;
			}
		}

		/* 전송설정 사용여부 */
		System.out.println("Whether data transfer is enabled? (y, n)");
		strTransferYN = scan.nextLine();
		strTransferYN = strTransferYN.toUpperCase();
		while (true) {
			if(strTransferYN.equals("")) {
				System.out.println("Please enter your transfer setting yn. ");
				System.out.println("Whether data transfer is enabled? (y, n) :");
				strTransferYN = scan.nextLine();
				strTransferYN = strTransferYN.toUpperCase();
			} else {
				break;
			}
		}

		/* 전송설정-컨슈머전송 사용여부 */
		System.out.println("Whether data consumer transfer is enabled? (y, n)");
		strTransferOraYN = scan.nextLine();
		strTransferOraYN = strTransferOraYN.toUpperCase();
		while (true) {
			if(strTransferOraYN.equals("")) {
				System.out.println("Please enter your consumer transfer setting yn. ");
				System.out.println("Whether data consumer transfer is enabled? (y, n) :");
				strTransferOraYN = scan.nextLine();
				strTransferOraYN = strTransferOraYN.toUpperCase();
			} else {
				break;
			}
		}

		/* Proxy Menu in/out 사용여부 */
		System.out.println("Whether data Proxy Menu is enabled? (y, n)");
		strProxyMenuYN = scan.nextLine();
		strProxyMenuYN = strProxyMenuYN.toUpperCase();
		while (true) {
			if(strProxyMenuYN.equals("")) {
				System.out.println("Please enter your Proxy Menu setting yn. ");
				System.out.println("Whether data Proxy Menu is enabled? (y, n) :");
				strProxyMenuYN = scan.nextLine();
				strProxyMenuYN = strProxyMenuYN.toUpperCase();
			} else {
				break;
			}
		}

		if(strProxyMenuYN.equals("Y")){
			/* Proxy in/out 사용여부 */
			System.out.println("Whether data Proxy-Service is enabled? (y, n)");
			strProxyYN = scan.nextLine();
			strProxyYN = strProxyYN.toUpperCase();
			while (true) {
				if(strProxyYN.equals("")) {
					System.out.println("Please enter your Proxy-Service setting yn. ");
					System.out.println("Whether data Proxy Service is enabled? (y, n) :");
					strProxyYN = scan.nextLine();
					strProxyYN = strProxyYN.toUpperCase();
				} else {
					break;
				}
			}
		} else {
			strProxyYN = "N";
		}

		//proxy_log_path
		if(strProxyYN.equals("Y")){
			System.out.println("eXperDB-Proxy log_path(/home/experdb/app/eXperDB-Management/eXperDB-Proxy):");
			strProxyPath = scan.nextLine();
			if(strProxyPath.equals("")) {
				strProxyPath = "/home/experdb/app/eXperDB-Management/eXperDB-Proxy";
			}
		}

		/* Scale in/out 사용여부 */
		System.out.println("Whether to enable eXperDB-Scale settings? (y, n)");
		strScaleYN = scan.nextLine();
		strScaleYN = strScaleYN.toUpperCase();
		while (true) {
			if(strScaleYN.equals("")) {
				System.out.println("Please enter your eXperDB-Scale setting yn. ");
				System.out.println("Whether to enable eXperDB-Scale settings? (y, n) :");
				strScaleYN = scan.nextLine();
				strScaleYN = strScaleYN.toUpperCase();
			} else {
				break;
			}
		}

		if(strScaleYN.equals("Y")){
			System.out.println("eXperDB-Scale scale_path(/home/experdb/.experscale):");
			strScalePath = scan.nextLine();
			if(strScalePath.equals("")) {
				strScalePath = "/home/experdb/.experscale";
			}

			System.out.println("eXperDB-Scale scale_in_cmd (./experscale scale-in -id %s):");
			strScaleInCmd = scan.nextLine();
			if(strScaleInCmd.equals("")) {
				strScaleInCmd = "./experscale scale-in -id %s";
			}

			System.out.println("eXperDB-Scale scale_out_cmd (./experscale scale-out -id %s):");
			strScaleOutCmd = scan.nextLine();
			if(strScaleOutCmd.equals("")) {
				strScaleOutCmd = "./experscale scale-out -id %s";
			}

			System.out.println("eXperDB-Scale scale_in_multi_cmd (./experscale multi-scale-in --scale-in-count %s):");
			strScaleInMultiCmd = scan.nextLine();
			if(strScaleInMultiCmd.equals("")) {
				strScaleInMultiCmd = "./experscale multi-scale-in --scale-in-count %s";
			}

			System.out.println("eXperDB-Scale scale_out_multi_cmd (./experscale multi-scale-out --scale-out-count %s):");
			strScaleOutMultiCmd = scan.nextLine();
			if(strScaleOutMultiCmd.equals("")) {
				strScaleOutMultiCmd = "./experscale multi-scale-out --scale-out-count %s";
			}

			System.out.println("eXperDB-Scale scale_json_view (aws ec2 describe-instances %s --filters ):");
			strScaleJsonView = scan.nextLine();
			if(strScaleJsonView.equals("")) {
				strScaleJsonView = "aws ec2 describe-instances %s --filters ";
			}

			System.out.println("eXperDB-Scale scale_chk_prgress (ps -ef | grep -v grep | grep %s | wc -l):");
			strScaleChkPrgress = scan.nextLine();
			if(strScaleChkPrgress.equals("")) {
				strScaleChkPrgress = "ps -ef | grep -v grep | grep %s | wc -l";
			}
		}

		/* eXperDB-Encrypt 설치 */
		System.out.println("Whether eXperDB-Encrypt is enabled? (y, n)");
		String strEnctyptYn = scan.nextLine();
		strEnctyptYn = strEnctyptYn.toUpperCase();
		if(strEnctyptYn.equals("Y")) {
			System.out.println("eXperDB-Encrypt server.url (127.0.0.1):");
			strEncryptServerUrl = scan.nextLine();
			if(strEncryptServerUrl.equals("")) {
				strEncryptServerUrl = "127.0.0.1";
			}

			System.out.println("eXperDB-Encrypt server.port (9443) :");
			strEncryptServerPort = scan.nextLine();
			if(strEncryptServerPort.equals("")) {
				strEncryptServerPort = "9443";
			}
		}

		strDatabaseUrl = "jdbc:postgresql://" + strDatabaseIp + ":" + strDatabasePort + "/" + strDatabaseUsername;

		//아크서버, 백업을위한 DBURL 추가 (2021-04-13 변승우)
		strBackupDatabaseUrl = "jdbc:postgresql://" + strDatabaseIp + ":" + strDatabasePort + "/ARCserveLinuxD2D";
		strActivitylogDatabaseUrl = "jdbc:postgresql://" + strDatabaseIp + ":" + strDatabasePort + "/ActivityLog";
		strJobhistoryDatabaseUrl = "jdbc:postgresql://" + strDatabaseIp + ":" + strDatabasePort + "/JobHistory";

		System.out.println("################globals.properties##################");
		System.out.println("Repository database IP address :" + strDatabaseIp);
		System.out.println("Repository database port :" + strDatabasePort);		
		System.out.println("Repository database username :" + strDatabaseUsername);
		System.out.println("Repository database password :" + strDatabasePassword);
		System.out.println("Repository database Access information :" + strDatabaseUrl);
		System.out.println("Whether to enable auditing settings : " + strAuditYN);
		System.out.println("Whether to enable Backup settings : " + strBackupYN);
		System.out.println("Whether data transfer is enabled : " + strTransferYN);
		System.out.println("eXperDB-DB2PG installation path : " + strDb2pgPath);
		System.out.println("###################eXperDB-Scale##################");
		System.out.println("Whether scale is enabled : " + strScaleYN);

		System.out.println("Whether proxy menu is enabled : " + strProxyMenuYN);
		System.out.println("Whether proxy-service is enabled : " + strProxyYN);

		if(strScaleYN.equals("Y")){
			System.out.println("eXperDB-Scale scale_path : " + strScalePath);
			System.out.println("eXperDB-Scale scale_in_cmd : " + strScaleInCmd);
			System.out.println("eXperDB-Scale scale_out_cmd : " + strScaleOutCmd);
			System.out.println("eXperDB-Scale scale_in_multi_cmd : " + strScaleInMultiCmd);
			System.out.println("eXperDB-Scale scale_out_multi_cmd : " + strScaleOutMultiCmd);
			System.out.println("eXperDB-Scale scale_json_view : " + strScaleJsonView);
			System.out.println("eXperDB-Scale scale_chk_prgress : " + strScaleChkPrgress);
		}
		System.out.println("##################################################");

		System.out.println("###################eXperDB-Encrypt##################");
		System.out.println("Whether eXperDB-Encrypt is enabled : " + strEnctyptYn);
		if(strEnctyptYn.equals("Y")){
			System.out.println("eXperDB-Encrypt server.url :" + strEncryptServerUrl);
			System.out.println("eXperDB-Encrypt server.port :" + strEncryptServerPort);	
		}
		System.out.println("##################################################");

		System.out.println("Do you want to apply what you entered? (y, n)");
		String strApply = scan.nextLine();
		if(strApply.equals("y")) {

			StandardPBEStringEncryptor pbeEnc = new StandardPBEStringEncryptor();
			pbeEnc.setPassword("k4mda"); // PBE 값(XML PASSWORD설정)

			String url = pbeEnc.encrypt(strDatabaseUrl);
			String username = pbeEnc.encrypt(strDatabaseUsername);
			String password = pbeEnc.encrypt(strDatabasePassword);

			//아크서버, 백업을위한 DBURL 추가 (2021-04-13 변승우)
			String backupUrl = pbeEnc.encrypt(strBackupDatabaseUrl);
			String activitylUrl = pbeEnc.encrypt(strActivitylogDatabaseUrl);
			String jobhistoryUrl = pbeEnc.encrypt(strJobhistoryDatabaseUrl);		    
			String backupPw = pbeEnc.encrypt(strRootPw);

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

			prop.setProperty("version", strVersion);
			prop.setProperty("lang", strLanguage);
			prop.setProperty("database.url", "ENC(" + url + ")");
			prop.setProperty("database.username", "ENC(" + username + ")");
			prop.setProperty("database.password", "ENC(" + password + ")");

			//아크서버, 백업을위한 DBURL 추가 (2021-04-13 변승우)
			prop.setProperty("backupdb.url", "ENC(" + backupUrl + ")");
			prop.setProperty("activitylog.url", "ENC(" + activitylUrl + ")");
			prop.setProperty("jobhistory.url", "ENC(" + jobhistoryUrl + ")");

			if(strBackupYN.equals("Y")){
				prop.setProperty("backup.url", strDatabaseIp);
				prop.setProperty("backup.username", "root");
				prop.setProperty("backup.password", backupPw);
				prop.setProperty("backup.port", strSshPort);
				prop.setProperty("bnr.license", strBnrLicense);
			}

			prop.setProperty("pg_audit", strAuditYN);
			prop.setProperty("bnr.useyn", strBackupYN);
			prop.setProperty("transfer", strTransferYN);	
			prop.setProperty("transfer_ora", strTransferOraYN);

			if(strScaleYN.equals("Y")){
				prop.setProperty("scale", strScaleYN);	
				prop.setProperty("scale_path", strScalePath);	
				prop.setProperty("scale_in_cmd", strScaleInCmd);
				prop.setProperty("scale_out_cmd", strScaleOutCmd);	
				prop.setProperty("scale_in_multi_cmd", strScaleInMultiCmd);	
				prop.setProperty("scale_out_multi_cmd", strScaleOutMultiCmd);	
				prop.setProperty("scale_json_view", strScaleJsonView);	
				prop.setProperty("scale_chk_prgress", strScaleChkPrgress);	
			}else{
				prop.setProperty("scale", strScaleYN);	
			}

			prop.setProperty("proxy.menu.useyn", strProxyMenuYN);
			prop.setProperty("proxy.useyn", strProxyYN);

			if(strProxyYN.equals("Y")){
				prop.setProperty("proxy_path", strProxyPath);	
			}

			prop.setProperty("db2pg_path", strDb2pgPath);

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