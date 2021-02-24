package com.experdb.management.backup.node.service;

import java.util.List;

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

}
