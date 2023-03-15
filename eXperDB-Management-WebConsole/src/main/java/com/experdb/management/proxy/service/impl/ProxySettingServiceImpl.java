package com.experdb.management.proxy.service.impl;

import java.net.ConnectException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Service;

import com.experdb.management.proxy.cmmn.CommonUtil;
import com.experdb.management.proxy.cmmn.ProxyClientInfoCmmn;
import com.experdb.management.proxy.service.ProxyAgentVO;
import com.experdb.management.proxy.service.ProxyGlobalVO;
import com.experdb.management.proxy.service.ProxyListenerServerVO;
import com.experdb.management.proxy.service.ProxyListenerVO;
import com.experdb.management.proxy.service.ProxyServerVO;
import com.experdb.management.proxy.service.ProxySettingService;
import com.experdb.management.proxy.service.ProxyVipConfigVO;
import com.k4m.dx.tcontrol.admin.accesshistory.service.impl.AccessHistoryDAO;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.CmmnCodeDtlService;
import com.k4m.dx.tcontrol.common.service.CmmnCodeVO;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.common.service.PageVO;
import com.k4m.dx.tcontrol.common.service.impl.CmmnServerInfoDAO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @author 김민정
 * @see proxy 설정 관련 화면 serviceImpl
 * 
 *      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일                 수정자                   수정내용
*  -------     --------    ---------------------------
*  2021.03.05              최초 생성
 *      </pre>
 */
@Service("ProxySettingServiceImpl")
public class ProxySettingServiceImpl extends EgovAbstractServiceImpl implements ProxySettingService {
  @Resource(name = "proxySettingDAO")
  private ProxySettingDAO proxySettingDAO;
  
  @Resource(name = "accessHistoryDAO")
  private AccessHistoryDAO accessHistoryDAO;
  
  @Resource(name = "cmmnServerInfoDAO")
  private CmmnServerInfoDAO cmmnServerInfoDAO;
  
  @Autowired
  private CmmnCodeDtlService cmmnCodeDtlService;
  
  @Autowired
  private MessageSource msg;
  
  public void accessSaveHistory(HttpServletRequest request, HistoryVO historyVO, String dtlCd, String MnuId) throws Exception {
    CmmnUtils.saveHistory(request, historyVO);
    historyVO.setExe_dtl_cd(dtlCd);
    if (MnuId != null && !"".equals(MnuId))
      historyVO.setMnu_id(Integer.parseInt(MnuId)); 
    this.accessHistoryDAO.insertHistory(historyVO);
  }
  
  public List<ProxyServerVO> selectProxyServerList(Map<String, Object> param) throws Exception {
    return this.proxySettingDAO.selectProxyServerList(param);
  }
  
  public List<String> getAgentInterface(Map<String, Object> param) throws ConnectException, Exception {
    List<String> interfList = new ArrayList<>();
    ProxyAgentVO proxyAgentVO = this.proxySettingDAO.selectProxyAgentInfo(param);
    Map<String, Object> intfItemsResult = new HashMap<>();
    ProxyClientInfoCmmn cic = new ProxyClientInfoCmmn();
    try {
      intfItemsResult = cic.getProxyAgtInterface(proxyAgentVO.getIpadr(), proxyAgentVO.getSocket_port());
    } catch (ConnectException e) {
      throw e;
    } catch (Exception e) {
      throw e;
    } 
    if (intfItemsResult != null) {
      String agentInterfList = intfItemsResult.get("INTF_LIST").toString();
      String agentInterf = intfItemsResult.get("INTF").toString();
      interfList.add(agentInterf);
      String[] interfItems = agentInterfList.split("\t");
      for (int i = 0; i < interfItems.length; i++)
        interfList.add(interfItems[i]); 
    } 
    return interfList;
  }
  
  public JSONObject getPoxyServerConf(Map<String, Object> param) throws Exception {
    JSONObject resultObj = new JSONObject();
    ProxyGlobalVO globalInfo = this.proxySettingDAO.selectProxyGlobal(param);
    List<ProxyListenerVO> listenerList = this.proxySettingDAO.selectProxyListenerList(param);
    List<ProxyVipConfigVO> vipConfigList = this.proxySettingDAO.selectProxyVipConfList(param);
    List<Map<String, Object>> dbSelList = this.proxySettingDAO.selectDBSelList(param);
    List<Map<String, Object>> ipSelList = this.proxySettingDAO.selectPoxyServerIPList(param);
    param.put("peer", "Y");
    List<ProxyVipConfigVO> peerVipConfigList = this.proxySettingDAO.selectProxyVipConfList(param);
    List<ProxyListenerVO> peerListenerList = this.proxySettingDAO.selectProxyListenerList(param);
    List<Map<String, Object>> peerIpSelList = this.proxySettingDAO.selectPoxyServerIPList(param);
    resultObj.put("errcd", Integer.valueOf(0));
    resultObj.put("errMsg", this.msg.getMessage("eXperDB_proxy.msg45", null, LocaleContextHolder.getLocale()));
    resultObj.put("global_info", (globalInfo == null) ? null : globalInfo);
    resultObj.put("listener_list", (listenerList == null) ? null : listenerList);
    resultObj.put("vipconfig_list", (vipConfigList == null) ? null : vipConfigList);
    resultObj.put("db_sel_list", (dbSelList == null) ? null : dbSelList);
    resultObj.put("ip_sel_list", (ipSelList == null) ? null : ipSelList);
    resultObj.put("peer_ip_sel_list", (peerIpSelList == null) ? null : peerIpSelList);
    resultObj.put("peer_listener_list", (peerListenerList == null) ? null : peerListenerList);
    resultObj.put("peer_vipconfig_list", (peerVipConfigList == null) ? null : peerVipConfigList);
    return resultObj;
  }
  
  public JSONObject getVipInstancePeerList(Map<String, Object> param) throws Exception {
    JSONObject resultObj = new JSONObject();
    param.put("peer", "Y");
    List<ProxyVipConfigVO> peerVipConfigList = this.proxySettingDAO.selectProxyVipConfList(param);
    resultObj.put("errcd", Integer.valueOf(0));
    resultObj.put("errMsg", this.msg.getMessage("eXperDB_proxy.msg45", null, LocaleContextHolder.getLocale()));
    resultObj.put("peer_vipconfig_list", (peerVipConfigList == null) ? null : peerVipConfigList);
    return resultObj;
  }
  
  public JSONObject createSelPrySvrReg(Map<String, Object> param) throws Exception {
    JSONObject resultObj = new JSONObject();
    List<Map<String, Object>> dbmsSelList = this.proxySettingDAO.selectDbmsList(param);
    List<Map<String, Object>> mstSvrSelList = this.proxySettingDAO.selectMasterSvrProxyList(param);
    resultObj.put("dbmsSvrList", (dbmsSelList == null) ? null : dbmsSelList);
    resultObj.put("mstSvrList", (mstSvrSelList == null) ? null : mstSvrSelList);
    return resultObj;
  }
  
  public JSONObject selectMasterSvrProxyList(Map<String, Object> param) {
    JSONObject resultObj = new JSONObject();
    List<Map<String, Object>> mstSvrSelList = this.proxySettingDAO.selectMasterSvrProxyList(param);
    resultObj.put("mstSvr_sel_list", (mstSvrSelList == null) ? null : mstSvrSelList);
    return resultObj;
  }
  
  public String proxySetServerNmList(Map<String, Object> param) {
    String result = "";
    try {
      int resultObjNum = 0;
      String ServerCnt = this.proxySettingDAO.proxySetServerNmList(param);
      if (ServerCnt != null && !"".equals(ServerCnt)) {
        resultObjNum = Integer.parseInt(ServerCnt) + 1;
        result = Integer.toString(resultObjNum);
      } else {
        result = "1";
      } 
    } catch (Exception e) {
      e.printStackTrace();
    } 
    return result;
  }
  
  public JSONObject runProxyService(Map<String, Object> param) throws ConnectException, Exception {
    JSONObject resultObj = new JSONObject();
    int prySvrId = Integer.parseInt(param.get("pry_svr_id").toString());
    String lst_mdfr_id = param.get("lst_mdfr_id").toString();
    String status = param.get("status").toString();
    String actType = param.get("act_type").toString();
    String exeActType = param.get("act_exe_type").toString();
    String[] statusNm = new String[1];
    boolean proxyExecute = false;
    boolean keepaExecute = true;
    String resultLog = "";
    String errMsg = "";
    ProxyServerVO proxyServerVO = this.proxySettingDAO.selectProxyServerInfo(prySvrId);
    String kalUseYn = (proxyServerVO.getKal_install_yn() == null) ? "" : proxyServerVO.getKal_install_yn();
    ProxyAgentVO proxyAgentVO = this.proxySettingDAO.selectProxyAgentInfo(param);
    Map<String, Object> proxyExecuteResult = new HashMap<>();
    Map<String, Object> keepaExecuteResult = new HashMap<>();
    ProxyClientInfoCmmn cic = new ProxyClientInfoCmmn();
    JSONObject agentJobj = new JSONObject();
    agentJobj.put("act_type", actType);
    if ("S".equals(actType)) {
      statusNm[0] = this.msg.getMessage("eXperDB_proxy.act_stop", null, LocaleContextHolder.getLocale());
    } else if ("A".equals(actType)) {
      statusNm[0] = this.msg.getMessage("eXperDB_proxy.act_start", null, LocaleContextHolder.getLocale());
    } else if ("R".equals(actType)) {
      statusNm[0] = this.msg.getMessage("eXperDB_proxy.act_restart", null, LocaleContextHolder.getLocale());
    } 
    agentJobj.put("pry_svr_id", Integer.valueOf(prySvrId));
    agentJobj.put("lst_mdfr_id", lst_mdfr_id);
    agentJobj.put("act_exe_type", exeActType);
    try {
      agentJobj.put("sys_type", "PROXY");
      proxyExecuteResult = cic.proxyServiceExcute(proxyAgentVO.getIpadr(), proxyAgentVO.getSocket_port(), agentJobj);
    } catch (ConnectException e) {
      throw e;
    } 
    if (proxyExecuteResult != null) {
      if (status.equals(proxyExecuteResult.get("EXECUTE_RESULT"))) {
        proxyExecute = true;
      } else {
        proxyExecute = false;
      } 
    } else {
      proxyExecute = false;
    } 
    if (kalUseYn.equals("Y")) {
      try {
        agentJobj.remove("sys_type");
        agentJobj.put("sys_type", "KEEPALIVED");
        keepaExecuteResult = cic.proxyServiceExcute(proxyAgentVO.getIpadr(), proxyAgentVO.getSocket_port(), agentJobj);
      } catch (ConnectException e) {
        throw e;
      } 
      if (keepaExecuteResult != null) {
        if (status.equals(keepaExecuteResult.get("EXECUTE_RESULT"))) {
          keepaExecute = true;
        } else {
          keepaExecute = false;
        } 
      } else {
        keepaExecute = false;
      } 
    } 
    if (!proxyExecute || !keepaExecute) {
      if (!proxyExecute)
        errMsg = "Proxy "; 
      if (!keepaExecute)
        if (!errMsg.equals("")) {
          errMsg = String.valueOf(errMsg) + " / Keepalived ";
        } else {
          errMsg = String.valueOf(errMsg) + "Keepalived ";
        }  
      errMsg = String.valueOf(errMsg) + this.msg.getMessage("eXperDB_proxy.msg51", (Object[])statusNm, LocaleContextHolder.getLocale());
    } else {
      ProxyServerVO prySvrVO = this.proxySettingDAO.selectProxyServerInfo(prySvrId);
      if ("S".equals(actType)) {
        if ("TC001502".equals(prySvrVO.getExe_status()) && ((kalUseYn.equals("Y") && "TC001502".equals(prySvrVO.getKal_exe_status())) || kalUseYn.equals("N"))) {
          errMsg = this.msg.getMessage("eXperDB_proxy.msg52", (Object[])statusNm, LocaleContextHolder.getLocale());
        } else {
          errMsg = this.msg.getMessage("eXperDB_proxy.msg51", (Object[])statusNm, LocaleContextHolder.getLocale());
        } 
      } else if ("TC001501".equals(prySvrVO.getExe_status()) && (kalUseYn.equals("N") || (kalUseYn.equals("Y") && "TC001501".equals(prySvrVO.getKal_exe_status())))) {
        errMsg = this.msg.getMessage("eXperDB_proxy.msg52", (Object[])statusNm, LocaleContextHolder.getLocale());
      } else {
        errMsg = this.msg.getMessage("eXperDB_proxy.msg51", (Object[])statusNm, LocaleContextHolder.getLocale());
      } 
    } 
    resultObj.put("resultLog", resultLog);
    resultObj.put("result", Boolean.valueOf((proxyExecute && keepaExecute)));
    resultObj.put("errMsg", errMsg);
    return resultObj;
  }
  
  public JSONObject prySvrConnTest(Map<String, Object> param) throws ConnectException, Exception {
    JSONObject resultObj = new JSONObject();
    try {
      ProxyAgentVO proxyAgentVO = this.proxySettingDAO.selectProxyAgentInfo(param);
      String result_code = "";
      Map<String, Object> agentConnectResult = new HashMap<>();
      boolean agentConn = false;
      String IP = proxyAgentVO.getIpadr();
      int PORT = proxyAgentVO.getSocket_port();
      System.out.println("Agent IP : " + IP + "\n PORT : " + PORT);
      ProxyClientInfoCmmn cic = new ProxyClientInfoCmmn();
      agentConnectResult = cic.proxyAgentConnectionTest(IP, PORT);
      if (agentConnectResult != null) {
        result_code = agentConnectResult.get("RESULT_CODE").toString();
        if ("0".equals(result_code))
          agentConn = true; 
      } else {
        agentConn = false;
      } 
      resultObj.put("agentConn", Boolean.valueOf(agentConn));
      resultObj.put("errcd", Integer.valueOf(0));
      resultObj.put("errmsg", this.msg.getMessage("eXperDB_proxy.msg45", null, LocaleContextHolder.getLocale()));
    } catch (ConnectException e) {
      resultObj.put("agentConn", Boolean.valueOf(false));
      resultObj.put("errcd", Integer.valueOf(-2));
      resultObj.put("errmsg", this.msg.getMessage("eXperDB_proxy.msg47", null, LocaleContextHolder.getLocale()));
      e.printStackTrace();
    } catch (Exception e) {
      resultObj.put("agentConn", Boolean.valueOf(false));
      resultObj.put("errcd", Integer.valueOf(-1));
      resultObj.put("errmsg", this.msg.getMessage("eXperDB_proxy.msg48", null, LocaleContextHolder.getLocale()));
      e.printStackTrace();
    } 
    return resultObj;
  }
  
  public Map<String, Object> proxyServerReg(Map<String, Object> param) throws Exception {
    Map<String, Object> resultObj = new HashMap<>();
    try {
      String reg_mode = param.get("reg_mode").toString();
      long pry_svr_id_sn = 1L;
      List<ProxyServerVO> prySvrList = this.proxySettingDAO.selectProxyServerList(param);
      if (prySvrList != null && prySvrList.size() > 0) {
        resultObj.put("resultLog", "fail");
        resultObj.put("result", Boolean.valueOf(false));
        resultObj.put("errMsg", this.msg.getMessage("eXperDB_proxy.msg50", null, LocaleContextHolder.getLocale()));
        return resultObj;
      } 
      ProxyAgentVO pryAgtVO = new ProxyAgentVO();
      ProxyServerVO prySvrVO = new ProxyServerVO();
      pryAgtVO.setSvr_use_yn("Y");
      int prySvrId = Integer.parseInt((param.get("pry_svr_id") != null && !"".equals(param.get("pry_svr_id"))) ? param.get("pry_svr_id").toString() : "0");
      int day_data_del_term = Integer.parseInt((param.get("day_data_del_term") != null && !"".equals(param.get("day_data_del_term"))) ? param.get("day_data_del_term").toString() : "0");
      int min_data_del_term = Integer.parseInt((param.get("min_data_del_term") != null && !"".equals(param.get("min_data_del_term"))) ? param.get("min_data_del_term").toString() : "0");
      int db_svr_id = Integer.parseInt((param.get("db_svr_id") != null && !"".equals(param.get("db_svr_id"))) ? param.get("db_svr_id").toString() : "0");
      String ipadr = param.get("ipadr").toString();
      String lst_mdfr_id = param.get("lst_mdfr_id").toString();
      String master_gbn = param.get("master_gbn").toString();
      String kal_install_yn = param.get("kal_install_yn").toString();
      prySvrVO.setPry_svr_id(prySvrId);
      prySvrVO.setPry_svr_nm(param.get("pry_svr_nm").toString());
      prySvrVO.setDay_data_del_term(day_data_del_term);
      prySvrVO.setMin_data_del_term(min_data_del_term);
      prySvrVO.setUse_yn(param.get("use_yn").toString());
      prySvrVO.setMaster_gbn(param.get("master_gbn").toString());
      if ("S".equals(master_gbn)) {
        int master_svr_id = Integer.parseInt((param.get("master_svr_id") != null && !"".equals(param.get("master_svr_id"))) ? param.get("master_svr_id").toString() : "0");
        prySvrVO.setMaster_svr_id(master_svr_id);
      } 
      prySvrVO.setDb_svr_id(db_svr_id);
      prySvrVO.setLst_mdfr_id(lst_mdfr_id);
      prySvrVO.setFrst_regr_id(lst_mdfr_id);
      prySvrVO.setIpadr(param.get("ipadr").toString());
      prySvrVO.setKal_install_yn(kal_install_yn);
      if ("reg".equals(reg_mode)) {
        Map<String, Object> agentParam = new HashMap<>();
        agentParam.put("ipadr", ipadr);
        ProxyAgentVO proxyAgentVO = this.proxySettingDAO.selectProxyAgentInfo(agentParam);
        pry_svr_id_sn = this.proxySettingDAO.selectQ_T_PRY_SVR_I_01();
        prySvrId = (int)pry_svr_id_sn;
        prySvrVO.setPry_svr_id(prySvrId);
        this.proxySettingDAO.insertProxyServerInfo(prySvrVO);
        ProxyGlobalVO proxyGlobalVO = new ProxyGlobalVO();
        proxyGlobalVO.setPry_svr_id(prySvrVO.getPry_svr_id());
        proxyGlobalVO.setMax_con_cnt(1000);
        proxyGlobalVO.setCl_con_max_tm("30m");
        proxyGlobalVO.setCon_del_tm("4s");
        proxyGlobalVO.setSvr_con_max_tm("30m");
        proxyGlobalVO.setChk_tm("5s");
        proxyGlobalVO.setIf_nm(null);
        if ("Y".equals(proxyAgentVO.getKal_install_yn())) {
          proxyGlobalVO.setObj_ip(ipadr);
        } else {
          proxyGlobalVO.setObj_ip(null);
        } 
        proxyGlobalVO.setPeer_server_ip(null);
        proxyGlobalVO.setLst_mdfr_id(lst_mdfr_id);
        proxyGlobalVO.setFrst_regr_id(lst_mdfr_id);
        this.proxySettingDAO.insertProxyGlobalConf(proxyGlobalVO);
      } else {
        this.proxySettingDAO.updateProxyServerInfo(prySvrVO);
      } 
      String svrUseYn = this.proxySettingDAO.selectProxyAgentSvrUseYnFromProxyId(prySvrId);
      String reRegYn = "";
      if ("D".equals(svrUseYn))
        reRegYn = "Y"; 
      Map<String, Object> paramEnd = new HashMap<>();
      paramEnd.put("svr_use_yn", "Y");
      paramEnd.put("lst_mdfr_id", lst_mdfr_id);
      paramEnd.put("pry_svr_id", Integer.valueOf(prySvrId));
      this.proxySettingDAO.updateProxyAgentInfoFromProxyId(paramEnd);
      resultObj.put("reRegYn", reRegYn);
      resultObj.put("resultLog", "success");
      resultObj.put("result", Boolean.valueOf(true));
      resultObj.put("errMsg", this.msg.getMessage("eXperDB_proxy.msg45", null, LocaleContextHolder.getLocale()));
    } catch (Exception e) {
      resultObj.put("resultLog", "fail");
      resultObj.put("result", Boolean.valueOf(false));
      resultObj.put("errcd", Integer.valueOf(-1));
      resultObj.put("errmsg", this.msg.getMessage("eXperDB_proxy.msg49", null, LocaleContextHolder.getLocale()));
      e.printStackTrace();
    } 
    return resultObj;
  }
  
  public boolean proxyServerReReg(Map<String, Object> param) {
    try {
      ProxyAgentVO proxyAgentVO = this.proxySettingDAO.selectProxyAgentInfo(param);
      Map<String, Object> insertDataResult = new HashMap<>();
      ProxyClientInfoCmmn cic = new ProxyClientInfoCmmn();
      try {
        insertDataResult = cic.insertProxyConfigFileInfo(proxyAgentVO.getIpadr(), proxyAgentVO.getSocket_port());
      } catch (ConnectException e) {
        throw e;
      } 
      if (insertDataResult != null && 
        "true".equals(insertDataResult.get("RESULT_DATA")))
        return true; 
    } catch (Exception e) {
      e.printStackTrace();
    } 
    return false;
  }
  
  public JSONObject deletePrySvr(Map<String, Object> param) throws Exception {
    JSONObject resultObj = new JSONObject();
    try {
      String lst_mdfr_id = param.get("lst_mdfr_id").toString();
      int prySvrId = Integer.parseInt(param.get("pry_svr_id").toString());
      int dbSvrId = Integer.parseInt(param.get("db_svr_id").toString());
      param.put("svr_use_yn", "D");
      param.put("lst_mdfr_id", lst_mdfr_id);
      param.put("pry_svr_id", Integer.valueOf(prySvrId));
      this.proxySettingDAO.updateProxyAgentInfoFromProxyId(param);
      ProxyAgentVO proxyAgentVO = this.proxySettingDAO.selectProxyAgentInfo(param);
      Map<String, Object> agentConnectResult = new HashMap<>();
      ProxyClientInfoCmmn cic = new ProxyClientInfoCmmn();
      try {
        agentConnectResult = cic.deleteProxyConfigFiles(proxyAgentVO.getIpadr(), proxyAgentVO.getSocket_port());
      } catch (ConnectException e) {
        e.printStackTrace();
      } catch (Exception e) {
        e.printStackTrace();
      } 
      this.proxySettingDAO.deletePryVipConfList(prySvrId);
      this.proxySettingDAO.deleteProxyTblList(prySvrId);
      this.proxySettingDAO.upgradePrySvrOldMaster(dbSvrId);
      resultObj.put("resultLog", "success");
      resultObj.put("result", Boolean.valueOf(true));
      resultObj.put("errMsg", this.msg.getMessage("eXperDB_proxy.msg45", null, LocaleContextHolder.getLocale()));
    } catch (Exception e) {
      resultObj.put("resultLog", "fail");
      resultObj.put("result", Boolean.valueOf(false));
      resultObj.put("errcd", Integer.valueOf(-1));
      resultObj.put("errmsg", this.msg.getMessage("eXperDB_proxy.msg49", null, LocaleContextHolder.getLocale()));
      e.printStackTrace();
    } 
    return resultObj;
  }
  
  public List<ProxyListenerServerVO> selectListenServerList(Map<String, Object> param) {
    return this.proxySettingDAO.selectListenServerList(param);
  }
  
  public List<Map<String, Object>> selectIpList(Map<String, Object> param) {
    return this.proxySettingDAO.selectIpList(param);
  }
  
  public JSONObject applyProxyConf(Map<String, Object> param, JSONObject confData) throws ConnectException, Exception {
    JSONObject resultObj = new JSONObject();
    int prySvrId = CommonUtil.getIntOfJsonObj(confData, "pry_svr_id");
    String lst_mdfr_id = param.get("lst_mdfr_id").toString();
    ProxyGlobalVO global = new ProxyGlobalVO();
    global.setChk_tm(CommonUtil.getStringOfJsonObj(confData, "chk_tm"));
    global.setIf_nm(CommonUtil.getStringOfJsonObj(confData, "if_nm"));
    global.setObj_ip(CommonUtil.getStringOfJsonObj(confData, "obj_ip"));
    global.setPeer_server_ip(CommonUtil.getStringOfJsonObj(confData, "peer_server_ip"));
    global.setPry_svr_id(prySvrId);
    global.setPry_glb_id(CommonUtil.getIntOfJsonObj(confData, "pry_glb_id"));
    global.setLst_mdfr_id(lst_mdfr_id);
//    this.proxySettingDAO.updateProxyGlobalConf(global);
//    this.proxySettingDAO.updatePryAgentIp(global);
    JSONArray delVipcngJArray = (JSONArray)confData.get("delVipcng");
    int delVipcngSize = delVipcngJArray.size();
    if (delVipcngSize > 0) {
      ProxyVipConfigVO[] delVipConf = new ProxyVipConfigVO[delVipcngSize];
      for (int j = 0; j < delVipcngSize; j++) {
        JSONObject delVipcngJobj = (JSONObject)delVipcngJArray.get(j);
        delVipConf[j] = new ProxyVipConfigVO();
        delVipConf[j].setPry_svr_id(prySvrId);
        delVipConf[j].setVip_cng_id(CommonUtil.getIntOfJsonObj(delVipcngJobj, "vip_cng_id"));
//        this.proxySettingDAO.deletePryVipConf(delVipConf[j]);
      } 
    } 
    JSONArray vipcngJArray = (JSONArray)confData.get("vipcng");
    int vipcngSize = vipcngJArray.size();
    if (vipcngSize > 0) {
      ProxyVipConfigVO[] vipConf = new ProxyVipConfigVO[vipcngSize];
      for (int j = 0; j < vipcngSize; j++) {
        JSONObject vipcngJobj = (JSONObject)vipcngJArray.get(j);
        vipConf[j] = new ProxyVipConfigVO();
        vipConf[j].setPry_svr_id(prySvrId);
        if (!CommonUtil.nullCheckOfJsonObj(vipcngJobj, "vip_cng_id"))
          vipConf[j].setVip_cng_id(CommonUtil.getIntOfJsonObj(vipcngJobj, "vip_cng_id")); 
        vipConf[j].setV_ip(CommonUtil.getStringOfJsonObj(vipcngJobj, "v_ip"));
        vipConf[j].setV_rot_id(CommonUtil.getStringOfJsonObj(vipcngJobj, "v_rot_id"));
        vipConf[j].setV_if_nm(CommonUtil.getStringOfJsonObj(vipcngJobj, "v_if_nm"));
        vipConf[j].setPriority(110 - CommonUtil.getIntOfJsonObj(vipcngJobj, "priority"));
        System.out.println(vipConf[j].getPriority());
        vipConf[j].setState_nm(CommonUtil.getStringOfJsonObj(vipcngJobj, "state_nm"));
        vipConf[j].setLst_mdfr_id(lst_mdfr_id);
//        this.proxySettingDAO.insertUpdatePryVipConf(vipConf[j]);
      } 
    } 
    JSONArray delListnJArray = (JSONArray)confData.get("delListener");
    int delListnSize = delListnJArray.size();
    if (delListnSize > 0) {
      ProxyListenerVO[] delListn = new ProxyListenerVO[delListnSize];
      for (int j = 0; j < delListnSize; j++) {
        JSONObject delListnObj = (JSONObject)delListnJArray.get(j);
        delListn[j] = new ProxyListenerVO();
        delListn[j].setPry_svr_id(prySvrId);
        delListn[j].setLsn_id(CommonUtil.getIntOfJsonObj(delListnObj, "lsn_id"));
        ProxyListenerServerVO delListnSvr = new ProxyListenerServerVO();
        delListnSvr.setPry_svr_id(prySvrId);
        delListnSvr.setLsn_id(CommonUtil.getIntOfJsonObj(delListnObj, "lsn_id"));
        this.proxySettingDAO.deletePryListenerSvr(delListnSvr);
        this.proxySettingDAO.deletePryListener(delListn[j]);
        Map<String, Object> delStatusParam = new HashMap<>();
        delStatusParam.put("pry_svr_id", Integer.valueOf(prySvrId));
        delStatusParam.put("lsn_id", Integer.valueOf(CommonUtil.getIntOfJsonObj(delListnObj, "lsn_id")));
//        this.proxySettingDAO.deletePrySvrStatusList(delStatusParam);
      } 
    } 
    JSONArray listenerJArray = (JSONArray)confData.get("listener");
    int listenerSize = listenerJArray.size();
    if (listenerSize > 0) {
      ProxyListenerVO[] listener = new ProxyListenerVO[listenerSize];
      for (int j = 0; j < listenerSize; j++) {
        JSONObject listenerObj = (JSONObject)listenerJArray.get(j);
        listener[j] = new ProxyListenerVO();
        listener[j].setPry_svr_id(prySvrId);
        if (!CommonUtil.nullCheckOfJsonObj(listenerObj, "lsn_id"))
          listener[j].setLsn_id(CommonUtil.getIntOfJsonObj(listenerObj, "lsn_id")); 
        listener[j].setLsn_nm(CommonUtil.getStringOfJsonObj(listenerObj, "lsn_nm"));
        listener[j].setCon_bind_port(CommonUtil.getStringOfJsonObj(listenerObj, "con_bind_port"));
        listener[j].setDb_usr_id(CommonUtil.getStringOfJsonObj(listenerObj, "db_usr_id"));
        listener[j].setDb_nm(CommonUtil.getStringOfJsonObj(listenerObj, "db_nm"));
        listener[j].setCon_sim_query(CommonUtil.getStringOfJsonObj(listenerObj, "con_sim_query"));
        listener[j].setLst_mdfr_id(lst_mdfr_id);
        listener[j].setBal_yn(CommonUtil.getStringOfJsonObj(listenerObj, "bal_yn"));
        listener[j].setBal_opt(CommonUtil.getStringOfJsonObj(listenerObj, "bal_opt"));
        System.out.println(listener[j]);
        if (listenerObj.get("lsn_svr_del_list") != null) {
          JSONArray delListnSvrArry = (JSONArray)listenerObj.get("lsn_svr_del_list");
          int delListnSvrSize = delListnSvrArry.size();
          if (delListnSvrSize > 0) {
            ProxyListenerServerVO[] delListnSvr = new ProxyListenerServerVO[delListnSvrSize];
            for (int k = 0; k < delListnSvrSize; k++) {
              JSONObject delListnSvrObj = (JSONObject)delListnSvrArry.get(k);
              delListnSvr[k] = new ProxyListenerServerVO();
              delListnSvr[k].setPry_svr_id(prySvrId);
              delListnSvr[k].setLsn_id(CommonUtil.getIntOfJsonObj(delListnSvrObj, "lsn_id"));
              delListnSvr[k].setLsn_svr_id(CommonUtil.getIntOfJsonObj(delListnSvrObj, "lsn_svr_id"));
              delListnSvr[k].setDb_con_addr(CommonUtil.getStringOfJsonObj(delListnSvrObj, "db_con_addr"));
              this.proxySettingDAO.deletePryListenerSvr(delListnSvr[k]);
              Map<String, Object> delStatusParam = new HashMap<>();
              delStatusParam.put("pry_svr_id", Integer.valueOf(prySvrId));
              delStatusParam.put("lsn_id", Integer.valueOf(CommonUtil.getIntOfJsonObj(delListnSvrObj, "lsn_id")));
              delStatusParam.put("lsn_svr_id", Integer.valueOf(CommonUtil.getIntOfJsonObj(delListnSvrObj, "lsn_svr_id")));
//              this.proxySettingDAO.deletePrySvrStatusList(delStatusParam);
            } 
          } 
        } 
        if (listenerObj.get("lsn_svr_edit_list") != null) {
          JSONArray listnSvrArry = (JSONArray)listenerObj.get("lsn_svr_edit_list");
          int listnSvrSize = listnSvrArry.size();
          if (listnSvrSize > 0) {
            ProxyListenerServerVO[] listnSvr = new ProxyListenerServerVO[listnSvrSize];
            for (int k = 0; k < listnSvrSize; k++) {
              JSONObject listnSvrObj = (JSONObject)listnSvrArry.get(k);
              listnSvr[k] = new ProxyListenerServerVO();
              listnSvr[k].setPry_svr_id(prySvrId);
              if (!CommonUtil.nullCheckOfJsonObj(listnSvrObj, "lsn_id")) {
                listnSvr[k].setLsn_id(CommonUtil.getIntOfJsonObj(listnSvrObj, "lsn_id"));
              } else {
                int newLsnId = this.proxySettingDAO.selectPryListenerMaxId();
                listnSvr[k].setLsn_id(newLsnId);
              } 
              if (!CommonUtil.nullCheckOfJsonObj(listnSvrObj, "lsn_svr_id"))
                listnSvr[k].setLsn_svr_id(CommonUtil.getIntOfJsonObj(listnSvrObj, "lsn_svr_id")); 
              listnSvr[k].setDb_con_addr(CommonUtil.getStringOfJsonObj(listnSvrObj, "db_con_addr"));
              listnSvr[k].setChk_portno(CommonUtil.getIntOfJsonObj(listnSvrObj, "chk_portno"));
              listnSvr[k].setBackup_yn(CommonUtil.getStringOfJsonObj(listnSvrObj, "backup_yn"));
              listnSvr[k].setLst_mdfr_id(lst_mdfr_id);
//              this.proxySettingDAO.insertUpdatePryListenerSvr(listnSvr[k]);
            } 
          } 
        } 
      } 
    } 
    Map<String, Object> agentParam = new HashMap<>();
    agentParam.put("pry_svr_id", Integer.valueOf(prySvrId));
    JSONObject globalJObj = this.proxySettingDAO.selectProxyGlobal(agentParam).toJSONObject();
    JSONObject agentJobj = new JSONObject();
    agentJobj.put("global_info", globalJObj);
    List<ProxyListenerVO> listenerList = this.proxySettingDAO.selectProxyListenerList(agentParam);
    JSONArray listenerJArr = new JSONArray();
    for (ProxyListenerVO listenVO : listenerList) {
      JSONObject tempObj = listenVO.toJSONObject();
      agentParam.put("lsn_id", Integer.valueOf(listenVO.getLsn_id()));
      List<ProxyListenerServerVO> listenerSvrList = this.proxySettingDAO.selectListenServerList(agentParam);
      JSONArray listenerSvrJArr = new JSONArray();
      for (ProxyListenerServerVO listenSvrVO : listenerSvrList)
        listenerSvrJArr.add(listenSvrVO.toJSONObject()); 
      tempObj.put("server_list", listenerSvrJArr);
      listenerJArr.add(tempObj);
      agentParam.remove("lsn_id");
    } 
    agentJobj.put("listener_list", listenerJArr);
    List<ProxyVipConfigVO> vipConfigList = this.proxySettingDAO.selectProxyVipConfList(agentParam);
    JSONArray vipConfgJArr = new JSONArray();
    for (ProxyVipConfigVO vipVO : vipConfigList)
      vipConfgJArr.add(vipVO.toJSONObject()); 
    agentJobj.put("vipconfig_list", vipConfgJArr);
    agentJobj.put("lst_mdfr_id", lst_mdfr_id);
    List<CmmnCodeVO> cmmnCodeVO = null;
    PageVO pageVO = new PageVO();
    pageVO.setGrp_cd("TC0042");
    pageVO.setSearchCondition("0");
    cmmnCodeVO = this.cmmnCodeDtlService.cmmnDtlCodeSearch(pageVO);
    for (int i = 0; i < cmmnCodeVO.size(); i++) {
      CmmnCodeVO tempCode = cmmnCodeVO.get(i);
      agentJobj.put(tempCode.getSys_cd(), tempCode.getSys_cd_nm());
    } 
    ProxyServerVO proxyServerVO = this.proxySettingDAO.selectProxyServerInfo(prySvrId);
    String kalUseYn = (proxyServerVO.getKal_install_yn() == null) ? "" : proxyServerVO.getKal_install_yn();
    String awsYn = (proxyServerVO.getAws_yn() == null) ? "N" : proxyServerVO.getAws_yn();
    agentJobj.put("KAL_INSTALL_YN", kalUseYn);
    agentJobj.put("AWS_YN", awsYn);
    boolean createNewConfig = false;
    String resultLog = "";
    String errMsg = "";
    ProxyAgentVO proxyAgentVO = this.proxySettingDAO.selectProxyAgentInfo(agentParam);
    Map<String, Object> agentConnectResult = new HashMap<>();
    ProxyClientInfoCmmn cic = new ProxyClientInfoCmmn();
    try {
      agentConnectResult = cic.createProxyConfigFile(proxyAgentVO.getIpadr(), proxyAgentVO.getSocket_port(), agentJobj);
    } catch (ConnectException e) {
      throw e;
    } 
    if (agentConnectResult != null) {
      if ("0".equals(agentConnectResult.get("RESULT_CODE"))) {
        createNewConfig = true;
        resultLog = "success";
        errMsg = this.msg.getMessage("eXperDB_proxy.msg45", null, LocaleContextHolder.getLocale());
      } else {
        createNewConfig = false;
        resultLog = "faild";
        errMsg = this.msg.getMessage("eXperDB_proxy.msg48", null, LocaleContextHolder.getLocale());
      } 
      System.out.println("N");
    } else {
      createNewConfig = false;
      resultLog = "faild";
      errMsg = this.msg.getMessage("eXperDB_proxy.msg48", null, LocaleContextHolder.getLocale());
    } 
    resultObj.put("resultLog", resultLog);
    resultObj.put("result", Boolean.valueOf(createNewConfig));
    resultObj.put("errMsg", errMsg);
    resultObj.put("lst_mdfr_id", lst_mdfr_id);
    return resultObj;
  }
  
  public List<Map<String, Object>> selectPoxyAgentSvrList(Map<String, Object> param) {
    return this.proxySettingDAO.selectPoxyAgentSvrList(param);
  }
  
  public ProxyAgentVO getProxyAgent(int pry_svr_id) throws Exception {
    Map<String, Object> agentParam = new HashMap<>();
    agentParam.put("pry_svr_id", Integer.valueOf(pry_svr_id));
    return this.proxySettingDAO.selectProxyAgentInfo(agentParam);
  }
  
  public List<Map<String, Object>> selectMasterProxyList(Map<String, Object> param) {
    return this.proxySettingDAO.selectMasterProxyList(param);
  }
  
  public void updateDeleteVipUseYn(Map<String, Object> param) throws ConnectException, Exception {
    int prySvrId = Integer.parseInt(param.get("pry_svr_id").toString());
    String lstMdfrId = param.get("lst_mdfr_id").toString();
    String kalInstallYn = param.get("kal_install_yn").toString();
    ProxyServerVO prySvrVO = new ProxyServerVO();
    prySvrVO.setPry_svr_id(prySvrId);
    prySvrVO.setLst_mdfr_id(lstMdfrId);
    prySvrVO.setKal_install_yn(kalInstallYn);
    this.proxySettingDAO.updateProxyAgentInfo(prySvrVO);
    this.proxySettingDAO.updatePrySvrKalInstYn(prySvrVO);
    ProxyGlobalVO globalVO = this.proxySettingDAO.selectProxyGlobal(param);
    if (kalInstallYn.equals("N")) {
      globalVO.setPeer_server_ip("");
      globalVO.setObj_ip("");
      globalVO.setIf_nm("");
      this.proxySettingDAO.updateProxyGlobalConf(globalVO);
      this.proxySettingDAO.deletePryVipConfList(prySvrId);
      ProxyAgentVO proxyAgentVO = this.proxySettingDAO.selectProxyAgentInfo(param);
      Map<String, Object> keepaExecuteResult = new HashMap<>();
      ProxyClientInfoCmmn cic = new ProxyClientInfoCmmn();
      JSONObject agentJobj = new JSONObject();
      agentJobj.put("act_type", "S");
      agentJobj.put("pry_svr_id", Integer.valueOf(prySvrId));
      agentJobj.put("lst_mdfr_id", lstMdfrId);
      try {
        agentJobj.put("sys_type", "KEEPALIVED");
        keepaExecuteResult = cic.proxyServiceExcute(proxyAgentVO.getIpadr(), proxyAgentVO.getSocket_port(), agentJobj);
      } catch (ConnectException e) {
        throw e;
      } 
    } else {
      globalVO.setIf_nm("");
      globalVO.setPeer_server_ip("");
      globalVO.setObj_ip(globalVO.getIpadr());
      this.proxySettingDAO.updateProxyGlobalConf(globalVO);
    } 
  }
  
  public List<Map<String, Object>> selectDbmsTotList(Map<String, Object> param) throws Exception {
    List<Map<String, Object>> dbmsSelList = this.proxySettingDAO.selectDbmsList(param);
    return dbmsSelList;
  }
  
  public List<Map<String, Object>> selectProxyMstTotList(Map<String, Object> param) throws Exception {
    List<Map<String, Object>> mstSvrSelList = this.proxySettingDAO.selectMasterSvrProxyList(param);
    return mstSvrSelList;
  }
  
  public boolean checkAgentKalInstYn(Map<String, Object> param) throws ConnectException, Exception {
    boolean result = true;
    int prySvrId = Integer.parseInt(param.get("pry_svr_id").toString());
    String lstMdfrId = param.get("lst_mdfr_id").toString();
    String kalInstYn = param.get("kal_install_yn").toString();
    ProxyAgentVO proxyAgentVO = this.proxySettingDAO.selectProxyAgentInfo(param);
    Map<String, Object> checkKeepaResult = new HashMap<>();
    ProxyClientInfoCmmn cic = new ProxyClientInfoCmmn();
    JSONObject agentJobj = new JSONObject();
    agentJobj.put("pry_svr_id", Integer.valueOf(prySvrId));
    agentJobj.put("lst_mdfr_id", lstMdfrId);
    agentJobj.put("kal_install_yn", kalInstYn);
    try {
      checkKeepaResult = cic.checkKeepavliedInstallYn(proxyAgentVO.getIpadr(), proxyAgentVO.getSocket_port(), agentJobj);
    } catch (ConnectException e) {
      throw e;
    } 
    if (checkKeepaResult != null) {
      if ("Y".equals(checkKeepaResult.get("KAL_INSTALL_YN").toString())) {
        result = true;
      } else {
        result = false;
      } 
    } else {
      result = false;
    } 
    return result;
  }
}
