package com.experdb.management.backup.history.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.experdb.management.backup.history.service.BackupActivityLogVO;
import com.experdb.management.backup.history.service.BackupJobHistoryVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;


@Repository("ExperdbBackupHistoryDAO")
public class ExperdbBackupHistoryDAO extends EgovAbstractMapper {
	
	@Autowired 
	@Resource(name="jobhistoryDB") 
	private SqlSession jobhistoryDBsql;
	
	
	@Autowired 
	@Resource(name="activitylogDB") 
	private SqlSession activitylogDBsql;
	
	public List<BackupJobHistoryVO> selectJobHistoryList(Map<String, Object> param) {
	       List<BackupJobHistoryVO> result = null;
	       result =jobhistoryDBsql.selectList("experdbHistorySql.selectJobHistoryList", param);
	        return result;
	}

	public List<BackupActivityLogVO> selectBackupActivityLogList(int jobid) {
			List<BackupActivityLogVO> result = null;
	       result =activitylogDBsql.selectList("experdbHistorySql.selectBackupActivityLogList",jobid);
	        return result;
	}

}
