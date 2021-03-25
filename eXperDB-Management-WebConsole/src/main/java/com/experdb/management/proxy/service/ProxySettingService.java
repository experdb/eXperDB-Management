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

	public void updateProxyAgentInfoFromProxyId(Map<String, Object> param);

	public void deleteProxyConfHistList(int prySvrId);

	public void deleteProxyActStateConfHistList(int prySvrId);

	public void deleteProxySvrStatusHistList(int prySvrId);

	public void deletePryListenerSvrList(int prySvrId);

	public void deletePryListenerList(int prySvrId);

	public void deletePryVipConfList(int prySvrId);

	public void deleteGlobalConfList(int prySvrId);

	public void deleteProxyServer(int prySvrId);

	/*public void insertPryVipConf(ProxyVipConfigVO pryVipVO);

	public void updatePryVipConf(ProxyVipConfigVO pryVipVO);*/

	public List<ProxyListenerServerVO> selectListenServerList(Map<String, Object> param);

	public void updateProxyGlobalConf(ProxyGlobalVO globalVO);

	public void insertUpdatePryVipConf(ProxyVipConfigVO proxyVipConfigVO);

	public void deletePryVipConf(ProxyVipConfigVO proxyVipConfigVO);

	public void insertUpdatePryListener(ProxyListenerVO proxyListenerVO);

	public void insertUpdatePryListenerSvr(ProxyListenerServerVO proxyListenerServerVO);

	public int selectPryListenerMaxId();

	public void deletePryListenerSvr(ProxyListenerServerVO proxyListenerServerVO);

	public void deletePryListener(ProxyListenerVO proxyListenerVO);

	public List<Map<String, Object>> selectPoxyAgentSvrList(Map<String, Object> param);

	public void updateProxyServerStatus(Map<String, Object> param);


}
