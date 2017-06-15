package com.k4m.dx.tcontrol.util;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public class RunCommandExec extends Thread {

	public String CMD = null;
	public String retVal = null;
	public String consoleTxt = null;
	
	public RunCommandExec(String cmd){
		this.CMD = cmd;
	}
	
	@Override
	public void run(){
		runExec(CMD);
	}
	
	public String call(){
		return this.retVal;
	}
	
	public String callConsoleTxt(){
		return this.consoleTxt;
	}

	public void runExec(String cmd){
		Process proc = null;

		try{
			proc = Runtime.getRuntime().exec(cmd);
			try (InputStream psout = proc.getInputStream()) {
	            this.copy_old(psout, System.out);
				//this.copy(psout);
	        }
			proc.getErrorStream().close();
			proc.getInputStream().close();
			proc.getOutputStream().close();
			proc.waitFor();
			this.retVal = "OK";
		}catch(IOException e){
			System.out.println(e);
			this.retVal = "IOException";
		}catch(InterruptedException e){
			System.out.println(e);
			retVal = "InterruptedException";
		}catch(Exception e){
			System.out.println(e);
			this.retVal = "Exception";
		}
		
		/*
		try {
			Thread.currentThread().sleep(2000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		*/
		proc.destroy();
		System.out.println("Exec End");
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
}
