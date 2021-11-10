package com.k4m.dx.tcontrol.transfer.service;

import java.util.List;
import java.util.Map;

public interface TransConService {

	/**
	 * kafka-Connection 연결 테스트
	 * 
	 * @param response, request
	 * @return result
	 * @throws Exception
	 */
	public Map<String, Object> kafkaConnectionTest(Map<String, Object> paramMap) throws Exception;
	
	/**
	 * trans kafka connect 사용여부 확인
	 * 
	 * @param transDbmsVO
	 * @throws Exception
	 */
	public String selectTransKafkaConIngChk(TransDbmsVO transDbmsVO) throws Exception;

	/**
	 * trans Schema Registry 사용여부 확인
	 * 
	 * @param transRegiVO
	 * @return String
	 * @throws Exception
	 */
	public String selectTransSchemRegiIngChk(TransRegiVO transRegiVO) throws Exception;

	/**
	 * Schema Registry 수정
	 * 
	 * @param transRegiVO
	 * @return String
	 * @throws Exception
	 */
	public String updateTransShcemaRegistry(TransRegiVO transRegiVO) throws Exception;
	
	/**
	 * Schema Registry 정보 
	 * 
	 * @param transRegiVO
	 * @return List<TransRegiVO>
	 * @throws Exception
	 */
	public List<TransRegiVO> selectTransRegiList(TransRegiVO transRegiVO) throws Exception;

	/**
	 * trans kafka connect 리스트 조회
	 * 
	 * @param transDbmsVO
	 * @return List<TransDbmsVO>
	 * @throws Exception
	 */
	public List<TransDbmsVO> selectTransKafkaConList(TransDbmsVO transDbmsVO) throws Exception;

	/**
	 * Schema Registry 수정
	 * 
	 * @param transRegiVO
	 * @return String
	 * @throws Exception
	 */
	public void deleteTransSchemaRegistry(TransRegiVO transRegiVO) throws Exception;
	
	/**
	 * trans kafka connect 설정 삭제
	 * 
	 * @param transDbmsVO
	 * @throws Exception
	 */
	public void deleteTransKafkaConnect(TransDbmsVO transDbmsVO) throws Exception;

	/**
	 * Schema Registry 등록
	 * 
	 * @param transRegiVO
	 * @return String
	 * @throws Exception
	 */
	public String insertTransSchemaRegistry(TransRegiVO transRegiVO) throws Exception;

	/**
	 * TRANS kafka connect 설정 등록
	 * 
	 * @param transDbmsVO
	 * @return String
	 * @throws Exception
	 */
	public String insertTransKafkaConnect(TransDbmsVO transDbmsVO) throws Exception;

	/**
	 * Schema Registry 커넥트명 중복 체크
	 * 
	 * @param transRegiVO
	 * @return String
	 * @throws Exception
	 */
	public String trans_Registry_nmCheck(String regi_nm) throws Exception;

	/**
	 * trans DBMS시스템 명 체크
	 * 
	 * @param transDbmsVO
	 * @return List<TransDbmsVO>
	 * @throws Exception
	 */
	public String trans_connect_nmCheck(String kc_nm) throws Exception;

	/**
	 * trans connect 수정
	 * 
	 * @param transDbmsVO
	 * @return String
	 * @throws Exception
	 */
	public String updateTransKafkaConnect(TransDbmsVO transDbmsVO) throws Exception;

	/**
	 * trans connect faild 수정
	 * 
	 * @param transDbmsVO
	 * @return String
	 * @throws Exception
	 */
	public String updateTransKafkaConnectFaild(TransDbmsVO transDbmsVO) throws Exception;

	/**
	 * select box kafka-Connection 연결 테스트
	 * 
	 * @param transDbmsVO
	 * @return String
	 * @throws Exception
	 */
	public Map<String, Object> kafkaConnectionTestUpdate(TransDbmsVO transDbmsVO, List<TransDbmsVO> resultSet, int db_svr_id, String id) throws Exception;

	/**
	 * select box schema Registry 연결 테스트
	 * 
	 * @param transDbmsVO
	 * @return String
	 * @throws Exception
	 */
	public Map<String, Object> schemaRegistryTestUpdate(TransRegiVO transRegiVO, List<TransRegiVO> resultSet, int db_svr_id, String id) throws Exception;
	
	/**
	 * trans schema registry connect 수정
	 * 
	 * @param transDbmsVO
	 * @return String
	 * @throws Exception
	 */
	public String updateTransSchemaConnectFaild(TransRegiVO transRegiVO) throws Exception;
}
