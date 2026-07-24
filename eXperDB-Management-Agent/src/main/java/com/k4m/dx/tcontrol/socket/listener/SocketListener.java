package com.k4m.dx.tcontrol.socket.listener;

import java.io.InterruptedIOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Vector;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.k4m.dx.tcontrol.util.CommonUtil;
import java.net.InetAddress;
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
public class SocketListener implements Runnable {
	
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	
	private String			listenerName = "";
	private int				listenPort = -1;
	private int				timeout = -1;
	private int				backlog = -1;
	private boolean			acceptMode = true;
	private	Vector			oppositeIPs = new Vector();
	private Thread			mainThread  ;
    private ServerSocket	serverSocket = null;	
	private boolean 		toBeShutdown = false;
	private boolean 		isRunning = false;

	public SocketListener(String listenerName, int port) throws Exception {
		super();
		
		this.listenerName		= listenerName;
		this.listenPort = port;
	}
	
	private void createServerSocket() throws Exception {
		try {
			this.serverSocket	= new ServerSocket(listenPort);
			//this.serverSocket.setSoTimeout(1000);
		} catch(Exception e) {
			socketLogger.info("서버소켓을 생성하지 못했습니다. [" + e + "]");
			
			throw new Exception("서버소켓을 생성하지 못했습니다. [" + e + "]");
		}
	}
	
	public void startup() throws Exception {

		socketLogger.info("SocketListener[" + listenerName + "]를 기동합니다.");
		socketLogger.info("ListenerPort : [" + listenPort + "]");
		socketLogger.info("Timeout : [" + timeout + "]");
		socketLogger.info("Backlog : [" + backlog + "]");

		createServerSocket();
		
		//Thread		mainThread = new Thread(this);
		mainThread = new Thread(this);
		mainThread.start();
		socketLogger.info("SocketListener[" + listenerName + "]가 메시지 수신을 대기하고 있습니다.");

	}
	
	public void shutdown() throws Exception {
		socketLogger.info("");
		
		this.toBeShutdown = true;
		
		try {			
			//this.serverSocket.close();
			//mainThread.join();
			mainThread.interrupt();
			
		} catch(Exception e) {
			e.printStackTrace();
			throw new Exception("A listener could not be shutdown. Exception [" + e + "]");
		}
		
		socketLogger.info("SocketListener가 종료되었습니다.");	
	}	
	
	public void run() {
		isRunning = true;
		String allowedIp = loadAllowedIp();
		try {
		//ServerSocket	serverSocket = new ServerSocket(listenPort);
		//serverSocket.setSoTimeout(1000);
		
		while ( !toBeShutdown) {
			try {
				

				Socket client = serverSocket.accept();

					
				if ( toBeShutdown ) break;
				
				if (client != null && !client.isClosed()){
					if (!isAllowedClient(client, allowedIp)) {
						InetAddress remoteAddr = client.getInetAddress();
						socketLogger.warn("Blocked connection from disallowed source IP ["
								+ (remoteAddr != null ? remoteAddr.getHostAddress() : "unknown")
								+ "] (allowed: repoDB_ip=" + allowedIp + ")");
						try { client.close(); } catch (Exception ce) { /* ignore */ }
						continue;
					}
					Thread thread = new Thread(new DXTcontrolSocketExecute(client));
					
					thread.start();
					//socketLogger.info("Thread가 종료될때까지 기다립니다.");
//		            try {
//		                // 해당 쓰레드가 멈출때까지 멈춤
//		                thread.join();
//		            } catch (InterruptedException e) {
//		                e.printStackTrace();
//		            }
		           // socketLogger.info("Thread가 종료되었습니다."); 
		            //if(client != null) client.close();
				}
				
				
//				if(client != null) {
//					socketLogger.info("client socket 종료."); 
//					client.close();
//					client = null;
//				}
				
				//System.out.println(client);
					
			} catch(Exception e) {
				errLogger.error("Fail to processing client request. Exception [" + e.toString() + "]");
			}
		}
		
		this.serverSocket.close();
		socketLogger.info("Please wait for Shutdown a listener...");	
		socketLogger.info("Closing ServerSocket.");	
		
		isRunning = false;
		} catch (Exception e) {
			errLogger.error("Fail to Closing Socket [" + e.toString() + "]");
		} finally {
			
		}
	}


	/**
	 * Loads the allowed source IP from context.properties once. The WebConsole runs on
	 * the repository DB host, so repoDB_ip is the WebConsole address.
	 * Returns an empty string when the value is missing.
	 */
	private String loadAllowedIp() {
		try {
			String ip = FileUtil.getPropertyValue("context.properties", "repoDB_ip");
			return ip == null ? "" : ip.trim();
		} catch (Exception e) {
			errLogger.error("Failed to load repoDB_ip for source IP validation [" + e.toString() + "]");
			return "";
		}
	}

	/**
	 * Allows a client only when its source IP matches the configured repoDB_ip
	 * (the WebConsole host). Loopback is not exempt from this check.
	 * When repoDB_ip is not configured the connection is denied (fail-closed).
	 */
	private boolean isAllowedClient(Socket client, String allowedIp) {
		InetAddress addr = client.getInetAddress();
		if (addr == null) {
			return false;
		}
		if (allowedIp == null || allowedIp.isEmpty()) {
			errLogger.error("repoDB_ip is not configured; denying connection from [" + addr.getHostAddress() + "]");
			return false;
		}
		return allowedIp.equals(addr.getHostAddress());
	}
}
