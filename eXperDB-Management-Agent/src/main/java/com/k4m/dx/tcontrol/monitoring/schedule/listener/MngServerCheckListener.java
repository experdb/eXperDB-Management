package com.k4m.dx.tcontrol.monitoring.schedule.listener;

import java.io.File;
import java.io.FileOutputStream;
import java.util.Properties;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.k4m.dx.tcontrol.monitoring.schedule.checker.ServerChecker;
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
public class MngServerCheckListener extends Thread {


	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");

	public MngServerCheckListener() throws Exception {
	}

	@Override
	public void run() {
		int i = 0;

		while (!Thread.interrupted()) {


			try {
				
				String strIpadr = FileUtil.getPropertyValue("context.properties", "webconsole.ip");
				String strPort = FileUtil.getPropertyValue("context.properties", "webconsole.port");
				
				int intTImeout = 2000;
				ServerChecker serverChecker = new ServerChecker();

				boolean isServerState = serverChecker.isServerState(strIpadr, Integer.parseInt(strPort), intTImeout);
				

				if(isServerState) {
						makeServerCheckFile("serverStatus.properties", "Y");
				} else {
						makeServerCheckFile("serverStatus.properties", "N");
				}

				try {
					Thread.sleep(3000);
				} catch (InterruptedException ex) {
					this.interrupt();
					continue;
				}

			} catch (Exception e) {
			} finally {
			}
		}

	}
	
	private void makeServerCheckFile(String strFileName, String strSerStatus) throws Exception {
	    Properties prop = new Properties();
	    
	    ClassLoader loader = Thread.currentThread().getContextClassLoader();
	    File file = new File(loader.getResource(strFileName).getFile());
	    
	    String path = file.getParent() + File.separator;

	    prop.setProperty("management.server.status", strSerStatus);
	    
	    prop.store(new FileOutputStream(path + strFileName), "");
	}

}
