package com.experdb.management.recovery.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSession;
import org.json.simple.JSONObject;
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
	@Resource(name="activitylogDB") 
	private SqlSession sql3;
	
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

	public String getUserPassword(String usr_id) {
		String user_password = sql.selectOne("experdbRecoverySql.getUserPassword", usr_id);
		return user_password;
	}

	public List<Map<String, Object>> getRecoveryTimeList(String target) {
		return jobhistoryDBsql.selectList("experdbRecoverySql.getRecoveryTimeList", target);
	}

	public List<Map<String, Object>> getRecoveryPoinList(String jobid) {
		return sql3.selectList("experdbRecoverySql.getRecoveryPoinList", jobid);
	}

	public List<Map<String, Object>> getRecoveryTimeOption(String jobid) {
		return jobhistoryDBsql.selectList("experdbRecoverySql.getRecoveryTimeOption", jobid);
	}
	
	
	

}
