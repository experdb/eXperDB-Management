package com.k4m.dx.tcontrol.common.service.impl;

import java.sql.SQLException;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.common.service.HistoryVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("CmmnHistoryDAO")
public class CmmnHistoryDAO extends EgovAbstractMapper{

	/**
	 * 로그인 이력 등록
	 * 
	 * @param historyVO
	 * @throws SQLException
	 */
	public void insertHistoryLogin(HistoryVO historyVO) throws SQLException {
		insert("cmmnHistorySQL.insertHistoryLogin", historyVO);
	}

	
	/**
	 * 로그아웃 이력 등록
	 * 
	 * @param historyVO
	 * @throws SQLException
	 */
	public void insertHistoryLogout(HistoryVO historyVO) throws SQLException {
		insert("cmmnHistorySQL.insertHistoryLogout", historyVO);
	}

	
	/**
	 * 메인화면 이력 등록
	 * 
	 * @param historyVO
	 * @throws SQLException
	 */
	public void insertHistoryMain(HistoryVO historyVO) throws SQLException {
		insert("cmmnHistorySQL.insertHistoryMain", historyVO);
	}

	
	/**
	 * DB Server Tree 이력 등록
	 * 
	 * @param historyVO
	 * @throws SQLException
	 */
	public void insertHistoryDbTree(HistoryVO historyVO) throws SQLException {
		insert("cmmnHistorySQL.insertHistoryDbTree", historyVO);
	}

	
	/**
	 * DB Server 화면 이력 등록
	 * 
	 * @param historyVO
	 * @throws SQLException
	 */
	public void insertHistoryDbServer(HistoryVO historyVO) throws SQLException {
		insert("cmmnHistorySQL.insertHistoryDbServer", historyVO);
	}

	
	/**
	 * DB Server 등록팝업 이력 등록
	 * 
	 * @param historyVO
	 * @throws SQLException
	 */
	public void insertHistoryDbServerRegPopup(HistoryVO historyVO) throws SQLException {
		insert("cmmnHistorySQL.insertHistoryDbServerRegPopup", historyVO);
	}

	
	
	/**
	 * DB Server 등록팝업 저장이력 등록
	 * 
	 * @param historyVO
	 * @throws SQLException
	 */
	public void insertHistoryDbServerI(HistoryVO historyVO) throws SQLException {
		insert("cmmnHistorySQL.insertHistoryDbServerI", historyVO);
	}

	
	/**
	 * Database 조회화면 이력 등록
	 * 
	 * @param historyVO
	 * @throws SQLException
	 */
	public void insertHistoryDatabase(HistoryVO historyVO) throws SQLException {
		insert("cmmnHistorySQL.insertHistoryDatabase", historyVO);
	}
	
	
	/**
	 * 전송설정 이력 등록
	 * 
	 * @param historyVO
	 * @throws SQLException
	 */

	public void insertHistoryTransferSetting(HistoryVO historyVO) throws SQLException {
		insert("cmmnHistorySQL.insertHistoryTransferSetting", historyVO);
	}
	
	
	/**
	 * Connector 조회화면 이력 등록
	 * 
	 * @param historyVO
	 * @throws SQLException
	 */
	public void insertHistoryConnectorRegister(HistoryVO historyVO) throws SQLException {
		insert("cmmnHistorySQL.insertHistoryConnectorRegister", historyVO);
	}

	
	
	/**
	 * Connector수정 이력 등록
	 * 
	 * @param historyVO
	 * @throws SQLException
	 */
	public void insertHistoryConnectorRegisterU(HistoryVO historyVO) throws SQLException {
		insert("cmmnHistorySQL.insertHistoryConnectorRegisterU", historyVO);
	}

	
	/**
	 * Connector삭제 이력 등록
	 * 
	 * @param historyVO
	 * @throws SQLException
	 */
	public void insertHistoryConnectorRegisterD(HistoryVO historyVO) throws SQLException {
		insert("cmmnHistorySQL.insertHistoryConnectorRegisterD", historyVO);
	}

	
	/**
	 * Connector 등록 팝업 화면 이력 등록
	 * 
	 * @param historyVO
	 * @throws SQLException
	 */
	public void insertHistoryConnectorRegPopup(HistoryVO historyVO) throws SQLException {
		insert("cmmnHistorySQL.insertHistoryConnectorRegPopup", historyVO);
	}

	
	/**
	 * Connector등록 이력 등록
	 * 
	 * @param historyVO
	 * @throws SQLException
	 */
	public void insertHistoryConnectorRegisterI(HistoryVO historyVO) throws SQLException {
		insert("cmmnHistorySQL.insertHistoryConnectorRegisterI", historyVO);
	}

	
	/**
	 * Connector 연결테스트 이력 등록
	 * 
	 * @param historyVO
	 * @throws SQLException
	 */
	public void insertHistoryConnectorConnTest(HistoryVO historyVO) throws SQLException {
		insert("cmmnHistorySQL.insertHistoryConnectorConnTest", historyVO);
	}

	

	public void insertHistoryUserManager(HistoryVO historyVO) throws SQLException {
		insert("cmmnHistorySQL.insertHistoryUserManager", historyVO);
	}

	public void insertHistoryUserManagerD(HistoryVO historyVO) throws SQLException {
		insert("cmmnHistorySQL.insertHistoryUserManagerD", historyVO);
	}

	public void insertHistoryUserManagerI(HistoryVO historyVO) throws SQLException {
		insert("cmmnHistorySQL.insertHistoryUserManagerI", historyVO);
	}

	public void insertHistoryUserManagerU(HistoryVO historyVO) throws SQLException {
		insert("cmmnHistorySQL.insertHistoryUserManagerU", historyVO);
	}

	public void insertHistoryMenuAuthority(HistoryVO historyVO) throws SQLException {
		insert("cmmnHistorySQL.insertHistoryMenuAuthority", historyVO);
	}

	public void insertHistoryDbAuthority(HistoryVO historyVO) throws SQLException {
		insert("cmmnHistorySQL.insertHistoryDbAuthority", historyVO);
	}

	public void insertHistoryAccessHistory(HistoryVO historyVO) throws SQLException {
		insert("cmmnHistorySQL.insertHistoryAccessHistory", historyVO);
	}

	public void insertHistoryAgentMonitoring(HistoryVO historyVO) throws SQLException {
		insert("cmmnHistorySQL.insertHistoryAgentMonitoring", historyVO);
	}

}
