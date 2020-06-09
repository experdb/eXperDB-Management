package com.k4m.dx.tcontrol.db2pg.dbms.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.db2pg.dbms.service.Db2pgSysInfVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("DbmsDAO")
public class DbmsDAO extends EgovAbstractMapper {

	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<Map<String, Object>> selectCharSetList(HashMap<String, Object> paramvalue) {
		List<Map<String, Object>> sl = null;
		sl = (List<Map<String, Object>>) list("dbmsSQL.selectCharSetList", paramvalue);
		return sl;
	}

	public int db2pg_sys_nmCheck(String db2pg_sys_nm) {
		int resultSet = 0;
		resultSet = (int) getSqlSession().selectOne("dbmsSQL.db2pg_sys_nmCheck", db2pg_sys_nm);
		return resultSet;
	}

	public void insertDb2pgDBMS(Db2pgSysInfVO db2pgSysInfVO) {
		insert("dbmsSQL.insertDb2pgDBMS", db2pgSysInfVO);
	}

	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Db2pgSysInfVO> selectDb2pgDBMS(Db2pgSysInfVO db2pgSysInfVO) {
		List<Db2pgSysInfVO> sl = null;
		sl = (List<Db2pgSysInfVO>) list("dbmsSQL.selectDb2pgDBMS", db2pgSysInfVO);
		return sl;
	}

	public List<Map<String, Object>> dbmsGrb() {
		List<Map<String, Object>> sl = null;
		sl = (List<Map<String, Object>>) list("dbmsSQL.dbmsGrb", null);
		return sl;
	}

	public List<Map<String, Object>> dbmsListDbmsGrb() {
		List<Map<String, Object>> sl = null;
		sl = (List<Map<String, Object>>) list("dbmsSQL.dbmsListDbmsGrb", null);
		return sl;
	}

	public void updateDb2pgDBMS(Db2pgSysInfVO db2pgSysInfVO) {
		update("dbmsSQL.updateDb2pgDBMS", db2pgSysInfVO);
	}

	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<Db2pgSysInfVO> selectDDLDb2pgDBMS(Db2pgSysInfVO db2pgSysInfVO) {
		List<Db2pgSysInfVO> sl = null;
		sl = (List<Db2pgSysInfVO>) list("dbmsSQL.selectDDLDb2pgDBMS", db2pgSysInfVO);
		return sl;
	}

	public void deleteDBMS(int db2pg_sys_id) {
		delete("dbmsSQL.deleteDBMS",db2pg_sys_id);
	}

	public int exeMigCheck() {
		int migChk = (int) getSqlSession().selectOne("dbmsSQL.exeMigCheck");
		return migChk;
	}

	public int db2pg_ddl_check(Map<String, Object> param) {
		int db2pg_ddl_check = (int) getSqlSession().selectOne("dbmsSQL.db2pg_ddl_check", param);
		return db2pg_ddl_check;
	}

	public int db2pg_mig_check(Map<String, Object> param) {
		int db2pg_mig_check = (int) getSqlSession().selectOne("dbmsSQL.db2pg_mig_check", param);
		return db2pg_mig_check;
	}

}
