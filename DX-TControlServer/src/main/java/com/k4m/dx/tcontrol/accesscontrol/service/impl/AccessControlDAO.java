package com.k4m.dx.tcontrol.accesscontrol.service.impl;

import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.accesscontrol.service.AccessControlHistoryVO;
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
	 * 공통코드 method 조회
	 * 
	 * @param grp_cd
	 * @return AccessControlVO
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<AccessControlVO> selectCodeMethod(String grp_cd) throws SQLException {
		List<AccessControlVO> result = null;
		result = (List<AccessControlVO>) list("accessControlSql.selectCodeMethod", grp_cd);
		return result;
	}
	
	/**
	 * 공통코드 type 조회
	 * 
	 * @param grp_cd
	 * @return AccessControlVO
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<AccessControlVO> selectCodeType(String grp_cd) throws SQLException {
		List<AccessControlVO> result = null;
		result = (List<AccessControlVO>) list("accessControlSql.selectCodeType", grp_cd);
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

	/**
	 * 접근제어이력 등록
	 * 
	 * @param accessControlVO
	 * @throws Exception
	 */
	public void insertAccessControlHistory(AccessControlHistoryVO accessControlHistoryVO) throws SQLException {
		insert("accessControlSql.insertAccessControlHistory", accessControlHistoryVO);
	}

	/**
	 * 접근제어이력 수정 일시 조회
	 * 
	 * @param db_svr_id
	 * @throws Exception
	 * @return AccessControlHistoryVO
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<AccessControlHistoryVO> selectLstmdfdtm(int db_svr_id) throws SQLException {
		List<AccessControlHistoryVO> result = null;
		result = (List<AccessControlHistoryVO>) list("accessControlSql.selectLstmdfdtm", db_svr_id);
		return result;
	}

	/**
	 * 현재 이력_그룹_ID 조회
	 * 
	 * @return int
	 * @throws Exception
	 */
	public int selectCurrenthisrp() throws SQLException {
		return (int) getSqlSession().selectOne("accessControlSql.selectCurrenthisrp");
	}

	/**
	 * 접근제어이력 조회
	 * 
	 * @param accessControlHistoryVO
	 * @return accessControlHistoryVO
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<AccessControlHistoryVO> selectAccessControlHistory(AccessControlHistoryVO accessControlHistoryVO) throws SQLException {
		List<AccessControlHistoryVO> result = null;
		result = (List<AccessControlHistoryVO>) list("accessControlSql.selectAccessControlHistory",
				accessControlHistoryVO);
		return result;
	}


}
