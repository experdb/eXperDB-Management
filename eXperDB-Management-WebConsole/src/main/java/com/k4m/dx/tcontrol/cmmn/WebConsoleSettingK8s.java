package com.k4m.dx.tcontrol.cmmn;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;

public class WebConsoleSettingK8s {
	/*
	 *  webconsole setting for kubernetes
	 *  
	 *  args
	 *  0: repo ip
	 *  1: repo port
	 *  2: encrypt YN
	 *  3: encrypt ip
	 *  4: encrypt port
	 */
	
	public static void main(String[] args) throws Exception {
		String strLanguage ="ko";
		String strVersion ="eXperDB-Management-WebConsole-13.0.4";

		String strDatabaseIp = args[0];
		String strDatabasePort = args[1];
		String strDatabaseUsername = "experdb";
		String strDatabasePassword = "experdb";
		String strDatabaseUrl = "";

		String strBackupDatabaseUrl = "";
		String strActivitylogDatabaseUrl = "";
		String strJobhistoryDatabaseUrl = "";

		String strBnrLicense  = "";

		String strTransferYN ="N";

		//2020.09.23 trans 컨슈머 전송 추가
		//2021.09.09 trans 모니터링 메뉴 사용여부 추가
		String strTransferOraYN ="N";
		String strAuditYN="N";
		String strTransferMonMenuYN="N";
		
		// 2021-04-13 백업사용 유무 추가 변승우
		String strBackupYN = "N";
		String strRootPw = "";
		String strSshPort = "";

		String strScaleYN="N";
		String strScalePath="";
		String strScaleInCmd="";
		String strScaleOutCmd="";
		String strScaleInMultiCmd="";
		String strScaleOutMultiCmd="";
		String strScaleJsonView="";
		String strScaleChkPrgress="";

		String strDb2pgPath = "/experdb/eXperDB-DB2PG";
		
		String strEnctyptYn = args[2];
		String strEncryptServerUrl = args[3];
		String strEncryptServerPort = args[4];

		String strPropertiesPath ="egovframework" + File.separator + "tcontrolProps" + File.separator +"globals.properties";
		String strPropertiesNm ="globals.properties";

		String strProxyMenuYN="N";	//proxy 메뉴 사용여부
		String strProxyYN="N";	//proxy 사용여부
		String strProxyPath="";

		strDatabaseUrl = "jdbc:postgresql://" + strDatabaseIp + ":" + strDatabasePort + "/" + strDatabaseUsername;

		//아크서버, 백업을위한 DBURL 추가 (2021-04-13 변승우)
		strBackupDatabaseUrl = "jdbc:postgresql://" + strDatabaseIp + ":" + strDatabasePort + "/ARCserveLinuxD2D";
		strActivitylogDatabaseUrl = "jdbc:postgresql://" + strDatabaseIp + ":" + strDatabasePort + "/ActivityLog";
		strJobhistoryDatabaseUrl = "jdbc:postgresql://" + strDatabaseIp + ":" + strDatabasePort + "/JobHistory";

		System.out.println("##################################################");

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
		prop.setProperty("transfer_mon_menu", strTransferMonMenuYN);
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

		//모니터링 사용여부 및 path 고정 (2022-03-21 변승우)
		prop.setProperty("monitoring.installyn", "Y");
		prop.setProperty("monitoring_path", "/$PGMHOME/files");
		
		
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
		System.out.println("######### WebConsole Setting success !! #########");
	}
}
