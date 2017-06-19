package com.k4m.dx.tcontrol.admin.accesshistory.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.login.service.UserVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("accessHistoryDAO")
public class AccessHistoryDAO extends EgovAbstractMapper{
	
	/**
	 * 접근 내역 조회
	 * 
	 * @param userVO
	 * @return List
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<UserVO> selectAccessHistory(Map<String, Object> param) throws SQLException {
		List<UserVO> result = null;
		result = (List<UserVO>) list("accessHistorySql.selectAccessHistory",param);
		return result;
	}

}
