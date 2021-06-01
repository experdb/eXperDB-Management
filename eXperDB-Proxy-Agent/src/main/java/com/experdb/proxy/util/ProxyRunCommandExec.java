package com.experdb.proxy.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
* @author 최정환
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2021.02.24   최정환 	최초 생성
*      </pre>
*/
public class ProxyRunCommandExec extends Thread {

	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	public String strCmd = null;
	public String retVal = null;
	public int iMode;
	
	private String returnMessage = "";

	ApplicationContext context;
	
	public ProxyRunCommandExec(){}
	
	public ProxyRunCommandExec(String _strCmd, int _iMode){
		this.strCmd=_strCmd; //cmd값
		this.iMode=_iMode; //구분값

		context = new ClassPathXmlApplicationContext(new String[] { "context-tcontrol.xml" });
	}

	public String call(){
		return this.retVal;
	}
	
	public String getMessage() {
		return this.returnMessage;
	}

	@Override
	public void run(){		
		String strResult = "";
		String strReturnVal = "";
		String strResultErrInfo = "";
		
        BufferedReader successBufferReaderRe = null; // 성공 버퍼
        BufferedReader errorBufferReaderRe = null; // 오류 버퍼

        ProcessBuilder runBuilder = null;

        Process p = null;
        try {
    		String path = FileUtil.getPropertyValue("context.properties", "agent.path");
    		//strCmd = strCmd + " >/dev/null 2>1 &";

    		List runCmd = new ArrayList();
    		runCmd.add("/bin/bash");
    		runCmd.add("-c");
    		runCmd.add(strCmd);
    				
    		runBuilder = new ProcessBuilder(runCmd);
    		runBuilder.directory(new File(path));
    				
    		p = runBuilder.start();
    				
    		p.waitFor ();

    		if ( p.exitValue() != 0 ) {
    			BufferedReader out = new BufferedReader ( new InputStreamReader ( p.getInputStream() ) );
    			while ( out.ready() ) {
    				strResultErrInfo += out.readLine();
    			}
    			out.close();
    					
    			BufferedReader err = new BufferedReader ( new InputStreamReader ( p.getErrorStream() ) );
    			while ( err.ready() ) {
    				strResult += err.readLine();
    			}
    					
    			strResult += strResultErrInfo;

    			err.close();
    			strReturnVal = "failed";
    		} else {
    			BufferedReader out = new BufferedReader ( new InputStreamReader ( p.getInputStream() ) );

    			while ( out.ready() ) {
    				strResult += out.readLine();
    				//socketLogger.info("out.ready() --> " + out.readLine());
    			}
    			out.close();
    			strReturnVal = "success";
    		}

    		this.returnMessage = strResult;
    		this.retVal = strReturnVal;

    		strReturnVal = "success";	

    	}catch(IOException e){
    		System.out.println(e);
    		this.retVal = "IOException" + e.toString();
    		this.returnMessage = "IOException" + e.toString();
    	}catch(Exception e) {
    		System.out.println(e);
    		this.retVal = "Exception" + e.toString();
    		this.returnMessage = "Exception" + e.toString();
    	}finally {
    		p.destroy();
    		if (successBufferReaderRe != null) {
    			try {
    				successBufferReaderRe.close();
    			} catch (IOException e) {
    				// TODO Auto-generated catch block
    				e.printStackTrace();
    			}
    		}
    	   	
    		if (errorBufferReaderRe != null) {
    			try {
    				errorBufferReaderRe.close();
    			} catch (IOException e) {
    				// TODO Auto-generated catch block
    				e.printStackTrace();
    			}
    		}
    						
    		System.out.println("Exec End");
    	}
	}

	public static void main(String[] args) throws Exception {
		ProxyRunCommandExec runCommandExec = new ProxyRunCommandExec();

		String path = runCommandExec.getClass().getResource("/").getPath();
	}
}