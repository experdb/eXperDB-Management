package com.experdb.management.proxy.service;

import java.net.ConnectException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;

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
	 * 
	 * @param request, historyVO, dtlCd, mnu_id
	 * @throws Exception
	 */
	void monitoringSaveHistory(HttpServletRequest request, HistoryVO historyVO, String dtlCd, String mnu_id) throws Exception;
	
	/**
	 * Proxy 서버 목록 조회
	 * 
	 * @param 
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectProxyServerList();
	
	/**
	 * Proxy 서버  cluster 조회 by master server id
	 * 
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectProxyServerByMasterId(int pry_svr_id);

	/**
	 * Proxy 서버 cluster 별 연결 vip 조회
	 * 
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectProxyServerVipChk(int pry_svr_id);
	
	/**
	 * proxy / keepalived 기동 상태 이력 조회
	 * 
	 * @param pry_svr_id
	 * @return List<ProxyLogVO>
	 */
	public List<ProxyLogVO> selectProxyLogList(int pry_svr_id);

	/**
	 * Proxy 연결된 db 서버 조회
	 * 
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectDBServerConProxyList(int pry_svr_id);
	
	/**
	 * Proxy 리스너 목록 및 상태조회
	 * 
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectProxyListnerMainList(int pry_svr_id);
	
	/**
	 * Proxy 리스너 상세 정보 조회
	 * 
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectProxyStatisticsInfo(int pry_svr_id);
	
	/**
	 * Proxy 리스너 통계 정보 조회
	 * 
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectProxyStatisticsChartInfo(int pry_svr_id);
	
	/**
	 * Proxy 리스너 통계 정보 카운트
	 * 
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectProxyChartCntList(int pry_svr_id);

	/**
	 * Proxy, keepalived config 파일 정보 조회
	 * 
	 * @param pry_svr_id, type
	 * @return Map<String, Object>
	 */
	public Map<String, Object> selectConfigurationInfo(int pry_svr_id, String type);
	
	/**
	 * Proxy, keepalived config 파일 가져오기
	 * 
	 * @param pry_svr_id, type, Map<String, Object>
	 * @return Map<String, Object>
	 * @throws Exception 
	 */
	public Map<String, Object> getConfiguration(int pry_svr_id, String type, Map<String, Object> param) throws Exception;
	
	/**
	 * proxy / keepavlived 기동-정지 실패 로그 
	 * 
	 * @param pry_act_exe_sn
	 * @return Map<String, Object>
	 */
	public Map<String, Object> selectActExeFailLog(int pry_act_exe_sn);

	/**
	 * proxy / keepalived 상태 변경
	 * 
	 * @param Map<String, Object>
	 * @return JSONObject
	 */
	public JSONObject actExeCng(Map<String, Object> param) throws ConnectException, Exception;
	
	/**
	 * proxy / keepalived log 파일 가져오기
	 * 
	 * @param pry_svr_id,type, param
	 * @return Map<String, Object>
	 */
	public Map<String, Object> getLogFile(int pry_svr_id, String type, Map<String, Object> param) throws Exception;
	
	/**
	 * proxy config파일 변경 이력 조회
	 * 
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectPryCngList(int pry_svr_id);

	/**
	 * proxy 연결 db standby ip list
	 * 
	 * @param db_svr_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectDbStandbyList(int db_svr_id);

	/**
	 * proxy agent 상태 확인
	 * 
	 * @param pry_svr_id
	 * @return Map<String, Object>
	 */
	public Map<String, Object> getProxyAgentStatus(int pry_svr_id);

	/**
	 * dashbord Proxy 조회 by db server id
	 * 
	 * @param db_svr_id
	 * @return List<Map<String, Object>>
	 */
	public List<Map<String, Object>> selectProxyServerByDBSvrId(int db_svr_id);
}