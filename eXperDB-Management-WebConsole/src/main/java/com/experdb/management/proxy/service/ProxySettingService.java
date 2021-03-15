package com.experdb.management.proxy.service;

import java.util.List;
import java.util.Map;

public interface ProxySettingService {
	
	/**
	 * Proxy Server 조회
	 * @param 
	 * @throws Exception
	 */
	public List<ProxyServerVO> selectProxyServerList(Map<String, Object> param) throws Exception;

	public ProxyGlobalVO selectProxyGlobal(Map<String, Object> param)throws Exception;

	public List<ProxyListenerVO> selectProxyListenerList(Map<String, Object> param)throws Exception;

	public List<ProxyVipConfigVO> selectProxyVipConfList(Map<String, Object> param)throws Exception;

	public List<Map<String, Object>> selectMasterProxyList(Map<String, Object> param);

	public List<Map<String, Object>> selectDbmsList(Map<String, Object> param);

	public void updateProxyAgentInfo(ProxyAgentVO pryAgtVO);

	public void updateProxyServerInfo(ProxyServerVO prySvrVO);


}
