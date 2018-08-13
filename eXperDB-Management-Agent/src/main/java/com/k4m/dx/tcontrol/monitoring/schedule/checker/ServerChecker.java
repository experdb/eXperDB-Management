package com.k4m.dx.tcontrol.monitoring.schedule.checker;

import java.io.IOException;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.Socket;

/**
* @author 박태혁
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2018.06.28   박태혁 최초 생성
*      </pre>
*/

public class ServerChecker {

	/**
	 * 서버 상태 체크
	 * @param strServerUrl
	 * @param port
	 * @param timeout
	 * @return
	 * @throws Exception
	 */
	public boolean isServerState(String strServerUrl, int port, int timeout) throws Exception {
		boolean isServerState = false;
		isServerState = isReachable(strServerUrl, port, timeout);
		return isServerState;
	}
	
	private boolean isReachable(String addr, int openPort, int timeOutMillis) {
	    try {
	        try (Socket soc = new Socket()) {
	            soc.connect(new InetSocketAddress(addr, openPort), timeOutMillis);
	        }
	        return true;
	    } catch (IOException ex) {
	        return false;
	    }
	}
	
	public static void main(String[] args) throws Exception {
		
		ServerChecker serverChecket = new ServerChecker();
		
		String strServerUrl = "192.168.56.105";
		int port = 8080;
		int timeout = 2000;
		boolean isServerState = false;
		
		isServerState = serverChecket.isReachable(strServerUrl, port, timeout);
		
		System.out.println(" isServerState : " + isServerState);
	}
}
