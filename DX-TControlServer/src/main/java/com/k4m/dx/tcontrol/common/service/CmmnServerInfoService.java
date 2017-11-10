package com.k4m.dx.tcontrol.common.service;

import java.util.List;

import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;

public interface CmmnServerInfoService {

	/**
	 * DBMS 서버 리스트 조회
	 * @param db_svr_nm
	 * @return
	 * @throws Exception
	 */
	List<DbServerVO> selectDbServerList(String db_svr_nm) throws Exception;
	
	/**
	 * Agent 정보 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public AgentInfoVO selectAgentInfo(AgentInfoVO vo) throws Exception;
	
	/**
	 * 서버 정보 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public DbServerVO selectServerInfo(DbServerVO vo) throws Exception;

}
