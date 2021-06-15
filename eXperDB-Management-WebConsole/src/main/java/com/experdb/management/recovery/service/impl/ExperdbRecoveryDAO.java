package com.experdb.management.recovery.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.experdb.management.backup.service.BackupLocationInfoVO;

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
		System.out.println("####### getStorageList DAO #######");
		return jobhistoryDBsql.selectList("experdbRecoverySql.getStorageList", ipadr);
	}

	public int getStorageType(String backupDestLocation) {
		System.out.println("####### getStorageType DAO #######");
		int r;
		r = sql2.selectOne("experdbRecoverySql.getStorageType", backupDestLocation);
		
		System.out.println("**** " + r);
		
		return r;
	}
	
	
	

}
