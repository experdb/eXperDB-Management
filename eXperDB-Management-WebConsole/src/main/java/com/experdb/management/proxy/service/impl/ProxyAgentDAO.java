package com.experdb.management.proxy.service.impl;

import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.experdb.management.proxy.service.ProxyAgentVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

/**
 * @author
 * @see proxy 관리 agent dao
 * 
 *      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일                 수정자                   수정내용
*  -------     --------    ---------------------------
*  2021.02.24              최초 생성
 *      </pre>
 */
@Repository("proxyAgentDAO")
public class ProxyAgentDAO extends EgovAbstractMapper{

	/**
	 * Proxy agent count 조회
	 * 
	 * @param 
	 * @return integer
	 * @throws SQLException
	 */
	public int selectAgentCount() throws SQLException {
		return (int) getSqlSession().selectOne("proxyMonitoringSql.selectAgentCount");
	}

	/**
	 * proxy agent 리스트 조회
	 * 
	 * @param proxyAgentVO
	 * @return List<ProxyAgentVO>
	 * @throws SQLException
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<ProxyAgentVO> selectProxyAgentList(ProxyAgentVO proxyAgentVO) throws SQLException {
		List<ProxyAgentVO> sl = null;
		sl = (List<ProxyAgentVO>) list("proxyMonitoringSql.selectProxyAgentList", proxyAgentVO);
		return sl;
	}
}