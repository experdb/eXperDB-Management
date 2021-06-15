package com.experdb.management.backup.jobstatus.service;

import java.util.HashMap;
import java.util.List;

public interface ExperdbBackupJobStatusService {

	/**
	 * JobStatus 리스트 조회
	 * @param 
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	List<JobStatusVO> selectBackupJobStatusList() throws Exception ;

	
	/**
	 * JobEnd 잡 종료 확인
	 * @param 
	 * @return int
	 * @throws Exception
	 */
	int selectJobEnd(int jobid) throws Exception ;

	
	/**
	 * jobId 호출
	 * @param paramvalue 
	 * @param 
	 * @return int
	 * @throws Exception
	 */
	int selectJobid(HashMap<String, Object> paramvalue) throws Exception ;

}
