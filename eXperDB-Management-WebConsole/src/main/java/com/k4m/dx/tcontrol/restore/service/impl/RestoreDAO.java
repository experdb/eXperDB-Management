package com.k4m.dx.tcontrol.restore.service.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.backup.service.WorkLogVO;
import com.k4m.dx.tcontrol.restore.service.RestoreDumpVO;
import com.k4m.dx.tcontrol.restore.service.RestoreRmanVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("restoreDAO")
public class RestoreDAO extends EgovAbstractMapper {

	public void insertRmanRestore(RestoreRmanVO restoreRmanVO) {
		insert("restoreRmanSql.insertRmanRestore", restoreRmanVO);		
	}

	public int restore_nmCheck(String restore_nm) {
		int resultSet = 0;
		resultSet = (int) getSqlSession().selectOne("restoreRmanSql.restore_nmCheck", restore_nm);
		return resultSet;
	}

	public RestoreRmanVO latestRestoreSN() {
		return (RestoreRmanVO)getSqlSession().selectOne("restoreRmanSql.latestRestoreSN");
	}

	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<RestoreRmanVO> rmanRestoreHistory(RestoreRmanVO restoreRmanVO) {
		return (List<RestoreRmanVO>) list("restoreRmanSql.rmanRestoreHistory",restoreRmanVO);
	}

	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<WorkLogVO> selectBckInfo(WorkLogVO workLogVO) {
		return (List<WorkLogVO>) list("restoreDumpSql.selectBckInfo",workLogVO);
	}

	public void insertDumpRestore(RestoreDumpVO restoreDumpVO) {
		insert("restoreDumpSql.insertDumpRestore", restoreDumpVO);				
	}

	public RestoreDumpVO latestDumpRestoreSN() {
		return (RestoreDumpVO)getSqlSession().selectOne("restoreDumpSql.latestDumpRestoreSN");
	}

}
