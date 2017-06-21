package com.k4m.dx.tcontrol.common.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.common.service.CmmnHistoryService;
import com.k4m.dx.tcontrol.common.service.HistoryVO;

@Service("cmmnCodeHistoryServiceImpl")
public class CmmnCodeHistoryServiceImpl implements CmmnHistoryService {

	@Resource(name = "CmmnHistoryDAO")
	private CmmnHistoryDAO cmmnHistoryDAO;


	@Override
	public void insertHistoryDbTree(HistoryVO historyVO) throws Exception {
		cmmnHistoryDAO.insertHistoryDbTree(historyVO);
	}

	@Override
	public void insertHistoryDbServer(HistoryVO historyVO) throws Exception {
		cmmnHistoryDAO.insertHistoryDbServer(historyVO);
	}

	@Override
	public void insertHistoryDbServerRegPopup(HistoryVO historyVO) throws Exception {
		cmmnHistoryDAO.insertHistoryDbServerRegPopup(historyVO);
	}

	@Override
	public void insertHistoryDbServerI(HistoryVO historyVO) throws Exception {
		cmmnHistoryDAO.insertHistoryDbServerI(historyVO);

	}

	@Override
	public void insertHistoryDatabase(HistoryVO historyVO) throws Exception {
		cmmnHistoryDAO.insertHistoryDatabase(historyVO);
	}


}
