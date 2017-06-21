package com.k4m.dx.tcontrol.common.service.impl;

import java.sql.SQLException;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.common.service.HistoryVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("CmmnHistoryDAO")
public class CmmnHistoryDAO extends EgovAbstractMapper{

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
	
}
