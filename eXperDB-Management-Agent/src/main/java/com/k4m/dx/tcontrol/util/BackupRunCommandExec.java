package com.k4m.dx.tcontrol.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.util.Scanner;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


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
public class BackupRunCommandExec extends Thread {

	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	public String CMD = null;
	public String retVal = null;
	public String consoleTxt = null;
	
	private String returnMessage = "";
	
	public BackupRunCommandExec(){}
	
	public BackupRunCommandExec(String cmd){
		this.CMD = cmd;
	}
	
	@Override
	public void run(){
		runExecRtn2(CMD);
		//runExec(CMD);
	}
	
	public String call(){
		return this.retVal;
	}
	
	public String getMessage() {
		return this.returnMessage;
	}
	
	public String callConsoleTxt(){
		return this.consoleTxt;
	}

	public void runExec(String cmd){
		Process proc = null;

		try{
			socketLogger.info("cmd --> " + cmd);
			//proc = Runtime.getRuntime().exec(cmd);
			proc = Runtime.getRuntime().exec(new String[]{"/bin/sh", "-c", cmd}); 
			try (InputStream psout = proc.getInputStream()) {
	            this.copy_old(psout, System.out);
				//this.copy(psout);
	        }
			proc.getErrorStream().close();
			proc.getInputStream().close();
			proc.getOutputStream().close();
			proc.waitFor();
			this.retVal = "success";
		}catch(IOException e){
			e.printStackTrace();
			socketLogger.info("err.IOException() --> " + e);
			this.retVal = "IOException" + e.toString();
		}catch(InterruptedException e){
			e.printStackTrace();
			socketLogger.info("err.InterruptedException() --> " + e);
			retVal = "InterruptedException" + e.toString();
		}catch(Exception e){
			e.printStackTrace();
			socketLogger.info("err.Exception() --> " + e);
			this.retVal = "Exception" + e.toString();
		} finally {
			proc.destroy();
		}
		
		/*
		try {
			Thread.currentThread().sleep(2000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		*/

	}
	
	public void runExecRtn(String cmd){
		Process proc = null;
		String strResult = "";
		String strScanner = "";
		try{
			socketLogger.info("[ cmd  ] "+cmd);
			//proc = Runtime.getRuntime().exec(cmd);
			proc = Runtime.getRuntime().exec(new String[]{"/bin/sh", "-c", cmd}); 
			
			BufferedReader br = new BufferedReader(new InputStreamReader(proc.getInputStream()));
			
			Scanner scanner = new Scanner(br); scanner.useDelimiter(System.getProperty("line.separator"));

			while(scanner.hasNext()) {
				strScanner = scanner.next();
				strResult += strScanner;
				
				socketLogger.info("scanner : " + strResult);
			}
			scanner.close(); 
			br.close();

			this.returnMessage = strResult;
			this.retVal = "success";
		}catch(IOException e){
			socketLogger.info("[ IOException ] " + e);
			e.printStackTrace();
			this.retVal = "IOException" + e.toString();
			this.returnMessage = "IOException" + e.toString();
		}catch(Exception e){
			socketLogger.info("[ Exception ] " + e);
			e.printStackTrace();
			this.retVal = "Exception" + e.toString();
			this.returnMessage = "Exception" + e.toString();
		} finally {
			proc.destroy();
			socketLogger.info("[ Exec End ] ");
			System.out.println("Exec End");
		}
	}
	
	public void runExecRtn2(String cmd){
		Process proc = null;
		String strResult = "";
		String strScanner = "";
		String strReturnVal = "";
		String strResultErrInfo = "";
		try{
			//proc = Runtime.getRuntime().exec(cmd);
			socketLogger.info("cmd --> " + cmd);
			
			proc = Runtime.getRuntime().exec(new String[]{"/bin/sh", "-c", cmd}); 
			
			try (InputStream psout = proc.getInputStream()) {
	            this.copy_old(psout, System.out);
				//this.copy(psout);
	        }
			
			ReadStream s1 = new ReadStream("stdin", proc.getInputStream ());
			ReadStream s2 = new ReadStream("stderr", proc.getErrorStream ());
			
			//proc.getErrorStream().close();
			//proc.getInputStream().close();
			//proc.getOutputStream().close();
			
			s1.start ();
			s2.start ();
			proc.waitFor ();

			if ( proc.exitValue() != 0 ) {
				BufferedReader out = new BufferedReader ( new InputStreamReader ( proc.getInputStream() ) );
				while ( out.ready() ) {
					strResultErrInfo += out.readLine();
				}
				socketLogger.info("err.ready() --> " + strResultErrInfo);
				out.close();
				
				BufferedReader err = new BufferedReader ( new InputStreamReader ( proc.getErrorStream() ) );
				while ( err.ready() ) {
					strResult += err.readLine();
				}
				
				strResult += strResultErrInfo;
				socketLogger.info("err.ready() --> " + strResult);
				errLogger.info("err.ready() --> " + strResult);
				err.close();
				strReturnVal = "failed";
			} else {
				BufferedReader out = new BufferedReader ( new InputStreamReader ( proc.getInputStream() ) );

				while ( out.ready() ) {
					strResult += out.readLine();
					
					socketLogger.info("out.ready() --> " + strResult);
				}
				out.close();
				strReturnVal = "success";
			}
			//socketLogger.info("@@@@@@@@@ scanner end" );

			this.returnMessage = strResult;
			this.retVal = strReturnVal;
		}catch(IOException e){
			socketLogger.info("IOException " + e);
			errLogger.info("IOException " + e );
			System.out.println(e);
			this.retVal = "IOException" + e.toString();
			this.returnMessage = "IOException" + e.toString();
		}catch(Exception e){
			socketLogger.info("Exception " + e);
			errLogger.info("Exception " + e );
			System.out.println(e);
			this.retVal = "Exception" + e.toString();
			this.returnMessage = "Exception" + e.toString();
		} finally {
			proc.destroy();
			socketLogger.info("Exec End ");
		}
	}
	
	public void copy_old(InputStream input, OutputStream output) throws IOException {
        byte[] buffer = new byte[1024];
        int n = 0;
        while ((n = input.read(buffer)) != -1) {
            output.write(buffer, 0, n);
        }
    }

	public void copy(InputStream input) throws IOException {
        byte[] buffer = new byte[1024];
        int n = 0;
        while ((n = input.read(buffer)) != -1) {
        	this.consoleTxt += input.read(buffer);
        }
    }
	
	public static void main(String[] args) throws Exception {
		BackupRunCommandExec runCommandExec = new BackupRunCommandExec();
		
		String path = runCommandExec.getClass().getResource("/").getPath();
		
		System.out.println(path);

		
	}
}
