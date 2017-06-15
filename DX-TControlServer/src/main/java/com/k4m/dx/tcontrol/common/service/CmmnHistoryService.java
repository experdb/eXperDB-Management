package com.k4m.dx.tcontrol.common.service;

public interface CmmnHistoryService {

	/**
	 * 로그인 이력을 등록한다.
	 * 
	 * @param historyVO
	 * @throws Exception
	 */
	void insertHistoryLogin(HistoryVO historyVO) throws Exception;

	/**
	 * 로그아웃 이력을 등록한다.
	 * 
	 * @param historyVO
	 * @throws Exception
	 */
	void insertHistoryLogout(HistoryVO historyVO) throws Exception;

	/**
	 * 메인화면 이력을 등록한다.
	 * 
	 * @param historyVO
	 * @throws Exception
	 */
	void insertHistoryMain(HistoryVO historyVO) throws Exception;

	/**
	 * DB Server Tree 이력을 등록한다.
	 * 
	 * @param historyVO
	 * @throws Exception
	 */
	void insertHistoryDbTree(HistoryVO historyVO) throws Exception;

	/**
	 * DB Server 화면 이력을 등록한다.
	 * 
	 * @param historyVO
	 * @throws Exception
	 */
	void insertHistoryDbServer(HistoryVO historyVO) throws Exception;

	/**
	 * DB Server 등록팝업 이력을 등록한다.
	 * 
	 * @param historyVO
	 * @throws Exception
	 */
	void insertHistoryDbServerRegPopup(HistoryVO historyVO) throws Exception;

	/**
	 * DB Server 등록팝업 저장이력을 등록한다.
	 * 
	 * @param historyVO
	 * @throws Exception
	 */
	void insertHistoryDbServerI(HistoryVO historyVO) throws Exception;

	/**
	 * Database 조회화면 이력을 등록한다.
	 * 
	 * @param historyVO
	 * @throws Exception
	 */
	void insertHistoryDatabase(HistoryVO historyVO) throws Exception;

	/**
	 * 전송설정 이력을 등록한다.
	 * 
	 * @param historyVO
	 * @throws Exception
	 */
	void insertHistoryTransferSetting(HistoryVO historyVO) throws Exception;

	/**
	 * Connector 조회화면 이력을 등록한다.
	 * 
	 * @param historyVO
	 * @throws Exception
	 */
	void insertHistoryConnectorRegister(HistoryVO historyVO) throws Exception;

	/**
	 * Connector수정 이력을 등록한다.
	 * 
	 * @param historyVO
	 * @throws Exception
	 */
	void insertHistoryConnectorRegisterU(HistoryVO historyVO) throws Exception;

	/**
	 * Connector삭제 이력을 등록한다.
	 * 
	 * @param historyVO
	 * @throws Exception
	 */
	void insertHistoryConnectorRegisterD(HistoryVO historyVO) throws Exception;

	/**
	 * Connector 등록 팝업 화면 이력을 등록한다.
	 * 
	 * @param historyVO
	 * @throws Exception
	 */
	void insertHistoryConnectorRegPopup(HistoryVO historyVO) throws Exception;

	/**
	 * Connector등록 이력을 등록한다.
	 * 
	 * @param historyVO
	 * @throws Exception
	 */
	void insertHistoryConnectorRegisterI(HistoryVO historyVO) throws Exception;

	/**
	 * Connector 연결테스트 이력을 등록한다.
	 * 
	 * @param historyVO
	 * @throws Exception
	 */
	void insertHistoryConnectorConnTest(HistoryVO historyVO) throws Exception;

	/**
	 * 사용자 관리 이력을 등록한다.
	 * 
	 * @param historyVO
	 * @throws Exception
	 */
	void insertHistoryUserManager(HistoryVO historyVO) throws Exception;

	/**
	 * 사용자 등록 이력을 등록한다.
	 * 
	 * @param historyVO
	 * @throws Exception
	 */
	void insertHistoryUserManagerI(HistoryVO historyVO) throws Exception;

	/**
	 * 사용자 삭제 이력을 등록한다.
	 * 
	 * @param historyVO
	 * @throws Exception
	 */
	void insertHistoryUserManagerD(HistoryVO historyVO) throws Exception;

	/**
	 * 사용자 수정 이력을 등록한다.
	 * 
	 * @param historyVO
	 * @throws Exception
	 */
	void insertHistoryUserManagerU(HistoryVO historyVO) throws Exception;

	/**
	 * 메뉴권한관리 이력을 등록한다.
	 * 
	 * @param historyVO
	 * @throws Exception
	 */
	void insertHistoryMenuAuthority(HistoryVO historyVO) throws Exception;

	/**
	 * DB권한관리 이력을 등록한다.
	 * 
	 * @param historyVO
	 * @throws Exception
	 */
	void insertHistoryDbAuthority(HistoryVO historyVO) throws Exception;

	/**
	 * 화면접근 이력을 등록한다.
	 * 
	 * @param historyVO
	 * @throws Exception
	 */
	void insertHistoryAccessHistory(HistoryVO historyVO) throws Exception;

	/**
	 * Agent모니터링 이력을 등록한다.
	 * 
	 * @param historyVO
	 * @throws Exception
	 */
	void insertHistoryAgentMonitoring(HistoryVO historyVO) throws Exception;

}
