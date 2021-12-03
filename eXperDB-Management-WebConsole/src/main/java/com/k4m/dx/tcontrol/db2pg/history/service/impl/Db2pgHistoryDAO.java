package com.k4m.dx.tcontrol.db2pg.history.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.db2pg.history.service.Db2pgHistoryVO;
import com.k4m.dx.tcontrol.db2pg.history.service.Db2pgMigHistoryDetailVO;
import com.k4m.dx.tcontrol.db2pg.history.service.Db2pgMigHistoryVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("db2pgHistoryDAO")
public class Db2pgHistoryDAO extends EgovAbstractMapper{

	public void insertMigExe(Map<String, Object> param) throws SQLException {
		insert("db2pgHistorySql.insertMigExe", param);
	}

	public void updateMigExe(Map<String, Object> param) {
		update("db2pgHistorySql.updateMigExe", param);
	}
	

	public int lastMigExe() throws SQLException {
		return selectOne("db2pgHistorySql.selectLastMigExe");
	}

	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Db2pgHistoryVO> selectDb2pgDDLHistory(Db2pgHistoryVO db2pgHistoryVO) {
		List<Db2pgHistoryVO> result = null;
		result = (List<Db2pgHistoryVO>) list("db2pgHistorySql.selectDb2pgDDLHistory", db2pgHistoryVO);
		return result;
	}

	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<Db2pgHistoryVO> selectDb2pgMigHistory(Db2pgHistoryVO db2pgHistoryVO) {
		List<Db2pgHistoryVO> result = null;
		result = (List<Db2pgHistoryVO>) list("db2pgHistorySql.selectDb2pgMigHistory", db2pgHistoryVO);
		return result;
	}

	public Db2pgHistoryVO selectDb2pgDdlHistoryDetail(int mig_exe_sn) {
		return (Db2pgHistoryVO) selectOne("db2pgHistorySql.selectDb2pgDdlHistoryDetail", mig_exe_sn);
	}

	public Db2pgHistoryVO selectDb2pgMigHistoryDetail(int mig_exe_sn) {
		return (Db2pgHistoryVO) selectOne("db2pgHistorySql.selectDb2pgMigHistoryDetail", mig_exe_sn);
	}

	
	/**
	 *  MIGRATION 수행이력 조회
	 * 2021-11-30 (변승우 책임)
	 **/
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<Db2pgMigHistoryVO> selectMigHistory(Db2pgMigHistoryVO db2pgMigHistoryVO) {
		List<Db2pgMigHistoryVO> result = null;
		result = (List<Db2pgMigHistoryVO>) list("db2pgHistorySql.selectMigHistory", db2pgMigHistoryVO);
		return result;
	}

	
	/**
	 *  MIGRATION 수행이력 디테일 조회
	 * 2021-11-30 (변승우 책임)
	 **/
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Db2pgMigHistoryDetailVO> selectMigHistoryDetail(Db2pgMigHistoryDetailVO db2pgMigHistoryDetailVO) {
		List<Db2pgMigHistoryDetailVO> result = null;
		result = (List<Db2pgMigHistoryDetailVO>) list("db2pgHistorySql.selectMigHistoryDetail", db2pgMigHistoryDetailVO);
		return result;
	}

	
	/**
	 *  MIGRATION 수행이력 디테일 조회 (조회조건 조회)
	 * 2021-12-02 (변승우 책임)
	 **/
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Db2pgMigHistoryDetailVO> selectMigTableInfo(Db2pgMigHistoryDetailVO db2pgMigHistoryDetailVO) {
		List<Db2pgMigHistoryDetailVO> result = null;
		result = (List<Db2pgMigHistoryDetailVO>) list("db2pgHistorySql.selectMigTableInfo", db2pgMigHistoryDetailVO);
		return result;
	}
}
