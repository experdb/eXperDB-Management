package com.experdb.management.proxy.service.impl;

import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.experdb.management.proxy.service.ProxyAgentVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;


@Repository("proxyAgentDAO")
public class ProxyAgentDAO extends EgovAbstractMapper{

	/**
	 * proxy agent count 조회
	 * 
	 * @param prySvrVO
	 * @return
	 * @throws
	 */
	public int selectAgentCount() throws SQLException {
		return (int) getSqlSession().selectOne("proxyMonitoringSql.selectAgentCount");
	}

	/**
	 * proxy agent 목록 조회
	 * 
	 * @param transDbmsVO
	 * @return List<ProxyAgentVO>
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<ProxyAgentVO> selectProxyAgentList(ProxyAgentVO proxyAgentVO) {
		List<ProxyAgentVO> sl = null;
		sl = (List<ProxyAgentVO>) list("proxyMonitoringSql.selectProxyAgentList", proxyAgentVO);
		return sl;
	}
}
