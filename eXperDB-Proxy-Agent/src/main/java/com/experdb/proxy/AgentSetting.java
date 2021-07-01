package com.experdb.proxy;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;
import java.util.Scanner;

import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;

import com.experdb.proxy.util.NetworkUtil;

/**
* @author 최정환
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2021.02.25   최정환 	최초 생성
*      </pre>
*/
public class AgentSetting {
	
	public static void main(String[] args) throws Exception {
		/**
		 * 1. database.url
		 * 2. database.username
		 * 3. database.password
		 * 4. socket.server.port
		 * 5. agent.install.ip
		 */
		String strDatabaseIp = "";
		String strDatabasePort = "";
		String strDatabaseName = "";
		String strDatabaseUrl = "";

		String strDatabaseUsername = "";
		String strDatabasePassword = "";
		String strAgentIp = "";
		String strAgentPort = "";
		
		String strAgentPath = "";
		String strConfBackupPath = "";
		String strKeepInstaillYn = "";
		
		String strProxyUser = "";
		String strProxyGroup = "";

		Scanner scan = new Scanner(System.in);
		String localIp = NetworkUtil.getLocalServerIp();
		
		//agent ip port 확인
		System.out.println("agent ip(" + localIp + ") : ");
		strAgentIp = scan.nextLine();

		if(strAgentIp.equals("")) {
			strAgentIp = localIp;
		}

		System.out.println("agent port(9002) : ");
		strAgentPort = scan.nextLine();
		if(strAgentPort.equals("")) {
			strAgentPort = "9002";
		}
		
		System.out.println("proxy global user(exproxy) : ");
		strProxyUser = scan.nextLine();
		if(strProxyUser.equals("")) {
			strProxyUser = "exproxy";
		}
		
		System.out.println("proxy global group(exproxy) : ");
		strProxyGroup = scan.nextLine();
		if(strProxyGroup.equals("")) {
			strProxyGroup = "exproxy";
		}

		System.out.println("agent path :(/root/app/eXperDB-Proxy-Agent/bin)");
		strAgentPath = scan.nextLine();
		if(strAgentPath.equals("")) {
			strAgentPath = "/root/app/eXperDB-Proxy-Agent/bin";
		} 
		
		System.out.println("proxy config backup path :(/root/app/eXperDB-Proxy-Agent/backup)");
		strConfBackupPath = scan.nextLine();
		if(strConfBackupPath.equals("")) {
			strConfBackupPath = "/root/app/eXperDB-Proxy-Agent/backup";
		} 
	
		System.out.println("keepalived install Status (Y/N) :");
		strKeepInstaillYn = scan.nextLine();
		strKeepInstaillYn = strKeepInstaillYn.toUpperCase();
		while (true) {
			if(strKeepInstaillYn.equals("")) {
				System.out.println("Please enter the keepalived install Status. ");
				
				System.out.println("keepalived install Status (Y/N) :");
				
				strKeepInstaillYn = scan.nextLine();
				strKeepInstaillYn = strKeepInstaillYn.toUpperCase();
			} else {
				break;
			}
		}
		
		/////////////////////////////////////////////////////////////////////
		
		//Repository db 설정
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
		
		System.out.println("Repository database Port(5432) :");
		strDatabasePort = scan.nextLine();
		if(strDatabasePort.equals("")) {
			strDatabasePort = "5432";
		}

		System.out.println("Repository database Name(experdb) :");
		strDatabaseName = scan.nextLine();
		if(strDatabaseName.equals("")) {
			strDatabaseName = "experdb";
		}
		
		System.out.println("Repository database.username(experdb) :");
		strDatabaseUsername = scan.nextLine();
		if(strDatabaseUsername.equals("")) {
			strDatabaseUsername = "experdb";
		}
		///////////////////////////////////////////////////

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

		//database 설정
		strDatabaseUrl = "jdbc:postgresql://" + strDatabaseIp + ":" + strDatabasePort + "/" + strDatabaseName;
		
		System.out.println("#####################################################");
		System.out.println("agent ip :" + strAgentIp);
		System.out.println("agent port :" + strAgentPort);
		System.out.println("keepalived install :" + strKeepInstaillYn);
		System.out.println("database Connection Info :" + strDatabaseUrl);
		System.out.println("database.username :" + strDatabaseUsername);
		System.out.println("database.password :" + strDatabasePassword);
		System.out.println("#####################################################");
		
		System.out.println("Do you want to apply what you entered? (y, n)");
		String strApply = scan.nextLine();
		
		if(strApply.equals("y")) {
			StandardPBEStringEncryptor pbeEnc = new StandardPBEStringEncryptor();
			pbeEnc.setPassword("experdba"); // PBE 값(XML PASSWORD설정)

			String url = pbeEnc.encrypt(strDatabaseUrl);
			String username = pbeEnc.encrypt(strDatabaseUsername);
			String password = pbeEnc.encrypt(strDatabasePassword);

			Properties prop = new Properties();

			ClassLoader loader = Thread.currentThread().getContextClassLoader();
			File file = new File(loader.getResource("context.properties").getFile());

			String path = file.getParent() + File.separator;

			try {
				prop.load(new FileInputStream(path + "context.properties"));
			} catch(FileNotFoundException e) {
				System.out.println("Exit(0) File Not Found ");
				System.exit(0);
			} catch(Exception e) {
				System.out.println("Exit(0) Error : " + e.toString());
				System.exit(0);
			}

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

			prop.setProperty("database.url", "ENC(" + url + ")");
			prop.setProperty("database.username", "ENC(" + username + ")");
			prop.setProperty("database.password", "ENC(" + password + ")");

			prop.setProperty("keepalived.install.yn", strKeepInstaillYn);
			
			prop.setProperty("socket.server.port", strAgentPort);
			prop.setProperty("agent.install.ip", strAgentIp);
			prop.setProperty("agent.path", strAgentPath);
			prop.setProperty("proxy.conf_backup_path", strConfBackupPath);
			prop.setProperty("proxy.global.user", strProxyUser);
			prop.setProperty("proxy.global.group", strProxyGroup);

			try {
				prop.store(new FileOutputStream(path + "context.properties"), "");
			} catch(FileNotFoundException e) {
				System.out.println("Exit(0) Error : File Not Found ");
				System.exit(0);
			} catch(Exception e) {
				System.out.println("Exit(0) Error : " + e.toString());
				System.exit(0);
			}

			System.out.println("#### Agent Setting success !! #####");
		} else {
			System.out.println("#### Exit(0) Cancel Agent Setting #####");
		}
	}
}
