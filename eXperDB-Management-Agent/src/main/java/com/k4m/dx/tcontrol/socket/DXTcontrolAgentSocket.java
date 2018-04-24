package com.k4m.dx.tcontrol.socket;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.k4m.dx.tcontrol.socket.listener.SocketListener;
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
*  2018.04.23   박태혁 최초 생성
*      </pre>
*/
public class DXTcontrolAgentSocket implements DXTcontrolAgentSocketService{
	private static SocketListener sc ;
	private Logger daemonStartLogger = LoggerFactory.getLogger("DaemonStartLogger");
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	
	public DXTcontrolAgentSocket() {
		
	}
	
	public void start() throws Exception{
		
		String ip = FileUtil.getPropertyValue("context.properties", "socket.server.ip");
		int port = Integer.parseInt(FileUtil.getPropertyValue("context.properties", "socket.server.port").toString());
		sc = new SocketListener(ip, port);
		sc.startup();
	}
	
	public void stop() throws Exception {
		try{
			if (sc != null){
				sc.shutdown();
			}
		}catch(Exception e){
			errLogger.error("리스너 종료 에러가 발생하였습니다.{}", e.toString());
		}
	}
	
	

}
