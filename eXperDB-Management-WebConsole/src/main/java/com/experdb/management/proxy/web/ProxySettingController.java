package com.experdb.management.proxy.web;

import java.net.ConnectException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.experdb.management.proxy.service.ProxyListenerServerVO;
import com.experdb.management.proxy.service.ProxyServerVO;
import com.experdb.management.proxy.service.ProxySettingService;
import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityService;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.CmmnCodeDtlService;
import com.k4m.dx.tcontrol.common.service.CmmnCodeVO;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.common.service.PageVO;
import com.k4m.dx.tcontrol.login.service.LoginVO;

@Controller
public class ProxySettingController {
  @Autowired
  private MenuAuthorityService menuAuthorityService;
  
  @Autowired
  private ProxySettingService proxySettingService;
  
  @Autowired
  private AccessHistoryService accessHistoryService;
  
  @Autowired
  private CmmnCodeDtlService cmmnCodeDtlService;
  
  @Autowired
  private MessageSource msg;
  
  private List<Map<String, Object>> menuAut;
  
  private String sohw_menu_id = "45";
  
  @Autowired
  private PlatformTransactionManager txManager;
  
  @RequestMapping({"/proxySetting.do"})
  public ModelAndView proxySettingForm(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
    CmmnUtils cu = new CmmnUtils();
    this.menuAut = cu.selectMenuAut(this.menuAuthorityService, "MN0001802");
    ModelAndView mv = new ModelAndView();
    try {
      if (((Map)this.menuAut.get(0)).get("read_aut_yn").equals("N")) {
        mv.setViewName("error/autError");
      } else {
        this.proxySettingService.accessSaveHistory(request, historyVO, "DX-T0159", this.sohw_menu_id);
        HttpSession session = request.getSession();
        LoginVO loginVo = (LoginVO)session.getAttribute("session");
        mv.addObject("usr_id", loginVo.getUsr_id());
        List<CmmnCodeVO> cmmnCodeVO = null;
        PageVO pageVO = new PageVO();
        pageVO.setGrp_cd("TC0041");
        pageVO.setSearchCondition("0");
        cmmnCodeVO = this.cmmnCodeDtlService.cmmnDtlCodeSearch(pageVO);
        mv.addObject("simpleQueryList", cmmnCodeVO);
        PageVO pageVO_2 = new PageVO();
        pageVO_2.setGrp_cd("TC0042");
        pageVO_2.setSearchCondition("0");
        cmmnCodeVO = this.cmmnCodeDtlService.cmmnDtlCodeSearch(pageVO_2);
        mv.addObject("listenerNmList", cmmnCodeVO);
        PageVO pageVO_3 = new PageVO();
        pageVO_3.setGrp_cd("TC0043");
        pageVO_3.setSearchCondition("0");
        cmmnCodeVO = this.cmmnCodeDtlService.cmmnDtlCodeSearch(pageVO_3);
        mv.addObject("BalOptList", cmmnCodeVO);
        mv.addObject("read_aut_yn", ((Map)this.menuAut.get(0)).get("read_aut_yn"));
        mv.addObject("wrt_aut_yn", ((Map)this.menuAut.get(0)).get("wrt_aut_yn"));
        mv.setViewName("proxy/setting/proxySetting");
      } 
    } catch (Exception e) {
      e.printStackTrace();
    } 
    return mv;
  }
  
  @RequestMapping({"/popup/proxySvrRegForm.do"})
  public ModelAndView proxyServerRegForm(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
    ModelAndView mv = new ModelAndView("jsonView");
    try {
      CmmnUtils cu = new CmmnUtils();
      this.menuAut = cu.selectMenuAut(this.menuAuthorityService, "MN0001802");
      if (((Map)this.menuAut.get(0)).get("wrt_aut_yn").equals("N")) {
        mv.setViewName("error/autError");
      } else {
        this.proxySettingService.accessSaveHistory(request, historyVO, "DX-T0159_01", this.sohw_menu_id);
      } 
    } catch (Exception e) {
      e.printStackTrace();
    } 
    return mv;
  }
  
  @RequestMapping({"/popup/vipInstanceRegForm.do"})
  public ModelAndView vipInstanceRegForm(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
    ModelAndView mv = new ModelAndView("jsonView");
    try {
      CmmnUtils cu = new CmmnUtils();
      this.menuAut = cu.selectMenuAut(this.menuAuthorityService, "MN0001802");
      if (((Map)this.menuAut.get(0)).get("wrt_aut_yn").equals("N")) {
        mv.setViewName("error/autError");
      } else {
        this.proxySettingService.accessSaveHistory(request, historyVO, "DX-T0159_02", this.sohw_menu_id);
      } 
    } catch (Exception e) {
      e.printStackTrace();
    } 
    return mv;
  }
  
  @RequestMapping({"/popup/proxyListenRegForm.do"})
  public ModelAndView proxyListenRegForm(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
    ModelAndView mv = new ModelAndView("jsonView");
    try {
      CmmnUtils cu = new CmmnUtils();
      this.menuAut = cu.selectMenuAut(this.menuAuthorityService, "MN0001802");
      if (((Map)this.menuAut.get(0)).get("wrt_aut_yn").equals("N")) {
        mv.setViewName("error/autError");
      } else {
        this.proxySettingService.accessSaveHistory(request, historyVO, "DX-T0159_03", this.sohw_menu_id);
      } 
    } catch (Exception e) {
      e.printStackTrace();
    } 
    return mv;
  }
  
  @RequestMapping({"/selectPoxyServerTable.do"})
  @ResponseBody
  public List<ProxyServerVO> selectPoxyServerTable(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
    CmmnUtils cu = new CmmnUtils();
    this.menuAut = cu.selectMenuAut(this.menuAuthorityService, "MN0001802");
    List<ProxyServerVO> resultSet = null;
    Map<String, Object> param = new HashMap<>();
    try {
      if (((Map)this.menuAut.get(0)).get("read_aut_yn").equals("N")) {
        response.sendRedirect("/autError.do");
        return resultSet;
      } 
      this.proxySettingService.accessSaveHistory(request, historyVO, "DX-T0159_07", this.sohw_menu_id);
      param.put("search", cu.getStringWithoutNull(request.getParameter("search")));
      param.put("svr_use_yn", cu.getStringWithoutNull(request.getParameter("svr_use_yn")));
      param.put("pry_svr_id", cu.getStringWithoutNull(request.getParameter("pry_svr_id")));
      resultSet = this.proxySettingService.selectProxyServerList(param);
    } catch (Exception e) {
      e.printStackTrace();
    } 
    return resultSet;
  }
  
  @RequestMapping({"/selectPoxyAgentSvrList.do"})
  @ResponseBody
  public ModelAndView selectPoxyAgentList(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
    ModelAndView mv = new ModelAndView("jsonView");
    List<Map<String, Object>> dbmsResultSet = null;
    List<Map<String, Object>> agentResultSet = null;
    List<Map<String, Object>> mstResultSet = null;
    Map<String, Object> param = new HashMap<>();
    try {
      this.proxySettingService.accessSaveHistory(request, historyVO, "DX-T0159_07", this.sohw_menu_id);
      param.put("svr_use_yn", 
          (request.getParameter("svr_use_yn") == null) ? "" : request.getParameter("svr_use_yn").toString());
      param.put("mode", (request.getParameter("mode") == null) ? "" : request.getParameter("mode").toString());
      agentResultSet = this.proxySettingService.selectPoxyAgentSvrList(param);
      dbmsResultSet = this.proxySettingService.selectDbmsTotList(param);
      if (dbmsResultSet.size() > 0) {
        param.put("db_svr_id", ((Map)dbmsResultSet.get(0)).get("db_svr_id"));
      } else {
        param.put("db_svr_id", null);
      } 
      mstResultSet = this.proxySettingService.selectProxyMstTotList(param);
      mv.addObject("agentSvrList", agentResultSet);
      mv.addObject("dbmsSvrList", dbmsResultSet);
      mv.addObject("mstSvrList", mstResultSet);
    } catch (Exception e) {
      e.printStackTrace();
    } 
    return mv;
  }
  
  @RequestMapping({"/getPoxyServerConf.do"})
  @ResponseBody
  public JSONObject getPoxyServerConf(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
    CmmnUtils cu = new CmmnUtils();
    this.menuAut = cu.selectMenuAut(this.menuAuthorityService, "MN0001802");
    Map<String, Object> param = new HashMap<>();
    JSONObject resultObj = new JSONObject();
    try {
      CmmnUtils.saveHistory(request, historyVO);
      if (((Map)this.menuAut.get(0)).get("read_aut_yn").equals("N")) {
        response.sendRedirect("/autError.do");
        return resultObj;
      } 
      this.proxySettingService.accessSaveHistory(request, historyVO, "DX-T0159_08", this.sohw_menu_id);
      int prySvrId = Integer.parseInt(request.getParameter("pry_svr_id"));
      param.put("pry_svr_id", Integer.valueOf(prySvrId));
      resultObj = this.proxySettingService.getPoxyServerConf(param);
      try {
        List<String> interfList = this.proxySettingService.getAgentInterface(param);
        resultObj.put("interf", interfList.get(0));
        interfList.remove(0);
        resultObj.put("interface_items", interfList);
      } catch (ConnectException e) {
        resultObj.put("errcd", Integer.valueOf(1));
        resultObj.put("errMsg", 
            this.msg.getMessage("eXperDB_proxy.msg47", null, LocaleContextHolder.getLocale()));
        resultObj.put("interface_items", null);
      } catch (Exception e) {
        resultObj.put("errcd", Integer.valueOf(2));
        resultObj.put("errMsg", 
            this.msg.getMessage("eXperDB_proxy.msg48", null, LocaleContextHolder.getLocale()));
        resultObj.put("interface_items", null);
      } 
    } catch (Exception e) {
      e.printStackTrace();
      resultObj.put("errcd", Integer.valueOf(-1));
      resultObj.put("errMsg", this.msg.getMessage("eXperDB_proxy.msg49", null, LocaleContextHolder.getLocale()));
    } 
    return resultObj;
  }
  
  @RequestMapping({"/getVipInstancePeerList.do"})
  @ResponseBody
  public JSONObject getVipInstancePeerList(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
    CmmnUtils cu = new CmmnUtils();
    this.menuAut = cu.selectMenuAut(this.menuAuthorityService, "MN0001802");
    Map<String, Object> param = new HashMap<>();
    JSONObject resultObj = new JSONObject();
    try {
      CmmnUtils.saveHistory(request, historyVO);
      if (((Map)this.menuAut.get(0)).get("read_aut_yn").equals("N")) {
        response.sendRedirect("/autError.do");
        return resultObj;
      } 
      String peerSvrIp = cu.getStringWithoutNull(request.getParameter("peer_server_ip"));
      param.put("peer_server_ip", peerSvrIp);
      resultObj = this.proxySettingService.getVipInstancePeerList(param);
    } catch (Exception e) {
      e.printStackTrace();
      resultObj.put("errcd", Integer.valueOf(-1));
      resultObj.put("errMsg", this.msg.getMessage("eXperDB_proxy.msg49", null, LocaleContextHolder.getLocale()));
    } 
    return resultObj;
  }
  
  @RequestMapping({"/createSelPrySvrReg.do"})
  @ResponseBody
  public JSONObject createSelPrySvrReg(HttpServletRequest request, HttpServletResponse response) {
    CmmnUtils cu = new CmmnUtils();
    this.menuAut = cu.selectMenuAut(this.menuAuthorityService, "MN0001802");
    Map<String, Object> param = new HashMap<>();
    JSONObject resultObj = new JSONObject();
    try {
      if (((Map)this.menuAut.get(0)).get("read_aut_yn").equals("N")) {
        response.sendRedirect("/autError.do");
        return resultObj;
      } 
      int prySvrId = Integer.parseInt(!"".equals(cu.getStringWithoutNull(request.getParameter("pry_svr_id"))) ? 
          request.getParameter("pry_svr_id").toString() : 
          "0");
      int dbSvrId = Integer.parseInt(!"".equals(cu.getStringWithoutNull(request.getParameter("db_svr_id"))) ? 
          request.getParameter("db_svr_id").toString() : 
          "0");
      param.put("db_svr_id", Integer.valueOf(dbSvrId));
      param.put("pry_svr_id", Integer.valueOf(prySvrId));
      resultObj = this.proxySettingService.createSelPrySvrReg(param);
    } catch (Exception e) {
      e.printStackTrace();
    } 
    return resultObj;
  }
  
  @RequestMapping({"/proxySetMstSvrChange.do"})
  @ResponseBody
  public JSONObject proxySetMstSvrChange(HttpServletRequest request, HttpServletResponse response) {
    CmmnUtils cu = new CmmnUtils();
    this.menuAut = cu.selectMenuAut(this.menuAuthorityService, "MN0001802");
    Map<String, Object> param = new HashMap<>();
    JSONObject resultObj = new JSONObject();
    try {
      if (((Map)this.menuAut.get(0)).get("read_aut_yn").equals("N")) {
        response.sendRedirect("/autError.do");
        return resultObj;
      } 
      int prySvrId = Integer.parseInt(!"".equals(cu.getStringWithoutNull(request.getParameter("pry_svr_id"))) ? 
          request.getParameter("pry_svr_id").toString() : 
          "0");
      int dbSvrId = Integer.parseInt(!"".equals(cu.getStringWithoutNull(request.getParameter("db_svr_id"))) ? 
          request.getParameter("db_svr_id").toString() : 
          "0");
      param.put("pry_svr_id", Integer.valueOf(prySvrId));
      param.put("db_svr_id", Integer.valueOf(dbSvrId));
      resultObj = this.proxySettingService.selectMasterSvrProxyList(param);
    } catch (Exception e) {
      e.printStackTrace();
    } 
    return resultObj;
  }
  
  @RequestMapping({"/proxySetServerNmChange.do"})
  @ResponseBody
  public String proxySetServerNmChange(HttpServletRequest request, HttpServletResponse response) {
    CmmnUtils cu = new CmmnUtils();
    this.menuAut = cu.selectMenuAut(this.menuAuthorityService, "MN0001802");
    Map<String, Object> param = new HashMap<>();
    String resultStr = "";
    try {
      if (((Map)this.menuAut.get(0)).get("read_aut_yn").equals("N")) {
        response.sendRedirect("/autError.do");
        return resultStr;
      } 
      int dbSvrId = Integer.parseInt(!"".equals(cu.getStringWithoutNull(request.getParameter("db_svr_id"))) ? 
          request.getParameter("db_svr_id").toString() : 
          "0");
      param.put("db_svr_id", Integer.valueOf(dbSvrId));
      resultStr = this.proxySettingService.proxySetServerNmList(param);
    } catch (Exception e) {
      e.printStackTrace();
    } 
    return resultStr;
  }
  
  @RequestMapping({"/runProxyService.do"})
  @ResponseBody
  public JSONObject runProxyService(HttpServletRequest request, HttpServletResponse response) {
    CmmnUtils cu = new CmmnUtils();
    this.menuAut = cu.selectMenuAut(this.menuAuthorityService, "MN0001802");
    Map<String, Object> param = new HashMap<>();
    JSONObject resultObj = new JSONObject();
    try {
      if (((Map)this.menuAut.get(0)).get("read_aut_yn").equals("N")) {
        response.sendRedirect("/autError.do");
        return resultObj;
      } 
      HttpSession session = request.getSession();
      LoginVO loginVo = (LoginVO)session.getAttribute("session");
      int prySvrId = Integer.parseInt(!"".equals(cu.getStringWithoutNull(request.getParameter("pry_svr_id"))) ? 
          request.getParameter("pry_svr_id").toString() : 
          "0");
      String status_cd = (request.getParameter("status") == null) ? "" : 
        request.getParameter("status").toString();
      if ("TC001502".equals(status_cd)) {
        param.put("act_type", "S");
      } else if ("TC001501".equals(status_cd)) {
        param.put("act_type", "A");
      } 
      param.put("pry_svr_id", Integer.valueOf(prySvrId));
      param.put("status", status_cd);
      param.put("lst_mdfr_id", (loginVo.getUsr_id() == null) ? "" : loginVo.getUsr_id().toString());
      param.put("act_exe_type", "TC004001");
      resultObj = this.proxySettingService.runProxyService(param);
    } catch (ConnectException e) {
      e.printStackTrace();
      resultObj.put("errcd", Integer.valueOf(-1));
      resultObj.put("errMsg", this.msg.getMessage("eXperDB_proxy.msg47", null, LocaleContextHolder.getLocale()));
    } catch (Exception e) {
      e.printStackTrace();
      resultObj.put("errcd", Integer.valueOf(-1));
      resultObj.put("errmsg", this.msg.getMessage("eXperDB_proxy.msg49", null, LocaleContextHolder.getLocale()));
    } 
    return resultObj;
  }
  
  @RequestMapping({"/prySvrConnTest.do"})
  @ResponseBody
  public JSONObject prySvrConnTest(HttpServletRequest request, HttpServletResponse response) {
    CmmnUtils cu = new CmmnUtils();
    this.menuAut = cu.selectMenuAut(this.menuAuthorityService, "MN0001802");
    Map<String, Object> param = new HashMap<>();
    JSONObject resultObj = new JSONObject();
    try {
      if (((Map)this.menuAut.get(0)).get("read_aut_yn").equals("N")) {
        response.sendRedirect("/autError.do");
        return resultObj;
      } 
      int prySvrId = Integer.parseInt(!"".equals(cu.getStringWithoutNull(request.getParameter("pry_svr_id"))) ? 
          request.getParameter("pry_svr_id").toString() : 
          "0");
      param.put("pry_svr_id", Integer.valueOf(prySvrId));
      param.put("ipadr", request.getParameter("ipadr"));
      System.out.println("prySvrConnTest start");
      resultObj = this.proxySettingService.prySvrConnTest(param);
    } catch (Exception e) {
      e.printStackTrace();
    } 
    return resultObj;
  }
  
  @RequestMapping({"/prySvrReg.do"})
  @ResponseBody
  public Map<String, Object> proxyServerReg(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
    CmmnUtils cu = new CmmnUtils();
    this.menuAut = cu.selectMenuAut(this.menuAuthorityService, "MN0001802");
    DefaultTransactionDefinition def = new DefaultTransactionDefinition();
    Map<String, Object> resultObj = new HashMap<>();
    TransactionStatus status = this.txManager.getTransaction((TransactionDefinition)def);
    try {
      if (((Map)this.menuAut.get(0)).get("read_aut_yn").equals("N")) {
        response.sendRedirect("/autError.do");
        return resultObj;
      } 
      Map<String, Object> paramMap = new HashMap<>();
      HttpSession session = request.getSession();
      LoginVO loginVo = (LoginVO)session.getAttribute("session");
      paramMap.put("pry_svr_nm", cu.getStringWithoutNull(request.getParameter("pry_svr_nm")));
      paramMap.put("lst_mdfr_id", cu.getStringWithoutNull(loginVo.getUsr_id()));
      paramMap.put("not_pry_svr_id", cu.getStringWithoutNull(request.getParameter("pry_svr_id")));
      paramMap.put("pry_svr_id", cu.getStringWithoutNull(request.getParameter("pry_svr_id")));
      paramMap.put("reg_mode", cu.getStringWithoutNull(request.getParameter("reg_mode")));
      paramMap.put("agt_sn", cu.getStringWithoutNull(request.getParameter("agt_sn")));
      paramMap.put("ipadr", cu.getStringWithoutNull(request.getParameter("ipadr")));
      paramMap.put("day_data_del_term", cu.getStringWithoutNull(request.getParameter("day_data_del_term")));
      paramMap.put("min_data_del_term", cu.getStringWithoutNull(request.getParameter("min_data_del_term")));
      paramMap.put("use_yn", cu.getStringWithoutNull(request.getParameter("use_yn")));
      paramMap.put("master_gbn", cu.getStringWithoutNull(request.getParameter("master_gbn")));
      paramMap.put("master_svr_id", cu.getStringWithoutNull(request.getParameter("master_svr_id")));
      paramMap.put("db_svr_id", cu.getStringWithoutNull(request.getParameter("db_svr_id")));
      paramMap.put("kal_install_yn", cu.getStringWithoutNull(request.getParameter("kal_install_yn")));
      resultObj = this.proxySettingService.proxyServerReg(paramMap);
      if ("success".equals(resultObj.get("resultLog")))
        this.proxySettingService.accessSaveHistory(request, historyVO, "DX-T0159_04", this.sohw_menu_id); 
      this.txManager.commit(status);
      if ("Y".equals(cu.getStringWithoutNull(resultObj.get("reRegYn")))) {
        Map<String, Object> agentIp = new HashMap<>();
        agentIp.put("ipadr", paramMap.get("ipadr").toString());
        resultObj.put("reRegResult", Boolean.valueOf(this.proxySettingService.proxyServerReReg(agentIp)));
      } 
    } catch (Exception e) {
      e.printStackTrace();
      resultObj.put("result", Boolean.valueOf(false));
      resultObj.put("errMsg", this.msg.getMessage("eXperDB_proxy.msg49", null, LocaleContextHolder.getLocale()));
      this.txManager.rollback(status);
    } 
    return resultObj;
  }
  
  @RequestMapping({"/deletePrySvr.do"})
  @ResponseBody
  public JSONObject deletePrySvr(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletResponse response, HttpServletRequest request) {
    CmmnUtils cu = new CmmnUtils();
    this.menuAut = cu.selectMenuAut(this.menuAuthorityService, "MN0001802");
    DefaultTransactionDefinition def = new DefaultTransactionDefinition();
    JSONObject resultObj = new JSONObject();
    TransactionStatus status = this.txManager.getTransaction((TransactionDefinition)def);
    try {
      if (((Map)this.menuAut.get(0)).get("read_aut_yn").equals("N")) {
        response.sendRedirect("/autError.do");
        return resultObj;
      } 
      Map<String, Object> param = new HashMap<>();
      HttpSession session = request.getSession();
      LoginVO loginVo = (LoginVO)session.getAttribute("session");
      param.put("svr_use_yn", "D");
      param.put("lst_mdfr_id", loginVo.getUsr_id());
      param.put("pry_svr_id", cu.getStringWithoutNull(request.getParameter("pry_svr_id")));
      param.put("db_svr_id", cu.getStringWithoutNull(request.getParameter("db_svr_id")));
      resultObj = this.proxySettingService.deletePrySvr(param);
      if ("success".equals(resultObj.get("resultLog")))
        this.proxySettingService.accessSaveHistory(request, historyVO, "DX-T0159_06", this.sohw_menu_id); 
      this.txManager.commit(status);
    } catch (Exception e) {
      e.printStackTrace();
      resultObj.put("result", Boolean.valueOf(false));
      resultObj.put("errMsg", this.msg.getMessage("eXperDB_proxy.msg49", null, LocaleContextHolder.getLocale()));
      this.txManager.rollback(status);
    } 
    return resultObj;
  }
  
  @RequestMapping({"/selectListenServerList.do"})
  @ResponseBody
  public List<ProxyListenerServerVO> selectListenServerList(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
    CmmnUtils cu = new CmmnUtils();
    this.menuAut = cu.selectMenuAut(this.menuAuthorityService, "MN0001802");
    List<ProxyListenerServerVO> resultSet = null;
    Map<String, Object> param = new HashMap<>();
    try {
      this.proxySettingService.accessSaveHistory(request, historyVO, "DX-T0159_07", this.sohw_menu_id);
      if (((Map)this.menuAut.get(0)).get("read_aut_yn").equals("N")) {
        response.sendRedirect("/autError.do");
        return resultSet;
      } 
      int prySvrId = Integer.parseInt(request.getParameter("pry_svr_id"));
      int lsnId = Integer.parseInt(request.getParameter("lsn_id"));
      param.put("lsn_id", Integer.valueOf(lsnId));
      param.put("pry_svr_id", Integer.valueOf(prySvrId));
      resultSet = this.proxySettingService.selectListenServerList(param);
    } catch (Exception e) {
      e.printStackTrace();
    } 
    return resultSet;
  }
  
  @RequestMapping({"/proxy/selectIpList.do"})
  @ResponseBody
  public List<Map<String, Object>> selectIpList(HttpServletRequest request, HttpServletResponse response) {
    List<Map<String, Object>> resultSet = null;
    try {
      Map<String, Object> param = new HashMap<>();
      param.put("pry_svr_id", Integer.valueOf(Integer.parseInt(request.getParameter("pry_svr_id"))));
      resultSet = this.proxySettingService.selectIpList(param);
    } catch (Exception e) {
      e.printStackTrace();
    } 
    return resultSet;
  }
  
  @RequestMapping({"/applyProxyConf.do"})
  @ResponseBody
  public JSONObject applyProxyConf(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletResponse response, HttpServletRequest request) {
    CmmnUtils cu = new CmmnUtils();
    this.menuAut = cu.selectMenuAut(this.menuAuthorityService, "MN0001802");
    DefaultTransactionDefinition def = new DefaultTransactionDefinition();
    JSONObject resultObj = new JSONObject();
    TransactionStatus status = this.txManager.getTransaction((TransactionDefinition)def);
    boolean runRollback = false;
    try {
      if (((Map)this.menuAut.get(0)).get("read_aut_yn").equals("N")) {
        response.sendRedirect("/autError.do");
        return resultObj;
      } 
      Map<String, Object> param = new HashMap<>();
      HttpSession session = request.getSession();
      LoginVO loginVo = (LoginVO)session.getAttribute("session");
      JSONParser jparser = new JSONParser();
      JSONObject confData = new JSONObject();
      confData = (JSONObject)jparser.parse(request.getParameter("confData").replaceAll("&quot;", "\""));
      param.put("lst_mdfr_id", cu.getStringWithoutNull(loginVo.getUsr_id()));
      System.out.println("A");
      resultObj = this.proxySettingService.applyProxyConf(param, confData);
      if ("success".equals(resultObj.get("resultLog"))) {
        this.proxySettingService.accessSaveHistory(request, historyVO, "DX-T0159_09", this.sohw_menu_id);
        this.txManager.commit(status);
        param.put("pry_svr_id", confData.get("pry_svr_id"));
        param.put("status", "TC001501");
        param.put("act_type", "R");
        param.put("act_exe_type", "TC004001");
        resultObj = this.proxySettingService.runProxyService(param);
      } else {
        this.txManager.rollback(status);
        runRollback = true;
      } 
    } catch (ConnectException e) {
      e.printStackTrace();
      if (!runRollback)
        this.txManager.rollback(status); 
      resultObj.put("result", Boolean.valueOf(false));
      resultObj.put("errMsg", this.msg.getMessage("eXperDB_proxy.msg47", null, LocaleContextHolder.getLocale()));
    } catch (Exception e) {
      e.printStackTrace();
      resultObj.put("result", Boolean.valueOf(false));
      resultObj.put("errMsg", this.msg.getMessage("eXperDB_proxy.msg49", null, LocaleContextHolder.getLocale()));
    } 
    return resultObj;
  }
  
  @RequestMapping({"/setVipUseYn.do"})
  @ResponseBody
  public JSONObject setVipUseYn(HttpServletRequest request, HttpServletResponse response) {
    CmmnUtils cu = new CmmnUtils();
    this.menuAut = cu.selectMenuAut(this.menuAuthorityService, "MN0001802");
    Map<String, Object> param = new HashMap<>();
    JSONObject resultObj = new JSONObject();
    try {
      if (((Map)this.menuAut.get(0)).get("read_aut_yn").equals("N")) {
        response.sendRedirect("/autError.do");
        return resultObj;
      } 
      HttpSession session = request.getSession();
      LoginVO loginVo = (LoginVO)session.getAttribute("session");
      int prySvrId = Integer.parseInt(!"".equals(cu.getStringWithoutNull(request.getParameter("pry_svr_id"))) ? 
          request.getParameter("pry_svr_id").toString() : 
          "0");
      String kalInstYn = cu.getStringWithoutNull(request.getParameter("kal_install_yn"));
      param.put("kal_install_yn", kalInstYn);
      param.put("pry_svr_id", Integer.valueOf(prySvrId));
      param.put("lst_mdfr_id", cu.getStringWithoutNull(loginVo.getUsr_id()));
      boolean kalInstYnInAgent = true;
      kalInstYnInAgent = this.proxySettingService.checkAgentKalInstYn(param);
      if (kalInstYn.equals("Y") && !kalInstYnInAgent) {
        resultObj.put("result", Boolean.valueOf(false));
        resultObj.put("errMsg", 
            this.msg.getMessage("eXperDB_proxy.msg53", null, LocaleContextHolder.getLocale()));
        return resultObj;
      } 
      this.proxySettingService.updateDeleteVipUseYn(param);
      resultObj.put("result", Boolean.valueOf(true));
      resultObj.put("errMsg", this.msg.getMessage("eXperDB_proxy.msg45", null, LocaleContextHolder.getLocale()));
    } catch (ConnectException e) {
      e.printStackTrace();
      resultObj.put("result", Boolean.valueOf(false));
      resultObj.put("errMsg", this.msg.getMessage("eXperDB_proxy.msg47", null, LocaleContextHolder.getLocale()));
    } catch (Exception e) {
      e.printStackTrace();
      resultObj.put("result", Boolean.valueOf(false));
      resultObj.put("errMsg", this.msg.getMessage("eXperDB_proxy.msg49", null, LocaleContextHolder.getLocale()));
    } 
    return resultObj;
  }
  
  @RequestMapping({"/addProxyServerList.do"})
  @ResponseBody
  public JSONObject addProxyServerList(HttpServletRequest request, HttpServletResponse response) {
    CmmnUtils cu = new CmmnUtils();
    this.menuAut = cu.selectMenuAut(this.menuAuthorityService, "MN0001802");
    Map<String, Object> param = new HashMap<>();
    JSONObject resultObj = new JSONObject();
    try {
      if (((Map)this.menuAut.get(0)).get("read_aut_yn").equals("N")) {
        response.sendRedirect("/autError.do");
        return resultObj;
      } 
      HttpSession session = request.getSession();
      LoginVO loginVo = (LoginVO)session.getAttribute("session");
      int prySvrId = Integer.parseInt(!"".equals(cu.getStringWithoutNull(request.getParameter("pry_svr_id"))) ? 
          request.getParameter("pry_svr_id").toString() : 
          "0");
      String kalInstYn = cu.getStringWithoutNull(request.getParameter("kal_install_yn"));
      param.put("kal_install_yn", kalInstYn);
      param.put("pry_svr_id", Integer.valueOf(prySvrId));
      param.put("lst_mdfr_id", cu.getStringWithoutNull(loginVo.getUsr_id()));
      boolean kalInstYnInAgent = true;
      kalInstYnInAgent = this.proxySettingService.checkAgentKalInstYn(param);
      if (kalInstYn.equals("Y") && !kalInstYnInAgent) {
        resultObj.put("result", Boolean.valueOf(false));
        resultObj.put("errMsg", 
            this.msg.getMessage("eXperDB_proxy.msg53", null, LocaleContextHolder.getLocale()));
        return resultObj;
      } 
      this.proxySettingService.updateDeleteVipUseYn(param);
      resultObj.put("result", Boolean.valueOf(true));
      resultObj.put("errMsg", this.msg.getMessage("eXperDB_proxy.msg45", null, LocaleContextHolder.getLocale()));
    } catch (ConnectException e) {
      e.printStackTrace();
      resultObj.put("result", Boolean.valueOf(false));
      resultObj.put("errMsg", this.msg.getMessage("eXperDB_proxy.msg47", null, LocaleContextHolder.getLocale()));
    } catch (Exception e) {
      e.printStackTrace();
      resultObj.put("result", Boolean.valueOf(false));
      resultObj.put("errMsg", this.msg.getMessage("eXperDB_proxy.msg49", null, LocaleContextHolder.getLocale()));
    } 
    return resultObj;
  }
}
