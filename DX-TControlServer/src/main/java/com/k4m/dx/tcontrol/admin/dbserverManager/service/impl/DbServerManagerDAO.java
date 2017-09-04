package com.k4m.dx.tcontrol.admin.dbserverManager.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.backup.service.DbVO;

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
		sl = (List<DbServerVO>) list("dbserverManagerSql.selectDbServerList", dbServerVO);
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

	
	/**
	 * DB서버 정보 수정
	 * 
	 * @param dbServerVO
	 * @return 
	 * @throws Exception
	 */	
	public void updateDbServer(DbServerVO dbServerVO) throws SQLException {
		update("dbserverManagerSql.updateDbServer", dbServerVO);	
	}


	/**
	 * DB 삭제
	 * 
	 * @param dbServerVO
	 * @return 
	 * @throws Exception
	 */	
	public void deleteDB(DbServerVO dbServerVO) throws SQLException{
		delete("dbserverManagerSql.deleteDB", dbServerVO);	
	}


	/**
	 * DB 등록
	 * 
	 * @param paramvalue
	 * @return 
	 * @throws Exception
	 */	
	public void insertDB(HashMap<String, Object> paramvalue) {
		insert("dbserverManagerSql.insertDB",paramvalue );		
	}

	
	/**
	 * DB 정보 조회
	 * 
	 * @param 
	 * @return List
	 * @throws Exception
	 */	
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<DbVO> selectDbList() {
		List<DbVO> sl = null;
		sl = (List<DbVO>) list("dbserverManagerSql.selectDbList", null);
		return sl;
	}


	/**
	 * Repository DB 정보 조회
	 * @param paramvalue 
	 * 
	 * @param 
	 * @return List
	 * @throws Exception
	 */	
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<Map<String, Object>> selectRepoDBList(HashMap<String, Object> paramvalue) {
		List<Map<String, Object>>  sl = null;
		sl = (List<Map<String, Object>>) list("dbserverManagerSql.selectRepoDBList", paramvalue);
		return sl;
	}


	/**
	 * Repository DB에 등록되어 있는 DB의 서버명 SelectBox 
	 * @param db_svr_id 
	 * 
	 * @param 
	 * @return List
	 * @throws Exception
	 */	
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<Map<String, Object>> selectSvrList(int db_svr_id) {
		List<Map<String, Object>>  sl = null;
		sl = (List<Map<String, Object>>) list("dbserverManagerSql.selectSvrList", db_svr_id);
		return sl;
	}


	public int dbServerIpCheck(String ipadr) {
		int resultSet = 0;
		resultSet = (int) getSqlSession().selectOne("dbserverManagerSql.dbServerIpCheck", ipadr);
		return resultSet;
	}


	public int selectDBcnt(DbServerVO dbServerVO) {
		int resultSet = 0;
		resultSet = (int) getSqlSession().selectOne("dbserverManagerSql.selectDBcnt", dbServerVO);
		return resultSet;
	}


	public void updateDB(HashMap<String, Object> paramvalue) {
		update("dbserverManagerSql.updateDB",paramvalue );		
	}


	public int db_svr_nmCheck(String db_svr_nm) {
		int resultSet = 0;
		resultSet = (int) getSqlSession().selectOne("dbserverManagerSql.db_svr_nmCheck", db_svr_nm);
		return resultSet;
	}

}
