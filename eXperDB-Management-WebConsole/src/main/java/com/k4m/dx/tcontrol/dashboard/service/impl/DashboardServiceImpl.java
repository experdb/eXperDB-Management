package com.k4m.dx.tcontrol.dashboard.service.impl;

import java.sql.SQLException;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.dashboard.service.DashboardService;
import com.k4m.dx.tcontrol.dashboard.service.DashboardVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("DashboardService")
public class DashboardServiceImpl extends EgovAbstractServiceImpl implements DashboardService {

	@Resource(name = "dashboardDAO")
	private DashboardDAO dashboardDAO;

	public DashboardVO selectDashboardScheduleInfo() throws SQLException {
		return (DashboardVO) dashboardDAO.selectDashboardScheduleInfo();
	}

	public DashboardVO selectDashboardBackupInfo() throws SQLException {
		return (DashboardVO) dashboardDAO.selectDashboardBackupInfo();
	}

	public List<DashboardVO> selectDashboardServerInfo(DashboardVO vo) throws SQLException {
		return (List<DashboardVO>) dashboardDAO.selectDashboardServerInfo(vo);
	}

	public List<DashboardVO> selectDashboardBackupDumpInfo(DashboardVO vo) throws SQLException {
		return (List<DashboardVO>) dashboardDAO.selectDashboardBackupDumpInfo(vo);
	}

	public List<DashboardVO> selectDashboardBackupRmanInfo(DashboardVO vo) throws SQLException {
		return (List<DashboardVO>) dashboardDAO.selectDashboardBackupRmanInfo(vo);
	}

	public int selectDashboardScheduleTotal() throws SQLException {
		return (int) dashboardDAO.selectDashboardScheduleTotal();
	}


	public int selectDashboardScheduleFail() throws SQLException {
		return (int) dashboardDAO.selectDashboardScheduleFail();
	}

	@Override
	public int selectDashboardServerTotal() throws SQLException {
		return (int) dashboardDAO.selectDashboardServerTotal();
	}

	@Override
	public int selectDashboardServerUse() throws SQLException {
		return (int) dashboardDAO.selectDashboardServerUse();
	}

	@Override
	public int selectDashboardServerDeath() throws SQLException {
		return (int) dashboardDAO.selectDashboardServerDeath();
	}
	
	@Override
	public int selectDashboardBackupTotal() throws SQLException {
		return (int) dashboardDAO.selectDashboardBackupTotal();
	}

	@Override
	public int selectDashboardBackupFail() throws SQLException {
		return (int) dashboardDAO.selectDashboardBackupFail();
	}

	@Override
	public int selectDashboardBackupNouse() throws SQLException {
		return (int) dashboardDAO.selectDashboardBackupNouse();
	}

	@Override
	public List<DbServerVO> selectDashboardServer() throws SQLException {
		return (List<DbServerVO>) dashboardDAO.selectDashboardServer();
	}



}
