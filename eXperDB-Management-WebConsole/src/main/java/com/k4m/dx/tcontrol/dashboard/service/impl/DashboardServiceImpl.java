package com.k4m.dx.tcontrol.dashboard.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.json.simple.JSONObject;
import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.dashboard.service.DashboardService;
import com.k4m.dx.tcontrol.dashboard.service.DashboardVO;
import com.k4m.dx.tcontrol.scale.service.InstanceScaleVO;

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
	
	public List<DashboardVO> selectDashboardServerInfoNew(DashboardVO vo) throws SQLException {
		return (List<DashboardVO>) dashboardDAO.selectDashboardServerInfoNew(vo);
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

	@Override
	public List<Map<String, Object>> selectDashboardScaleInfo() throws SQLException {
		return (List<Map<String, Object>>) dashboardDAO.selectDashboardScaleInfo();
	}
	
	
	////////////////////////////////////////////////////////////////////////////////////
	/**
	 * 백업, 배치 스케줄 조회
	 * 
	 * @param DashboardVO
	 * @throws SQLException
	 */
	@Override
	public List<Map<String, Object>> selectDashboardScdList(DashboardVO vo) throws SQLException {
		return (List<Map<String, Object>>) dashboardDAO.selectDashboardScdList(vo);
	}

	/**
	 * 스케줄이력목록 조회
	 * 
	 * @param DashboardVO
	 * @throws SQLException
	 */
	@Override
	public List<Map<String, Object>> selectDashboardScheduleHistory(DashboardVO vo) throws SQLException {
		return (List<Map<String, Object>>) dashboardDAO.selectDashboardScheduleHistory(vo);
	}
	
	/**
	 * 스케줄이력 chart 조회
	 * 
	 * @param param
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> selectDashboardScheduleHistoryChart(DashboardVO vo) throws SQLException {
		return (Map<String, Object>) dashboardDAO.selectDashboardScheduleHistoryChart(vo);
	}
	
	
	
}
