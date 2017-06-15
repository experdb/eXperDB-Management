package com.k4m.dx.tcontrol.admin.dbserverManager.service.impl;

import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;

@Repository("DbServerManagerDAO")
public class DbServerManagerDAO {

	@Autowired
	@Qualifier("sqlMapClient")
	private SqlMapClient sqlMapClient;


	@SuppressWarnings("unchecked")
	public List<DbServerVO> selectDbServerList(DbServerVO dbServerVO) {
		List<DbServerVO> sl = null;
		try {
			sl = (List<DbServerVO>) sqlMapClient.queryForList("dbserverManagerSql.selectDbServerList", dbServerVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return sl;
	}


	public void insertDbServer(DbServerVO dbServerVO) {
		try {
			sqlMapClient.insert("dbserverManagerSql.insertDbServer", dbServerVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}		
	}
	
}
