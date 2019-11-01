package com.k4m.dx.tcontrol.db2pg.history.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.db2pg.history.service.Db2pgHistoryVO;
import com.k4m.dx.tcontrol.db2pg.setting.service.CodeVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("db2pgHistoryDAO")
public class Db2pgHistoryDAO extends EgovAbstractMapper{

	public void insertImdExe(Map<String, Object> param) throws SQLException {
		insert("db2pgHistorySql.insertImdExe", param);
	}

	public List<Db2pgHistoryVO> selectDb2pgHistory(Db2pgHistoryVO db2pgHistoryVO) {
		List<Db2pgHistoryVO> result = null;
		result = (List<Db2pgHistoryVO>) list("db2pgHistorySql.selectDb2pgHistory", db2pgHistoryVO);
		return result;
	}

}
