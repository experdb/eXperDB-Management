package com.k4m.dx.tcontrol.script.service;

import java.util.List;
import java.util.Map;

public interface ScriptService {

	/**
	 * 스크립트 목록 조회
	 * @param WorkVO
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectScriptList(ScriptVO scriptVO) throws Exception;

	/**
	 * 스크립트 Work Insert
	 * @param ScriptVO
	 * @return 
	 * @throws Exception
	 */
	public void insertScriptWork(ScriptVO scriptVO) throws Exception;

	/**
	 * 스크립트실행 명령문 Insert
	 * @param ScriptVO
	 * @return 
	 * @throws Exception
	 */
	public void insertScript(ScriptVO scriptVO) throws Exception;

	/**
	 * 스크립트실행 수정 조회
	 * @param wrk_id
	 * @return 
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectSciptExeInfo(int wrk_id) throws Exception;

	/**
	 * 스크립트실행 명령문 update
	 * @param ScriptVO
	 * @return 
	 * @throws Exception
	 */
	public void updateScriptWork(ScriptVO scriptVO) throws Exception;

	/**
	 * 스크립트실행 명령문 delete
	 * @param ScriptVO
	 * @return 
	 * @throws Exception
	 */
	public void deleteScriptWork(int wrk_id) throws Exception;

	/**
	 * 스크립트 스케줄 리스트 조회
	 * @param 
	 * @throws Exception
	 */
	List<Map<String, Object>> selectScriptScheduleList(ScriptVO scriptVO) throws Exception;

	
	
	public List<Map<String, Object>> selectScriptHistoryList(ScriptVO scriptVO) throws Exception;

}
