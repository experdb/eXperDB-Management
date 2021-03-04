package com.experdb.management.backup.jobstatus.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.experdb.management.backup.jobstatus.service.JobStatusVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("ExperdbBackupJobStatusDAO")
public class ExperdbBackupJobStatusDAO extends EgovAbstractMapper {
	
	@Autowired 
	@Resource(name="backupDB") 
	private SqlSession backupDBsql;

	public List<JobStatusVO> selectJobStatusList() {
	       List<JobStatusVO> result = null;
	       result =backupDBsql.selectList("backupDBsql.selectJobStatusList");
	        return result;
	}

}
