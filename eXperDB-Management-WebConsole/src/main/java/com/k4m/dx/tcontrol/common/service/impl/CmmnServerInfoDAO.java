package com.k4m.dx.tcontrol.common.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.common.service.AgentInfoVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("cmmnServerInfoDAO")
public class CmmnServerInfoDAO extends EgovAbstractMapper {

	/**
	 * DB Server 정보 리스트
	 * 
	 * @param DbServerVO
	 * @throws SQLException
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<DbServerVO> selectDbServerList(String db_svr_nm) {
		List<DbServerVO> sl = null;
		sl = (List<DbServerVO>) list("cmmnSql.selectDbServerList", db_svr_nm);
		return sl;
	}

	/**
	 * Agent 정보 조회
	 * 
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public AgentInfoVO selectAgentInfo(AgentInfoVO vo) throws Exception {
		return (AgentInfoVO) selectOne("cmmnSql.selectAgentInfo", vo);
	}

	/**
	 * 서버 정보 조회
	 * 
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public DbServerVO selectServerInfo(DbServerVO vo) throws Exception {
		return (DbServerVO) selectOne("cmmnSql.selectServerInfo", vo);
	}

	/**
	 * 서버 정보 조회(Slave)
	 * 
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<DbServerVO> selectServerInfoSlave(DbServerVO vo) {
		List<DbServerVO> sl = null;
		sl = (List<DbServerVO>) list("cmmnSql.selectServerInfoSlave", vo);
		return sl;
	}

	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectIpadrList(int db_svr_id) {
		List<Map<String, Object>> sl = null;
		sl = (List<Map<String, Object>>) list("cmmnSql.selectIpadrList", db_svr_id);
		return sl;
	}

	public void deleteIpadr(DbServerVO dbServerVO) {
		insert("cmmnSql.deleteIpadr", dbServerVO);
	}

	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<DbServerVO> selectAllIpadrList(int db_svr_id) {
		List<DbServerVO> sl = null;
		sl = (List<DbServerVO>) list("cmmnSql.selectAllIpadrList", db_svr_id);
		return sl;
	}

	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<Map<String, Object>> selectWrkErrorMsg(int exe_sn) {
		List<Map<String, Object>> sl = null;
		sl = (List<Map<String, Object>>) list("cmmnSql.selectWrkErrorMsg", exe_sn);
		return sl;
	}

	/**
	 * RepoDB 조회
	 * 
	 * @param db_svr_id
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<DbServerVO> selectRepoDBList(DbServerVO dbServerVO) {
		List<DbServerVO> sl = null;
		sl = (List<DbServerVO>) list("cmmnSql.selectRepoDBList", dbServerVO);
		return sl;
	}

	public List<Map<String, Object>> selectHaCnt(int db_svr_id) {
		List<Map<String, Object>> sl = null;
		sl = (List<Map<String, Object>>) list("cmmnSql.selectHaCnt", db_svr_id);
		return sl;
	}

	/**
	 * DB Server 정보 리스트 레이아웃
	 * 
	 * @param DbServerVO
	 * @throws SQLException
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<Map<String, Object>> selectDashboardServerInfoImg(DbServerVO dbServerVO) {
		List<Map<String, Object>> sl = null;
		sl = (List<Map<String, Object>>) list("cmmnSql.selectDashboardServerInfoImg", dbServerVO);
		return sl;
	}
}
