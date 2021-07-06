package com.k4m.dx.tcontrol;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;
import java.util.Scanner;

import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;

import com.k4m.dx.tcontrol.util.NetworkUtil;


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
		
		String strTransPath = "";

		String strProxyYN = "";
		String strProxyInterYN = "";
		String strProxyInterIP = "";

		Scanner scan = new Scanner(System.in);
		
		String localIp = NetworkUtil.getLocalServerIp();
		
		//System.out.println("agent ip : " + localIp);
		System.out.println("agent ip : ");
		strAgentIp = scan.nextLine();
		//strAgentIp = localIp;
		
		System.out.println("agent port :");
		
		strAgentPort = scan.nextLine();
		
		while (true) {
			if(strAgentPort.equals("")) {
				System.out.println("Please enter the port. ");
				
				System.out.println("agent port :");
				
				strAgentPort = scan.nextLine();
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
		
		System.out.println("Repository database Name :");
		
		strDatabaseName = scan.nextLine();
		
		while (true) {
			if(strDatabaseName.equals("")) {
				System.out.println("Please enter a Repository database Name. ");
				
				System.out.println("Repository database Name :");
				
				strDatabaseName = scan.nextLine();
			} else {
				break;
			}
		}
		
		
		System.out.println("Repository database.username :");
		
		strDatabaseUsername = scan.nextLine();
		
		while (true) {
			if(strDatabaseName.equals("")) {
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
			if(strDatabaseName.equals("")) {
				System.out.println("Please enter your Repository database password. ");
				
				System.out.println("Repository database.password :");
				
				strDatabasePassword = scan.nextLine();
			} else {
				break;
			}
		}
		
		//trans setting 추가
		System.out.println("trans path :(/home/experdb/programs/kafka)");
		strTransPath = scan.nextLine();
		if(strTransPath.equals("")) {
			strTransPath = "/home/experdb/programs/kafka";
		} 
		
		/* Proxy in/out 사용여부 */
		System.out.println("Whether Proxy-Service is enabled (y, n) :");
		strProxyYN = scan.nextLine();
		strProxyYN = strProxyYN.toUpperCase();
		while (true) {
			if(strProxyYN.equals("")) {
				System.out.println("Please enter your Proxy-Service setting yn. ");
				System.out.println("Whether Proxy Service is enabled (y, n) :");
				strProxyYN = scan.nextLine();
				strProxyYN = strProxyYN.toUpperCase();
			} else {
				break;
			}
		}

		//proxy 내부 ip 사용여부
		if(strProxyYN.equals("Y")){
			System.out.println("Whether to Proxy use internal IP (y, n) :");
			strProxyInterYN = scan.nextLine();
			strProxyInterYN = strProxyInterYN.toUpperCase();

			while (true) {
				if(strProxyInterYN.equals("")) {
					System.out.println("Please enter your Proxy use internal IP yn. ");
					System.out.println("Whether to Proxy use internal IP (y, n) :");
					strProxyInterYN = scan.nextLine();
					strProxyInterYN = strProxyInterYN.toUpperCase();
				} else {
					break;
				}
			}
		}

		//proxy 내부 ip 
		if(strProxyInterYN.equals("Y")){
			System.out.println("Proxy Internal IP :");
			strProxyInterIP = scan.nextLine();
			strProxyInterIP = strProxyInterIP.toUpperCase();

			while (true) {
				if(strProxyInterIP.equals("")) {
					System.out.println("Please enter your Proxy Internal IP. ");
					System.out.println("Proxy Internal IP :");
					strProxyInterIP = scan.nextLine();
					strProxyInterIP = strProxyInterIP.toUpperCase();
				} else {
					break;
				}
			}
		}
		
		strDatabaseUrl = "jdbc:postgresql://" + strDatabaseIp + ":" + strDatabasePort + "/" + strDatabaseName;
		
		System.out.println("#####################################################");
		System.out.println("agent ip :" + strAgentIp);
		System.out.println("agent port :" + strAgentPort);
		System.out.println("database Connection Info :" + strDatabaseUrl);
		System.out.println("database.username :" + strDatabaseUsername);
		System.out.println("database.password :" + strDatabasePassword);
		System.out.println("trans_path :" + strTransPath);

		System.out.println("proxy_yn :" + strProxyYN);
		System.out.println("proxy_inter_yn :" + strProxyInterYN);
		System.out.println("proxy_inter_ip :" + strProxyInterIP);
		System.out.println("#####################################################");
		
		

		
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
		    File file = new File(loader.getResource("context.properties").getFile());
		    
		    String path = file.getParent() + File.separator;
		    
		   // System.out.println(path);
		    
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
		    
		    prop.setProperty("socket.server.port", strAgentPort);
		    prop.setProperty("agent.install.ip", strAgentIp);

		    prop.setProperty("agent.trans_path", strTransPath);
		    

		    prop.setProperty("agent.proxy_yn", strProxyYN);
		    prop.setProperty("agent.proxy_inter_yn", strProxyInterYN);
		    prop.setProperty("agent.proxy_inter_ip", strProxyInterIP);

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
