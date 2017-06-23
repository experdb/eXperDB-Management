package com.k4m.dx.tcontrol.db.repository.dao;

import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.k4m.dx.tcontrol.db.repository.vo.DbServerInfoVO;


@Repository("SystemDAO")
public class SystemDAO {
	
	@Autowired
	@Qualifier("sqlMapClient")
	private SqlMapClient sqlMapClient;

	public List<DbServerInfoVO> selectDbServerInfoList() {
		List<DbServerInfoVO> sl = null;
		try {
			sl = (List<DbServerInfoVO>) sqlMapClient.queryForList("system.selectDbServerInfo");	
		} catch (SQLException e) {
			e.printStackTrace();
        }
		return sl;
	}
	
	public DbServerInfoVO selectDbServerInfo() {
		DbServerInfoVO sl = null;
		try {
			sl = (DbServerInfoVO) sqlMapClient.queryForObject("system.selectDbServerInfo");	
		} catch (SQLException e) {
			e.printStackTrace();
        }
		return sl;
	}

	
}
