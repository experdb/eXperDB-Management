package com.experdb.management.proxy.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

/**
 * @author
 * @see proxy 설정이력 dao
 * 
 *      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일                 수정자                   수정내용
*  -------     --------    ---------------------------
*  2021.02.24              최초 생성
 *      </pre>
 */
@Repository("proxyHistoryDAO")
public class ProxyHistoryDAO extends EgovAbstractMapper{
	
	/**
	 * Proxy 기동 상태 변경 이력 조회
	 * 
	 * @param Map<String, Object> param
	 * @return List<Map<String, Object>>
	 * @throws 
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
	 * @throws 
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectProxySettingChgHistoryList(Map<String, Object> param) {
		List<Map<String, Object>> result = null;
		result = (List<Map<String, Object>>) list("proxyHistorySql.selectProxySettingChgHistoryList", param);
		return result;
	}

	/**
	 * Proxy 설정 파일 백업 경로 조회
	 * 
	 * @param param
	 * @return Map<String, Object>
	 * @throws SQLException
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public Map<String, Object> selectProxyConfFilePath(Map<String, Object> param) throws SQLException {
		Map<String, Object> result = null;
		result = (Map<String, Object>) selectOne("proxyHistorySql.selectProxyConfFilePathInfo", param);
		return result;
	}
	/**
	 * Proxy DB 접속 주소 목록
	 * 
	 * @return Map<String, Object>
	 * @throws SQLException
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectSvrStatusDBConAddrList() {
		List<Map<String, Object>> result = null;
		result = (List<Map<String, Object>>) list("proxyHistorySql.selectSvrStatusDBConAddrList", null);
		return result;
	}
	/**
	 * Proxy 서버 실시간 상태 로그 조회
	 * 
	 * @param param
	 * @return Map<String, Object>
	 * @throws SQLException
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectProxyStatusHistory(Map<String, Object> param) throws SQLException {
		List<Map<String, Object>> result = null;
		result = (List<Map<String, Object>>) list("proxyHistorySql.selectProxyStatusHistoryList", param);
		return result;
	}
	/**
	 * Proxy Agent 정보 업데이트
	 * 
	 * @param ProxyServerVO
	 * @throws
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public void updateProxySettingChgHistoryList(Map<String, Object> param) {
		update("proxyHistorySql.updateProxySettingChgHistoryList", param);	
		
	}
}