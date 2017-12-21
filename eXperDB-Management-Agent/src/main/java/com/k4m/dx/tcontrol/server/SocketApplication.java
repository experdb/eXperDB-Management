package com.k4m.dx.tcontrol.server;

import org.apache.log4j.Logger;
import org.json.simple.JSONObject;


public interface SocketApplication {
	public static Logger log = Logger.getLogger(SocketApplication.class);
	
	public JSONObject perform(String tran_cd, JSONObject dbInfoObj) throws Exception;
}
