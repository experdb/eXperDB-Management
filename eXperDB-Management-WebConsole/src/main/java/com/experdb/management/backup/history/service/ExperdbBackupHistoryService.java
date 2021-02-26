package com.experdb.management.backup.history.service;

import java.util.List;
import java.util.Map;

public interface ExperdbBackupHistoryService {

	/**
	 * JobHistory 리스트 조회
	 * @param 
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	public List<BackupJobHistoryVO> selectJobHistoryList() throws Exception ;

	
	/**
	 * ActivityLog 리스트 조회
	 * @param 
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	public List<BackupActivityLogVO> selectBackupActivityLogList(int jobid) throws Exception ;


}
