package com.experdb.management.recovery.service;


import java.io.IOException;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.springframework.web.multipart.MultipartHttpServletRequest;


public interface ExperdbRecoveryService {
	JSONObject getNodeInfoList();

	JSONObject getStorageList(HttpServletRequest request);

	JSONObject getRecoveryDBList();

	JSONObject serverInfoFileRead(MultipartHttpServletRequest request) throws IllegalStateException, IOException;

	JSONObject recoveryDBInsert(HttpServletRequest request);

	JSONObject recoveryDBDelete(HttpServletRequest request);
	
}
