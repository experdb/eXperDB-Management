package com.k4m.dx.tcontrol.db2pg.history.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.db2pg.history.service.Db2pgHistoryService;
import com.k4m.dx.tcontrol.db2pg.history.service.Db2pgHistoryVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("Db2pgHistoryServiceImpl")
public class Db2pgHistoryServiceImpl extends EgovAbstractServiceImpl implements Db2pgHistoryService {

	@Resource(name = "db2pgHistoryDAO")
	private Db2pgHistoryDAO db2pgHistoryDAO;

	@Override
	public void insertMigExe(Map<String, Object> param) throws Exception {
		db2pgHistoryDAO.insertMigExe(param);
	}

	@Override
	public void updateMigExe(Map<String, Object> param) throws Exception {
		db2pgHistoryDAO.updateMigExe(param);
	}
	

	@Override
	public int lastMigExe() throws Exception {
		return db2pgHistoryDAO.lastMigExe();
	}

	@Override
	public List<Db2pgHistoryVO> selectDb2pgDDLHistory(Db2pgHistoryVO db2pgHistoryVO) throws Exception {
		return db2pgHistoryDAO.selectDb2pgDDLHistory(db2pgHistoryVO);
	}

	@Override
	public List<Db2pgHistoryVO> selectDb2pgMigHistory(Db2pgHistoryVO db2pgHistoryVO) throws Exception {
		return db2pgHistoryDAO.selectDb2pgMigHistory(db2pgHistoryVO);
	}

	@Override
	public Db2pgHistoryVO selectDb2pgDdlHistoryDetail(int mig_exe_sn) throws Exception {
		return db2pgHistoryDAO.selectDb2pgDdlHistoryDetail(mig_exe_sn);
	}

	@Override
	public Db2pgHistoryVO selectDb2pgMigHistoryDetail(int mig_exe_sn) throws Exception {
		return db2pgHistoryDAO.selectDb2pgMigHistoryDetail(mig_exe_sn);
	}



}
