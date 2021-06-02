package com.experdb.management.proxy.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.experdb.management.proxy.service.ProxyLogVO;

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

	/**
	 * Proxy 서버 목록 조회
	 * 
	 * @param 
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectProxyServerList() {
		List<Map<String, Object>> result = null;
		result = selectList("proxyMonitoringSql.selectProxyServerList");
		return result;
	}

	/**
	 * Proxy 서버  cluster 조회 by master server id
	 * 
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectProxyServerByMasterId(int pry_svr_id) {
		List<Map<String, Object>> result = null;
		result = (List<Map<String, Object>>) list("proxyMonitoringSql.selectProxyServerByMasterId", pry_svr_id);
		return result;
	}

	/**
	 * Proxy 서버 cluster 별 연결 vip 조회
	 * 
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectProxyServerVipChk(int pry_svr_id) {
		List<Map<String, Object>> result = null;
		result = (List<Map<String, Object>>) list("proxyMonitoringSql.selectProxyServerVipChk", pry_svr_id);
		return result;
	}

	/**
	 * proxy / keepalived 기동 상태 이력 조회
	 * 
	 * @param pry_svr_id
	 * @return List<ProxyLogVO>
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<ProxyLogVO> selectProxyLogList(int pry_svr_id) {
		List<ProxyLogVO> result = null;
		result = (List<ProxyLogVO>) list("proxyMonitoringSql.selectProxyLogList", pry_svr_id);
		return result;
	}

	/**
	 * Proxy 연결된 db 서버 조회
	 * 
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectDBServerConProxyList(int pry_svr_id) {
		List<Map<String, Object>> result = null;
		result = (List<Map<String, Object>>) list("proxyMonitoringSql.selectDBServerConProxyList", pry_svr_id);
		return result;
	}

	/**
	 * Proxy 리스너 목록 및 상태조회
	 * 
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectProxyListnerMainList(int pry_svr_id) {
		List<Map<String, Object>> result = null;
		result = (List<Map<String, Object>>) list("proxyMonitoringSql.selectProxyListnerMainList", pry_svr_id);
		return result;
	}

	/**
	 * Proxy 리스너 상세 정보 조회
	 * 
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectProxyStatisticsInfo(int pry_svr_id) {
		List<Map<String, Object>> result = null;
		result = (List<Map<String, Object>>) list("proxyMonitoringSql.selectProxyStatisticsInfo", pry_svr_id);
		return result;
	}

	/**
	 * Proxy 리스너 통계 정보 조회
	 * 
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectProxyStatisticsChartInfo(int pry_svr_id) {
		List<Map<String, Object>> result = null;
		result = (List<Map<String, Object>>) list("proxyMonitoringSql.selectProxyStatisticsChartInfo", pry_svr_id);
		return result;
	}

	/**
	 * Proxy 리스너 통계 정보 카운트
	 * 
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectProxyChartCntList(int pry_svr_id) {
		List<Map<String, Object>> result = null;
		result = (List<Map<String, Object>>) list("proxyMonitoringSql.selectProxyChartCntList", pry_svr_id);
		return result;
	}

	/**
	 * proxy / keepalived config 파일 정보 조회
	 * 
	 * @param int pry_svr_id, String type
	 * @return Map<String, Object>
	 */
	public Map<String, Object> selectConfigurationInfo(int pry_svr_id, String type) {
		Map<String, Object> result = null;
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("pry_svr_id", pry_svr_id);
		param.put("type", type);
		result = selectOne("proxyMonitoringSql.selectConfiguration", param);
		return result;
	}

	/**
	 * proxy / keepavlived 기동-정지 실패 로그 
	 * 
	 * @param pry_act_exe_sn
	 * @return Map<String, Object>
	 */
	public Map<String, Object> selectActExeFailLog(int pry_act_exe_sn) {
		Map<String, Object> result = selectOne("proxyMonitoringSql.selectActExeFailLog", pry_act_exe_sn);
		return result;
	}
	
	/**
	 * proxy config파일 변경 이력 조회
	 * 
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectPryCngList(int pry_svr_id) {
		List<Map<String, Object>> result = null;
		result = (List<Map<String, Object>>) list("proxyMonitoringSql.selectPryCngList", pry_svr_id);
		return result;
	}

	/**
	 * proxy 연결 db standby ip list
	 * 
	 * @param db_svr_id
	 * @return List<Map<String, Object>>
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectDbStandbyList(int db_svr_id) {
		List<Map<String, Object>> result = null;
		result = (List<Map<String, Object>>) list("proxyMonitoringSql.selectDbStandbyList", db_svr_id);
		return result;
	}

	/**
	 * dashbord Proxy 조회 by db server id
	 * @param db_svr_id
	 * @return List<Map<String, Object>>
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectProxyServerByDBSvrId(int db_svr_id) {
		List<Map<String, Object>> result = null;
		result = (List<Map<String, Object>>) list("proxyMonitoringSql.selectProxyServerByDBSvrId", db_svr_id);
		return result;
	}
}