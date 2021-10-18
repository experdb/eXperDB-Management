package com.k4m.dx.tcontrol.transfer.service;

import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;

public interface TransMonitoringService {
	
	/**
	 * kafka Process CPU 조회
	 * 
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectProcessCpuList();

	/**
	 * kafka Memory 조회
	 * 
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectMemoryList();
	
	/**
	 * 소스 Connector 목록 조회
	 * 
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectSrcConnectorList();

	/**
	 * 소스 Connector 연결 테이블 조회
	 * 
	 * @param trans_id
	 * @return Map<String, Object>
	 */
	public Map<String, Object> selectSourceConnectorTableList(int trans_id);
	
	/**
	 * 소스 Connect 정보
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectSourceConnectInfo(int trans_id);
	
	/**
	 * 소스 Connector snapshot chart
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectSourceSnapshotChart(int trans_id);
	
	/**
	 * 소스 Connector snapshot 정보 테이블
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectSourceSnapshotInfo(int trans_id);

	/**
	 * 소스 Connector streaming chart 
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>> 
	 */
	public List<Map<String, Object>> selectStreamingChart(int trans_id);
	
	/**
	 * 소스 Connector streaming 정보 조회
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectStreamingInfo(int trans_id);

	/**
	 * 소스 Connect 실시간 chart1
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectSourceChart_1(int trans_id);
	
	/**
	 * 소스 Connect 실시간 chart2
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectSourceChart_2(int trans_id);
	
	/**
	 * 소스 connect 실시간 정보
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectSourceInfo(int trans_id);
	
	/**
	 * 소스 Connect error chart
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectSourceErrorChart(int trans_id);
	
	/**
	 * 소스 Connect error 정보
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectSourceErrorInfo(int trans_id);
	
	/**
	 * 타겟 Connector 목록 조회
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectTargetConnectList(int trans_id);
	
	/**
	 * 타겟 DBMS 정보 조회
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectTargetDBMSInfo(int trans_id);
	
	/**
	 * 타겟 전송대상 테이블 목록 조회
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	public Map<String, Object> selectTargetTopicList(int trans_id);
	
	/**
	 * 타겟 record sink chart
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectTargetSinkRecordChart(int trans_id);
	
	/**
	 * 타겟 complete sink chart
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectTargetSinkCompleteChart(int trans_id);
	
	/**
	 * 타겟 sink 정보 조회
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectTargetSinkInfo(int trans_id); 
	
	/**
	 * 타겟 error chart
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectTargetErrorChart(int trans_id);
	
	/**
	 * 타겟 error 정보 조회
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectTargetErrorInfo(int trans_id);
	
	/**
	 * kafka Connect 전체 에러 조회
	 * 
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectAllErrorList();
	
	/**
	 * trans log 파일 가져오기
	 * 
	 * @param param
	 * @return Map<String, Object>
	 */
	public Map<String, Object> getLogFile(TransVO transVO, Map<String, Object> param);

	/**
	 * trans kafka connect 재시작
	 * 
	 * @param transVO, param
	 * @return JSONObject
	 */
	public Map<String, Object> transKafkaConnectRestart(TransVO transVO, Map<String, Object> param);
	
	/**
	 * trans kafka 기동 정지 이력 조회
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectKafkaActCngList(int trans_id);

}
