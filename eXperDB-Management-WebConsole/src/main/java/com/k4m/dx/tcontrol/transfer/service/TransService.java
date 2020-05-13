package com.k4m.dx.tcontrol.transfer.service;

import java.util.List;
import java.util.Map;



public interface TransService {

	
	/**
	 * 스냅샷모드 목록 조회
	 * @param TransVO
	 * @return List<TransVO>
	 * @throws Exception
	 */
	public List<TransVO> selectSnapshotModeList() throws Exception;

	
	
	/**
	 * 전송설정 등록
	 * @param TransVO
	 * @throws Exception
	 */
	public void insertConnectInfo(TransVO transVO) throws Exception;


	/**
	 * 전송설정 조회
	 * @param TransVO
	 * @return List<TransVO>
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectTransSetting(TransVO transVO) throws Exception;


	
	/**
	 * 커넥터명 중복검사
	 * @param connect_nm
	 * @return int
	 * @throws Exception
	 */
	public int connect_nm_Check(String connect_nm) throws Exception;


	/**
	 * 포함대상 스키마,테이블 시퀀스 조회
	 * @param connect_nm
	 * @return int
	 * @throws Exception
	 */
	public int selectTransExrttrgMappSeq() throws Exception;


	
	/**
	 * 포함대상 스키마,테이블 등록
	 * @param connect_nm
	 * @return int
	 * @throws Exception
	 */
	public void insertTransExrttrgMapp(TransMappVO transMappVO) throws Exception;


	/**
	 * 커넥트 정보 조회
	 * @param trans_id
	 * @return int
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectTransInfo(int trans_id) throws Exception;


	/**
	 * 매핑 정보 조회
	 * @param trans_exrt_trg_tb_id
	 * @return int
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectMappInfo(int trans_exrt_trg_tb_id) throws Exception;



	public void updateTransExrttrgMapp(TransMappVO transMappVO) throws Exception;


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


}
