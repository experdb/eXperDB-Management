package com.k4m.dx.tcontrol.db2pg.history.service;

import java.util.List;
import java.util.Map;


public interface Db2pgHistoryService {

	/**
	 *  이관로그 등록
	 * 
	 * @param Map<String, Object>
	 * @throws Exception
	 */
	void insertMigExe(Map<String, Object> param) throws Exception;

	
	/**
	 *  DB2PG 수행이력 조회
	 * 
	 * @param List<Db2pgHistoryVO>
	 * @throws Exception
	 */
	int lastMigExe() throws Exception;
	
	
	/**
	 *  이관로그 수정
	 * 
	 * @param Map<String, Object>
	 * @throws Exception
	 */
	void updateMigExe(Map<String, Object> param) throws Exception;
	

	/**
	 *  DDL 실행로그 조회
	 * 
	 * @param List<Db2pgHistoryVO>
	 * @throws Exception
	 */
	List<Db2pgHistoryVO> selectDb2pgDDLHistory(Db2pgHistoryVO db2pgHistoryVO) throws Exception;


	/**
	 *  Migration 실행로그 조회
	 * 
	 * @param List<Db2pgHistoryVO>
	 * @throws Exception
	 */
	List<Db2pgHistoryVO> selectDb2pgMigHistory(Db2pgHistoryVO db2pgHistoryVO) throws Exception;


	/**
	 *  DDL 실행 상세로그 조회
	 * 
	 * @param List<Db2pgHistoryVO>
	 * @throws Exception
	 */
	Db2pgHistoryVO selectDb2pgDdlHistoryDetail(int mig_exe_sn) throws Exception;


	/**
	 *  MIGRATION 실행 상세로그 조회
	 * 
	 * @param List<Db2pgHistoryVO>
	 * @throws Exception
	 */
	Db2pgHistoryVO selectDb2pgMigHistoryDetail(int mig_exe_sn) throws Exception;



}
