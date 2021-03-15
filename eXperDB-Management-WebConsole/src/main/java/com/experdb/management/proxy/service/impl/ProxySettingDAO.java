package com.experdb.management.proxy.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.experdb.management.proxy.service.ProxyAgentVO;
import com.experdb.management.proxy.service.ProxyGlobalVO;
import com.experdb.management.proxy.service.ProxyListenerVO;
import com.experdb.management.proxy.service.ProxyServerVO;
import com.experdb.management.proxy.service.ProxyVipConfigVO;
import com.k4m.dx.tcontrol.login.service.UserVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;


@Repository("proxySettingDAO")
public class ProxySettingDAO extends EgovAbstractMapper{

	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<ProxyServerVO> selectProxyServerList(Map<String, Object> param)throws SQLException {
		List<ProxyServerVO> result = null;
		result = (List<ProxyServerVO>) list("proxyServerSettingSql.selectProxyServerList", param);
		return result;
	}

	public ProxyGlobalVO selectProxyGlobal(Map<String, Object> param) {
		ProxyGlobalVO result = null;
		result = (ProxyGlobalVO) selectOne("proxyServerSettingSql.selectProxyGlobal", param);
		return result;
	}
	
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<ProxyListenerVO> selectProxyListenerList(Map<String, Object> param) {
		List<ProxyListenerVO> result = null;
		result = (List<ProxyListenerVO>) list("proxyServerSettingSql.selectProxyListenerList", param);
		return result;
	}
	
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<ProxyVipConfigVO> selectProxyVipConfList(Map<String, Object> param) {
		List<ProxyVipConfigVO> result = null;
		result = (List<ProxyVipConfigVO>) list("proxyServerSettingSql.selectProxyVipConfList", param);
		return result;
	}
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectMasterProxyList(Map<String, Object> param) {
		List<Map<String, Object>> result = null;
		result = (List<Map<String, Object>>) list("proxyServerSettingSql.selectMasterProxyList", param);
		return result;
	}

	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectDbmsList(Map<String, Object> param) {
		List<Map<String, Object>> result = null;
		result = (List<Map<String, Object>>) list("proxyServerSettingSql.selectDbmsList", param);
		return result;
	}

	public void updateProxyAgentInfo(ProxyAgentVO pryAgtVO) {
		insert("proxyServerSettingSql.updateProxyAgentInfo", pryAgtVO);	
	}

	public void updateProxyServerInfo(ProxyServerVO prySvrVO) {
		insert("proxyServerSettingSql.updateProxyServerInfo", prySvrVO);	
		
	}

	
}
