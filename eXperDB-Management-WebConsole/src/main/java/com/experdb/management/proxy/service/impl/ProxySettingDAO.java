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
		result = (List<ProxyServerVO>) list("proxySettingSql.selectProxyServerList", param);
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
		result = (ProxyGlobalVO) selectOne("proxySettingSql.selectProxyGlobal", param);
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
		result = (List<ProxyListenerVO>) list("proxySettingSql.selectProxyListenerList", param);
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
		result = (List<ProxyVipConfigVO>) list("proxySettingSql.selectProxyVipConfList", param);
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
		result = (List<Map<String, Object>>) list("proxySettingSql.selectDBSelList", param);
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
		result = (List<Map<String, Object>>) list("proxySettingSql.selectDbmsList", param);
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
		result = (List<Map<String, Object>>) list("proxySettingSql.selectMasterSvrProxyList", param);
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
		resultSet = (String) getSqlSession().selectOne("proxySettingSql.proxySetServerNmList", param);
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
		update("proxySettingSql.updateProxyServerStatus", param);	
	}

	/**
	 * proxy agent update
	 * 
	 * @param pryAgtVO
	 * @return
	 * @throws
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public void updateProxyAgentInfo(ProxyServerVO prySvrVO) {
		update("proxySettingSql.updateProxyAgentInfo", prySvrVO);	
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
		insert("proxySettingSql.insertProxyServerInfo", prySvrVO);	
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
		insert("proxySettingSql.insertProxyGlobalConf", globalVO);	
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
		update("proxySettingSql.updateProxyServerInfo", prySvrVO);	
	}

	/**
	 * proxy server id 조회
	 * 
	 * @param prySvrVO
	 * @return
	 * @throws
	 */
	public long selectQ_T_PRY_SVR_I_01() throws SQLException {
		return (long) getSqlSession().selectOne("proxySettingSql.selectQ_T_PRY_SVR_I_01");
	}

	/**
	 * update t_pry_agt_i의 svr_use_yn = N으로 업데이트
	 * 
	 * @param param
	 * @return
	 * @throws
	 */
	public void updateProxyAgentInfoFromProxyId(Map<String, Object> param) {
		update("proxySettingSql.updateProxyAgentInfoFromProxyId", param);	
	}

	/**
	 * delete t_prycng_g
	 * 
	 * @param prySvrId
	 * @return
	 * @throws
	 */
	public void deleteProxyConfHistList(int prySvrId) {
		delete("proxySettingSql.deleteProxyConfHistList", prySvrId);
	}

	/**
	 * delete t_pry_actstate_cng_g
	 * 
	 * @param prySvrId
	 * @return
	 * @throws
	 */
	public void deleteProxyActStateConfHistList(int prySvrId) {
		delete("proxySettingSql.deleteProxyActStateConfHistList", prySvrId);
	}

	/**
	 * delete t_pry_svr_status_g
	 * 
	 * @param prySvrId
	 * @return
	 * @throws
	 */
	public void deleteProxySvrStatusHistList(int prySvrId) {
		delete("proxySettingSql.deleteProxySvrStatusHistList", prySvrId);
	}

	/**
	 * delete t_pry_lsn_svr_i 
	 * 
	 * @param prySvrId
	 * @return
	 * @throws
	 */
	public void deletePryListenerSvrList(int prySvrId) {
		delete("proxySettingSql.deletePryListenerSvrList", prySvrId);
	}

	/**
	 * delete t_pry_lsn_i
	 * 
	 * @param prySvrId
	 * @return
	 * @throws
	 */
	public void deletePryListenerList(int prySvrId) {
		delete("proxySettingSql.deletePryListenerList", prySvrId);
	}

	/**
	 * delete t_pry_vipcng_i
	 * 
	 * @param prySvrId
	 * @return
	 * @throws
	 */
	public void deletePryVipConfList(int prySvrId) {
		delete("proxySettingSql.deletePryVipConfList", prySvrId);
	}

	/**
	 * delete t_pry_glb_i
	 * 
	 * @param prySvrId
	 * @return
	 * @throws
	 */
	public void deleteGlobalConfList(int prySvrId) {
		delete("proxySettingSql.deleteGlobalConfList", prySvrId);
	}

	/**
	 * delete t_pry_svr_i
	 * 
	 * @param prySvrId
	 * @return
	 * @throws
	 */
	public void deleteProxyServer(int prySvrId) {
		delete("proxySettingSql.deleteProxyServer", prySvrId);
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
		result = (List<ProxyListenerServerVO>) list("proxySettingSql.selectListenServerList", param);
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
		result = (List<Map<String, Object>>) list("proxySettingSql.selectIpList", param);
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
		update("proxySettingSql.updateProxyGlobalConf", globalVO);	
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
			insert("proxySettingSql.insertPryVipConf", proxyVipConfigVO);	
		}else{
			update("proxySettingSql.updatePryVipConf", proxyVipConfigVO);	
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
		delete("proxySettingSql.deletePryVipConf", proxyVipConfigVO);
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
		result = selectOne("proxySettingSql.selectPryListenerMaxId");
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
			insert("proxySettingSql.insertPryListenerSvr", proxyListenerServerVO);	
		}else{
			update("proxySettingSql.updatePryListenerSvr", proxyListenerServerVO);	
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
		delete("proxySettingSql.deletePryListenerSvr", proxyListenerServerVO);
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
		return (List<Map<String, Object>>) list("proxySettingSql.selectPoxyAgentSvrList", param);
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
			insert("proxySettingSql.insertPryListener", proxyListenerVO);	
		}else{
			update("proxySettingSql.updatePryListener", proxyListenerVO);	
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
		delete("proxySettingSql.deletePryListener", proxyListenerVO);
	}

	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectMasterProxyList(Map<String, Object> param) {
		List<Map<String, Object>> result = null;
		result = (List<Map<String, Object>>) list("proxySettingSql.selectMasterProxyList", param);
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
		result = (ProxyAgentVO) selectOne("proxySettingSql.selectProxyAgentInfo", param);
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
		return (ProxyServerVO) selectOne("proxySettingSql.selectProxyServerInfo", pry_svr_id);
	}

	public void updatePrySvrKalInstYn(ProxyServerVO prySvrVO) {
		// TODO Auto-generated method stub
		update("proxySettingSql.updatePrySvrKalInstYn", prySvrVO);	
	}

	/**
	 * delete t_pry_svr_status_g
	 * 
	 * @param param
	 * @return 
	 */
	public void deletePrySvrStatusList(Map<String, Object> param) {
		delete("proxySettingSql.deletePrySvrStatusList", param);	
	}

	public String selectProxyAgentSvrUseYnFromProxyId(int prySvrId) {
		String svrUseYn = "";
		svrUseYn = (String) getSqlSession().selectOne("proxySettingSql.selectProxyAgentSvrUseYnFromProxyId", prySvrId);
		return svrUseYn;
	}

	public void upgradePrySvrOldMaster(int dbSvrId) {
		update("proxySettingSql.upgradePrySvrOldMaster", dbSvrId);	
	}
}
