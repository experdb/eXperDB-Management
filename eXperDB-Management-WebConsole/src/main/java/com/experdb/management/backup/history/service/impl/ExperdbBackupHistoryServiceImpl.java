package com.experdb.management.backup.history.service.impl;

import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.experdb.management.backup.history.service.BackupActivityLogVO;
import com.experdb.management.backup.history.service.BackupJobHistoryVO;
import com.experdb.management.backup.history.service.ExperdbBackupHistoryService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("ExperdbBackupHistoryServiceImpl")
public class ExperdbBackupHistoryServiceImpl extends EgovAbstractServiceImpl implements ExperdbBackupHistoryService{
	
	@Autowired
	@Resource(name="ExperdbBackupHistoryDAO")
	private ExperdbBackupHistoryDAO experdbBackupHistoryDAO;
	
	@Override
	public List<BackupJobHistoryVO> selectJobHistoryList(Map<String, Object> param) throws Exception {
		return experdbBackupHistoryDAO.selectJobHistoryList(param);
	}

	@Override
	public List<BackupActivityLogVO> selectBackupActivityLogList(int jobid) throws Exception {
		return experdbBackupHistoryDAO.selectBackupActivityLogList(jobid);
	}

	@Override
	public List<BackupJobHistoryVO> selectRestoreJobHistoryList(Map<String, Object> param) throws Exception {
		return experdbBackupHistoryDAO.selectRestoreJobHistoryList(param);
	}

}
