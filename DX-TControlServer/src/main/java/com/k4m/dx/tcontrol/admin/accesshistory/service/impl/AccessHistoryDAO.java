package com.k4m.dx.tcontrol.admin.accesshistory.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.k4m.dx.tcontrol.login.service.UserVO;

@Repository("AccessHistoryDAO")
public class AccessHistoryDAO {
	
	@Autowired
	@Qualifier("sqlMapClient")
	private SqlMapClient sqlMapClient;

	@SuppressWarnings("unchecked")
	public List<UserVO> selectAccessHistory(Map<String, Object> param) {
		List<UserVO> sl = null;
		try {
			sl = (List<UserVO>) sqlMapClient.queryForList("userAccessSql.selectAccessHistory",param);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return sl;
	}

}
