package com.experdb.management.backup.policy.service.impl;

import java.util.*;

import javax.annotation.Resource;
import javax.servlet.http.*;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.experdb.management.backup.node.service.TargetMachineVO;
import com.experdb.management.backup.service.*;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("ExperdbBackupPolicyDAO")
public class ExperdbBackupPolicyDAO extends EgovAbstractMapper{
	
	@Autowired 
	@Resource(name="sqlSessionTemplate") 
	private SqlSession sql; 
	
	@Autowired 
	@Resource(name="backupDB") 
	private SqlSession sql2;

	public TargetMachineVO getScheduleNodeInfo(String path){
		return sql2.selectOne("backupNodeSql.getScheduleNodeInfo", path);
	}

	public BackupLocationInfoVO getScheduleLocationInfo(String path) {
		return sql2.selectOne("backupStorageSql.getScheduleLocationInfo", path);
	}

	public void volumeUpdate(Map<String, Object> volumeInsert) {
		sql2.update("backupNodeSql.volumeUpdate", volumeInsert);
	}

	public void scheduleInsert2(Map<String, Object> jobInsert) {
		sql2.update("backupNodeSql.setScheduleJob2", jobInsert);
	}

	public int checkJobExist(String ipadr) {
		return sql2.selectOne("backupNodeSql.checkJobExist", ipadr);
	}

}
