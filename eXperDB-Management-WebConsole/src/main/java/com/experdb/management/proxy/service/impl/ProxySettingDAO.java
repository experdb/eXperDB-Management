package com.experdb.management.proxy.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.experdb.management.proxy.service.ProxyAgentVO;
import com.experdb.management.proxy.service.ProxyGlobalVO;
import com.experdb.management.proxy.service.ProxyListenerServerVO;
import com.experdb.management.proxy.service.ProxyListenerVO;
import com.experdb.management.proxy.service.ProxyServerVO;
import com.experdb.management.proxy.service.ProxyVipConfigVO;

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

	public void updateProxyAgentInfoFromProxyId(Map<String, Object> param) {
		insert("proxyServerSettingSql.updateProxyAgentInfoFromProxyId", param);	
	}

	public void deleteProxyConfHistList(int prySvrId) {
		delete("proxyServerSettingSql.deleteProxyConfHistList", prySvrId);
	}

	public void deleteProxyActStateConfHistList(int prySvrId) {
		delete("proxyServerSettingSql.deleteProxyActStateConfHistList", prySvrId);
	}

	public void deleteProxySvrStatusHistList(int prySvrId) {
		delete("proxyServerSettingSql.deleteProxySvrStatusHistList", prySvrId);
	}

	public void deletePryListenerSvrList(int prySvrId) {
		delete("proxyServerSettingSql.deletePryListenerSvrList", prySvrId);
	}

	public void deletePryListenerList(int prySvrId) {
		delete("proxyServerSettingSql.deletePryListenerList", prySvrId);
	}

	public void deletePryVipConfList(int prySvrId) {
		delete("proxyServerSettingSql.deletePryVipConfList", prySvrId);
	}

	public void deleteGlobalConfList(int prySvrId) {
		delete("proxyServerSettingSql.deleteGlobalConfList", prySvrId);
	}

	public void deleteProxyServer(int prySvrId) {
		delete("proxyServerSettingSql.deleteProxyServer", prySvrId);
	}

/*	public void insertPryVipConf(ProxyVipConfigVO pryVipVO) {
		insert("proxyServerSettingSql.insertPryVipConf", pryVipVO);	
	}

	public void updatePryVipConf(ProxyVipConfigVO pryVipVO) {
		insert("proxyServerSettingSql.updatePryVipConf", pryVipVO);	
	}*/
	
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<ProxyListenerServerVO> selectListenServerList(Map<String, Object> param) {
		List<ProxyListenerServerVO> result = null;
		result = (List<ProxyListenerServerVO>) list("proxyServerSettingSql.selectListenServerList", param);
		return result;
		
	}

	public void updateProxyGlobalConf(ProxyGlobalVO globalVO) {
		insert("proxyServerSettingSql.updateProxyGlobalConf", globalVO);	
	}

	public void insertUpdatePryVipConf(ProxyVipConfigVO proxyVipConfigVO) {
		if(proxyVipConfigVO.getVip_cng_id() == 0){
			insert("proxyServerSettingSql.insertPryVipConf", proxyVipConfigVO);	
		}else{
			
			insert("proxyServerSettingSql.updatePryVipConf", proxyVipConfigVO);	
		}	
	}

	public void deletePryVipConf(ProxyVipConfigVO proxyVipConfigVO) {
		delete("proxyServerSettingSql.deletePryVipConf", proxyVipConfigVO);
	}

	public void insertUpdatePryListener(ProxyListenerVO proxyListenerVO) {
		if(proxyListenerVO.getLsn_id() == 0){
			insert("proxyServerSettingSql.insertPryListener", proxyListenerVO);	
		}else{
			insert("proxyServerSettingSql.updatePryListener", proxyListenerVO);	
		}	
	}

	public void insertUpdatePryListenerSvr(ProxyListenerServerVO proxyListenerServerVO) {
		if(proxyListenerServerVO.getLsn_svr_id() == 0){
			insert("proxyServerSettingSql.insertPryListenerSvr", proxyListenerServerVO);	
		}else{
			insert("proxyServerSettingSql.updatePryListenerSvr", proxyListenerServerVO);	
		}	
	}
	
	public int selectPryListenerMaxId() {
		int result = 0;
		result = selectOne("proxyServerSettingSql.selectPryListenerMaxId");
		return result;
	}

	public void deletePryListenerSvr(ProxyListenerServerVO proxyListenerServerVO) {
		delete("proxyServerSettingSql.deletePryListenerSvr", proxyListenerServerVO);
	}

	public void deletePryListener(ProxyListenerVO proxyListenerVO) {
		delete("proxyServerSettingSql.deletePryListener", proxyListenerVO);
	}
	
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectPoxyAgentSvrList(Map<String, Object> param) {
		List<Map<String, Object>> result = null;
		result = (List<Map<String, Object>>) list("proxyServerSettingSql.selectPoxyAgentSvrList", param);
		return result;
	}

	public void updateProxyServerStatus(Map<String, Object> param) {
		insert("proxyServerSettingSql.updateProxyServerStatus", param);	
	}

	public List<Map<String, Object>> selectIpList(Map<String, Object> param) {
		List<Map<String, Object>> result = null;
		result = (List<Map<String, Object>>) list("proxyServerSettingSql.selectIpList", param);
		return result;
	}
	
}
