package com.k4m.dx.tcontrol.transfer.service;

import java.util.List;
import java.util.Map;



public interface TransService {

	/**
	 * 소스시스템 전송설정 조회
	 * 
	 * @param transVO
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectTransSetting(TransVO transVO) throws Exception;

	/**
	 * trans DBMS시스템 리스트 조회
	 * 
	 * @param transDbmsVO
	 * @return List<TransDbmsVO>
	 * @throws Exception
	 */
	public List<TransDbmsVO> selectTransDBMS(TransDbmsVO transDbmsVO) throws Exception;

	/**
	 * trans DBMS시스템 명 체크
	 * 
	 * @param transDbmsVO
	 * @return List<TransDbmsVO>
	 * @throws Exception
	 */
	public String trans_sys_nmCheck(String db2pg_sys_nm) throws Exception;

	/**
	 * trans DBMS시스템 등록
	 * 
	 * @param transDbmsVO
	 * @return String
	 * @throws Exception
	 */
	public String insertTransDBMS(TransDbmsVO transDbmsVO) throws Exception;
	
	/**
	 * trans DBMS시스템 사용여부 확인
	 * 
	 * @param transDbmsVO
	 * @throws Exception
	 */
	public String selectTransDbmsIngChk(TransDbmsVO transDbmsVO) throws Exception;

	/**
	 * trans DBMS시스템 수정
	 * 
	 * @param transDbmsVO
	 * @return String
	 * @throws Exception
	 */
	public String updateTransDBMS(TransDbmsVO transDbmsVO) throws Exception;
	
	/**
	 * trans DBMS시스템 삭제
	 * 
	 * @param transDbmsVO
	 * @throws Exception
	 */
	public void deleteTransDBMS(TransDbmsVO transDbmsVO) throws Exception;

	/**
	 * 소스시스템 전송설정 조회
	 * 
	 * @param transVO
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectTargetTransSetting(TransVO transVO) throws Exception;

	/**
	 * source 커넥트 정보 조회
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectTransInfo(int trans_id) throws Exception;

	/**
	 * target 커넥트 정보 조회
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectTargetTransInfo(int trans_id) throws Exception;
	
	/**
	 * 매핑 정보 조회
	 * @param trans_exrt_trg_tb_id
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectMappInfo(int trans_exrt_trg_tb_id) throws Exception;

	/**
	 * source trans 커넥트 시작
	 * 
	 * @param transVO
	 * @return String
	 * @throws Exception
	 */
	public String transStart(TransVO transVO) throws Exception;

	/**
	 * source trans 커넥트 stop
	 * 
	 * @param transVO
	 * @return String
	 * @throws Exception
	 */
	public String transStop(TransVO transVO) throws Exception;

	/**
	 * target trans 커넥트 시작
	 * 
	 * @param transVO
	 * @return String
	 * @throws Exception
	 */
	public String transTargetStart(TransVO transVO) throws Exception;

	/**
	 * trans 삭제
	 * @param transVO
	 * @return String
	 * @throws Exception
	 */
	public String deleteTransTotSetting(TransVO transVO) throws Exception;

	/**
	 * 매핑 정보 삭제
	 * @param trans_exrt_trg_tb_id
	 * @return int
	 * @throws Exception
	 */
	public void deleteTransExrttrgMapp(int trans_exrt_trg_tb_id) throws Exception;
	
	/**
	 * 전송설정 정보 삭제
	 * @param trans_id
	 * @return int
	 * @throws Exception
	 */
	public void deleteTransSetting(int trans_id) throws Exception;
	
	/**
	 * 커넥터명 중복검사
	 * @param connect_nm
	 * @return int
	 * @throws Exception
	 */
	public int connect_nm_Check(String connect_nm) throws Exception;

	/**
	 * 커넥터명 타겟시스템 중복검사
	 * @param connect_nm
	 * @return int
	 * @throws Exception
	 */
	public int connect_target_nm_Check(String connect_nm) throws Exception;
	
	/**
	 * 포함대상 스키마,테이블 시퀀스 조회
	 * @param connect_nm
	 * @return int
	 * @throws Exception
	 */
	public int selectTransExrttrgMappSeq() throws Exception;

	/**
	 * 포함대상 스키마,테이블 등록
	 * @param transMappVO
	 * @return 
	 * @throws Exception
	 */
	public void insertTransExrttrgMapp(TransMappVO transMappVO) throws Exception;

	/**
	 * 전송설정 등록
	 * @param TransVO
	 * @throws Exception
	 */
	public void insertConnectInfo(TransVO transVO) throws Exception;

	/**
	 * 타겟시스템 전송설정 등록
	 * @param TransVO
	 * @throws Exception
	 */
	public void insertTargetConnectInfo(TransVO transVO) throws Exception;

	/**
	 * 포함대상 스키마,테이블 수정
	 * @param transMappVO
	 * @return 
	 * @throws Exception
	 */
	public void updateTransExrttrgMapp(TransMappVO transMappVO) throws Exception;
	
	/**
	 * 전송설정 정보 수정
	 * @param transVO
	 * @return vo
	 * @throws Exception
	 */
	public void updateConnectInfo(TransVO transVO) throws Exception;
	
	/**
	 * target 전송설정 정보 수정
	 * @param transVO
	 * @return vo
	 * @throws Exception
	 */
	public void updateTargetConnectInfo(TransVO transVO) throws Exception;

	/**
	 * 스냅샷모드 목록 조회
	 * @param TransVO
	 * @return List<TransVO>
	 * @throws Exception
	 */
	public List<TransVO> selectSnapshotModeList() throws Exception;

	/**
	 * 압축형식
	 * @param TransVO
	 * @return List<TransVO>
	 * @throws Exception
	 */
	public List<TransVO> selectCompressionTypeList() throws Exception;
	

	/**
	 * source auto 커넥트 정보 조회
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectTransInfoAuto(int db_svr_id) throws Exception;

	/**
	 * target auto 커넥트 정보 조회
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectTargetTransInfoAuto(int db_svr_id) throws Exception;

	/**
	 * trans kafka connect 리스트 조회
	 * 
	 * @param transDbmsVO
	 * @return List<TransDbmsVO>
	 * @throws Exception
	 */
	public List<TransDbmsVO> selectTransKafkaConList(TransDbmsVO transDbmsVO) throws Exception;

	/**
	 * TRANS kafka connect 설정 등록
	 * 
	 * @param transDbmsVO
	 * @return String
	 * @throws Exception
	 */
	public String insertTransKafkaConnect(TransDbmsVO transDbmsVO) throws Exception;

	/**
	 * trans DBMS시스템 명 체크
	 * 
	 * @param transDbmsVO
	 * @return List<TransDbmsVO>
	 * @throws Exception
	 */
	public String trans_connect_nmCheck(String kc_nm) throws Exception;
	
	/**
	 * trans kafka connect 설정 삭제
	 * 
	 * @param transDbmsVO
	 * @throws Exception
	 */
	public void deleteTransKafkaConnect(TransDbmsVO transDbmsVO) throws Exception;

	/**
	 * trans connect 수정
	 * 
	 * @param transDbmsVO
	 * @return String
	 * @throws Exception
	 */
	public String updateTransKafkaConnect(TransDbmsVO transDbmsVO) throws Exception;

	/**
	 * 기본설정 등록 상세조회
	 * @param transVO, request, historyVO
	 * @return Map<String, Object>
	 */
	public Map<String, Object> selectTransComSettingCngInfo(TransVO transVO) throws Exception;

	/**
	 * 기본설정 등록
	 * @param transVO
	 * @return String
	 * @throws Exception
	 */
	public String updateTransCommonSetting(TransVO transVO) throws Exception;
	
	/**
	 * trans kafka connect 사용여부 확인
	 * 
	 * @param transDbmsVO
	 * @throws Exception
	 */
	public String selectTransKafkaConIngChk(TransDbmsVO transDbmsVO) throws Exception;

	/**
	 * trans connect faild 수정
	 * 
	 * @param transDbmsVO
	 * @return String
	 * @throws Exception
	 */
	public String updateTransKafkaConnectFaild(TransDbmsVO transDbmsVO) throws Exception;

	/**
	 * 기본설정 리스트 조회
	 * 
	 * @param transVO
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectTransComConPopList(TransVO transVO) throws Exception;
	
	/**
	 * 기본설정 삭제
	 * 
	 * @param transVO
	 * @throws Exception
	 */
	public void deleteTransComConSet(TransVO transVO) throws Exception;

}
