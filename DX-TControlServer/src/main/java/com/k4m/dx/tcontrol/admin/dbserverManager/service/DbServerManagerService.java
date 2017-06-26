package com.k4m.dx.tcontrol.admin.dbserverManager.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.k4m.dx.tcontrol.backup.service.DbVO;

public interface DbServerManagerService {

	/**
	 * DB서버 리스트 조회
	 * @param dbServerVO
	 * @throws Exception
	 */
	List<DbServerVO> selectDbServerList(DbServerVO dbServerVO) throws Exception;

	
	/**
	 * DB서버 등록
	 * @param dbServerVO
	 * @throws Exception
	 */
	void insertDbServer(DbServerVO dbServerVO) throws Exception;

	
	/**
	 * DB서버 수정
	 * @param dbServerVO
	 * @throws Exception
	 */
	void updateDbServer(DbServerVO dbServerVO)throws Exception;


	/**
	 * DB 삭제
	 * @param dbServerVO
	 * @throws Exception
	 */
	void deleteDB(DbServerVO dbServerVO)throws Exception;


	/**
	 * DB 등록
	 * @param paramvalue
	 * @throws Exception
	 */
	void insertDB(HashMap<String, Object> paramvalue) throws Exception;


	/**
	 * DB 리스트 조회
	 * @param paramvalue
	 * @throws Exception
	 */
	List<DbVO> selectDbList() throws Exception;


	/**
	 * DB Repository 리스트 조회
	 * @param paramvalue 
	 * @param paramvalue
	 * @throws Exception
	 */
	List<Map<String, Object>> selectRepoDBList(HashMap<String, Object> paramvalue) throws Exception;


	/**
	 * Repository DB에 등록되어 있는 DB의 서버명 SelectBox 
	 * @throws Exception
	 */
	List<Map<String, Object>> selectSvrList() throws Exception;
	
}
