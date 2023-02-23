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
 * 매니지먼트 모드 세팅
 * 
* @author 박태혁
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2018.04.23   박태혁 		최초 생성
*  2023.01.17	강병석		에이전트 통합 프록시 에이전트 코드 추가 및 수정
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
		
		//공통정보
		String strDatabaseIp = "";
		String strDatabasePort = "";
		String strDatabaseName = "";
		String strDatabaseUrl = "";
		
		String strDatabaseUsername = "";
		String strDatabasePassword = "";
		String strAgentIp = "";
		String strAgentPort = "";
		
		//전송정보
		String strTransPath = "";

		//프록시 사용 정보
		String strProxyYN = "";
		String strProxyInterYN = "";
		String strProxyInterIP = "";
		String strTransYN = "";
		
		//scale
		String strScaleYN = "";
		String strScalePath = "";
		String strScaleInCmd = "";
		String strScaleOutCmd = "";
		String strScaleInMultiCmd = "";
		String strScaleOutMultiCmd = "";
		String strScaleJsonView = "";
		String strScaleChkPrgress = "";
		String strScaleMonIP = "";
		String strScaleMonPort = "";
		String strScaleMonDatabase = "";
		String strScaleMonUser = "";
		String strScaleMonPassword = "";
		
		//=====================================
		//프록시 변수
		//프록시 내부 IP 정보
		String strAgentInnerIPUseYn = "";
		String strAgentInnerIP="";
		
		//프록시 에이전트 설정 정보
		String strAgentPath = "";
		String strConfBackupPath = "";
		String strKeepInstaillYn = "";
		String strProxyUser = "";
		String strProxyGroup = "";
		String strAWSUseYn="";
		String strProxyServerYn="N";
		
		//유틸리티
		Scanner scan = new Scanner(System.in);
		String localIp = NetworkUtil.getLocalServerIp();
		
	    //에이전트 설정 파일 호출
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
	
		
		
		//=======공통정보=========
		//IP 입력
		System.out.println("==========================================");
		System.out.println("agent ip(" + localIp + ") : ");
		strAgentIp = scan.nextLine();
		//strAgentIp = localIp;
		
		//IP 입력, 공백 확인 추가
		while (true) {
			if(strAgentIp.equals("")) {
				System.out.println("Please enter the IP. ");
				
				System.out.println("agent ip(" + localIp + ") : ");
				
				strAgentIp = scan.nextLine();
			} else {
				break;
			}
		}
		
		//포트 입력
		System.out.println("agent port(9001) :");
		
		strAgentPort = scan.nextLine();
		
		while (true) {
			if(strAgentPort.equals("")) {
				System.out.println("Please enter the port. ");
				
				System.out.println("agent port(9001) :");
				
				strAgentPort = scan.nextLine();
			} else {
				break;
			}
		}
		
		//RepoDB IP 입력
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
		
		//RepoDB port 입력
		System.out.println("Repository database Port(5432) :");
		strDatabasePort = scan.nextLine();
		
		while (true) {
			if(strDatabasePort.equals("")) {
				System.out.println("Please enter a Repository database Port. ");
				System.out.println("Repository the database Port(5432) :");
				strDatabasePort = scan.nextLine();
			} else {
				break;
			}
		}
		
		//RepoDB DB명 
		System.out.println("Repository database Name(experdb) :");
		strDatabaseName = scan.nextLine();
		
		while (true) {
			if(strDatabaseName.equals("")) {
				System.out.println("Please enter a Repository database Name. ");
				System.out.println("Repository database Name(experdb) :");
				strDatabaseName = scan.nextLine();
			} else {
				break;
			}
		}
		
		//RepoDB 유저명
		System.out.println("Repository database.username(experdb) :");
		strDatabaseUsername = scan.nextLine();
		
		while (true) {
			if(strDatabaseName.equals("")) {
				System.out.println("Please enter your Repository database username. ");
				System.out.println("Repository database.username(experdb) :");
				strDatabaseUsername = scan.nextLine();
			} else {
				break;
			}
		}
		
		//RepoDB 유저 패스워드
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

		
		
		
		//=============================================================
		//MGMT 내용
		
		System.out.println("====================================");
		System.out.println("eXperDB-Agent Management Setting");
		
		/* CDC 사용여부 */
		System.out.println("Whether CDC-Service is enabled (y, n) :");
		strTransYN = scan.nextLine();
		strTransYN = strTransYN.toUpperCase();
		while (true) {
			if(strTransYN.equals("")) {
				System.out.println("Please enter your CDC-Service setting yn. ");
				System.out.println("Whether CDC-Service is enabled (y, n) :");
				strTransYN = scan.nextLine();
				strTransYN = strTransYN.toUpperCase();
			} else {
				break;
			}
		}

		//cdc 사용일 경우
		if(strTransYN.equals("Y")){
			//trans setting 추가
			System.out.println("trans path :(/home/experdb/programs/kafka)");
			strTransPath = scan.nextLine();
			if(strTransPath.equals("")) {
				strTransPath = "/home/experdb/programs/kafka";
			} 
		}
		////////////////////////////////////////////////////////////////////////////////////
		
		////////////////////////////////////////////////////////////////////////////////////
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
		////////////////////////////////////////////////////////////////////////////////////
		
		////////////////////////////////////////////////////////////////////////////////////
		/* Scale in/out 사용여부 */
		System.out.println("Whether eXperDB-Scale is enabled (y, n) :");
		strScaleYN = scan.nextLine();
		strScaleYN = strScaleYN.toUpperCase();
		while (true) {
			if(strScaleYN.equals("")) {
				System.out.println("Please enter your PeXperDB-Scale setting yn. ");
				System.out.println("Whether eXperDB-Scale is enabled (y, n) :");
				strScaleYN = scan.nextLine();
				strScaleYN = strScaleYN.toUpperCase();
			} else {
				break;
			}
		}

		/* Scale in/out 사용여부 */
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
			
			System.out.println("Please enter a Monitoring Repository database IP. ");
			System.out.println("eXperDB-Scale monitoring_server_ip("+strDatabaseIp+") : ");
			strScaleMonIP = scan.nextLine();
			if(strScaleMonIP.equals("")) {
				strScaleMonIP = strDatabaseIp;
			}
			
			System.out.println("Please enter a Monitoring Repository database Port. ");
			System.out.println("eXperDB-Scale monitoring_server_port("+strDatabasePort+") : ");
			strScaleMonPort = scan.nextLine();
			if(strScaleMonPort.equals("")) {
				strScaleMonPort = strDatabasePort;
			}
			
			if(!strScaleMonIP.equals(strDatabaseIp)){
				System.out.println("eXperDB-Scale monitoring_server_database(experdb) : ");
				strScaleMonDatabase = scan.nextLine();
				if(strScaleMonDatabase.equals("")) {
					strScaleMonDatabase = "experdb";
				}
				System.out.println("eXperDB-Scale monitoring_server_user(pgmon) : ");
				strScaleMonUser = scan.nextLine();
				if(strScaleMonUser.equals("")) {
					strScaleMonUser = "pgmon";
				}
				System.out.println("eXperDB-Scale monitoring_server_password(pgmon) : ");
				strScaleMonPassword = scan.nextLine();
				if(strScaleMonPassword.equals("")) {
					strScaleMonPassword = "pgmon";
				}
			} else {
				strScaleMonDatabase = strDatabaseName;
				strScaleMonUser = "pgmon";
				strScaleMonPassword = "pgmon";
			}
		}
		
		//====================================================
	
		
		//====================================================
		//프록시 에이전트 추가
		
		if("Y".equals(strProxyYN)) {
			System.out.println("====================================");
			System.out.println("eXperDB-Agent Proxy Setting");
			
			//서버 분리 유무 입력
			System.out.println("Server use Proxy Only(default : Y) : ");
			strProxyServerYn = scan.nextLine();
			if(strProxyServerYn.equals("")) {
				strProxyServerYn = "Y";
			}
			
			//사용자, 그룹 입력
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
			
			
			//내부 IP 사용 여부
			System.out.println("Whether to Proxy use internal IP (Y/N) :");
			strAgentInnerIPUseYn = scan.nextLine().toUpperCase();
			if(strAgentInnerIPUseYn.equals("Y")){
				System.out.println("Proxy Agent Inner IP : ");
				strAgentInnerIP = scan.nextLine();
				
				while(true){
					if(strAgentInnerIP.equals("")) {
						System.out.println("Please enter Inner IP of the Proxy Agent!!! ");
						System.out.println("Proxy Agent Inner IP : ");
						strAgentInnerIP = scan.nextLine();
					} else {
						break;
					}
				}
			}else{
				strAgentInnerIPUseYn="N";
			}
		
			//에이전트 설치 경로(고정)
			strAgentPath = "/experdb/app/eXperDB-Agent/bin";
			strConfBackupPath = "/experdb/app/eXperDB-Agent/backup";
			
			//keepalived 설치 여부
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
			
			//AWS 사용 여부
			System.out.println("Is installed the proxy in AWS (Y/N) :");
			strAWSUseYn = scan.nextLine();
			strAWSUseYn = strAWSUseYn.toUpperCase();
			
			while (true) {
				if(strAWSUseYn.equals("")) {
					System.out.println("Is installed the proxy in AWS (Y/N) :");
					strAWSUseYn = scan.nextLine();
				} else {
					break;
				}
			}	
		}		
		
		//====================================================
		
		//연결 DataBase 설정
		strDatabaseUrl = "jdbc:postgresql://" + strDatabaseIp + ":" + strDatabasePort + "/" + strDatabaseName;
		
		
		
		//입력 내용 최종 확인
		System.out.println("#####################################################");
		System.out.println("agent ip :" + strAgentIp);
		System.out.println("agent port :" + strAgentPort);
		System.out.println("database Connection Info :" + strDatabaseUrl);
		System.out.println("database.username :" + strDatabaseUsername);
		System.out.println("database.password :" + strDatabasePassword);
		
		
		
		System.out.println("#####################################################");
		
		//입력 내용 최종확인(MGMT)
		System.out.println("eXperDB-Agent Management");
		
		System.out.println("trans_yn :" + strTransYN);
		System.out.println("trans_path :" + strTransPath);

		System.out.println("proxy_yn :" + strProxyYN);
		System.out.println("proxy_inter_yn :" + strProxyInterYN);
		System.out.println("proxy_inter_ip :" + strProxyInterIP);
		
		System.out.println("scale_yn :" + strScaleYN);
		System.out.println("scale_path : " + strScalePath);
		System.out.println("scale_in_cmd : " + strScaleInCmd);
		System.out.println("scale_out_cmd : " + strScaleOutCmd);
		System.out.println("scale_in_multi_cmd : " + strScaleInMultiCmd);
		System.out.println("scale_out_multi_cmd : " + strScaleOutMultiCmd);
		System.out.println("scale_json_view : " + strScaleJsonView);
		System.out.println("scale_chk_prgress : " + strScaleChkPrgress);
		System.out.println("scale_monitoring_ip : " + strScaleMonIP);
		System.out.println("scale_monitoring_port : " + strScaleMonPort);
		System.out.println("scale_monitoring_database : " + strScaleMonDatabase);
		System.out.println("scale_monitoring_user : " + strScaleMonUser);
		System.out.println("scale_monitoring_password : " + strScaleMonPassword);
		System.out.println("#####################################################");
	
		
		//입력 내용 최종 확인(Proxy)
		if("Y".equals(strProxyYN)) {
			System.out.println("eXperDB-Agent Proxy");
			
			System.out.println("agent inner ip :"+strAgentInnerIP);
			System.out.println("keepalived install :" + strKeepInstaillYn);
			System.out.println("installed in AWS :" + strAWSUseYn);
			System.out.println("Server Proxy Only :" + strProxyServerYn);
			System.out.println("#####################################################");
		}
		

		System.out.println("Do you want to apply what you entered? (y, n)");
		String strApply = scan.nextLine();

		//설정 파일에 입력 내용 추가
		if(strApply.equals("y")) {
		    StandardPBEStringEncryptor pbeEnc = new StandardPBEStringEncryptor();
		    pbeEnc.setPassword("k4mda"); // PBE 값(XML PASSWORD설정)
		    
			
		    String url = pbeEnc.encrypt(strDatabaseUrl);
		    String username = pbeEnc.encrypt(strDatabaseUsername);
		    String password = pbeEnc.encrypt(strDatabasePassword);
		    
		    String mon_user = pbeEnc.encrypt(strScaleMonUser);
		    String mon_passwd = pbeEnc.encrypt(strScaleMonPassword);
		    
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
			
			prop.setProperty("repoDB_ip", strDatabaseIp);
		    
			//공통 설정
		    prop.setProperty("database.url", "ENC(" + url + ")");
		    prop.setProperty("database.username", "ENC(" + username + ")");
		    prop.setProperty("database.password", "ENC(" + password + ")");
		    prop.setProperty("agent.install.ip", strAgentIp);
		    prop.setProperty("socket.server.port", strAgentPort);

		    //MGMT 설정
		    prop.setProperty("agent.trans_yn", strTransYN);
		    prop.setProperty("agent.trans_path", strTransPath);
		    

		    prop.setProperty("agent.proxy_yn", strProxyYN);
		    prop.setProperty("agent.proxy_inter_yn", strProxyInterYN);
		    prop.setProperty("agent.proxy_inter_ip", strProxyInterIP);

		    prop.setProperty("agent.scale_yn", strScaleYN);
		    prop.setProperty("agent.scale_auto_reset_time", "0 0/5 * 1/1 * ? *");
		    prop.setProperty("agent.scale_path", strScalePath);
		    prop.setProperty("agent.scale_in_cmd", strScaleInCmd);
		    prop.setProperty("agent.scale_out_cmd", strScaleOutCmd);
		    prop.setProperty("agent.scale_in_multi_cmd", strScaleInMultiCmd);
		    prop.setProperty("agent.scale_out_multi_cmd", strScaleOutMultiCmd);
		    prop.setProperty("agent.scale_json_view", strScaleJsonView);
		    prop.setProperty("agent.scale_chk_prgress", strScaleChkPrgress);
		    prop.setProperty("agent.scale_monitoring_ip", strScaleMonIP);
		    prop.setProperty("agent.scale_monitoring_port", strScaleMonPort);
		    prop.setProperty("agent.scale_monitoring_database", strScaleMonDatabase);
		    prop.setProperty("agent.scale_monitoring_user", mon_user);
		    prop.setProperty("agent.scale_monitoring_passwd", mon_passwd);
		    
		    /* prop.setProperty("agent.scale_monitoring_user", "ENC(" + mon_user + ")");
		    prop.setProperty("agent.scale_monitoring_passwd", "ENC(" + mon_passwd + ")"); */
	    
		    
		    //Proxy 설정
		    if("Y".equals(strProxyYN)){
			    prop.setProperty("keepalived.install.yn", strKeepInstaillYn);
				prop.setProperty("aws.yn", strAWSUseYn);
				prop.setProperty("agent.inner.ip.useyn", strAgentInnerIPUseYn);
				prop.setProperty("agent.inner.ip", strAgentInnerIP);
				prop.setProperty("agent.path", strAgentPath);
				prop.setProperty("proxy.conf_backup_path", strConfBackupPath);
				prop.setProperty("proxy.global.user", strProxyUser);
				prop.setProperty("proxy.global.group", strProxyGroup);
		    }
		    
		    //프록시 서버 분리 유무
			prop.setProperty("proxy.global.serveryn", strProxyServerYn);
		    
		    //설정 파일 저장
		    try {
		    	prop.store(new FileOutputStream(path + "context.properties"), "");
		    } catch(FileNotFoundException e) {
		    	System.out.println("Exit(0) Error : File Not Found ");
		    	System.exit(0);
		    } catch(Exception e) {
		    	System.out.println("Exit(0) Error : " + e.toString());
		    	System.exit(0);
		    }
		    System.out.println("#### eXperDB-Agent Setting success !! #####");
		} else {
			System.out.println("#### Exit(0) Cancel Agent Setting #####");
		}
	}
}