package com.k4m.dx.tcontrol.dashboard.service.impl;

import java.sql.SQLException;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.admin.agentmonitoring.service.AgentMonitoringVO;
import com.k4m.dx.tcontrol.dashboard.service.DashboardService;
import com.k4m.dx.tcontrol.dashboard.service.DashboardVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("DashboardService")
public class DashboardServiceImpl extends EgovAbstractServiceImpl implements DashboardService{
	
	@Resource(name = "dashboardDAO")
	private DashboardDAO dashboardDAO;

	public DashboardVO selectDashboardScheduleInfo() throws SQLException{
		return (DashboardVO) dashboardDAO.selectDashboardScheduleInfo();
	}
	
	public DashboardVO selectDashboardBackupInfo() throws SQLException {
		return (DashboardVO) dashboardDAO.selectDashboardBackupInfo();
	}
	
	public List<DashboardVO> selectDashboardServerInfo(DashboardVO vo) throws SQLException{
		return (List<DashboardVO>) dashboardDAO.selectDashboardServerInfo(vo);
	}

}
