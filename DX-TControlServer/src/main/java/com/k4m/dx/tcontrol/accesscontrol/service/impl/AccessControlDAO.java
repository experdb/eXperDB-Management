package com.k4m.dx.tcontrol.accesscontrol.service.impl;

import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.accesscontrol.service.AccessControlVO;
import com.k4m.dx.tcontrol.accesscontrol.service.DbAutVO;
import com.k4m.dx.tcontrol.accesscontrol.service.DbIDbServerVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("accessControlDAO")
public class AccessControlDAO extends EgovAbstractMapper {

	/**
	 * DB 조회
	 * 
	 * @param db_svr_id
	 * @return List
	 * @throws Exception
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<DbIDbServerVO> selectDatabaseList(DbAutVO dbAutVO) throws SQLException {
		List<DbIDbServerVO> result = null;
		result = (List<DbIDbServerVO>) list("accessControlSql.selectDatabaseList", dbAutVO);
		return result;
	}

	/**
	 * DB접근제어 전체 삭제
	 * 
	 * @param db_svr_id
	 * @throws Exception
	 */
	public void deleteDbAccessControl(int db_svr_id) throws SQLException {
		delete("accessControlSql.deleteDbAccessControl", db_svr_id);

	}

	/**
	 * 접근제어 등록
	 * 
	 * @param accessControlVO
	 * @throws Exception
	 */
	public void insertAccessControl(AccessControlVO accessControlVO) throws SQLException {
		insert("accessControlSql.insertAccessControl", accessControlVO);
	}



}
