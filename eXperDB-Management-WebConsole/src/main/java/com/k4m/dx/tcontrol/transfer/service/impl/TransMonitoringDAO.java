package com.k4m.dx.tcontrol.transfer.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("TransMonitoringDAO")
public class TransMonitoringDAO extends EgovAbstractMapper{

	/**
	 * 소스 Connector 목록 조회
	 * 
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectSrcConnectorList() {
		List<Map<String, Object>> result = null;
		result = selectList("transMonitoringSql.selectSourceConnectorList");
		return result;
	}

	/**
	 * 소스 Connector 연결 테이블 조회
	 * 
	 * @param trans_id
	 * @return Map<String, Object>
	 */
	public Map<String, Object> selectSourceConnectorTableList(int trans_id) {
		return selectOne("transMonitoringSql.selectSourceConnectorTableList", trans_id);
	}

	/**
	 * 소스 Connect 정보
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectSourceConnectInfo(int trans_id) {
		return selectList("transMonitoringSql.selectSourceConnectInfo", trans_id);
	}
	
	/**
	 * 소스 Connector snapshot chart
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectSourceSnapshotChart(int trans_id) {
		return selectList("transMonitoringSql.selectSourceSnapshotChart", trans_id);
	}

	/**
	 * 소스 Connector snapshot 정보 테이블
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectSourceSnapshotInfo(int trans_id) {
		return selectList("transMonitoringSql.selectSourceSnapshotInfo", trans_id);
	}

	/**
	 * 소스 Connect 실시간 chart1
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectSourceChart_1(int trans_id) {
		return selectList("transMonitoringSql.selectSourceChart_1", trans_id);
	}

	/**
	 * 소스 Connect 실시간 chart2
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectSourceChart_2(int trans_id) {
		return selectList("transMonitoringSql.selectSourceChart_2", trans_id);
	}

	/**
	 * 소스 Connect error chart
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectSourceErrorChart(int trans_id) {
		return selectList("transMonitoringSql.selectSourceErrorChart", trans_id);
	}

	/**
	 * 소스 Connect error 정보
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectSourceErrorInfo(int trans_id) {
		return selectList("transMonitoringSql.selectSourceErrorInfo", trans_id);
	}

	/**
	 * 타겟 Connector 목록 조회
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectTargetConnectList(int trans_id) {
		return selectList("transMonitoringSql.selectTargetConnectList", trans_id);
	}

	/**
	 * 타겟 DBMS 정보 조회
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectTargetDBMSInfo(int trans_id) {
		return selectList("transMonitoringSql.selectTargetDBMSInfo", trans_id);
	}
	
	/**
	 * 타겟 전송대상 테이블 목록 조회
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectTargetTopicList(int trans_id) {
		return selectList("transMonitoringSql.selectTargetTopicList", trans_id);
	}
	
	/**
	 * 타겟 record sink chart
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectTargetSinkRecordChart(int trans_id) {
		return selectList("transMonitoringSql.selectTargetSinkRecordChart", trans_id);
	}
	
	/**
	 * 타겟 complete sink chart
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectTargetSinkCompleteChart(int trans_id) {
		return selectList("transMonitoringSql.selectTargetSinkCompleteChart", trans_id);
	}
	
	/**
	 * 타겟 sink 정보 조회
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */	
	public List<Map<String, Object>> selectTargetSinkInfo(int trans_id) {
		return selectList("transMonitoringSql.selectTargetSinkInfo", trans_id);
	}
	
	/**
	 * 타겟 error chart
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectTargetErrorChart(int trans_id) {
		return selectList("transMonitoringSql.selectTargetErrorChart", trans_id);
	}
	
	/**
	 * 타겟 error 정보 조회
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectTargetErrorInfo(int trans_id) {
		return selectList("transMonitoringSql.selectTargetErrorInfo", trans_id);
	}


}
