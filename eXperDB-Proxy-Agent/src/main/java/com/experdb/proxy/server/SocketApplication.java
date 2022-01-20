package com.experdb.proxy.server;

//import org.apache.log4j.Logger;

//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import org.json.simple.JSONObject;

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
public interface SocketApplication {
	//public static Logger log = Logger.getLogger(SocketApplication.class);
	//public static Logger log = LoggerFactory.getLogger(SocketApplication.class);
	public static Logger log = LogManager.getLogger(SocketApplication.class.getName());
	public JSONObject perform(String tran_cd, JSONObject dbInfoObj) throws Exception;
}
