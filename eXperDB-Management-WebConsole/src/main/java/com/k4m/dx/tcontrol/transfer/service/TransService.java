package com.k4m.dx.tcontrol.transfer.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;

import com.k4m.dx.tcontrol.login.service.LoginVO;



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
	public int connect_nm_Check(String connect_nm, String connect_gbn) throws Exception;

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

	/**
	 * 타겟시스템 전송설정 total 등록
	 * @param TransVO
	 * @throws Exception
	 */
	public String insertTargetConnectInfoTot(TransMappVO transMappVO, TransVO transVO) throws Exception;

	/**
	 * 타겟시스템 전송설정 total 수정
	 * @param TransVO
	 * @throws Exception
	 */
	public String updateTargetConnectInfoTot(TransMappVO transMappVO, TransVO transVO) throws Exception;

	/**
	 * trans topic 리스트 조회
	 * @param TransVO
	 * @throws Exception
	 */
	public List<TransVO> selectTransTopicList(TransVO transVO) throws Exception;

	/**
	 * trans heatbeat 체크
	 * 
	 * @param transVO
	 * @return Map<String, Object>
	 * @throws Exception
	 */
	public Map<String, Object> selectTransComCoIngChk(TransVO transVO) throws Exception;

	/**
	 * 다중 kafka-Connection 시작
	 * 
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	public String transTotExecute(HttpServletRequest request, LoginVO loginVo) throws Exception;
	
	/**
	 * 전송대상테이블정보 setting
	 * 
	 * @param mappInfo, trans_active_gbn
	 * @return String
	 * @throws Exception
	 */
	public JSONObject selectTransMatchMappInfo(int trans_id, List<Map<String, Object>> mappInfo, String trans_active_gbn, String multi_gbn) throws Exception;

	/**
	 * 전송상세 전송설정정보 setting
	 * 
	 * @param mappInfo, trans_active_gbn
	 * @return String
	 * @throws Exception
	 */
	public Map<String, Object> selectTransMatchInfo(List<Map<String, Object>> transInfo, String trans_active_gbn) throws Exception;
}
