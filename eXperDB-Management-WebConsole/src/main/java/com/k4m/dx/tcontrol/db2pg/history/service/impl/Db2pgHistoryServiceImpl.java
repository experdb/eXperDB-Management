package com.k4m.dx.tcontrol.db2pg.history.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.db2pg.history.service.Db2pgHistoryService;
import com.k4m.dx.tcontrol.db2pg.history.service.Db2pgHistoryVO;
import com.k4m.dx.tcontrol.db2pg.history.service.Db2pgMigHistoryDetailVO;
import com.k4m.dx.tcontrol.db2pg.history.service.Db2pgMigHistoryVO;

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

	
	
	/**
	 *  MIGRATION 수행이력 조회
	 * 2021-11-30 (변승우 책임)
	 **/
	@Override
	public List<Db2pgMigHistoryVO> selectMigHistory(Db2pgMigHistoryVO db2pgMigHistoryVO) throws Exception {
		return db2pgHistoryDAO.selectMigHistory(db2pgMigHistoryVO);
	}

	/**
	 *  MIGRATION 수행이력 디테일 조회
	 * 2021-11-30 (변승우 책임)
	 **/
	@Override
	public List<Db2pgMigHistoryDetailVO> selectMigHistoryDetail(Db2pgMigHistoryDetailVO db2pgMigHistoryDetailVO)
			throws Exception {
		return db2pgHistoryDAO.selectMigHistoryDetail(db2pgMigHistoryDetailVO);
	}

	/**
	 *  MIGRATION 수행이력 디테일 조회 (조회조건 조회)
	 * 2021-12-02 (변승우 책임)
	 **/
	@Override
	public List<Db2pgMigHistoryDetailVO> selectMigTableInfo(Db2pgMigHistoryDetailVO db2pgMigHistoryDetailVO)
			throws Exception {
		return db2pgHistoryDAO.selectMigTableInfo(db2pgMigHistoryDetailVO);
	}

	@Override
	public void db2pgStop(String mig_nm) throws Exception {
		db2pgHistoryDAO.db2pgStop(mig_nm);
	}



}
