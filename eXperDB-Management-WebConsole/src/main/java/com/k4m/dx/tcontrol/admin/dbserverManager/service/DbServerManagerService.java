package com.k4m.dx.tcontrol.admin.dbserverManager.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.k4m.dx.tcontrol.backup.service.DbVO;
import com.k4m.dx.tcontrol.common.service.AgentInfoVO;

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
	 * @param db_svr_id 
	 * @throws Exception
	 */
	List<Map<String, Object>> selectSvrList(int db_svr_id) throws Exception;

	
	/**
	 * Repository DB서버 IP 중복체크
	 * @param ipadr 
	 * @throws Exception
	 */
	int dbServerIpCheck(String ipadr) throws Exception;


	int selectDBcnt(HashMap<String, Object> paramvalue) throws Exception;


	void updateDB(HashMap<String, Object> paramvalue) throws Exception;


	/**
	 * Repository DB서버명 중복체크
	 * @param db_svr_nm 
	 * @throws Exception
	 */
	int db_svr_nmCheck(String db_svr_nm) throws Exception;


	List<DbVO> selectDbListTree(int db_svr_id) throws Exception;


	List<Map<String, Object>> selectIpList(AgentInfoVO agentInfoVO) throws Exception;


	int selectDbsvrid() throws Exception;


	void insertIpadr(IpadrVO ipadrVO) throws Exception;


	Map exeCheck(int db_svr_id);


	void dbSvrDelete(int db_svr_id);


	List<DbVO> selectDBSync(int db_svr_id) throws Exception;


	void syncUpdate(HashMap<String, Object> paramvalue) throws Exception;


	List<DbServerVO> selectPgDbmsList()  throws Exception;


	void updateIpadr(IpadrVO ipadrVO) throws Exception;


	void deleteIpadr(HashMap<String, Object> paramvalue) throws Exception;


	int selectIpadrCnt() throws Exception;
	
}
