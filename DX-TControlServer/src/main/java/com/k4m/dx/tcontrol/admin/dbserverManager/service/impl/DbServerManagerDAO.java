package com.k4m.dx.tcontrol.admin.dbserverManager.service.impl;

import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.login.service.UserVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("dbServerManagerDAO")
public class DbServerManagerDAO extends EgovAbstractMapper{

	
	/**
	 * DB서버 정보 조회
	 * 
	 * @param dbServerVO
	 * @return List
	 * @throws Exception
	 */	
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<DbServerVO> selectDbServerList(DbServerVO dbServerVO) throws SQLException {
		List<DbServerVO> sl = null;
		sl = (List<DbServerVO>) list("dbserverManagerSql.selectLoginUserList", dbServerVO);
		return sl;
	}

	
	/**
	 * DB서버 정보 등록
	 * 
	 * @param dbServerVO
	 * @return 
	 * @throws Exception
	 */	
	public void insertDbServer(DbServerVO dbServerVO) throws SQLException {
		insert("dbserverManagerSql.insertDbServer", dbServerVO);		
	}
	
}
