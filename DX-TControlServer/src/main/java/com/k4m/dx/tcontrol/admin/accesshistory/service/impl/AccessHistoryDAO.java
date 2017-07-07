package com.k4m.dx.tcontrol.admin.accesshistory.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.login.service.UserVO;
import com.k4m.dx.tcontrol.sample.service.PagingVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("accessHistoryDAO")
public class AccessHistoryDAO extends EgovAbstractMapper{
	
	/**
	 * 화면접근 내역 조회
	 * 
	 * @param userVO
	 * @return List
	 * @throws SQLException
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<UserVO> selectAccessHistory(Map<String, Object> param) throws SQLException {
		List<UserVO> result = null;
		result = (List<UserVO>) list("accessHistorySql.selectAccessHistory",param);
		return result;
	}
	
	/**
	 * 화면접근 이력 등록
	 * 
	 * @param historyVO
	 * @throws SQLException
	 */
	public void insertHistory(HistoryVO historyVO) throws SQLException{
		insert("accessHistorySql.insertHistory", historyVO);	
	}

	/**
	 * 화면접근 내역 조회
	 * 
	 * @param userVO
	 * @return List
	 * @throws SQLException
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<UserVO> selectAccessHistoryList(PagingVO searchVO) throws SQLException{
		List<UserVO> result = null;
		result = (List<UserVO>) list("accessHistorySql.selectAccessHistoryList",searchVO);
		return result;
	}
	
	/**
	 * 화면접근 내역 총 갯수
	 * 
	 * @return TotCnt
	 * @throws SQLExceptio
	 */
	public int selectAccessHistoryTotCnt() throws SQLException{
		int TotCnt= 0;
		TotCnt = (int) getSqlSession().selectOne("accessHistorySql.selectAccessHistoryTotCnt");
		return TotCnt;
	}

}
