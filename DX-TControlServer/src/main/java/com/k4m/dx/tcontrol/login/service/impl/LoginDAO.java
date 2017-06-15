package com.k4m.dx.tcontrol.login.service.impl;

import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.k4m.dx.tcontrol.login.service.UserVO;

@Repository("LoginDAO")
public class LoginDAO {
	
	@Autowired
	@Qualifier("sqlMapClient")
	private SqlMapClient sqlMapClient;

	@SuppressWarnings("unchecked")
	public List<UserVO> selectUserList(UserVO userVO) {
		List<UserVO> result = null;
		try {
			//사용자 정보 조회
			result = (List<UserVO>) sqlMapClient.queryForList("cmmnListSQL.selectLoginUserList", userVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}	
		return result;
	}


	public void insertLoginLog(UserVO userVO) {
		try {
			sqlMapClient.insert("cmmnListSQL.insertLoginLog", userVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}	
	}


	public void insertLogoutLog(UserVO userVo) {
		try {
			sqlMapClient.insert("cmmnListSQL.insertLogoutLog", userVo);
		} catch (SQLException e) {
			e.printStackTrace();
		}	
	}
	
}
