package com.experdb.management.recovery.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.experdb.management.backup.service.BackupLocationInfoVO;
import com.experdb.management.recovery.cmmn.RestoreInfoVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("ExperdbRecoveryDAO")
public class ExperdbRecoveryDAO extends EgovAbstractMapper{
	
	@Autowired 
	@Resource(name="sqlSessionTemplate") 
	private SqlSession sql; 
	
	@Autowired 
	@Resource(name="backupDB") 
	private SqlSession sql2;
	
	@Autowired 
	@Resource(name="jobhistoryDB") 
	private SqlSession jobhistoryDBsql;

	public List<BackupLocationInfoVO> getStorageList(String ipadr) {
		return jobhistoryDBsql.selectList("experdbRecoverySql.getStorageList", ipadr);
	}

	public int getStorageType(String backupDestLocation) {
		int result = -1;
		BackupLocationInfoVO resultInfo = sql2.selectOne("experdbRecoverySql.getStorageType", backupDestLocation);
		
		if(resultInfo != null){
			result = resultInfo.getType();
		}
		return result;
	}

	public List<RestoreInfoVO> getRecoveryDBList() {
		System.out.println("@@ getRecoveryDBList DAO @@");
		return sql.selectList("experdbRecoverySql.getRecoveryDBList");
	}

	public void recoveryDBInsert(RestoreInfoVO resultInfo) {
		sql.insert("experdbRecoverySql.recoveryDBInsert", resultInfo);
	}

	public void recoveryDBDelete(String dbId) {
		System.out.println("### recoveryDBDelete DAO ## " + dbId);
		sql.delete("experdbRecoverySql.recoveryDBDelete", dbId);
	}
	
	
	

}
