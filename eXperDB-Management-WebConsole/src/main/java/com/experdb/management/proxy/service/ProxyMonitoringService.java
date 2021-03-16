package com.experdb.management.proxy.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.k4m.dx.tcontrol.common.service.HistoryVO;

public interface ProxyMonitoringService {
	
	/**
	 * Proxy 모니터링 화면 접속 이력 등록
	 * @param request, historyVO, dtlCd
	 * @throws Exception
	 */
	void monitoringSaveHistory(HttpServletRequest request, HistoryVO historyVO, String dtlCd, int mnu_id) throws Exception;
	List<Map<String, Object>> selectProxyServerList();
	List<Map<String, Object>> selectProxyServerByMasterId(int pry_svr_id);
//	List<DbServerVO> selectDbServerByPryMasterId(HttpServletRequest request, int pry_svr_id);
	List<ProxyLogVO> selectProxyLogList(int pry_svr_id);
	List<Map<String, Object>> selectDBServerConProxy(int pry_svr_id);
	List<Map<String, Object>> selectProxyStatisticsInfo(int pry_svr_id);
	Map<String, Object> selectConfiguration(int pry_svr_id, String Type);
}
