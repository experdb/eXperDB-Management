package com.k4m.dx.tcontrol.transfer.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.transfer.service.TransMonitoringService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("TransMonitoringServiceImpl")
public class TransMonitoringServiceImpl  extends EgovAbstractServiceImpl implements TransMonitoringService{

	@Resource(name = "TransMonitoringDAO")
	private TransMonitoringDAO transMonitoringDAO;
	
	/**
	 * 소스 Connector 목록 조회
	 * 
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectSrcConnectorList() {
		return transMonitoringDAO.selectSrcConnectorList();
	}

	/**
	 * 소스 Connector 연결 테이블 조회
	 * 
	 * @param trans_id
	 * @return Map<String, Object>
	 */
	@Override
	public Map<String, Object> selectSourceConnectorTableList(int trans_id) {
		return transMonitoringDAO.selectSourceConnectorTableList(trans_id);
	}

	/**
	 * 소스 Connect 정보
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectSourceConnectInfo(int trans_id) {
		return transMonitoringDAO.selectSourceConnectInfo(trans_id);
	}

	/**
	 * 소스 Connector snapshot chart
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectSourceSnapshotChart(int trans_id) {
		return transMonitoringDAO.selectSourceSnapshotChart(trans_id);
	}

	/**
	 * 소스 Connector snapshot 정보 테이블
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectSourceSnapshotInfo(int trans_id) {
		return transMonitoringDAO.selectSourceSnapshotInfo(trans_id);
	}

	/**
	 * 소스 Connect 실시간 chart1
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectSourceChart_1(int trans_id) {
		return transMonitoringDAO.selectSourceChart_1(trans_id);
	}

	/**
	 * 소스 Connect 실시간 chart2
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectSourceChart_2(int trans_id) {
		return transMonitoringDAO.selectSourceChart_2(trans_id);
	}

	/**
	 * 소스 Connect error chart
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectSourceErrorChart(int trans_id) {
		return transMonitoringDAO.selectSourceErrorChart(trans_id);
	}

	/**
	 * 소스 Connect error 정보
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectSourceErrorInfo(int trans_id) {
		return transMonitoringDAO.selectSourceErrorInfo(trans_id);
	}

	/**
	 * 타겟 Connector 목록 조회
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectTargetConnectList(int trans_id) {
		return transMonitoringDAO.selectTargetConnectList(trans_id);
	}

	/**
	 * 타겟 DBMS 정보 조회
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectTargetDBMSInfo(int trans_id) {
		return transMonitoringDAO.selectTargetDBMSInfo(trans_id);
	}

	/**
	 * 타겟 전송대상 테이블 목록 조회
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectTargetTopicList(int trans_id) {
		return transMonitoringDAO.selectTargetTopicList(trans_id);
	}

	/**
	 * 타겟 record sink chart
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectTargetSinkRecordChart(int trans_id) {
		return transMonitoringDAO.selectTargetSinkRecordChart(trans_id);
	}
	
	/**
	 * 타겟 complete sink chart
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectTargetSinkCompleteChart(int trans_id) {
		return transMonitoringDAO.selectTargetSinkCompleteChart(trans_id);
	}
	
	/**
	 * 타겟 sink 정보 조회
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectTargetSinkInfo(int trans_id) {
		return transMonitoringDAO.selectTargetSinkInfo(trans_id);
	}
	
	/**
	 * 타겟 error chart
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectTargetErrorChart(int trans_id) {
		return transMonitoringDAO.selectTargetErrorChart(trans_id);
	}
	
	/**
	 * 타겟 error 정보 조회
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectTargetErrorInfo(int trans_id) {
		return transMonitoringDAO.selectTargetErrorInfo(trans_id);
	}


	
	
}
