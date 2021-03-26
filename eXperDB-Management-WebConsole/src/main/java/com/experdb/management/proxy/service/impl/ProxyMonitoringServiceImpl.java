package com.experdb.management.proxy.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;

import com.experdb.management.proxy.service.ProxyLogVO;
import com.experdb.management.proxy.service.ProxyMonitoringService;
import com.k4m.dx.tcontrol.admin.accesshistory.service.impl.AccessHistoryDAO;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.common.service.impl.CmmnServerInfoDAO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
* @author 
* @see proxy 모니터링 관련 화면 serviceImpl
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일                 수정자                   수정내용
*  -------     --------    ---------------------------
*  2021.03.05              최초 생성
*      </pre>
*/
@Service("ProxyMonitoringServiceImpl")
public class ProxyMonitoringServiceImpl extends EgovAbstractServiceImpl implements ProxyMonitoringService{
	
	@Resource(name="proxyMonitoringDAO")
	private ProxyMonitoringDAO proxyMonitoringDAO;

	@Resource(name = "accessHistoryDAO")
	private AccessHistoryDAO accessHistoryDAO;
	
	@Resource(name = "cmmnServerInfoDAO")
	private CmmnServerInfoDAO cmmnServerInfoDAO;
	
	
	
	/**
	 * Proxy 모니터링 화면 접속 이력 등록	
	 * @param request, historyVO, dtlCd
	 * @throws Exception
	 */
	@Override
	public void monitoringSaveHistory(HttpServletRequest request, HistoryVO historyVO, String dtlCd, int mnu_id) throws Exception {
		CmmnUtils.saveHistory(request, historyVO);
		historyVO.setExe_dtl_cd(dtlCd);
		historyVO.setMnu_id(mnu_id);
		accessHistoryDAO.insertHistory(historyVO);
	}

	/**
	 * Proxy 서버 목록 조회
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectProxyServerList() {
		return proxyMonitoringDAO.selectProxyServerList();
	}

	/**
	 * Proxy 서버  cluster 조회 by master server id
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectProxyServerByMasterId(int pry_svr_id) {
		return proxyMonitoringDAO.selectProxyServerByMasterId(pry_svr_id);
	}

	/**
	 * proxy / keepalived 기동 상태 이력
	 * @param pry_svr_id
	 * @return List<ProxyLogVO>
	 */
	@Override
	public List<ProxyLogVO> selectProxyLogList(int pry_svr_id) {
		return proxyMonitoringDAO.selectProxyLogList(pry_svr_id);
	}

	/**
	 * Proxy 연결된 db 서버 조회
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectDBServerConProxy(int pry_svr_id) {
		return proxyMonitoringDAO.selectDBServerConProxy(pry_svr_id);
	}

	/**
	 * Proxy 리스너 상세 정보 조회
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectProxyStatisticsInfo(int pry_svr_id) {
		return proxyMonitoringDAO.selectProxyStatisticsInfo(pry_svr_id);
	}

	/**
	 * Proxy 리스너 통계 정보 조회
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectProxyStatisticsChartInfo(int pry_svr_id) {
		return proxyMonitoringDAO.selectProxyStatisticsChartInfo(pry_svr_id);
	}

	/**
	 * Proxy 리스너 통계 정보 카운트
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectProxyChartCntList(int pry_svr_id) {
		return proxyMonitoringDAO.selectProxyChartCntList(pry_svr_id);
	}

	/**
	 * proxy / keepalived config 파일 정보 조회
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public Map<String, Object> selectConfiguration(int pry_svr_id, String type) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("pry_svr_id", pry_svr_id);
		param.put("type", type);
		Map<String, Object> result = proxyMonitoringDAO.selectConfiguration(param);
		return result;
	}
	
	
	
}
