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

	/**
	 * 백업이력목록 조회
	 * 
	 * @param DashboardVO
	 * @throws SQLException
	 */
	@Override
	public List<Map<String, Object>> selectDashboardBackupHistory(DashboardVO vo) throws SQLException {
		return (List<Map<String, Object>>) dashboardDAO.selectDashboardBackupHistory(vo);
	}

	/**
	 * dump 백업 목록 조회
	 * 
	 * @param DashboardVO
	 * @throws SQLException
	 */
	public List<DashboardVO> selectDashboardBackupDumpInfo(DashboardVO vo) throws SQLException {
		return (List<DashboardVO>) dashboardDAO.selectDashboardBackupDumpInfo(vo);
	}

	/**
	 * Dashboard 백업정보 ONLINE 조회
	 * 
	 * @return
	 * @throws SQLException
	 */
	public List<DashboardVO> selectDashboardBackupRmanInfo(DashboardVO vo) throws SQLException {
		return (List<DashboardVO>) dashboardDAO.selectDashboardBackupRmanInfo(vo);
	}
	
	/**
	 * 배치이력 chart 조회
	 * 
	 * @param param
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> selectDashboardScriptHistoryChart(DashboardVO vo) throws SQLException {
		return (Map<String, Object>) dashboardDAO.selectDashboardScriptHistoryChart(vo);
	}

	/**
	 * MIGRATION 스케줄 조회
	 * 
	 * @param DashboardVO
	 * @throws SQLException
	 */
	@Override
	public List<Map<String, Object>> selectDashboardMigtList(DashboardVO vo) throws SQLException {
		return (List<Map<String, Object>>) dashboardDAO.selectDashboardMigtList(vo);
	}

	/**
	 * MIGRATION 이력목록 조회
	 * 
	 * @param DashboardVO
	 * @throws SQLException
	 */
	@Override
	public List<Map<String, Object>> selectDashboardMigtHistory(DashboardVO vo) throws SQLException {
		return (List<Map<String, Object>>) dashboardDAO.selectDashboardMigtHistory(vo);
	}
	
	/**
	 * MIGRATION 이력 chart 조회
	 * 
	 * @param param
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> selectDashboardMigtHistoryChart(DashboardVO vo) throws SQLException {
		return (Map<String, Object>) dashboardDAO.selectDashboardMigtHistoryChart(vo);
	}

	/**
	 * scale 이력목록 조회
	 * 
	 * @param DashboardVO
	 * @throws SQLException
	 */
	@Override
	public List<Map<String, Object>> selectDashboardScaleHistory(DashboardVO vo) throws SQLException {
		return (List<Map<String, Object>>) dashboardDAO.selectDashboardScaleHistory(vo);
	}

	/**
	 * scale 이력 chart 조회
	 * 
	 * @param param
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> selectDashboardScaleHistoryChart(DashboardVO vo) throws SQLException {
		return (Map<String, Object>) dashboardDAO.selectDashboardScaleHistoryChart(vo);
	}
	
	/**
	 * scale 발생이력 chart 조회
	 * 
	 * @param param
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> selectDashboardScaleSetChart(DashboardVO vo) throws SQLException {
		return (Map<String, Object>) dashboardDAO.selectDashboardScaleSetChart(vo);
	}

}
