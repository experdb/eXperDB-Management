package com.experdb.management.proxy.web;

import java.net.ConnectException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.experdb.management.proxy.cmmn.CommonUtil;
import com.experdb.management.proxy.service.ProxyAgentVO;
import com.experdb.management.proxy.service.ProxyGlobalVO;
import com.experdb.management.proxy.service.ProxyListenerServerVO;
import com.experdb.management.proxy.service.ProxyListenerVO;
import com.experdb.management.proxy.service.ProxyServerVO;
import com.experdb.management.proxy.service.ProxySettingService;
import com.experdb.management.proxy.service.ProxyVipConfigVO;
import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityService;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.AgentInfoVO;
import com.k4m.dx.tcontrol.common.service.CmmnCodeDtlService;
import com.k4m.dx.tcontrol.common.service.CmmnCodeVO;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.common.service.PageVO;
import com.k4m.dx.tcontrol.login.service.LoginVO;


/**
 *Proxy 설정관리
 *
 * @author 김민정
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2021.03.03   김민정 최초 생성
 *      </pre>
 */

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
	
	
	private List<Map<String, Object>> menuAut;
	
	private String sohw_menu_id = "45";
	
	/**
	 * Mybatis Transaction 
	 */
	@Autowired
	private PlatformTransactionManager txManager;
	/**
	 * VIP 설정 관리 화면 
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/proxySetting.do")
	public ModelAndView proxySettingForm(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001802");
				
		ModelAndView mv = new ModelAndView();
		try {
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{
				// 화면접근이력 이력 남기기 - Proxy 설정 관리 화면
				proxySettingService.accessSaveHistory(request, historyVO, "DX-T0159", sohw_menu_id);
				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				
				mv.addObject("usr_id", loginVo.getUsr_id());

				// simple query code search
				List<CmmnCodeVO> cmmnCodeVO =  null;
				PageVO pageVO = new PageVO();
				
				pageVO.setGrp_cd("TC0041");
				pageVO.setSearchCondition("0");
				cmmnCodeVO = cmmnCodeDtlService.cmmnDtlCodeSearch(pageVO);
				mv.addObject("simpleQueryList",cmmnCodeVO);
				
				//Listener Nm Code Search
				PageVO pageVO_2 = new PageVO();
				
				pageVO_2.setGrp_cd("TC0042");
				pageVO_2.setSearchCondition("0");
				cmmnCodeVO = cmmnCodeDtlService.cmmnDtlCodeSearch(pageVO_2);
				mv.addObject("listenerNmList", cmmnCodeVO);
				
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));	

				mv.setViewName("proxy/setting/proxySetting");
			}	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * proxy 서버 등록 팝업
	 * 
	 * @param request, historyVO
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/proxySvrRegForm.do")
	public ModelAndView proxyServerRegForm(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView("jsonView");

		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001802");

			if (menuAut.get(0).get("wrt_aut_yn").equals("N")) {
				mv.setViewName("error/autError");
			} else {
				// 화면접근이력 이력 남기기 - Proxy 설정관리 - 서버 등록 팝업
				proxySettingService.accessSaveHistory(request, historyVO, "DX-T0159_01", sohw_menu_id);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * VIP Instance 수정 팝업
	 * 
	 * @param request, historyVO
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/vipInstanceRegForm.do")
	public ModelAndView vipInstanceRegForm(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView("jsonView");

		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001802");

			if (menuAut.get(0).get("wrt_aut_yn").equals("N")) {
				mv.setViewName("error/autError");
			} else {
				// 화면접근이력 이력 남기기 - Proxy 설정관리 - VIP Instance 관리 팝업
				proxySettingService.accessSaveHistory(request, historyVO, "DX-T0159_02", sohw_menu_id);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * Proxy Listener 등록 팝업
	 * 
	 * @param request, historyVO
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/proxyListenRegForm.do")
	public ModelAndView proxyListenRegForm(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView("jsonView");

		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001802");

			if (menuAut.get(0).get("wrt_aut_yn").equals("N")) {
				mv.setViewName("error/autError");
			} else {
				// 화면접근이력 이력 남기기 - Proxy 설정관리 - Proxy Listen 관리 팝업
				proxySettingService.accessSaveHistory(request, historyVO, "DX-T0159_03", sohw_menu_id);				
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * Proxy 서버 리스트를 조회한다.
	 * 
	 * @param request
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectPoxyServerTable.do")
	public @ResponseBody List<ProxyServerVO> selectPoxyServerTable(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001802");
				
		List<ProxyServerVO> resultSet = null;
		Map<String, Object> param = new HashMap<String, Object>();

		try {	
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultSet;
			}else{
				// 화면접근이력 이력 남기기 - Proxy 설정관리 - Proxy Listen 관리 팝업
				proxySettingService.accessSaveHistory(request, historyVO, "DX-T0159_07", sohw_menu_id);		

				param.put("search", request.getParameter("search")==null ? "" : request.getParameter("search").toString());
				param.put("svr_use_yn", request.getParameter("svr_use_yn")==null ? "" : request.getParameter("svr_use_yn").toString());
				param.put("pry_svr_id", request.getParameter("pry_svr_id")==null ? "" : request.getParameter("pry_svr_id").toString());
				
				resultSet = proxySettingService.selectProxyServerList(param);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;

	}
	
	/**
	 * Proxy 미등록 Agent 리스트를 조회한다.(proxy 서버 등록 팝업)
	 * 
	 * @param historyVO, request, response
	 * @return resultSet
	 * @throws Exception
	**/	
	@RequestMapping(value = "/selectPoxyAgentSvrList.do")
	public @ResponseBody ModelAndView selectPoxyAgentList(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView("jsonView");
				
		List<Map<String, Object>> dbmsResultSet = null;
		List<Map<String, Object>> agentResultSet = null;
		List<Map<String, Object>> mstResultSet = null;
		
		Map<String, Object> param = new HashMap<String, Object>();

		try {	
			// 화면접근이력 이력 남기기 - Proxy 설정관리 - 서버 정보 조회
			proxySettingService.accessSaveHistory(request, historyVO, "DX-T0159_07", sohw_menu_id);		

			param.put("svr_use_yn", request.getParameter("svr_use_yn")==null ? "" : request.getParameter("svr_use_yn").toString());			
			param.put("mode", request.getParameter("mode")==null ? "" : request.getParameter("mode").toString());			
			agentResultSet = proxySettingService.selectPoxyAgentSvrList(param);
			
			//dbms 조회
			dbmsResultSet = proxySettingService.selectDbmsTotList(param);

			if (dbmsResultSet.size() > 0) {
				param.put("db_svr_id", dbmsResultSet.get(0).get("db_svr_id"));
			} else {
				param.put("db_svr_id", null);
			}
			
			//Master Proxy 정보
			mstResultSet = proxySettingService.selectProxyMstTotList(param);
			
			mv.addObject("agentSvrList", agentResultSet);
			mv.addObject("dbmsSvrList", dbmsResultSet);
			mv.addObject("mstSvrList", mstResultSet);
			
		} catch (Exception e) {
			e.printStackTrace();
		}

		return mv;
	} 
	
	/**
	 * 프록시 서버 상세 정보 조회
	 * 
	 * @param request
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/getPoxyServerConf.do")
	public @ResponseBody JSONObject getPoxyServerConf(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
		
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001802");
				
		Map<String, Object> param = new HashMap<String, Object>();
		JSONObject resultObj = new JSONObject();
		try {	
			CmmnUtils.saveHistory(request, historyVO);

			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultObj;
			}else{
				// 화면접근이력 이력 남기기 - Proxy 설정관리 - 상세 정보 조회
				proxySettingService.accessSaveHistory(request, historyVO, "DX-T0159_08", sohw_menu_id);				
				
				int prySvrId = Integer.parseInt(request.getParameter("pry_svr_id"));
				param.put("pry_svr_id", prySvrId);
					
				//정보조회
				resultObj = proxySettingService.getPoxyServerConf(param);
				try{
					List<String> interfList = proxySettingService.getAgentInterface(param);
					resultObj.put("interf", interfList.get(0));
					interfList.remove(0);
					resultObj.put("interface_items", interfList);
				}catch(ConnectException e){
					resultObj.put("errcd", 1);
					resultObj.put("errMsg","Proxy Agent와 연결이 불가능합니다.\nAgent 상태를 확인해주세요.");
					resultObj.put("interface_items", null);
				}catch(Exception e){
					resultObj.put("errcd", 2);
					resultObj.put("errMsg","Agent 작업 중 오류가 발생하였습니다.");
					resultObj.put("interface_items", null);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			resultObj.put("errcd", -1);
			resultObj.put("errMsg","Proxy 상세 정보 불러오는 중 오류가 발생하였습니다.");
		}
		return resultObj;
	}
	/**
	 * 프록시 서버 상세 정보 조회
	 * 
	 * @param request
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/getVipInstancePeerList.do")
	public @ResponseBody JSONObject getVipInstancePeerList(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
		
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001802");
				
		Map<String, Object> param = new HashMap<String, Object>();
		JSONObject resultObj = new JSONObject();
		try {	
			CmmnUtils.saveHistory(request, historyVO);

			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultObj;
			}else{
				String peerSvrIp = request.getParameter("peer_server_ip")==null ? "" : request.getParameter("peer_server_ip").toString();
				param.put("peer_server_ip", peerSvrIp);
					
				//정보조회
				resultObj = proxySettingService.getVipInstancePeerList(param);
				
			}
		} catch (Exception e) {
			e.printStackTrace();
			resultObj.put("errcd", -1);
			resultObj.put("errMsg","Proxy Peer 가상 IP 정보 불러오는 중 오류가 발생하였습니다.");
		}
		return resultObj;
	}
	/**
	 * 동적 select 박스 생성
	 * 
	 * @param request, response
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/createSelPrySvrReg.do")
	public @ResponseBody JSONObject createSelPrySvrReg(HttpServletRequest request, HttpServletResponse response) {
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001802");
	
		Map<String, Object> param = new HashMap<String, Object>();
		JSONObject resultObj = new JSONObject();

		try {	
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultObj;
			}else{
				int	prySvrId = Integer.parseInt(request.getParameter("pry_svr_id") != null && !"".equals((String)request.getParameter("pry_svr_id")) ? request.getParameter("pry_svr_id").toString():"0" );
				int	dbSvrId = Integer.parseInt(request.getParameter("db_svr_id") != null && !"".equals((String)request.getParameter("db_svr_id")) ? request.getParameter("db_svr_id").toString():"0" );
				
				param.put("db_svr_id", dbSvrId);
				param.put("pry_svr_id", prySvrId);
				
				resultObj = proxySettingService.createSelPrySvrReg(param);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultObj;
	}

	/**
	 * 동적 select 박스 생성(master proxy 서버)
	 * 
	 * @param request
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/proxySetMstSvrChange.do")
	public @ResponseBody JSONObject proxySetMstSvrChange(HttpServletRequest request, HttpServletResponse response) {
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001802");
	
		Map<String, Object> param = new HashMap<String, Object>();
		JSONObject resultObj = new JSONObject();
		
		try {
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultObj;
			}else{	
				int	prySvrId = Integer.parseInt(request.getParameter("pry_svr_id") != null && !"".equals((String)request.getParameter("pry_svr_id"))  ? request.getParameter("pry_svr_id").toString() : "0");
				int	dbSvrId = Integer.parseInt(request.getParameter("db_svr_id") != null && !"".equals((String)request.getParameter("db_svr_id")) ? request.getParameter("db_svr_id").toString() : "0");
				param.put("pry_svr_id", prySvrId);
				param.put("db_svr_id", dbSvrId);

				//Master Proxy 정보
				resultObj = proxySettingService.selectMasterSvrProxyList(param);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultObj;
	}
	
	/**
	 * 서버명 조회(proxy 서버 등록 시)
	 * 
	 * @param request, response
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(value = "/proxySetServerNmChange.do")
	public @ResponseBody String proxySetServerNmChange(HttpServletRequest request, HttpServletResponse response) {
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001802");
	
		Map<String, Object> param = new HashMap<String, Object>();
		String resultStr = "";

		try {	
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultStr;
			}else{
				int	dbSvrId = Integer.parseInt(request.getParameter("db_svr_id") != null && !"".equals((String)request.getParameter("db_svr_id")) ? request.getParameter("db_svr_id").toString() : "0");

				param.put("db_svr_id", dbSvrId);
				resultStr = proxySettingService.proxySetServerNmList(param);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultStr;
	}
	
	/**
	 * proxy 서버 구동/정지
	 * 
	 * @param request, response
	 * @return resultObj
	 * @throws Exception
	 */
	@RequestMapping(value = "/runProxyService.do")
	public @ResponseBody JSONObject runProxyService(HttpServletRequest request, HttpServletResponse response) {
	
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001802");
	
		Map<String, Object> param = new HashMap<String, Object>();
		JSONObject resultObj = new JSONObject();
	
		try {	
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultObj;
			}else{
				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");

				int	prySvrId = Integer.parseInt(request.getParameter("pry_svr_id") != null && !"".equals((String)request.getParameter("pry_svr_id"))  ? request.getParameter("pry_svr_id").toString() : "0");

				String status_cd =request.getParameter("status")==null ? "" : request.getParameter("status").toString();
				if("TC001502".equals(status_cd)){
					param.put("act_type", "S");//stop
				}else if("TC001501".equals(status_cd)){
					param.put("act_type", "A");//active
				}
				param.put("pry_svr_id", prySvrId);
				param.put("status", status_cd);
				param.put("lst_mdfr_id", loginVo.getUsr_id()==null ? "" : loginVo.getUsr_id().toString());

				resultObj = proxySettingService.runProxyService(param);
			}
		}  catch (ConnectException e) {
			e.printStackTrace();
			resultObj.put("errcd", -1);
			resultObj.put("errMsg","Proxy Agent와 연결이 불가능합니다.\nAgent 상태를 확인해주세요.");
			
		} catch (Exception e) {
			e.printStackTrace();
			resultObj.put("errcd", -1);
			resultObj.put("errmsg", "작업 중 요류가 발생하였습니");
		}
		return resultObj;

	}
	
	/**
	 * Proxy Agent Connect Test
	 * 
	 * @param request, response
	 * @return resultObj
	 * @throws Exception
	 */
	@RequestMapping(value = "/prySvrConnTest.do")
	public @ResponseBody JSONObject prySvrConnTest(HttpServletRequest request, HttpServletResponse response){
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001802");
	
		Map<String, Object> param = new HashMap<String, Object>();
		JSONObject resultObj = new JSONObject();

		try {
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultObj;
			}else{
				int	prySvrId = Integer.parseInt(request.getParameter("pry_svr_id") != null && !"".equals((String)request.getParameter("pry_svr_id"))  ? request.getParameter("pry_svr_id").toString() : "0");
				param.put("pry_svr_id", prySvrId);
				param.put("ipadr", request.getParameter("ipadr"));
				System.out.println("prySvrConnTest start");
				resultObj = proxySettingService.prySvrConnTest(param);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultObj;
	}
	
	/**
	 * Proxy 서버 등록
	 * 
	 * @param historyVO, request, response
	 * @return resultObj
	 * @throws Exception
	 */
	@RequestMapping(value = "/prySvrReg.do")
	public @ResponseBody Map<String, Object> proxyServerReg(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001802");
	
		DefaultTransactionDefinition def  = new DefaultTransactionDefinition();
	
		Map<String, Object> resultObj = new HashMap<String, Object>();
		TransactionStatus status = txManager.getTransaction(def);
	
		try {	
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultObj;
			}else{
				Map<String, Object> paramMap = new HashMap<String, Object>();
				
				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");

				paramMap.put("pry_svr_nm", request.getParameter("pry_svr_nm")==null ? "" : request.getParameter("pry_svr_nm").toString());
				paramMap.put("lst_mdfr_id", loginVo.getUsr_id()==null ? "" : loginVo.getUsr_id().toString());
				paramMap.put("not_pry_svr_id", request.getParameter("pry_svr_id")==null ? "" : request.getParameter("pry_svr_id").toString());
				paramMap.put("pry_svr_id", request.getParameter("pry_svr_id")==null ? "" : request.getParameter("pry_svr_id").toString());
				paramMap.put("reg_mode", request.getParameter("reg_mode")==null ? "" : request.getParameter("reg_mode").toString());
				paramMap.put("agt_sn", request.getParameter("agt_sn")==null ? "" : request.getParameter("agt_sn").toString());
				paramMap.put("ipadr", request.getParameter("ipadr")==null ? "" : request.getParameter("ipadr").toString());
				paramMap.put("day_data_del_term", request.getParameter("day_data_del_term")==null ? "" : request.getParameter("day_data_del_term").toString());
				paramMap.put("min_data_del_term", request.getParameter("min_data_del_term")==null ? "" : request.getParameter("min_data_del_term").toString());
				paramMap.put("use_yn", request.getParameter("use_yn")==null ? "" : request.getParameter("use_yn").toString());
				paramMap.put("master_gbn", request.getParameter("master_gbn")==null ? "" : request.getParameter("master_gbn").toString());
				paramMap.put("master_svr_id", request.getParameter("master_svr_id")==null ? "" : request.getParameter("master_svr_id").toString());
				paramMap.put("db_svr_id", request.getParameter("db_svr_id")==null ? "" : request.getParameter("db_svr_id").toString());
				paramMap.put("kal_install_yn", request.getParameter("kal_install_yn")==null ? "N" : request.getParameter("kal_install_yn").toString());

				resultObj = proxySettingService.proxyServerReg(paramMap);
				
				if ("success".equals(resultObj.get("resultLog"))) {
					// 화면접근이력 이력 남기기 - Proxy 설정관리 - VIP Instance 관리 팝업
					proxySettingService.accessSaveHistory(request, historyVO, "DX-T0159_04", sohw_menu_id);
				}
				
				txManager.commit(status);
			}
		} catch (Exception e) {
			e.printStackTrace();
			resultObj.put("result",false);
			resultObj.put("errMsg","서버 등록 중 오류가 발생하였습니다.");
			txManager.rollback(status);
		}
		return resultObj;
	}
	
	/**
	 * Proxy 서버를 삭제한다.
	 * 
	 * @param historyVO, response, request
	 * @return result
	 * @throws Exception
	 */
	@RequestMapping(value = "/deletePrySvr.do")
	public @ResponseBody JSONObject deletePrySvr(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletResponse response, HttpServletRequest request) {
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001802");
				
		DefaultTransactionDefinition def  = new DefaultTransactionDefinition();
	
		JSONObject resultObj = new JSONObject();
		TransactionStatus status = txManager.getTransaction(def);

		try {	
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultObj;
			}else{
				Map<String, Object> param = new HashMap<String, Object>();
	
				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");

				param.put("svr_use_yn", "D");
				param.put("lst_mdfr_id", loginVo.getUsr_id());
				param.put("pry_svr_id", request.getParameter("pry_svr_id"));

				resultObj = proxySettingService.deletePrySvr(param);

				if ("success".equals(resultObj.get("resultLog"))) {
					// 화면접근이력 이력 남기기 - Proxy 설정관리 - 서버 삭제
					proxySettingService.accessSaveHistory(request, historyVO, "DX-T0159_06", sohw_menu_id);
				}
				
				txManager.commit(status);
			}
		} catch (Exception e) {
			e.printStackTrace();

			resultObj.put("result", false);
			resultObj.put("errMsg","서버 삭제 중 오류가 발생하였습니다.");
			txManager.rollback(status);
		}
		return resultObj;
	}

	/**
	 * Proxy 서버 리스트를 조회한다.
	 * 
	 * @param request
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectListenServerList.do")
	public @ResponseBody List<ProxyListenerServerVO> selectListenServerList(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001802");
				
		List<ProxyListenerServerVO> resultSet = null;
		Map<String, Object> param = new HashMap<String, Object>();

		try {	
			// 화면접근이력 이력 남기기 - Proxy 설정관리 - 서버 정보 조회
			proxySettingService.accessSaveHistory(request, historyVO, "DX-T0159_07", sohw_menu_id);

			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultSet;
			}else{
				int prySvrId = Integer.parseInt(request.getParameter("pry_svr_id"));
				int lsnId = Integer.parseInt(request.getParameter("lsn_id"));
				
				param.put("lsn_id", lsnId);
				param.put("pry_svr_id", prySvrId);
				
				resultSet = proxySettingService.selectListenServerList(param);
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}

	/**
	 * DBMS IP SelectBox 
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/proxy/selectIpList.do")
	public @ResponseBody List<Map<String, Object>> selectIpList(HttpServletRequest request, HttpServletResponse response) {
	
		List<Map<String, Object>> resultSet = null;
	
		try {
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("pry_svr_id",  Integer.parseInt(request.getParameter("pry_svr_id")));
			
			resultSet = proxySettingService.selectIpList(param);	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
	
	
	/**
	 * Proxy 서버를 업데이트 하고 재실행한다.
	 * 
	 * @param historyVO, response, request
	 * @return result
	 * @throws Exception
	 */
	@RequestMapping(value = "/applyProxyConf.do")
	public @ResponseBody JSONObject applyProxyConf(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletResponse response, HttpServletRequest request) {
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001802");
		
		DefaultTransactionDefinition def  = new DefaultTransactionDefinition();

		JSONObject resultObj = new JSONObject();
		TransactionStatus status = txManager.getTransaction(def);
		boolean runRollback=false;
		try {	
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultObj;
			}else{
				Map<String, Object> param = new HashMap<String, Object>();

				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				
				JSONParser jparser = new JSONParser();
				JSONObject confData = new JSONObject();
				confData = (JSONObject)jparser.parse(request.getParameter("confData").replaceAll("&quot;", "\""));
				
				param.put("lst_mdfr_id", loginVo.getUsr_id()==null ? "" : loginVo.getUsr_id().toString());
				
				resultObj = proxySettingService.applyProxyConf(param, confData);
				
				if ("success".equals(resultObj.get("resultLog"))) {
					// 화면접근이력 이력 남기기 - Proxy 설정관리 - 설정 정보 수정 및 서버 재구동
					proxySettingService.accessSaveHistory(request, historyVO, "DX-T0159_09", sohw_menu_id);
					//설정변경이력 결과 남기기
					txManager.commit(status);
				}else{
					
					txManager.rollback(status);
					//설정변경이력 결과 남기기
					
					runRollback = true;
				}
				//Agent keepalive, haproxy 재구동
				param.put("pry_svr_id", confData.get("pry_svr_id"));
				param.put("status", "TC001501");
				param.put("act_type", "R");
				
				resultObj = proxySettingService.runProxyService(param);
			}
		} catch (ConnectException e) {
			e.printStackTrace();
			if(!runRollback) txManager.rollback(status);
			resultObj.put("result",false);
			resultObj.put("errMsg","Proxy Agent와 연결이 불가능합니다.\nAgent 상태를 확인해주세요.");
			
		} catch (Exception e) {
			e.printStackTrace();
			resultObj.put("result",false);
			resultObj.put("errMsg","설정 적용 중 오류가 발생하였습니다.");
		}
		return resultObj;
	}
	
	/**
	 * 가상 IP 사용 여부 설정 
	 * 
	 * @param request, response
	 * @return resultObj
	 * @throws Exception
	 */
	@RequestMapping(value = "/setVipUseYn.do")
	public @ResponseBody JSONObject setVipUseYn(HttpServletRequest request, HttpServletResponse response) {
	
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001802");
	
		Map<String, Object> param = new HashMap<String, Object>();
		JSONObject resultObj = new JSONObject();
	
		try {	
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultObj;
			}else{
				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");

				int	prySvrId = Integer.parseInt(request.getParameter("pry_svr_id") != null && !"".equals((String)request.getParameter("pry_svr_id"))  ? request.getParameter("pry_svr_id").toString() : "0");

				String kalInstYn =request.getParameter("kal_install_yn")==null ? "" : request.getParameter("kal_install_yn").toString();
				param.put("kal_install_yn", kalInstYn);//stop
				param.put("pry_svr_id", prySvrId);
				param.put("lst_mdfr_id", loginVo.getUsr_id()==null ? "" : loginVo.getUsr_id().toString());

				proxySettingService.updateDeleteVipUseYn(param);
				
				resultObj.put("result", true);
				resultObj.put("errMsg", "작업이 정상적으로 완료 되었습니다.");
			}
		}catch (Exception e) {
			e.printStackTrace();
			resultObj.put("result", false);
			resultObj.put("errMsg", "작업 중 요류가 발생하였습니다.");
		}
		return resultObj;

	}
}
