package com.experdb.management.proxy.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.experdb.management.proxy.service.ProxyListenerServerVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

/**
 * @author 김민정
 * @see proxy 설정 관련 화면 dao
 * 
 *      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일                 수정자                   수정내용
*  -------     --------    ---------------------------
*  2021.03.05              최초 생성
 *      </pre>
 */
@Repository("proxyRestDAO")
public class ProxyRestDAO extends EgovAbstractMapper{

	/**
	 * Scale In된 Proxy 서버 및 Agent 목록
	 * 
	 * @param List<String>
	 * @return List<Map<String, Object>>
	 * @throws 
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectScaleInProxyList(Map<String, Object> param) throws SQLException {
		List<Map<String, Object>> result = null;
		result = (List<Map<String, Object>>) list("proxyRestSql.selectScaleInProxyList", param);
		return result;
	}

	/**
	 * Scale Out된 Proxy 서버 및 Agent 목록
	 * 
	 * @param Map<String, Object> 
	 * @return List<Map<String, Object>>
	 * @throws 
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectScaleOutProxyList(Map<String, Object> param) throws SQLException {
		List<Map<String, Object>> result = null;
		result = (List<Map<String, Object>>) list("proxyRestSql.selectScaleOutProxyList", param);
		return result;
	}
	
	/**
	 * Scale In 시 Proxy Listener Svr List 삭제 
	 * 
	 * @param Map<String, Object>
	 * @return 
	 */
	public void deletProxyLsnSvrList(Map<String, Object> param) {
		delete("proxyRestSql.deletProxyLsnSvrList", param);	
	}
	
	/**
	 * Scale Out 시 Proxy Listener Svr List 추가 
	 * 
	 * @param Map<String, Object>
	 * @return 
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public void insertProxyLsnSvrList(ProxyListenerServerVO proxyListenerServerVO)  throws SQLException {
		insert("proxyRestSql.insertProxyLsnSvrList", proxyListenerServerVO);	
	}
	
	
	
}