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
	public void insertHistoryLogin(HistoryVO historyVO) throws Exception {
		cmmnHistoryDAO.insertHistoryLogin(historyVO);
	}

	@Override
	public void insertHistoryLogout(HistoryVO historyVO) throws Exception {
		cmmnHistoryDAO.insertHistoryLogout(historyVO);
	}

	@Override
	public void insertHistoryMain(HistoryVO historyVO) throws Exception {
		cmmnHistoryDAO.insertHistoryMain(historyVO);
	}

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

	@Override
	public void insertHistoryTransferSetting(HistoryVO historyVO) throws Exception {
		cmmnHistoryDAO.insertHistoryTransferSetting(historyVO);
	}

	@Override
	public void insertHistoryConnectorRegister(HistoryVO historyVO) throws Exception {
		cmmnHistoryDAO.insertHistoryConnectorRegister(historyVO);
	}

	@Override
	public void insertHistoryConnectorRegisterU(HistoryVO historyVO) throws Exception {
		cmmnHistoryDAO.insertHistoryConnectorRegisterU(historyVO);
	}

	@Override
	public void insertHistoryConnectorRegisterD(HistoryVO historyVO) throws Exception {
		cmmnHistoryDAO.insertHistoryConnectorRegisterD(historyVO);
	}

	@Override
	public void insertHistoryConnectorRegPopup(HistoryVO historyVO) throws Exception {
		cmmnHistoryDAO.insertHistoryConnectorRegPopup(historyVO);
	}

	@Override
	public void insertHistoryConnectorRegisterI(HistoryVO historyVO) throws Exception {
		cmmnHistoryDAO.insertHistoryConnectorRegisterI(historyVO);
	}

	@Override
	public void insertHistoryConnectorConnTest(HistoryVO historyVO) throws Exception {
		cmmnHistoryDAO.insertHistoryConnectorConnTest(historyVO);
	}

	@Override
	public void insertHistoryUserManager(HistoryVO historyVO) throws Exception {
		cmmnHistoryDAO.insertHistoryUserManager(historyVO);
	}

	@Override
	public void insertHistoryUserManagerD(HistoryVO historyVO) throws Exception {
		cmmnHistoryDAO.insertHistoryUserManagerD(historyVO);
	}

	@Override
	public void insertHistoryUserManagerI(HistoryVO historyVO) throws Exception {
		cmmnHistoryDAO.insertHistoryUserManagerI(historyVO);
	}

	@Override
	public void insertHistoryUserManagerU(HistoryVO historyVO) throws Exception {
		cmmnHistoryDAO.insertHistoryUserManagerU(historyVO);
	}

	@Override
	public void insertHistoryMenuAuthority(HistoryVO historyVO) throws Exception {
		cmmnHistoryDAO.insertHistoryMenuAuthority(historyVO);
	}

	@Override
	public void insertHistoryDbAuthority(HistoryVO historyVO) throws Exception {
		cmmnHistoryDAO.insertHistoryDbAuthority(historyVO);
	}

	@Override
	public void insertHistoryAccessHistory(HistoryVO historyVO) throws Exception {
		cmmnHistoryDAO.insertHistoryAccessHistory(historyVO);
	}

	@Override
	public void insertHistoryAgentMonitoring(HistoryVO historyVO) throws Exception {
		cmmnHistoryDAO.insertHistoryAgentMonitoring(historyVO);
	}

}
