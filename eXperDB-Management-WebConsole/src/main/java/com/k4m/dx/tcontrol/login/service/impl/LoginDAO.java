package com.k4m.dx.tcontrol.login.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

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
		result = (List<UserVO>) list("cmmnSql.selectLoginUserList", userVO);	
		return result;
	}

	public int selectMasterCheck() {
		return (int) getSqlSession().selectOne("cmmnSql.selectMasterCheck");
	}


	public void insertKeepLogin(UserVO userVo) {
		insert("cmmnSql.insertKeepLogin",userVo);
	}

	@SuppressWarnings({ "deprecation", "unchecked" })
	public UserVO checkUserWithSessionKey(UserVO userVO) throws SQLException {
		return (UserVO) selectOne("cmmnSql.checkUserWithSessionKey", userVO);
	}
}
