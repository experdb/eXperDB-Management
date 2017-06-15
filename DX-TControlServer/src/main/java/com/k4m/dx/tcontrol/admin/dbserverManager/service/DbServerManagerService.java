package com.k4m.dx.tcontrol.admin.dbserverManager.service;

import java.util.List;

public interface DbServerManagerService {

	/**
	 * DB서버 리스트 조회
	 * @param dbServerVO
	 * @throws Exception
	 */
	List<DbServerVO> selectDbServerList(DbServerVO dbServerVO) throws Exception;

	
	/**
	 * DB서버 등록
	 * @param dbServerVO
	 * @throws Exception
	 */
	void insertDbServer(DbServerVO dbServerVO) throws Exception;
	
	
}
