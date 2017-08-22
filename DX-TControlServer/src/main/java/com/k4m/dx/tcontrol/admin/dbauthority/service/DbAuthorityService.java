package com.k4m.dx.tcontrol.admin.dbauthority.service;

import java.util.List;
import java.util.Map;

public interface DbAuthorityService {

	/**
	 * DB서버 리스트 조회
	 * @param 
	 * @throws Exception
	 */
	List<Map<String, Object>> selectSvrList() throws Exception;

	
	/**
	 * 유저디비서버 권한 초기등록
	 * @param 
	 * @throws Exception
	 */
	void insertUsrDbSvrAut(Map<String, Object> param) throws Exception;

	
	/**
	 * DB 리스트 조회
	 * @param 
	 * @throws Exception
	 */
	List<Map<String, Object>> selectDBList() throws Exception;

	
	/**
	 * 유저디비 권한 초기등록
	 * @param 
	 * @throws Exception
	 */
	void insertUsrDbAut(Map<String, Object> param) throws Exception;


	/**
	 *  사용자삭제시, 디비서버권한 삭제
	 * @param 
	 * @throws Exception
	 */
	void deleteDbSvrAuthority(String string) throws Exception;


	/**
	 *  사용자삭제시, 디비권한 삭제
	 * @param 
	 * @throws Exception
	 */
	void deleteDbAuthority(String string) throws Exception;

	
	/**
	 *  유저 디비서버권한 정보 조회
	 * @param usr_id 
	 * @param 
	 * @throws Exception
	 */
	List<Map<String, Object>> selectUsrDBSrvAutInfo(String usr_id) throws Exception;


	/**
	 *  유저 디비서버권한 저장
	 * @param usr_id 
	 * @param 
	 * @throws Exception
	 */
	void updateUsrDBSrvAutInfo(Object object) throws Exception;


	/**
	 * 디비권한 정보 조회
	 * @param usr_id 
	 * @param 
	 * @throws Exception
	 */
	List<Map<String, Object>> selectDBAutInfo() throws Exception;


	/**
	 * 유저 디비권한 정보 조회
	 * @param usr_id 
	 * @param usr_id 
	 * @param 
	 * @throws Exception
	 */
	List<Map<String, Object>> selectUsrDBAutInfo(String usr_id) throws Exception;


	/**
	 *  유저 디비권한 저장
	 * @param usr_id 
	 * @param 
	 * @throws Exception
	 */
	void updateUsrDBAutInfo(Object object) throws Exception;

}
