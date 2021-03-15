package com.experdb.management.backup.node.service;

import java.util.*;

import javax.servlet.http.*;

import org.json.simple.*;

import com.experdb.management.backup.service.*;


public interface ExperdbBackupNodeService {
	
	List<TargetMachineVO> getNodeList()  throws Exception;

	List<ServerInfoVO> getNodeInfoList();

	List<ServerInfoVO> getUnregNodeList();

	JSONObject nodeInsert(HttpServletRequest request);


	JSONObject getNodeInfo(HttpServletRequest request) throws Exception;

	JSONObject nodeUpdate(HttpServletRequest request);

	JSONObject nodeDelete(HttpServletRequest request) throws Exception;

	void scheduleInsert(HttpServletRequest request, Map<Object, String> param);

}
