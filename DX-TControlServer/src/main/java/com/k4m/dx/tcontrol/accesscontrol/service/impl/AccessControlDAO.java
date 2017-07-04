package com.k4m.dx.tcontrol.accesscontrol.service.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.backup.service.DbVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("accessControlDAO")
public class AccessControlDAO extends EgovAbstractMapper{

	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<DbVO> selectDatabaseList(int db_svr_id) {
		List<DbVO> result = null;
		result = (List<DbVO>) list("accessControlSql.selectDatabaseList", db_svr_id);	
		return result;
	}

}
