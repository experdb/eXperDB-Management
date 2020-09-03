package com.k4m.dx.tcontrol.dashboard.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;

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
	 * 서버 정보 전체 조회
	 * 
	 * @param vo
	 * @return
	 * @throws SQLException
	 */
	public List<DashboardVO> selectDashboardServerInfoNew(DashboardVO vo) throws SQLException;

	/**
	 * 서버 정보 조회
	 * 
	 * @param vo
	 * @return
	 * @throws SQLException
	 */
	public List<DashboardVO> selectDashboardServerInfo(DashboardVO vo) throws SQLException;

	/**
	 * 관리상태_작업관리(전체스케줄수행건수)
	 * 
	 * @return
	 * @throws SQLException
	 */
	public int selectDashboardScheduleTotal() throws SQLException;

	/**
	 * 관리상태_작업관리(스케줄실패건수)
	 * 
	 * @return
	 * @throws SQLException
	 */
	public int selectDashboardScheduleFail() throws SQLException;

	/**
	 * 관리상태_서버관리(전체서버건수)
	 * 
	 * @return
	 * @throws SQLException
	 */
	public int selectDashboardServerTotal() throws SQLException;;

	/**
	 * 관리상태_서버관리(사용서버건수)
	 * 
	 * @return
	 * @throws SQLException
	 */
	public int selectDashboardServerUse() throws SQLException;
	
	/**
	 * 관리상태_서버관리(중지되어있는 서버수)
	 * 
	 * @return
	 * @throws SQLException
	 */
	public int selectDashboardServerDeath()throws SQLException;

	/**
	 * 관리상태_백업관리(전체등록건수)
	 * 
	 * @return
	 * @throws SQLException
	 */
	public int selectDashboardBackupTotal() throws SQLException;

	/**
	 * 관리상태_백업관리(실패건수)
	 * 
	 * @return
	 * @throws SQLException
	 */
	public int selectDashboardBackupFail() throws SQLException;

	/**
	 * 관리상태_백업관리(사용하지않는건수)
	 * 
	 * @return
	 * @throws SQLException
	 */
	public int selectDashboardBackupNouse() throws SQLException;

	/**
	 * //관리상태_서버관리(등록되어 있는 서버 정보)
	 * 
	 * @return
	 * @throws SQLException
	 */
	public List<DbServerVO> selectDashboardServer()throws SQLException;

	/**
	 * scale log list 조회
	 * 
	 * @return
	 * @throws SQLException
	 */
	public List<Map<String, Object>> selectDashboardScaleInfo() throws SQLException;


	
	/////////////////////////////////////////////////////////////////////////////////////
	/**
	 * 백업, 배치 스케줄 조회
	 * 
	 * @param vo
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 */
	public List<Map<String, Object>> selectDashboardScdList(DashboardVO vo) throws SQLException;

	/**
	 * 스케줄 이력 목록 조회
	 * 
	 * @param vo
	 * @return
	 * @throws SQLException
	 */
	public List<Map<String, Object>> selectDashboardScheduleHistory(DashboardVO vo) throws SQLException;
	
	/**
	 * 스케줄이력 chart 조회
	 * 
	 * @param param
	 * @throws Exception
	 */
	public Map<String, Object> selectDashboardScheduleHistoryChart(DashboardVO vo) throws SQLException;

	/**
	 * 백업 이력 목록 조회
	 * 
	 * @param vo
	 * @return
	 * @throws SQLException
	 */
	public List<Map<String, Object>> selectDashboardBackupHistory(DashboardVO vo) throws SQLException;

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
	
	/**
	 * 배치이력 chart 조회
	 * 
	 * @param param
	 * @throws Exception
	 */
	public Map<String, Object> selectDashboardScriptHistoryChart(DashboardVO vo) throws SQLException;

	/**
	 * MIGRATION 스케줄 조회
	 * 
	 * @param vo
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 */
	public List<Map<String, Object>> selectDashboardMigtList(DashboardVO vo) throws SQLException;

	/**
	 * MIGRATION 이력 목록 조회
	 * 
	 * @param vo
	 * @return
	 * @throws SQLException
	 */
	public List<Map<String, Object>> selectDashboardMigtHistory(DashboardVO vo) throws SQLException;
	
	/**
	 * MIGRATION chart 조회
	 * 
	 * @param param
	 * @throws Exception
	 */
	public Map<String, Object> selectDashboardMigtHistoryChart(DashboardVO vo) throws SQLException;
	
	/**
	 * scale 이력 chart 조회
	 * 
	 * @param param
	 * @throws Exception
	 */
	public Map<String, Object> selectDashboardScaleHistoryChart(DashboardVO vo) throws SQLException;

	/**
	 * scale 이력 목록 조회
	 * 
	 * @param vo
	 * @return
	 * @throws SQLException
	 */
	public List<Map<String, Object>> selectDashboardScaleHistory (DashboardVO vo) throws SQLException;

	/**
	 * scale 설정 chart 조회
	 * 
	 * @param vo
	 * @return
	 * @throws SQLException
	 */
	public Map<String, Object> selectDashboardScaleSetChart(DashboardVO vo) throws SQLException;

}
