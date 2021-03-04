package com.experdb.management.backup.jobstatus.service;

import java.util.List;

public interface ExperdbBackupJobStatusService {

	/**
	 * JobStatus 리스트 조회
	 * @param 
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	List<JobStatusVO> selectBackupJobStatusList() throws Exception ;

}
