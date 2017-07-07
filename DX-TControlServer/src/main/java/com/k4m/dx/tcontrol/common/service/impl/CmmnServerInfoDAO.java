package com.k4m.dx.tcontrol.common.service.impl;

import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.common.service.AgentInfoVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("cmmnServerInfoDAO")
public class CmmnServerInfoDAO extends EgovAbstractMapper{

	/**
	 * DB Server 정보 리스트
	 * 
	 * @param DbServerVO
	 * @throws SQLException
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<DbServerVO> selectDbServerList(String db_svr_nm) {
		List<DbServerVO> sl = null;
		sl = (List<DbServerVO>) list("cmmnListSQL.selectDbServerList", db_svr_nm);	
		return sl;
	}
	
	/**
	 * Agent 정보 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public AgentInfoVO selectAgentInfo(AgentInfoVO vo) throws Exception {
		return (AgentInfoVO) selectOne("cmmnListSQL.selectAgentInfo", vo);
	}

	/**
	 * 서버 정보 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public DbServerVO selectServerInfo(DbServerVO vo) throws Exception {
		return (DbServerVO) selectOne("cmmnListSQL.selectServerInfo", vo);
	}
	



}
