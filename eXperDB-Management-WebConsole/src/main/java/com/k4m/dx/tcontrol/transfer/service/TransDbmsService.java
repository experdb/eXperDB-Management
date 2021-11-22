package com.k4m.dx.tcontrol.transfer.service;

import java.util.List;

public interface TransDbmsService {

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
	 * trans DBMS시스템 리스트 조회
	 * 
	 * @param transDbmsVO
	 * @return List<TransDbmsVO>
	 * @throws Exception
	 */
	public List<TransDbmsVO> selectTransDBMS(TransDbmsVO transDbmsVO) throws Exception;
	
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
}
