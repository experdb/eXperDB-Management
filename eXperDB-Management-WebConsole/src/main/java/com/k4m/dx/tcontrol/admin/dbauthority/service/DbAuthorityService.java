package com.k4m.dx.tcontrol.admin.dbauthority.service;

import java.util.HashMap;
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
	 * @param param
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
	 * @param param
	 * @throws Exception
	 */
	void insertUsrDbAut(Map<String, Object> param) throws Exception;


	/**
	 *  사용자삭제시, 디비서버권한 삭제
	 * @param string
	 * @throws Exception
	 */
	void deleteDbSvrAuthority(String string) throws Exception;


	/**
	 *  사용자삭제시, 디비권한 삭제
	 * @param string
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
	 * @param object 
	 * @param 
	 * @throws Exception
	 */
	void updateUsrDBSrvAutInfo(Object object) throws Exception;


	/**
	 * 디비권한 정보 조회
	 * @param 
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
	 *  유저 디비권한 업데이트
	 * @param object 
	 * @param 
	 * @throws Exception
	 */
	void updateUsrDBAutInfo(Object object) throws Exception;


	/**
	 *  등록된 서버 권한 조회
	 * @param usr_id 
	 * @param 
	 * @throws Exception
	 */
	int selectUsrDBSrvAutInfoCnt(Object object) throws Exception;


	/**
	 *  유저 서버 권한 저장
	 * @param usr_id 
	 * @param 
	 * @throws Exception
	 */
	void insertUsrDBSrvAutInfo(Object object) throws Exception;


	/**
	 *  등록된 디비 권한 조회
	 * @param usr_id 
	 * @param 
	 * @throws Exception
	 */
	int selectUsrDBAutInfoCnt(Object object) throws Exception;


	/**
	 *  유저디비 권한 저장
	 * @param usr_id 
	 * @param 
	 * @throws Exception
	 */
	void insertUsrDBAutInfo(Object object) throws Exception;


	/**
	 *  유저 서버 권한 조회
	 * @param usr_id 
	 * @param 
	 * @throws Exception
	 */
	List<Map<String, Object>> selectUserDBSvrAutList(HashMap<String, Object> param) throws Exception;


	List<Map<String, Object>> selectTreeDBSvrList(String usr_id) throws Exception;

	/**
	 * 해당 서버에 대한 디비 조회
	 * @param param 
	 * @param 
	 * @throws Exception
	 */
	List<Map<String, Object>> selectDatabase(int param) throws Exception;

}
