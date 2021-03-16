package com.experdb.management.proxy.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.experdb.management.proxy.service.ProxyLogVO;
import com.experdb.management.proxy.service.ProxyServerVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

/**
* @author 
* @see proxy 모니터링 관련 화면 dao
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일                 수정자                   수정내용
*  -------     --------    ---------------------------
*  2021.03.05              최초 생성
*      </pre>
*/
@Repository("proxyMonitoringDAO")
public class ProxyMonitoringDAO extends EgovAbstractMapper {

//	public List<ProxyServerVO> selectProxyServerList() {
//		List<ProxyServerVO> result = null;
//		result = selectList("proxyMonitoringSql.selectProxyServerList");
//		return result;
//	}
	
	public List<Map<String, Object>> selectProxyServerList() {
		List<Map<String, Object>> result = null;
		result = selectList("proxyMonitoringSql.selectProxyServerList");
		return result;
	}
	
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectProxyServerByMasterId(int pry_svr_id) {
		List<Map<String, Object>> result = null;
		result = (List<Map<String, Object>>) list("proxyMonitoringSql.selectProxyServerByMasterId",pry_svr_id);
		return result;
	}

	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<ProxyLogVO> selectProxyLogList(int pry_svr_id) {
		List<ProxyLogVO> result = null;
		result = (List<ProxyLogVO>) list("proxyMonitoringSql.selectProxyLogList", pry_svr_id);
		return result;
	}

	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectDBServerConProxy(int pry_svr_id) {
		List<Map<String, Object>> result = null;
		result = (List<Map<String, Object>>) list("proxyMonitoringSql.selectDBServerConProxy", pry_svr_id);
		return result;
	}

	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectProxyStatisticsInfo(int pry_svr_id) {
		List<Map<String, Object>> result = null;
		result = (List<Map<String, Object>>) list("proxyMonitoringSql.selectProxyStatisticsInfo", pry_svr_id);
		return result;
	}

	public Map<String, Object> selectConfiguration(Map<String, Object> param) {
		Map<String, Object> result = null;
		result = selectOne("proxyMonitoringSql.selectConfiguration", param);
		return result;
	}
	
}
