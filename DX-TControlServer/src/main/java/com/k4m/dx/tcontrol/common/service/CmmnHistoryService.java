package com.k4m.dx.tcontrol.common.service;

public interface CmmnHistoryService {


	/**
	 * DB Server Tree 이력 등록
	 * 
	 * @param historyVO
	 * @throws Exception
	 */
	void insertHistoryDbTree(HistoryVO historyVO) throws Exception;

	/**
	 * DB Server 화면 이력 등록
	 * 
	 * @param historyVO
	 * @throws Exception
	 */
	void insertHistoryDbServer(HistoryVO historyVO) throws Exception;

	/**
	 * DB Server 등록팝업 이력 등록
	 * 
	 * @param historyVO
	 * @throws Exception
	 */
	void insertHistoryDbServerRegPopup(HistoryVO historyVO) throws Exception;

	/**
	 * DB Server 등록팝업 저장이력 등록
	 * 
	 * @param historyVO
	 * @throws Exception
	 */
	void insertHistoryDbServerI(HistoryVO historyVO) throws Exception;

	/**
	 * Database 조회화면 이력 등록
	 * 
	 * @param historyVO
	 * @throws Exception
	 */
	void insertHistoryDatabase(HistoryVO historyVO) throws Exception;


}
