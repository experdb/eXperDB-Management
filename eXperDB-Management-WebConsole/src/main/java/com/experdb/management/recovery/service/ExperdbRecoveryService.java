package com.experdb.management.recovery.service;


import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;


public interface ExperdbRecoveryService {
	JSONObject getNodeInfoList();

	JSONObject getStorageList(HttpServletRequest request);
	
}
