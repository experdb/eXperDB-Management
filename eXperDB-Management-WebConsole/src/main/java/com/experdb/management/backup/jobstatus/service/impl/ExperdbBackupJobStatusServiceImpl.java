package com.experdb.management.backup.jobstatus.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.experdb.management.backup.history.service.impl.ExperdbBackupHistoryDAO;
import com.experdb.management.backup.jobstatus.service.ExperdbBackupJobStatusService;
import com.experdb.management.backup.jobstatus.service.JobStatusVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("ExperdbBackupJobStatusServiceImpl")
public class ExperdbBackupJobStatusServiceImpl extends EgovAbstractServiceImpl implements ExperdbBackupJobStatusService{

	@Autowired
	@Resource(name="ExperdbBackupJobStatusDAO")
	private ExperdbBackupJobStatusDAO experdbBackupJobStatusDAO;

	
	
	@Override
	public List<JobStatusVO> selectBackupJobStatusList() throws Exception {
		return experdbBackupJobStatusDAO.selectJobStatusList();
	}



	@Override
	public int selectJobEnd(int jobid) throws Exception {
		return experdbBackupJobStatusDAO.selectJobEnd(jobid);
	}



	@Override
	public int selectJobid(HashMap<String, Object> paramvalue) throws Exception {
		return experdbBackupJobStatusDAO.selectJobid(paramvalue);
	}
	
}
