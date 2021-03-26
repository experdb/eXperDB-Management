package com.experdb.management.proxy.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.k4m.dx.tcontrol.common.service.HistoryVO;

/**
* @author 
* @see proxy 모니터링 관련 화면 service
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일                 수정자                   수정내용
*  -------     --------    ---------------------------
*  2021.03.05              최초 생성
*      </pre>
*/
public interface ProxyMonitoringService {
	
	/**
	 * Proxy 모니터링 화면 접속 이력 등록
	 * @param request, historyVO, dtlCd
	 * @throws Exception
	 */
	void monitoringSaveHistory(HttpServletRequest request, HistoryVO historyVO, String dtlCd, int mnu_id) throws Exception;
	
	/**
	 * Proxy 서버 목록 조회
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	List<Map<String, Object>> selectProxyServerList();
	
	/**
	 * Proxy 서버  cluster 조회 by master server id
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	List<Map<String, Object>> selectProxyServerByMasterId(int pry_svr_id);
//	List<DbServerVO> selectDbServerByPryMasterId(HttpServletRequest request, int pry_svr_id);
	
	/**
	 * proxy / keepalived 기동 상태 이력
	 * @param pry_svr_id
	 * @return List<ProxyLogVO>
	 */
	List<ProxyLogVO> selectProxyLogList(int pry_svr_id);
	
	/**
	 * Proxy 연결된 db 서버 조회
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	List<Map<String, Object>> selectDBServerConProxy(int pry_svr_id);
	
	/**
	 * Proxy 리스너 상세 정보 조회
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	List<Map<String, Object>> selectProxyStatisticsInfo(int pry_svr_id);
	
	/**
	 * Proxy 리스너 통계 정보 조회
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	List<Map<String, Object>> selectProxyStatisticsChartInfo(int pry_svr_id);
	
	/**
	 * Proxy 리스너 통계 정보카운트
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	List<Map<String, Object>> selectProxyChartCntList(int pry_svr_id);

	/**
	 * Proxy, keepalived config 파일 정보 조회
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	Map<String, Object> selectConfiguration(int pry_svr_id, String Type);
}
