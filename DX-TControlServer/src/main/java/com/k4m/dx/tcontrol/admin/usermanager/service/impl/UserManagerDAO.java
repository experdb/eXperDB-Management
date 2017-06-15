package com.k4m.dx.tcontrol.admin.usermanager.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.k4m.dx.tcontrol.login.service.UserVO;

@Repository("UserManagerDAO")
public class UserManagerDAO {

	@Autowired
	@Qualifier("sqlMapClient")
	private SqlMapClient sqlMapClient;

	public void insertUserManager(UserVO userVo) {
		try {
			sqlMapClient.insert("userManagerSql.insertUserManager", userVo);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@SuppressWarnings("unchecked")
	public List<UserVO> selectUserManager(Map<String, Object> param) {
		List<UserVO> sl = null;
		try {
			sl = (List<UserVO>) sqlMapClient.queryForList("userManagerSql.selectUserManager", param);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return sl;
	}

	public int userManagerIdCheck(String usr_id) {
		int resultSet = 0;
		try {
			resultSet = (int) sqlMapClient.queryForObject("userManagerSql.userManagerIdCheck", usr_id);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return resultSet;
	}

	public void deleteUserManager(String string) {
		try {
			sqlMapClient.delete("userManagerSql.deleteUserManager", string);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@SuppressWarnings("unchecked")
	public List<UserVO> selectDetailUserManager(String usr_id) {
		List<UserVO> sl = null;
		try {
			sl = (List<UserVO>) sqlMapClient.queryForList("userManagerSql.selectDetailUserManager", usr_id);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return sl;
	}

	public void updateUserManager(UserVO userVo) {
		try {
			sqlMapClient.update("userManagerSql.updateUserManager", userVo);
		} catch (SQLException e) {
			e.printStackTrace();
		}	
	}
}
