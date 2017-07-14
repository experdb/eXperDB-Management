package com.k4m.dx.tcontrol.accesscontrol.service.impl;

import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.accesscontrol.service.AccessControlVO;
import com.k4m.dx.tcontrol.accesscontrol.service.DbIDbServerVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("accessControlDAO")
public class AccessControlDAO extends EgovAbstractMapper{

	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<DbIDbServerVO> selectDatabaseList(int db_svr_id) throws SQLException{
		List<DbIDbServerVO> result = null;
		result = (List<DbIDbServerVO>) list("accessControlSql.selectDatabaseList", db_svr_id);	
		return result;
	}

	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<DbIDbServerVO> selectServerDb(int db_id) throws SQLException {
		List<DbIDbServerVO> result = null;
		result = (List<DbIDbServerVO>) list("accessControlSql.selectServerDb", db_id);	
		return result;
	}

	public void deleteDbAccessControl(int db_svr_id) throws SQLException{
		delete("accessControlSql.deleteDbAccessControl",db_svr_id);
		
	}
	public void insertAccessControl(AccessControlVO accessControlVO) throws SQLException{
		insert("accessControlSql.insertAccessControl", accessControlVO);		
	}

}
