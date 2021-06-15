package com.experdb.management.backup.history.service;

import java.util.List;
import java.util.Map;

public interface ExperdbBackupHistoryService {

	/**
	 * JobHistory 리스트 조회
	 * @param param 
	 * @param status 
	 * @param type 
	 * @param server 
	 * @param shEndDate 
	 * @param shStartDate 
	 * @param 
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	public List<BackupJobHistoryVO> selectJobHistoryList(Map<String, Object> param) throws Exception ;

	
	/**
	 * ActivityLog 리스트 조회
	 * @param 
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	public List<BackupActivityLogVO> selectBackupActivityLogList(int jobid) throws Exception ;


	/**
	 * JobHistory 복구히스토리 리스트 조회
	 * @param param 
	 * @param status 
	 * @param type 
	 * @param server 
	 * @param shEndDate 
	 * @param shStartDate 
	 * @param 
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	public List<BackupJobHistoryVO> selectRestoreJobHistoryList(Map<String, Object> param)  throws Exception ;


}
