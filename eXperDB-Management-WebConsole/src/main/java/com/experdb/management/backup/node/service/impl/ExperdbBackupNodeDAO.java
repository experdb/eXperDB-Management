package com.experdb.management.backup.node.service.impl;

import java.util.*;

import javax.annotation.Resource;
import javax.servlet.http.*;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.experdb.management.backup.node.service.TargetMachineVO;
import com.experdb.management.backup.service.*;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("ExperdbBackupNodeDAO")
public class ExperdbBackupNodeDAO extends EgovAbstractMapper{
	
	@Autowired 
	@Resource(name="sqlSessionTemplate") 
	private SqlSession sql; 
	
	@Autowired 
	@Resource(name="backupDB") 
	private SqlSession sql2;
	
	public List<TargetMachineVO> getNodeList() {
	       List<TargetMachineVO> result = null;
	       result =sql2.selectList("backupNodeSql.getNodeList");
	      //  result = (List<TargetMachineVO>) list("experdbBackupSql.getNodeList",null);
	        return result;
	}

	public TargetMachineVO getNodeInfo(String path) {
		return sql2.selectOne("backupNodeSql.getNodeInfo", path);
	}
	
}
