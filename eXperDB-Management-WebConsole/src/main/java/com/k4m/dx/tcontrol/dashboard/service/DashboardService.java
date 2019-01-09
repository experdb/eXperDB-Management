package com.k4m.dx.tcontrol.dashboard.service;

import java.sql.SQLException;
import java.util.List;

public interface DashboardService {

	/**
	 * Dashboard 스케줄정보 조회
	 * 
	 * @param param
	 * @param userVo
	 * @return
	 * @throws Exception
	 */
	public DashboardVO selectDashboardScheduleInfo() throws SQLException;

	/**
	 * Dashboard 백업정보 조회
	 * 
	 * @return
	 * @throws SQLException
	 */
	public DashboardVO selectDashboardBackupInfo() throws SQLException;

	/**
	 * 서버 정보 조회
	 * 
	 * @param vo
	 * @return
	 * @throws SQLException
	 */
	public List<DashboardVO> selectDashboardServerInfo(DashboardVO vo) throws SQLException;

	/**
	 * Dashboard 백업정보 DUMP 조회
	 * 
	 * @return
	 * @throws SQLException
	 */
	public List<DashboardVO> selectDashboardBackupDumpInfo(DashboardVO vo) throws SQLException;

	/**
	 * Dashboard 백업정보 ONLINE 조회
	 * 
	 * @return
	 * @throws SQLException
	 */
	public List<DashboardVO> selectDashboardBackupRmanInfo(DashboardVO vo) throws SQLException;





}
