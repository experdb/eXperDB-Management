package com.experdb.proxy.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Scanner;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

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
public class FileRunCommandExec extends Thread {

	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	public String CMD = null;
	public String retVal = null;
	public String consoleTxt = null;
	public ArrayList<String> returnListMessage = null;
	
	private String returnMessage = "";
	
	public FileRunCommandExec(){}
	
	public FileRunCommandExec(String cmd){
		this.CMD = cmd;
	}
	
	@Override
	public void run(){
		runExecRtn2(CMD);
	}
	
	public String call(){
		return this.retVal;
	}
	
	public String getMessage() {
		return this.returnMessage;
	}

	public ArrayList<String> getListMessage() {
		return this.returnListMessage;
	}
	
	
	public String callConsoleTxt(){
		return this.consoleTxt;
	}

	public void runExec(String cmd){
		Process proc = null;

		try{
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
			System.out.println(e);
			this.retVal = "IOException" + e.toString();
		}catch(InterruptedException e){
			System.out.println(e);
			retVal = "InterruptedException" + e.toString();
		}catch(Exception e){
			System.out.println(e);
			this.retVal = "Exception" + e.toString();
		} finally {
			proc.destroy();
			System.out.println("Exec End");
		}
	}
	
	public void runExecRtn(String cmd){
		Process proc = null;
		String strResult = "";
		String strScanner = "";
		try{
			//proc = Runtime.getRuntime().exec(cmd);
			proc = Runtime.getRuntime().exec(new String[]{"/bin/sh", "-c", cmd}); 
			
			BufferedReader br = new BufferedReader(new InputStreamReader(proc.getInputStream()));
			
			Scanner scanner = new Scanner(br); scanner.useDelimiter(System.getProperty("line.separator"));

			while(scanner.hasNext()) {
				strScanner = scanner.next();
				System.out.println(strScanner); 
				strResult += strScanner;
				
				socketLogger.info("scanner : " + strResult);
			}
			scanner.close(); 
			br.close();

			this.returnMessage = strResult;
			this.returnListMessage = null;
			this.retVal = "success";
		}catch(IOException e){
			System.out.println(e);
			this.retVal = "IOException" + e.toString();
			this.returnMessage = "IOException" + e.toString();
			this.returnListMessage = null;
			
		}catch(Exception e){
			System.out.println(e);
			this.retVal = "Exception" + e.toString();
			this.returnMessage = "Exception" + e.toString();
			this.returnListMessage = null;
		} finally {
			proc.destroy();
			System.out.println("Exec End");
		}
	}
	
	public void runExecRtn2(String cmd){
		Process proc = null;
		String strResult = "";
		String strRowResult = "";
		String strScanner = "";
		String strReturnVal = "";
		String strResultErrInfo = "";
		ArrayList<String> fileList = null;
		
		try{
			proc = Runtime.getRuntime().exec(new String[]{"/bin/sh", "-c", cmd}); 
			proc.waitFor ();

			if ( proc.exitValue() != 0 ) {
				BufferedReader out = new BufferedReader ( new InputStreamReader ( proc.getInputStream() ) );
				while ( out.ready() ) {
					strResultErrInfo += out.readLine();
				}
				out.close();
				
				BufferedReader err = new BufferedReader ( new InputStreamReader ( proc.getErrorStream() ) );
				while ( err.ready() ) {
					strResult += err.readLine();
				}
				
				strResult += strResultErrInfo;
				socketLogger.info("err.ready() --> " + strResult);
				err.close();
				strReturnVal = "failed";
			} else {
				BufferedReader out = new BufferedReader ( new InputStreamReader ( proc.getInputStream() ) );
				fileList = new ArrayList<String>();

				while ( out.ready() ) {
					strRowResult = out.readLine();
					strResult += strRowResult;
					
					if (strRowResult != null) {
						if (!"".equals(strRowResult) && !"null".equals(strRowResult)) {
							fileList.add(strRowResult);
						}
					}
				}
				out.close();
				strReturnVal = "success";
			}

			this.returnListMessage = fileList;
			this.returnMessage = strResult;
			this.retVal = strReturnVal;
		}catch(IOException e){
			System.out.println(e);
			this.retVal = "IOException" + e.toString();
			this.returnMessage = "IOException" + e.toString();
			this.returnListMessage = null;
		}catch(Exception e){
			System.out.println(e);
			this.retVal = "Exception" + e.toString();
			this.returnMessage = "Exception" + e.toString();
			this.returnListMessage = null;
		} finally {
			proc.destroy();
			System.out.println("Exec End");
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
		FileRunCommandExec runCommandExec = new FileRunCommandExec();
		
		String path = runCommandExec.getClass().getResource("/").getPath();
		
		System.out.println(path);
	}
}
