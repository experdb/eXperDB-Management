package com.experdb.management.proxy.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.experdb.management.proxy.service.*;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;


@Service("ProxySettingServiceImpl")
public class ProxySettingServiceImpl extends EgovAbstractServiceImpl implements ProxySettingService{
	
	@Resource(name = "proxySettingDAO")
	private ProxySettingDAO proxySettingDAO;
	
	@Override
	public List<ProxyServerVO> selectProxyServerList(Map<String, Object> param) throws Exception {
		return proxySettingDAO.selectProxyServerList(param);
	}
	
	@Override
	public ProxyGlobalVO selectProxyGlobal(Map<String, Object> param) throws Exception {
		return proxySettingDAO.selectProxyGlobal(param);
	}
	
	@Override
	public List<ProxyListenerVO> selectProxyListenerList(Map<String, Object> param) throws Exception {
		return proxySettingDAO.selectProxyListenerList(param);
	}
	
	@Override
	public List<ProxyVipConfigVO> selectProxyVipConfList(Map<String, Object> param) throws Exception {
		return proxySettingDAO.selectProxyVipConfList(param);
	}

	@Override
	public List<Map<String, Object>> selectMasterProxyList(Map<String, Object> param) {
		return proxySettingDAO.selectMasterProxyList(param);
	}

	@Override
	public List<Map<String, Object>> selectDbmsList(Map<String, Object> param) {
		return proxySettingDAO.selectDbmsList(param);
	}

	@Override
	public void updateProxyAgentInfo(ProxyAgentVO pryAgtVO) {
		proxySettingDAO.updateProxyAgentInfo(pryAgtVO);
	}

	@Override
	public void updateProxyServerInfo(ProxyServerVO prySvrVO) {
		proxySettingDAO.updateProxyServerInfo(prySvrVO);
	}

	@Override
	public void updateProxyAgentInfoFromProxyId(Map<String, Object> param) {
		proxySettingDAO.updateProxyAgentInfoFromProxyId(param);
	}

	@Override
	public void deleteProxyConfHistList(int prySvrId) {
		proxySettingDAO.deleteProxyConfHistList(prySvrId);
	}

	@Override
	public void deleteProxyActStateConfHistList(int prySvrId) {
		proxySettingDAO.deleteProxyActStateConfHistList(prySvrId);
	}

	@Override
	public void deleteProxySvrStatusHistList(int prySvrId) {
		proxySettingDAO.deleteProxySvrStatusHistList(prySvrId);
	}

	@Override
	public void deletePryListenerSvrList(int prySvrId) {
		proxySettingDAO.deletePryListenerSvrList(prySvrId);
	}

	@Override
	public void deletePryListenerList(int prySvrId) {
		proxySettingDAO.deletePryListenerList(prySvrId);
	}

	@Override
	public void deletePryVipConfList(int prySvrId) {
		proxySettingDAO.deletePryVipConfList(prySvrId);
	}

	@Override
	public void deleteGlobalConfList(int prySvrId) {
		proxySettingDAO.deleteGlobalConfList(prySvrId);
	}

	@Override
	public void deleteProxyServer(int prySvrId) {
		proxySettingDAO.deleteProxyServer(prySvrId);
	}

	/*@Override
	public void insertPryVipConf(ProxyVipConfigVO pryVipVO) {
		proxySettingDAO.insertPryVipConf(pryVipVO);
	}

	@Override
	public void updatePryVipConf(ProxyVipConfigVO pryVipVO) {
		proxySettingDAO.updatePryVipConf(pryVipVO);
	}*/

	@Override
	public List<ProxyListenerServerVO> selectListenServerList(Map<String, Object> param) {
		return proxySettingDAO.selectListenServerList(param);
	}

	@Override
	public void updateProxyGlobalConf(ProxyGlobalVO globalVO) {
		proxySettingDAO.updateProxyGlobalConf(globalVO);
	}

	@Override
	public void insertUpdatePryVipConf(ProxyVipConfigVO proxyVipConfigVO) {
		proxySettingDAO.insertUpdatePryVipConf(proxyVipConfigVO);
	}

	@Override
	public void deletePryVipConf(ProxyVipConfigVO proxyVipConfigVO) {
		proxySettingDAO.deletePryVipConf(proxyVipConfigVO);
	}

	@Override
	public void insertUpdatePryListener(ProxyListenerVO proxyListenerVO) {
		proxySettingDAO.insertUpdatePryListener(proxyListenerVO);
		
	}

	@Override
	public void insertUpdatePryListenerSvr(ProxyListenerServerVO proxyListenerServerVO) {
		proxySettingDAO.insertUpdatePryListenerSvr(proxyListenerServerVO);
		
	}

	@Override
	public int selectPryListenerMaxId() {
		return  proxySettingDAO.selectPryListenerMaxId();
	}

	@Override
	public void deletePryListenerSvr(ProxyListenerServerVO proxyListenerServerVO) {
		proxySettingDAO.deletePryListenerSvr(proxyListenerServerVO);
	}

	@Override
	public void deletePryListener(ProxyListenerVO proxyListenerVO) {
		proxySettingDAO.deletePryListener(proxyListenerVO);
	}

	@Override
	public List<Map<String, Object>> selectPoxyAgentSvrList(Map<String, Object> param) {
		return proxySettingDAO.selectPoxyAgentSvrList(param);
	}

	@Override
	public void updateProxyServerStatus(Map<String, Object> param) {
		proxySettingDAO.updateProxyServerStatus(param);
	}


}
