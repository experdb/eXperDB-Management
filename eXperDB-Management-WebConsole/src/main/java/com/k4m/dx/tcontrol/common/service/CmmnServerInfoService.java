package com.k4m.dx.tcontrol.common.service;

import java.util.List;
import java.util.Map;

import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;

public interface CmmnServerInfoService {

	/**
	 * DBMS 서버 리스트 조회
	 * 
	 * @param db_svr_nm
	 * @return
	 * @throws Exception
	 */
	List<DbServerVO> selectDbServerList(String db_svr_nm) throws Exception;

	/**
	 * Agent 정보 조회
	 * 
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public AgentInfoVO selectAgentInfo(AgentInfoVO vo) throws Exception;

	/**
	 * 서버 정보 조회
	 * 
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public DbServerVO selectServerInfo(DbServerVO vo) throws Exception;

	/**
	 * 아이피 정보 조회
	 * 
	 * @param db_svr_id
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectIpadrList(int db_svr_id) throws Exception;

	/**
	 * 아이피 정보 삭제
	 * 
	 * @param dbServerVO
	 * @return
	 * @throws Exception
	 */
	void deleteIpadr(DbServerVO dbServerVO) throws Exception;

	/**
	 * 서버 정보 조회(Slave)
	 * 
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	List<DbServerVO> selectServerInfoSlave(DbServerVO vo) throws Exception;

	/**
	 * 서버 정보 조회(Master, Slave)
	 * 
	 * @param db_svr_id
	 * @return
	 * @throws Exception
	 */
	List<DbServerVO> selectAllIpadrList(int db_svr_id) throws Exception;

	/**
	 * 작업로그 정보
	 * 
	 * @param exe_sn
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectWrkErrorMsg(int exe_sn) throws Exception;

	/**
	 * RepoDB 조회
	 * 
	 * @param dbServerVO
	 * @return
	 * @throws Exception
	 */
	List<DbServerVO> selectRepoDBList(DbServerVO dbServerVO) throws Exception;

	List<Map<String, Object>> selectHaCnt(int db_svr_id) throws Exception;

	/**
	 * DBMS 서버 리스트 조회 레이아웃
	 * 
	 * @param db_svr_nm
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectDashboardServerInfoImg(DbServerVO dbServerVO) throws Exception;

}
