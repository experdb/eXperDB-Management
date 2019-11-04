package com.k4m.dx.tcontrol.db2pg.history.service.impl;



import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.db2pg.history.service.Db2pgHistoryService;
import com.k4m.dx.tcontrol.db2pg.history.service.Db2pgHistoryVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("Db2pgHistoryServiceImpl")
public class Db2pgHistoryServiceImpl extends EgovAbstractServiceImpl implements Db2pgHistoryService{
	
	@Resource(name = "db2pgHistoryDAO")
	private Db2pgHistoryDAO db2pgHistoryDAO;

	@Override
	public void insertImdExe(Map<String, Object> param) throws Exception {
		db2pgHistoryDAO.insertImdExe(param);
	}

	@Override
	public List<Db2pgHistoryVO> selectDb2pgHistory(Db2pgHistoryVO db2pgHistoryVO) throws Exception {
		return db2pgHistoryDAO.selectDb2pgHistory(db2pgHistoryVO);
	}

}
