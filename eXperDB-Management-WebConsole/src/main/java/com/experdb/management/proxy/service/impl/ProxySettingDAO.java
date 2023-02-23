package com.experdb.management.proxy.service.impl;

import com.experdb.management.proxy.service.ProxyAgentVO;
import com.experdb.management.proxy.service.ProxyGlobalVO;
import com.experdb.management.proxy.service.ProxyListenerServerVO;
import com.experdb.management.proxy.service.ProxyListenerVO;
import com.experdb.management.proxy.service.ProxyServerVO;
import com.experdb.management.proxy.service.ProxyVipConfigVO;
import com.experdb.management.proxy.service.impl.ProxySettingDAO;
import egovframework.rte.psl.dataaccess.EgovAbstractMapper;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;

@Repository("proxySettingDAO")
public class ProxySettingDAO extends EgovAbstractMapper {
  public List<ProxyServerVO> selectProxyServerList(Map<String, Object> param) throws SQLException {
    List<ProxyServerVO> result = null;
    result = (List<ProxyServerVO>) list("proxySettingSql.selectProxyServerList", param);
    return result;
  }
  
  public ProxyGlobalVO selectProxyGlobal(Map<String, Object> param) throws SQLException {
    ProxyGlobalVO result = null;
    result = (ProxyGlobalVO)selectOne("proxySettingSql.selectProxyGlobal", param);
    return result;
  }
  
  public List<ProxyListenerVO> selectProxyListenerList(Map<String, Object> param) throws SQLException {
    List<ProxyListenerVO> result = null;
    result = (List<ProxyListenerVO>) list("proxySettingSql.selectProxyListenerList", param);
    return result;
  }
  
  public List<ProxyVipConfigVO> selectProxyVipConfList(Map<String, Object> param) throws SQLException {
    List<ProxyVipConfigVO> result = null;
    result = (List<ProxyVipConfigVO>) list("proxySettingSql.selectProxyVipConfList", param);
    return result;
  }
  
  public List<Map<String, Object>> selectDBSelList(Map<String, Object> param) throws SQLException {
    List<Map<String, Object>> result = null;
    result = (List<Map<String, Object>>) list("proxySettingSql.selectDBSelList", param);
    return result;
  }
  
  public List<Map<String, Object>> selectDbmsList(Map<String, Object> param) throws SQLException {
    List<Map<String, Object>> result = null;
    result = (List<Map<String, Object>>) list("proxySettingSql.selectDbmsList", param);
    return result;
  }
  
  public List<Map<String, Object>> selectMasterSvrProxyList(Map<String, Object> param) {
    List<Map<String, Object>> result = null;
    result = (List<Map<String, Object>>) list("proxySettingSql.selectMasterSvrProxyList", param);
    return result;
  }
  
  public String proxySetServerNmList(Map<String, Object> param) {
    String resultSet = "";
    resultSet = (String)getSqlSession().selectOne("proxySettingSql.proxySetServerNmList", param);
    return resultSet;
  }
  
  public void updateProxyAgentInfo(ProxyServerVO prySvrVO) {
    update("proxySettingSql.updateProxyAgentInfo", prySvrVO);
  }
  
  public void insertProxyServerInfo(ProxyServerVO prySvrVO) {
    insert("proxySettingSql.insertProxyServerInfo", prySvrVO);
  }
  
  public void insertProxyGlobalConf(ProxyGlobalVO globalVO) {
    insert("proxySettingSql.insertProxyGlobalConf", globalVO);
  }
  
  public void updateProxyServerInfo(ProxyServerVO prySvrVO) {
    update("proxySettingSql.updateProxyServerInfo", prySvrVO);
  }
  
  public long selectQ_T_PRY_SVR_I_01() throws SQLException {
    return ((Long)getSqlSession().selectOne("proxySettingSql.selectQ_T_PRY_SVR_I_01")).longValue();
  }
  
  public void updateProxyAgentInfoFromProxyId(Map<String, Object> param) {
    update("proxySettingSql.updateProxyAgentInfoFromProxyId", param);
  }
  
  public void deleteProxyTblList(int prySvrId) {
    delete("proxySettingSql.deleteProxyTblList", Integer.valueOf(prySvrId));
  }
  
  public void deletePryVipConfList(int prySvrId) {
    delete("proxySettingSql.deletePryVipConfList", Integer.valueOf(prySvrId));
  }
  
  public List<ProxyListenerServerVO> selectListenServerList(Map<String, Object> param) {
    List<ProxyListenerServerVO> result = null;
    result = (List<ProxyListenerServerVO>) list("proxySettingSql.selectListenServerList", param);
    return result;
  }
  
  public List<Map<String, Object>> selectIpList(Map<String, Object> param) {
    List<Map<String, Object>> result = null;
    result = (List<Map<String, Object>>) list("proxySettingSql.selectIpList", param);
    return result;
  }
  
  public void updateProxyGlobalConf(ProxyGlobalVO globalVO) {
    update("proxySettingSql.updateProxyGlobalConf", globalVO);
  }
  
  public void insertUpdatePryVipConf(ProxyVipConfigVO proxyVipConfigVO) {
    update("proxySettingSql.updatePryVipConf", proxyVipConfigVO);
  }
  
  public void deletePryVipConf(ProxyVipConfigVO proxyVipConfigVO) {
    delete("proxySettingSql.deletePryVipConf", proxyVipConfigVO);
  }
  
  public int selectPryListenerMaxId() {
    int result = 0;
    result = ((Integer)selectOne("proxySettingSql.selectPryListenerMaxId")).intValue();
    return result;
  }
  
  public void insertUpdatePryListenerSvr(ProxyListenerServerVO proxyListenerServerVO) {
    update("proxySettingSql.updatePryListenerSvr", proxyListenerServerVO);
  }
  
  public void deletePryListenerSvr(ProxyListenerServerVO proxyListenerServerVO) {
    delete("proxySettingSql.deletePryListenerSvr", proxyListenerServerVO);
  }
  
  public List<Map<String, Object>> selectPoxyAgentSvrList(Map<String, Object> param) {
    return (List<Map<String, Object>>) list("proxySettingSql.selectPoxyAgentSvrList", param);
  }
  
  public void insertUpdatePryListener(ProxyListenerVO proxyListenerVO) {
    update("proxySettingSql.updatePryListener", proxyListenerVO);
  }
  
  public void deletePryListener(ProxyListenerVO proxyListenerVO) {
    delete("proxySettingSql.deletePryListener", proxyListenerVO);
  }
  
  public List<Map<String, Object>> selectMasterProxyList(Map<String, Object> param) {
    List<Map<String, Object>> result = null;
    result = (List<Map<String, Object>>) list("proxySettingSql.selectMasterProxyList", param);
    return result;
  }
  
  public ProxyAgentVO selectProxyAgentInfo(Map<String, Object> param) throws SQLException {
    ProxyAgentVO result = null;
    result = (ProxyAgentVO)selectOne("proxySettingSql.selectProxyAgentInfo", param);
    return result;
  }
  
  public ProxyServerVO selectProxyServerInfo(int pry_svr_id) throws SQLException {
    return (ProxyServerVO)selectOne("proxySettingSql.selectProxyServerInfo", Integer.valueOf(pry_svr_id));
  }
  
  public void updatePrySvrKalInstYn(ProxyServerVO prySvrVO) {
    update("proxySettingSql.updatePrySvrKalInstYn", prySvrVO);
  }
  
  public void deletePrySvrStatusList(Map<String, Object> param) {
    delete("proxySettingSql.deletePrySvrStatusList", param);
  }
  
  public String selectProxyAgentSvrUseYnFromProxyId(int prySvrId) {
    String svrUseYn = "";
    svrUseYn = (String)getSqlSession().selectOne("proxySettingSql.selectProxyAgentSvrUseYnFromProxyId", Integer.valueOf(prySvrId));
    return svrUseYn;
  }
  
  public void upgradePrySvrOldMaster(int dbSvrId) {
    update("proxySettingSql.upgradePrySvrOldMaster", Integer.valueOf(dbSvrId));
  }
  
  public List<Map<String, Object>> selectPoxyServerIPList(Map<String, Object> param) {
    List<Map<String, Object>> result = (List<Map<String, Object>>) list("proxySettingSql.selectPoxyServerIPList", param);
    return result;
  }
  
  public void updatePryAgentIp(ProxyGlobalVO param) {
    update("proxySettingSql.updateIpAddress", param);
  }
}
