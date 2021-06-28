package com.experdb.management.recovery.service;


import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.List;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
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

	JSONObject completeRecoveryRun(HttpServletRequest request) throws InvalidKeyException, UnsupportedEncodingException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, IOException;

	JSONObject getRecoveryTimeListList(HttpServletRequest request);

	JSONObject getRecoveryTimeOption(HttpServletRequest request);
	
}
