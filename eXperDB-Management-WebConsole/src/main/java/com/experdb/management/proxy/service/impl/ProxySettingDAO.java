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

	/**
	 * Proxy Server 목록 조회
	 * 
	 * @param param
	 * @return List<ProxyServerVO>
	 * @throws SQLException
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<ProxyServerVO> selectProxyServerList(Map<String, Object> param) throws SQLException {
		List<ProxyServerVO> result = null;
		result = (List<ProxyServerVO>) list("proxyServerSettingSql.selectProxyServerList", param);
		return result;
	}

	/**
	 * Proxy Global 정보 조회
	 * 
	 * @param param
	 * @return ProxyGlobalVO
	 * @throws SQLException
	 */
	public ProxyGlobalVO selectProxyGlobal(Map<String, Object> param) throws SQLException {
		ProxyGlobalVO result = null;
		result = (ProxyGlobalVO) selectOne("proxyServerSettingSql.selectProxyGlobal", param);
		return result;
	}

	/**
	 * Proxy Listener List 정보 조회
	 * 
	 * @param param
	 * @return List<ProxyListenerVO>
	 * @throws SQLException
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<ProxyListenerVO> selectProxyListenerList(Map<String, Object> param) throws SQLException {
		List<ProxyListenerVO> result = null;
		result = (List<ProxyListenerVO>) list("proxyServerSettingSql.selectProxyListenerList", param);
		return result;
	}

	/**
	 * VIP List 정보 조회
	 * 
	 * @param param
	 * @return List<ProxyVipConfigVO>
	 * @throws SQLException
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<ProxyVipConfigVO> selectProxyVipConfList(Map<String, Object> param) throws SQLException {
		List<ProxyVipConfigVO> result = null;
		result = (List<ProxyVipConfigVO>) list("proxyServerSettingSql.selectProxyVipConfList", param);
		return result;
	}

	/**
	 * database 정보조회
	 * 
	 * @param param
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectDBSelList(Map<String, Object> param) throws SQLException {
		List<Map<String, Object>> result = null;
		result = (List<Map<String, Object>>) list("proxyServerSettingSql.selectDBSelList", param);
		return result;
	}

	/**
	 * 연결 DBMS 정보 조회
	 * 
	 * @param param
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectDbmsList(Map<String, Object> param) {
		List<Map<String, Object>> result = null;
		result = (List<Map<String, Object>>) list("proxyServerSettingSql.selectDbmsList", param);
		return result;
	}

	/**
	 * Master Proxy 정보 조회
	 * 
	 * @param param
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectMasterSvrProxyList(Map<String, Object> param) {
		List<Map<String, Object>> result = null;
		result = (List<Map<String, Object>>) list("proxyServerSettingSql.selectMasterSvrProxyList", param);
		return result;
	}

	/**
	 * Proxy 서버 등록 서버명 조회
	 * 
	 * @param param
	 * @return String
	 * @throws
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public String proxySetServerNmList(Map<String, Object> param) {
		String resultSet = "";
		resultSet = (String) getSqlSession().selectOne("proxyServerSettingSql.proxySetServerNmList", param);
		return resultSet;
	}

	/**
	 * proxy 적용 status 변경
	 * 
	 * @param param
	 * @return
	 * @throws
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public void updateProxyServerStatus(Map<String, Object> param) {
		update("proxyServerSettingSql.updateProxyServerStatus", param);	
	}

	/**
	 * proxy agent update
	 * 
	 * @param pryAgtVO
	 * @return
	 * @throws
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public void updateProxyAgentInfo(ProxyAgentVO pryAgtVO) {
		update("proxyServerSettingSql.updateProxyAgentInfo", pryAgtVO);	
	}

	/**
	 * proxy server insert
	 * 
	 * @param prySvrVO
	 * @return
	 * @throws
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public void insertProxyServerInfo(ProxyServerVO prySvrVO) {
		insert("proxyServerSettingSql.insertProxyServerInfo", prySvrVO);	
	}

	/**
	 * proxy global insert
	 * 
	 * @param prySvrVO
	 * @return
	 * @throws
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public void insertProxyGlobalConf(ProxyGlobalVO globalVO) {
		insert("proxyServerSettingSql.insertProxyGlobalConf", globalVO);	
	}

	/**
	 * proxy server update
	 * 
	 * @param prySvrVO
	 * @return
	 * @throws
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public void updateProxyServerInfo(ProxyServerVO prySvrVO) {
		update("proxyServerSettingSql.updateProxyServerInfo", prySvrVO);	
	}

	/**
	 * proxy server id 조회
	 * 
	 * @param prySvrVO
	 * @return
	 * @throws
	 */
	public long selectQ_T_PRY_SVR_I_01() throws SQLException {
		return (long) getSqlSession().selectOne("proxyServerSettingSql.selectQ_T_PRY_SVR_I_01");
	}

	/**
	 * update t_pry_agt_i의 svr_use_yn = N으로 업데이트
	 * 
	 * @param param
	 * @return
	 * @throws
	 */
	public void updateProxyAgentInfoFromProxyId(Map<String, Object> param) {
		update("proxyServerSettingSql.updateProxyAgentInfoFromProxyId", param);	
	}

	/**
	 * delete t_prycng_g
	 * 
	 * @param prySvrId
	 * @return
	 * @throws
	 */
	public void deleteProxyConfHistList(int prySvrId) {
		delete("proxyServerSettingSql.deleteProxyConfHistList", prySvrId);
	}

	/**
	 * delete t_pry_actstate_cng_g
	 * 
	 * @param prySvrId
	 * @return
	 * @throws
	 */
	public void deleteProxyActStateConfHistList(int prySvrId) {
		delete("proxyServerSettingSql.deleteProxyActStateConfHistList", prySvrId);
	}

	/**
	 * delete t_pry_svr_status_g
	 * 
	 * @param prySvrId
	 * @return
	 * @throws
	 */
	public void deleteProxySvrStatusHistList(int prySvrId) {
		delete("proxyServerSettingSql.deleteProxySvrStatusHistList", prySvrId);
	}

	/**
	 * delete t_pry_lsn_svr_i 
	 * 
	 * @param prySvrId
	 * @return
	 * @throws
	 */
	public void deletePryListenerSvrList(int prySvrId) {
		delete("proxyServerSettingSql.deletePryListenerSvrList", prySvrId);
	}

	/**
	 * delete t_pry_lsn_i
	 * 
	 * @param prySvrId
	 * @return
	 * @throws
	 */
	public void deletePryListenerList(int prySvrId) {
		delete("proxyServerSettingSql.deletePryListenerList", prySvrId);
	}

	/**
	 * delete t_pry_vipcng_i
	 * 
	 * @param prySvrId
	 * @return
	 * @throws
	 */
	public void deletePryVipConfList(int prySvrId) {
		delete("proxyServerSettingSql.deletePryVipConfList", prySvrId);
	}

	/**
	 * delete t_pry_glb_i
	 * 
	 * @param prySvrId
	 * @return
	 * @throws
	 */
	public void deleteGlobalConfList(int prySvrId) {
		delete("proxyServerSettingSql.deleteGlobalConfList", prySvrId);
	}

	/**
	 * delete t_pry_svr_i
	 * 
	 * @param prySvrId
	 * @return
	 * @throws
	 */
	public void deleteProxyServer(int prySvrId) {
		delete("proxyServerSettingSql.deleteProxyServer", prySvrId);
	}
	
	/**
	 * Proxy 리스너 server 목록 조회
	 * 
	 * @param param
	 * @return List<ProxyListenerServerVO>
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<ProxyListenerServerVO> selectListenServerList(Map<String, Object> param) {
		List<ProxyListenerServerVO> result = null;
		result = (List<ProxyListenerServerVO>) list("proxyServerSettingSql.selectListenServerList", param);
		return result;
		
	}
	
	/**
	 * Proxy ip 조회
	 * 
	 * @param param
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectIpList(Map<String, Object> param) {
		List<Map<String, Object>> result = null;
		result = (List<Map<String, Object>>) list("proxyServerSettingSql.selectIpList", param);
		return result;
	}
	
	/**
	 * update global conf Info
	 * 
	 * @param globalVO
	 * @return 
	 * @throws Exception
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public void updateProxyGlobalConf(ProxyGlobalVO globalVO) {
		update("proxyServerSettingSql.updateProxyGlobalConf", globalVO);	
	}
	
	/**
	 * insert/update vip instance
	 * 
	 * @param proxyVipConfigVO
	 * @return 
	 * @throws Exception
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public void insertUpdatePryVipConf(ProxyVipConfigVO proxyVipConfigVO) {
		if(proxyVipConfigVO.getVip_cng_id() == 0){
			insert("proxyServerSettingSql.insertPryVipConf", proxyVipConfigVO);	
		}else{
			update("proxyServerSettingSql.updatePryVipConf", proxyVipConfigVO);	
		}	
	}

	/**
	 * delete vip instance
	 * 
	 * @param proxyVipConfigVO
	 * @return 
	 * @throws Exception
	 */
	public void deletePryVipConf(ProxyVipConfigVO proxyVipConfigVO) {
		delete("proxyServerSettingSql.deletePryVipConf", proxyVipConfigVO);
	}

	/**
	 * 리스너 id 조회
	 * 
	 * @param 
	 * @return int
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public int selectPryListenerMaxId() {
		int result = 0;
		result = selectOne("proxyServerSettingSql.selectPryListenerMaxId");
		return result;
	}

	/**
	 * UPDATE/INSERT PROXY LISTENER Server List
	 * 
	 * @param proxyListenerServerVO
	 * @return 
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public void insertUpdatePryListenerSvr(ProxyListenerServerVO proxyListenerServerVO) {
		if(proxyListenerServerVO.getLsn_svr_id() == 0){
			insert("proxyServerSettingSql.insertPryListenerSvr", proxyListenerServerVO);	
		}else{
			update("proxyServerSettingSql.updatePryListenerSvr", proxyListenerServerVO);	
		}	
	}

	/**
	 * delete proxy listener server list
	 * 
	 * @param proxyListenerServerVO
	 * @return 
	 * @throws Exception
	 */
	public void deletePryListenerSvr(ProxyListenerServerVO proxyListenerServerVO) {
		delete("proxyServerSettingSql.deletePryListenerSvr", proxyListenerServerVO);
	}

	/**
	 * proxy agent 목록 조회
	 * 
	 * @param param
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectPoxyAgentSvrList(Map<String, Object> param) {
		List<Map<String, Object>> result = null;
		result = (List<Map<String, Object>>) list("proxyServerSettingSql.selectPoxyAgentSvrList", param);
		return result;
	}

	/**
	 * UPDATE/INSERT PROXY LISTENER
	 * 
	 * @param proxyListenerVO
	 * @return 
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public void insertUpdatePryListener(ProxyListenerVO proxyListenerVO) {
		if(proxyListenerVO.getLsn_id() == 0){
			insert("proxyServerSettingSql.insertPryListener", proxyListenerVO);	
		}else{
			update("proxyServerSettingSql.updatePryListener", proxyListenerVO);	
		}	
	}

	/**
	 * delete proxy listener
	 * 
	 * @param proxyListenerVO
	 * @return 
	 * @throws Exception
	 */
	public void deletePryListener(ProxyListenerVO proxyListenerVO) {
		delete("proxyServerSettingSql.deletePryListener", proxyListenerVO);
	}

	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectMasterProxyList(Map<String, Object> param) {
		List<Map<String, Object>> result = null;
		result = (List<Map<String, Object>>) list("proxyServerSettingSql.selectMasterProxyList", param);
		return result;
	}
	
	/**
	 * Proxy Agent 정보 조회
	 * 
	 * @param param
	 * @return ProxyAgentVO
	 * @throws SQLException
	 */
	public ProxyAgentVO selectProxyAgentInfo(Map<String, Object> param) throws SQLException {
		ProxyAgentVO result = null;
		result = (ProxyAgentVO) selectOne("proxyServerSettingSql.selectProxyAgentInfo", param);
		return result;
	}
	
	/**
	 * Proxy Global 정보 조회
	 * 
	 * @param param
	 * @return ProxyGlobalVO
	 * @throws SQLException
	 */
	public ProxyServerVO selectProxyServerInfo(int pry_svr_id) throws SQLException {
		ProxyServerVO result = null;
		result = (ProxyServerVO) selectOne("proxyServerSettingSql.selectProxyServerInfo", pry_svr_id);
		return result;
	}

	public void updatePrySvrKalInstYn(ProxyServerVO prySvrVO) {
		// TODO Auto-generated method stub
		update("proxyServerSettingSql.updatePrySvrKalInstYn", prySvrVO);	
	}
}
