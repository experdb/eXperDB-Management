package com.k4m.dx.tcontrol.accesscontrol.service;

import java.util.List;

public interface AccessControlService {

	/**
	 * DB조회
	 * 
	 * @param dbAutVO
	 * @return
	 * @throws Exception
	 */
	List<DbIDbServerVO> selectDatabaseList(DbAutVO dbAutVO) throws Exception;

	/**
	 * 공통코드 type 조회
	 * 
	 * @param grp_cd
	 * @return AccessControlVO
	 */
	List<AccessControlVO> selectCodeType(String grp_cd) throws Exception;

	/**
	 * 공통코드 method 조회
	 * 
	 * @param grp_cd
	 * @return AccessControlVO
	 */
	List<AccessControlVO> selectCodeMethod(String grp_cd) throws Exception;

	/**
	 * DB접근제어 전체 삭제
	 * 
	 * @param db_svr_id
	 * @return
	 * @throws Exception
	 */
	void deleteDbAccessControl(int db_svr_id) throws Exception;

	/**
	 * 접근제어 등록
	 * 
	 * @param accessControlVO
	 * @throws Exception
	 */
	void insertAccessControl(AccessControlVO accessControlVO) throws Exception;

	/**
	 * 접근제어 이력 등록
	 * 
	 * @param accessControlHistoryVO
	 * @throws Exception
	 */
	void insertAccessControlHistory(AccessControlHistoryVO accessControlHistoryVO) throws Exception;

	/**
	 * 접근제어이력 수정 일시 조회
	 * 
	 * @param db_svr_id
	 * @return AccessControlHistoryVO
	 * @throws Exception
	 */
	List<AccessControlHistoryVO> selectLstmdfdtm(int db_svr_id) throws Exception;

	/**
	 * 현재 이력_그룹_ID 조회
	 * 
	 * @return
	 * @throws Exception
	 */
	int selectCurrenthisrp() throws Exception;

	/**
	 * 접근제어이력 조회
	 * 
	 * @param accessControlHistoryVO
	 * @return AccessControlHistoryVO
	 */
	List<AccessControlHistoryVO> selectAccessControlHistory(AccessControlHistoryVO accessControlHistoryVO)
			throws Exception;

	/**
	 * 현재 서버_접근_제어_ID 조회
	 * 
	 * @return
	 * @throws Exception
	 */
	int selectCurrentCntrid() throws Exception;

}
