package com.experdb.management.proxy.service.impl;

import java.util.HashMap;
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


}
