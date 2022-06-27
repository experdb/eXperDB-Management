package com.k4m.dx.tcontrol.util;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ReadStream implements Runnable {
	
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");

    String name;
    InputStream is;
    Thread thread;      
    public ReadStream(String name, InputStream is) {
        this.name = name;
        this.is = is;
    }       
    public void start () {
        thread = new Thread (this);
        thread.start ();
    }       
    public void run () {
        try {
            InputStreamReader isr = new InputStreamReader (is);
            BufferedReader br = new BufferedReader (isr);   
            while (true) {
                String s = br.readLine ();
                if (s == null) break;
            }
            is.close ();    
        } catch (Exception ex) {
        	errLogger.info("Problem reading stream " + name + "... :" + ex);
            System.out.println ("Problem reading stream " + name + "... :" + ex);
            ex.printStackTrace ();
        }
    }
}