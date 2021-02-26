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
	public List<BackupJobHistoryVO> selectJobHistoryList() throws Exception {
		return experdbBackupHistoryDAO.selectJobHistoryList();
	}

	@Override
	public List<BackupActivityLogVO> selectBackupActivityLogList(int jobid) throws Exception {
		return experdbBackupHistoryDAO.selectBackupActivityLogList(jobid);
	}

}
