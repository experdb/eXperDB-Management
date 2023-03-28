package com.k4m.dx.tcontrol;

import java.io.FileInputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.util.ResourceUtils;

import com.experdb.proxy.socket.listener.DXTcontrolProxy;
import com.experdb.proxy.socket.listener.DXTcontrolProxyExecute;
import com.k4m.dx.tcontrol.db.DBCPPoolManager;
import com.k4m.dx.tcontrol.db.repository.service.SystemServiceImpl;
import com.k4m.dx.tcontrol.deamon.DxDaemon;
import com.k4m.dx.tcontrol.deamon.DxDaemonManager;
import com.k4m.dx.tcontrol.deamon.IllegalDxDaemonClassException;
import com.k4m.dx.tcontrol.socket.DXTcontrolAgentSocket;
import com.k4m.dx.tcontrol.socket.listener.DXTcontrolTrans;
import com.k4m.dx.tcontrol.socket.listener.ScaleCheckListener;
import com.k4m.dx.tcontrol.socket.listener.ServerCheckListener;
import com.k4m.dx.tcontrol.socket.listener.TransCheckListener;
import com.k4m.dx.tcontrol.util.FileUtil;

/**
* @author 박태혁
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2018.04.23   박태혁 		최초 생성
*  2022.12.22	강병석		에이전트 통합, 프록시 에이전트 기능 추가
*      </pre>
*/
public class DaemonStart implements DxDaemon{ 
	
	private Logger daemonStartLogger = LoggerFactory.getLogger("DaemonStartLogger");
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");

	private DXTcontrolAgentSocket socketService;
	private ServerCheckListener serverCheckListener;
	private TransCheckListener transCheckListener;
	private ScaleCheckListener scaleCheckListener;
	private Properties prop = new Properties();
	
	public static void main(String args[]) {
		// -shutdown 옵션이 있을 경우 데몬을 종료시킨다.
		if (args.length > 0 && args[0].equals("-shutdown")) {
			try {
				DxDaemonManager sdm = DxDaemonManager.getInstance(DaemonStart.class);
				sdm.shutdownDaemon();
			} catch (IOException e1) {
				//e1.printStackTrace();
			} catch (IllegalDxDaemonClassException e) {
				//e.printStackTrace();
			}
			
			System.out.println("## "+new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
			System.out.println("## eXperDB Agent Dammon Process is Shutdown...");
			
			Logger daemonStartLogger = LoggerFactory.getLogger("DaemonStartLogger");
			daemonStartLogger.info("{} eXperDB Agent Dammon Process is Shutdown...", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
			
			return; // 프로그램 종료.
		}

		DxDaemonManager sdm = null;
		Logger errLogger = LoggerFactory.getLogger("errorToFile");

		try {
			sdm = DxDaemonManager.getInstance(DaemonStart.class);
			sdm.start();
		}  catch (Exception e) {
			errLogger.error("데몬 시작시 에러가 발생하였습니다 shutdown 오류. {}", e.toString());
			e.printStackTrace();
		}
	}
	
	private static ApplicationContext context;

	public static ApplicationContext getContext() {
		return context;
	}

	public static void setContext(ApplicationContext context) {
		DaemonStart.context = context;
	}

	//@Override
	public void startDaemon() {
		
		try {
/*			String strMonitoringYN = FileUtil.getPropertyValue("context.properties", "agent.monitoring.useyn");
			
			if(strMonitoringYN.equals("Y")) {
				context = new ClassPathXmlApplicationContext(new String[] {"context-tcontrol.xml", "context-scheduling.xml"});
			} else {
				context = new ClassPathXmlApplicationContext(new String[] {"context-tcontrol.xml"});
			}*/
			context = new ClassPathXmlApplicationContext(new String[] {"context-tcontrol.xml"});
			
			//설정 파일 불러오기
			prop.load(new FileInputStream(ResourceUtils.getFile("../classes/context.properties")));	
			
			SystemServiceImpl service = null;
			service = (SystemServiceImpl) context.getBean("SystemService");
			
			
			// SqlSessionManager 초기화
			try {
				String strIpadr = FileUtil.getPropertyValue("context.properties", "agent.install.ip");
				String strPort = FileUtil.getPropertyValue("context.properties", "socket.server.port");
				String strVersion = FileUtil.getPropertyValue("context.properties", "agent.install.version");
				
					//MGMT부분
					String strProxyYN = "";
					String strProxyInterYN = "";
					String strProxyInterIP = "";
					
					if (FileUtil.getPropertyValue("context.properties", "agent.proxy_yn").equals("Y")) {
						strProxyYN = FileUtil.getPropertyValue("context.properties", "agent.proxy_yn");	
					}
					
//					if (FileUtil.getPropertyValue("context.properties", "agent.proxy_inter_yn").equals("Y")) {
//						strProxyInterYN = FileUtil.getPropertyValue("context.properties", "agent.proxy_inter_yn");
//					}
//	
//					if (strProxyYN != null && "Y".equals(strProxyYN)) {
//						if (strProxyInterYN != null && "Y".equals(strProxyInterYN)) {
//							strProxyInterIP = FileUtil.getPropertyValue("context.properties", "agent.proxy_inter_ip");
//						}
//					}
					
					//에이전트 실행
					service.agentInfoStartMng(strIpadr, strPort, strVersion, strProxyInterIP);

			} catch (Exception e) {
				errLogger.error("데몬 시작시 에러가 발생하였습니다 sql 초기화 . {}", e.toString());
				e.printStackTrace();
				return;
			}		
			
			//Driver 로딩 
			try {
				Class.forName("org.apache.commons.dbcp.PoolingDriver");
				Class.forName("org.postgresql.Driver");
			} catch (Exception e) {
				errLogger.error("데몬 시작시 에러가 발생하였습니다 드라이버 로딩. {}", e.toString());
				return;			
			}		
			
			mgmtFun();

			
/*			
			try {
				//scale 자동 실행 로직 추가
				DXTcontrolScale rSet = new DXTcontrolScale();
				rSet.start();

			} catch (Exception e) {
				errLogger.error("auto scale 시작시 에러가 발생하였습니다. {}", e.toString());
				e.printStackTrace();
				return;
			}	

*/
			///monitoring task
			//TaskExecuteListener.load();
			
			//serverCheckListener.join();
			
			//MGMT 부분
			System.out.println("######################################################################");
			System.out.println("## load file ");
			System.out.println("## "+new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
			System.out.println("## eXperDB Agent Dammon Process is started...");
			System.out.println("######################################################################");
			
			daemonStartLogger.info("{}", "");
			daemonStartLogger.info("{} {}", "eXperDB Agent Deamon Start..", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));

			service = null;
			
			serverCheckListener = new ServerCheckListener(context);
			serverCheckListener.start();
			
			socketService = new DXTcontrolAgentSocket();
			socketService.start();
			//
		
		} catch(Exception e) {
			errLogger.error("데몬 시작시 에러가 발생하였습니다 종합에러. {}" + e.toString());
			e.printStackTrace();
		}
	}
	
	//mgmt 기능
	public void mgmtFun() {
		// CDC  
		try {
			//trans 설정 setting 추가
			DXTcontrolTrans rSet = new DXTcontrolTrans();
			rSet.start();
		} catch (Exception e) {
			errLogger.error("CDC 설정 시작시 에러가 발생하였습니다. {}", e.toString());
			e.printStackTrace();
			return;
		}
		
		try {
			String strTransYN = FileUtil.getPropertyValue("context.properties", "agent.trans_yn");
			socketLogger.info("strTransYN[] : " + strTransYN);
			//CDC 자동 실행 로직 추가
			if ("Y".equals(strTransYN)) {
				//trans 설정 setting 추가
			//	DXTcontrolTrans rSet = new DXTcontrolTrans();
			//	rSet.start();
				
			//	transCheckListener = new TransCheckListener(context);
			//	transCheckListener.start();
			}
		} catch (Exception e) {
			errLogger.error("CDC 시작시 에러가 발생하였습니다. {}", e.toString());
			e.printStackTrace();
			return;
		}
		
		//scale
		try {
			String strScaleYN = FileUtil.getPropertyValue("context.properties", "agent.scale_yn");
			socketLogger.info("strScaleYN[] : " + strScaleYN);
			//CDC 자동 실행 로직 추가
			if ("Y".equals(strScaleYN)) {
				scaleCheckListener = new ScaleCheckListener(context);
				scaleCheckListener.start();
			}
		} catch (Exception e) {
			errLogger.error("auto scale 시작시 에러가 발생하였습니다. {}", e.toString());
			e.printStackTrace();
			return;
		}	
		
		//프록시 기능
		if(prop.getProperty("agent.proxy_yn").equals("Y")) {
			// SqlSessionManager 초기화
			try {
				//proxy 서버 데이터 생성
				DXTcontrolProxy rSet = new DXTcontrolProxy();
				rSet.start();
			} catch (Exception e) {
				errLogger.error("데몬 proxy 서버 데이터 생성 시 에러가 발생하였습니다.-proxy {}", e.toString());
				e.printStackTrace();
				return;
			}

			// SqlSessionManager 초기화
			try {
				//proxy 서버 실행
				DXTcontrolProxyExecute rExeSet = new DXTcontrolProxyExecute();
				rExeSet.start();
			} catch (Exception e) {
				errLogger.error("proxy exe 데몬 시작시 에러가 발생하였습니다 SQL 세션 불발. {}", e.toString());
				e.printStackTrace();
				return;
			}
		}
	}

	//에이전트 종료
	public void shutdown() {
		try {
			serverCheckListener.interrupt();
			socketService.stop();
			
			this.shutdownPool();
			
			String strIpadr = FileUtil.getPropertyValue("context.properties", "agent.install.ip");
			String strPort = FileUtil.getPropertyValue("context.properties", "socket.server.port");
			
			SystemServiceImpl service = (SystemServiceImpl) context.getBean("SystemService");
			
//			service.agentInfoStopMng(strIpadr, strPort);
			
			//에이전트 종료
			service.agentInfoStopMng(strIpadr, strPort);
		} catch(Exception e) {
			errLogger.error("데몬 종료시 에러가 발생하였습니다. {0}" + e.toString());
			e.printStackTrace();
			
		}
	}
	
	//데몬 종료
	private void shutdownPool() throws Exception {
		DBCPPoolManager dBCPPoolManager = new DBCPPoolManager();
		
		daemonStartLogger.info("{}", "DBCP Pool Shutdown Start ");
		
		for(String poolName : dBCPPoolManager.GetPoolNameList()){
			dBCPPoolManager.shutdownDriver(poolName);
			daemonStartLogger.info("{} {}", poolName, " Shutdown .. ");
		}
		
		daemonStartLogger.info("{}", "DBCP Pool Shutdown End ");
	}
	
	public void chkDir() {
	}
}