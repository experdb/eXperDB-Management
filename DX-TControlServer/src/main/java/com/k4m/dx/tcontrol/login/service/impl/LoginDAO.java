package com.k4m.dx.tcontrol.login.service.impl;

import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.k4m.dx.tcontrol.login.service.UserVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("loginDAO")
public class LoginDAO extends EgovAbstractMapper{
	
	/**
	 * 로그인 정보 조회
	 * 
	 * @param userVO
	 * @return List
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<UserVO> selectUserList(UserVO userVO) throws SQLException {
		List<UserVO> result = null;
		result = (List<UserVO>) list("cmmnListSQL.selectLoginUserList", userVO);	
		return result;
	}

}
