package com.k4m.dx.tcontrol.accesscontrol.service;

import java.util.List;

public interface AccessControlService {

	/**
	 * DB 조회
	 * 
	 * @param db_svr_id
	 * @return
	 * @throws Exception
	 */
	List<DbIDbServerVO> selectDatabaseList(int db_svr_id) throws Exception;

	/**
	 * DB,SERVER 조회
	 * 
	 * @param db_id
	 * @return
	 * @throws Exception
	 */
	List<DbIDbServerVO> selectServerDb(int db_id) throws Exception;

	/**
	 * DB SERVER Name 조회
	 * 
	 * @param db_svr_id
	 * @return
	 * @throws Exception
	 */
	List<DbIDbServerVO> selectDbServerName(int db_svr_id) throws Exception;

	/**
	 * DB접근제어 삭제
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

}
