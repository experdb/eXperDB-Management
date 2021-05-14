package com.experdb.management.proxy.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.experdb.management.proxy.service.ProxyAgentVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;


@Repository("proxyHistoryDAO")
public class ProxyHistoryDAO extends EgovAbstractMapper{
	
	/**
	 * Proxy 기동 상태 변경 이력 조회
	 * 
	 * @param param
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectProxyActStateHistoryList(Map<String, Object> param) {
		List<Map<String, Object>> result = null;
		result = (List<Map<String, Object>>) list("proxyHistorySql.selectProxyActStateHistoryList", param);
		return result;
	}

	/**
	 * Proxy 설정 변경 이력 조회
	 * 
	 * @param param
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectProxySettingChgHistoryList(Map<String, Object> param) {
		List<Map<String, Object>> result = null;
		result = (List<Map<String, Object>>) list("proxyHistorySql.selectProxySettingChgHistoryList", param);
		return result;
	}
	/**
	 * Proxy Agent 정보 조회
	 * 
	 * @param param
	 * @return ProxyAgentVO
	 * @throws SQLException
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public Map<String, Object> selectProxyConfFilePath(Map<String, Object> param) throws SQLException {
		Map<String, Object> result = null;
		result = (Map<String, Object>) selectOne("proxyHistorySql.selectProxyConfFilePathInfo", param);
		return result;
	}
}
