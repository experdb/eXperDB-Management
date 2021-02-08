package com.experdb.management.backup.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

public interface ExperdbBackupService {
	
	List<ServerInfoVO> getServerInfo(HttpServletRequest request) throws Exception;


}
