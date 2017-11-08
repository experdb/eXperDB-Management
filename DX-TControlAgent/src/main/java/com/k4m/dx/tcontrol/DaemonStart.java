package com.k4m.dx.tcontrol;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.k4m.dx.tcontrol.db.repository.service.SystemServiceImpl;
import com.k4m.dx.tcontrol.deamon.DxDaemon;
import com.k4m.dx.tcontrol.deamon.DxDaemonManager;
import com.k4m.dx.tcontrol.deamon.IllegalDxDaemonClassException;
import com.k4m.dx.tcontrol.socket.DXTcontrolAgentSocket;
import com.k4m.dx.tcontrol.socket.listener.ServerCheckListener;
import com.k4m.dx.tcontrol.util.FileUtil;

public class DaemonStart implements DxDaemon{
	
	private static Logger daemonStartLogger = LoggerFactory.getLogger("DaemonStartLogger");
	private static Logger errLogger = LoggerFactory.getLogger("errorToFile");
	
	private static Logger client= LoggerFactory.getLogger("client");
	private static Logger server = LoggerFactory.getLogger("server");
	
	private DXTcontrolAgentSocket socketService;
	private ServerCheckListener serverCheckListener ;

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
			System.out.println("## DX-TcontrolAgent Dammon Process is Shutdown...");
			
			daemonStartLogger.info("{} DX-TcontrolAgent Dammon Process is Shutdown...", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
			
			return; // 프로그램 종료.
		}

		DxDaemonManager sdm = null;
		

		
		try {
			
			sdm = DxDaemonManager.getInstance(DaemonStart.class);
			sdm.start();


			
		}  catch (Exception e) {
			errLogger.error("데몬 시작시 에러가 발생하였습니다. {}", e.toString());
			e.printStackTrace();
		}
	}
	
	ApplicationContext context;
	
	//@Override
	public void startDaemon() {
		
		try {
		
			context = new ClassPathXmlApplicationContext(new String[] {"context-tcontrol.xml"});
			SystemServiceImpl service = (SystemServiceImpl) context.getBean("SystemService");

			// SqlSessionManager 초기화
			try {
				String strIpadr = FileUtil.getPropertyValue("context.properties", "agent.install.ip");
				String strPort = FileUtil.getPropertyValue("context.properties", "socket.server.port");
				String strVersion = FileUtil.getPropertyValue("context.properties", "agent.install.version");
				

				
				

				
				service.agentInfoStartMng(strIpadr, strPort, strVersion);
				
			} catch (Exception e) {
				errLogger.error("데몬 시작시 에러가 발생하였습니다. {}", e.toString());
				e.printStackTrace();
				return;
			}		
			
			//Driver 로딩 
			try {
				Class.forName("org.apache.commons.dbcp.PoolingDriver");
			} catch (Exception e) {
				errLogger.error("데몬 시작시 에러가 발생하였습니다. {}", e.toString());
				return;			
			}
			
			System.out.println("######################################################################");
			System.out.println("## load file ");
			System.out.println("## "+new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
			System.out.println("## DX-TcontrolAgent Dammon Process is started...");
			System.out.println("######################################################################");
			
			daemonStartLogger.info("{}", "DX-TcontrolAgent Deamon Start..");
			daemonStartLogger.info("{} {}", "DX-TcontrolAgent Deamon Start..", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
	
			socketService = new DXTcontrolAgentSocket();
			socketService.start();
			
			serverCheckListener = new ServerCheckListener(service);
			serverCheckListener.run();
		
		} catch(Exception e) {
			errLogger.error("데몬 시작시 에러가 발생하였습니다. {}", e.toString());
			e.printStackTrace();
		}
			
		
	}

	public void shutdown() {
		
		try {
			socketService.stop();
			
			String strIpadr = FileUtil.getPropertyValue("context.properties", "agent.install.ip");
			String strPort = FileUtil.getPropertyValue("context.properties", "socket.server.port");

			SystemServiceImpl service = (SystemServiceImpl) context.getBean("SystemService");

			
			service.agentInfoStopMng(strIpadr, strPort);
			
		} catch(Exception e) {
			errLogger.error("데몬 종료시 에러가 발생하였습니다. {0}", e.toString());
			e.printStackTrace();
			
		}
		
	}
	
	public void chkDir() {

	}
	

}
