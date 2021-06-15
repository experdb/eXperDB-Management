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

/**
 * @author 김민정
 * @see proxy 설정 관련 화면 dao
 * 
 *      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일                 수정자                   수정내용
*  -------     --------    ---------------------------
*  2021.03.05              최초 생성
 *      </pre>
 */
@Repository("proxySettingDAO")
public class ProxySettingDAO extends EgovAbstractMapper{

	/**
	 * Proxy Server 목록 조회
	 * 
	 * @param Map<String, Object>
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
	 * @param Map<String, Object>
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
	 * @param Map<String, Object>
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
	 * @param Map<String, Object>
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
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws 
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectDbmsList(Map<String, Object> param) throws SQLException {
		List<Map<String, Object>> result = null;
		result = (List<Map<String, Object>>) list("proxySettingSql.selectDbmsList", param);
		return result;
	}

	/**
	 * Master Proxy 정보 조회
	 * 
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws 
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
	 * Proxy Agent 정보 업데이트
	 * 
	 * @param ProxyServerVO
	 * @throws
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public void updateProxyAgentInfo(ProxyServerVO prySvrVO) {
		update("proxySettingSql.updateProxyAgentInfo", prySvrVO);	
	}

	/**
	 * proxy server 정보 등록
	 * 
	 * @param ProxyServerVO
	 * @return
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public void insertProxyServerInfo(ProxyServerVO prySvrVO) {
		insert("proxySettingSql.insertProxyServerInfo", prySvrVO);	
	}

	/**
	 * Proxy global 정보 등록
	 * 
	 * @param ProxyGlobalVO
	 * @return
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public void insertProxyGlobalConf(ProxyGlobalVO globalVO) {
		insert("proxySettingSql.insertProxyGlobalConf", globalVO);	
	}

	/**
	 * Proxy 서버 정보 업데이트
	 * 
	 * @param ProxyServerVO
	 * @return
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public void updateProxyServerInfo(ProxyServerVO prySvrVO) {
		update("proxySettingSql.updateProxyServerInfo", prySvrVO);	
	}

	/**
	 * proxy server id 조회
	 * 
	 * @return
	 * @throws SQLException
	 */
	public long selectQ_T_PRY_SVR_I_01() throws SQLException {
		return (long) getSqlSession().selectOne("proxySettingSql.selectQ_T_PRY_SVR_I_01");
	}

	/**
	 * Proxy Agent svr_use_yn 정보 업데이트
	 * 
	 * @param Map<String, Object>
	 * @return
	 */
	public void updateProxyAgentInfoFromProxyId(Map<String, Object> param) {
		update("proxySettingSql.updateProxyAgentInfoFromProxyId", param);	
	}

	/**
	 * t_prycng_g, t_pry_actstate_cng_g, t_pry_svr_status_g 정보 삭제
	 * t_pry_lsn_svr_i, t_pry_lsn_i, t_pry_glb_i, t_pry_svr_i 정보삭제
	 * 
	 * @param int prySvrId
	 * @return
	 */
	public void deleteProxyTblList(int prySvrId) {
		delete("proxySettingSql.deleteProxyTblList", prySvrId);
	}

	/**
	 * vip 설정 삭제
	 * 
	 * @param int prySvrId
	 * @return
	 * @throws
	 */
	public void deletePryVipConfList(int prySvrId) {
		delete("proxySettingSql.deletePryVipConfList", prySvrId);
	}

	/**
	 * Proxy 리스너 server 목록 조회
	 * 
	 * @param Map<String, Object>
	 * @return List<ProxyListenerServerVO>
	 * @throws 
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<ProxyListenerServerVO> selectListenServerList(Map<String, Object> param) {
		List<ProxyListenerServerVO> result = null;
		result = (List<ProxyListenerServerVO>) list("proxySettingSql.selectListenServerList", param);
		return result;
	}
	
	/**
	 * Proxy 연결 dbms ip/port 조회
	 * 
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws 
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectIpList(Map<String, Object> param) {
		List<Map<String, Object>> result = null;
		result = (List<Map<String, Object>>) list("proxySettingSql.selectIpList", param);
		return result;
	}
	
	/**
	 * Proxy Global Config 정보 수정
	 * 
	 * @param ProxyGlobalVO
	 * @return 
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public void updateProxyGlobalConf(ProxyGlobalVO globalVO) {
		update("proxySettingSql.updateProxyGlobalConf", globalVO);	
	}

	/**
	 * insert/update vip instance
	 * 
	 * @param ProxyVipConfigVO
	 * @return 
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
	 * Proxy VIP Config 정보 삭제
	 * 
	 * @param ProxyVipConfigVO
	 * @return 
	 */
	public void deletePryVipConf(ProxyVipConfigVO proxyVipConfigVO) {
		delete("proxySettingSql.deletePryVipConf", proxyVipConfigVO);
	}

	/**
	 * 리스너 max id 조회
	 * 
	 * @param 
	 * @return integer
	 * @throws 
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
	 * @param ProxyListenerServerVO
	 * @return 
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
	 * Proxy Listener Server 정보  삭제
	 * 
	 * @param proxyListenerServerVO
	 * @return 
	 * @throws
	 */
	public void deletePryListenerSvr(ProxyListenerServerVO proxyListenerServerVO) {
		delete("proxySettingSql.deletePryListenerSvr", proxyListenerServerVO);
	}

	/**
	 * proxy agent 목록 조회
	 * 
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws 
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
	 * @throws
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
	 * Proxy Listener 정보  삭제
	 * 
	 * @param proxyListenerVO
	 * @return 
	 * @throws
	 */
	public void deletePryListener(ProxyListenerVO proxyListenerVO) {
		delete("proxySettingSql.deletePryListener", proxyListenerVO);
	}

	/**
	 * DBMS 별 Master Proxy 조회
	 * 
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectMasterProxyList(Map<String, Object> param) {
		List<Map<String, Object>> result = null;
		result = (List<Map<String, Object>>) list("proxySettingSql.selectMasterProxyList", param);
		return result;
	}
	
	/**
	 * Proxy Agent 정보 조회
	 * 
	 * @param Map<String, Object>
	 * @return ProxyAgentVO
	 * @throws SQLException
	 */
	public ProxyAgentVO selectProxyAgentInfo(Map<String, Object> param) throws SQLException {
		ProxyAgentVO result = null;
		result = (ProxyAgentVO) selectOne("proxySettingSql.selectProxyAgentInfo", param);
		return result;
	}
	
	/**
	 * Proxy server 정보 조회
	 * 
	 * @param int pry_svr_id
	 * @return ProxyServerVO
	 * @throws 
	 */
	public ProxyServerVO selectProxyServerInfo(int pry_svr_id) throws SQLException {
		return (ProxyServerVO) selectOne("proxySettingSql.selectProxyServerInfo", pry_svr_id);
	}
	
	/**
	 * Proxy 서버 KAL_INSTALL_YN 업데이트
	 * 
	 * @param ProxyServerVO
	 * @return
	 */
	public void updatePrySvrKalInstYn(ProxyServerVO prySvrVO) {
		// TODO Auto-generated method stub
		update("proxySettingSql.updatePrySvrKalInstYn", prySvrVO);	
	}

	/**
	 * Proxy 서버 실시간 상태 로그 삭제 
	 * 
	 * @param Map<String, Object>
	 * @return 
	 */
	public void deletePrySvrStatusList(Map<String, Object> param) {
		delete("proxySettingSql.deletePrySvrStatusList", param);	
	}
	
	/**
	 * Proxy agent SVR_USE_YN 변경
	 * 
	 * @param int prySvrId
	 * @return String
	 */
	public String selectProxyAgentSvrUseYnFromProxyId(int prySvrId) {
		String svrUseYn = "";
		svrUseYn = (String) getSqlSession().selectOne("proxySettingSql.selectProxyAgentSvrUseYnFromProxyId", prySvrId);
		return svrUseYn;
	}
	
	/**
	 * Proxy server OLD_MASTER_GBN 변경
	 * 
	 * @param int dbSvrId
	 * @return 
	 */
	public void upgradePrySvrOldMaster(int dbSvrId) {
		update("proxySettingSql.upgradePrySvrOldMaster", dbSvrId);	
	}
}