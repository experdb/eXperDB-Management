package com.experdb.management.proxy.web;

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
import com.k4m.dx.tcontrol.common.service.HistoryVO;
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
	
	private List<Map<String, Object>> menuAut;
	
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
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0159");//Proxy 설정 관리 화면
				historyVO.setMnu_id(45);
				accessHistoryService.insertHistory(historyVO);
		
				String usr_id = request.getParameter("usr_id")==null?"":request.getParameter("usr_id");
				if(usr_id != null){
					mv.addObject("usr_id", usr_id);
				}
				 
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
	 * VIP 서버 등록 팝업
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
				CmmnUtils.saveHistory(request, historyVO);

				// 화면접근이력 이력 남기기
				historyVO.setExe_dtl_cd("DX-T0159_01");//Proxy 설정관리 - 서버 등록 팝업
				historyVO.setMnu_id(45);
				accessHistoryService.insertHistory(historyVO);
				
				
				/*
				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				String strTocken = loginVo.getTockenValue();
				String entityId = loginVo.getEctityUid();
				String encp_use_yn = loginVo.getEncp_use_yn();

				if (encp_use_yn.equals("Y") && (strTocken != null && !"".equals(strTocken)) && (entityId !=null && !"".equals(entityId))) {
					mv.addObject("encp_yn", encp_use_yn);
				}*/
				//mv.setViewName("popup/userManagerRegForm");
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
				CmmnUtils.saveHistory(request, historyVO);

				// 화면접근이력 이력 남기기
				historyVO.setExe_dtl_cd("DX-T0159_02");//Proxy 설정관리 - VIP Instance 관리 팝업
				historyVO.setMnu_id(45);
				accessHistoryService.insertHistory(historyVO);
				
				
				/*
				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				String strTocken = loginVo.getTockenValue();
				String entityId = loginVo.getEctityUid();
				String encp_use_yn = loginVo.getEncp_use_yn();

				if (encp_use_yn.equals("Y") && (strTocken != null && !"".equals(strTocken)) && (entityId !=null && !"".equals(entityId))) {
					mv.addObject("encp_yn", encp_use_yn);
				}*/
				//mv.setViewName("popup/userManagerRegForm");
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * VIP Listen 등록 팝업
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
				CmmnUtils.saveHistory(request, historyVO);

				// 화면접근이력 이력 남기기
				historyVO.setExe_dtl_cd("DX-T0159_03");//Proxy 설정관리 - Proxy Listen 관리 팝업
				historyVO.setMnu_id(45);
				accessHistoryService.insertHistory(historyVO);
				
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
			CmmnUtils.saveHistory(request, historyVO);

			// 화면접근이력 이력 남기기
			historyVO.setExe_dtl_cd("DX-T0159_07");//Proxy 설정관리 - 서버 정보 조회
			historyVO.setMnu_id(45);
			accessHistoryService.insertHistory(historyVO);
			
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultSet;
			}else{
				String search = request.getParameter("search");
				String svrUseYn = request.getParameter("svr_use_yn");
				String prySvrId = request.getParameter("pry_svr_id");
				
				param.put("search", search);
				param.put("svr_use_yn", svrUseYn);
				param.put("pry_svr_id", prySvrId);
				
				resultSet = proxySettingService.selectProxyServerList(param);
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;

	}
	
	/**
	 * Proxy 미등록 Agent 리스트를 조회한다.
	 * 
	 * @param request
	 * @return resultSet
	 * @throws Exception
	
	@RequestMapping(value = "/selectPoxyAgentSvrList.do")
	public @ResponseBody List<Map<String, Object>> selectPoxyAgentList(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001802");
				
		List<Map<String, Object>> resultSet = null;
		Map<String, Object> param = new HashMap<String, Object>();
		try {	
			CmmnUtils.saveHistory(request, historyVO);

			// 화면접근이력 이력 남기기
			historyVO.setExe_dtl_cd("DX-T0159_07");//Proxy 설정관리 - 서버 정보 조회
			historyVO.setMnu_id(45);
			accessHistoryService.insertHistory(historyVO);
			
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultSet;
			}else{
				String svrUseYn = request.getParameter("svr_use_yn");
				param.put("svr_use_yn", svrUseYn);
				
				resultSet = proxySettingService.selectPoxyAgentSvrList(param);
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;

	} */
	
	/**
	 * 프록시 서버 상세 정보 
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
		JSONObject resultObj = null;
		try {	
			CmmnUtils.saveHistory(request, historyVO);

			// 화면접근이력 이력 남기기
			historyVO.setExe_dtl_cd("DX-T0159_08");//Proxy 설정관리 - 상세 정보 조회
			historyVO.setMnu_id(45);
			accessHistoryService.insertHistory(historyVO);
			
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultObj;
			}else{
				int prySvrId = Integer.parseInt(request.getParameter("pry_svr_id"));
				param.put("pry_svr_id", prySvrId);
									
				resultObj = new JSONObject();
				
				//Global 정보
				ProxyGlobalVO globalInfo = proxySettingService.selectProxyGlobal(param);
				resultObj.put("global_info", globalInfo);
				//Proxy Listener List 정보
				List<ProxyListenerVO> listenerList = proxySettingService.selectProxyListenerList(param);	
				resultObj.put("listener_list", listenerList);
				//VIP List 정보
				List<ProxyVipConfigVO> vipConfigList = proxySettingService.selectProxyVipConfList(param);	
				resultObj.put("vipconfig_list", vipConfigList);
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultObj;

	}
	
	
	/**
	 * 동적 select 박스 생성
	 * 
	 * @param request
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/createSelPrySvrReg.do")
	public @ResponseBody JSONObject createSelPrySvrReg(HttpServletRequest request, HttpServletResponse response) {
		
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001802");
				
		Map<String, Object> param = new HashMap<String, Object>();
		JSONObject resultObj = null;
		try {	
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultObj;
			}else{
				int prySvrId = Integer.parseInt(request.getParameter("pry_svr_id"));
				param.put("pry_svr_id", prySvrId);
				
				System.out.println("param :: "+param.toString());
				
				resultObj = new JSONObject();
				
				//Master Proxy 정보
				List<Map<String, Object>> mstSvrSelList = proxySettingService.selectMasterProxyList(param);
				resultObj.put("mstSvr_sel_list", mstSvrSelList);
				//연결 DBMS 정보 
				List<Map<String, Object>> dbmsSelList = proxySettingService.selectDbmsList(param);
				resultObj.put("dbms_sel_list", dbmsSelList);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultObj;

	}
	
	/**
	 * proxy 서버 구동/정지
	 * 
	 * @param request
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/runProxyServer.do")
	public @ResponseBody JSONObject runProxyServer(HttpServletRequest request, HttpServletResponse response) {
		
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001802");
				
		Map<String, Object> param = new HashMap<String, Object>();
		JSONObject resultObj = null;
		try {	
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultObj;
			}else{
				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				String lst_mdfr_id = loginVo.getUsr_id();
				
				int prySvrId = Integer.parseInt(request.getParameter("pry_svr_id"));
				String status = request.getParameter("exe_status");
				param.put("pry_svr_id", prySvrId);
				param.put("exe_status", status);
				if(status.equals("TC001502")) param.put("use_yn", "N");
				else param.put("use_yn", "Y");
				param.put("lst_mdfr_id", lst_mdfr_id);
				
				resultObj = new JSONObject();
				
				proxySettingService.updateProxyServerStatus(param);
				resultObj.put("errcd", 0);
				resultObj.put("errMsg", "정상적으로 처리되었습니다.");
			}
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
	 * @param request
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/prySvrConnTest.do")
	public @ResponseBody JSONObject prySvrConnTest(HttpServletRequest request, HttpServletResponse response) {
		
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001802");
				
		Map<String, Object> param = new HashMap<String, Object>();
		JSONObject resultObj = null;
		try {	
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultObj;
			}else{
				int prySvrId = Integer.parseInt(request.getParameter("pry_svr_id"));
				param.put("pry_svr_id", prySvrId);
				
				resultObj = new JSONObject();
				
				//Proxy Agent 연결 
				
				//결과 
				boolean agentConn = true;
				if(agentConn){
					resultObj.put("agentConn", true);
				}else{
					resultObj.put("agentConn", false);
				}
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultObj;

	}
	/**
	 * Proxy 서버명이 중복되는지 확인 한 후 등록
	 * 
	 * @param request
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/prySvrReg.do")
	public @ResponseBody Map<String, Object> proxyServerReg(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001802");
				
		DefaultTransactionDefinition def  = new DefaultTransactionDefinition();
		
		Map<String, Object> resultObj = null;
		TransactionStatus status = txManager.getTransaction(def);
		try {	
			CmmnUtils.saveHistory(request, historyVO);

			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultObj;
			}else{
				resultObj = new HashMap<String, Object>();
				
				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				String lst_mdfr_id = loginVo.getUsr_id();
				
				//서버명이 중복되는지 확인
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("pry_svr_nm", request.getParameter("pry_svr_nm"));
				param.put("not_pry_svr_id", Integer.parseInt(request.getParameter("pry_svr_id")));
				
				List<ProxyServerVO> prySvrList = proxySettingService.selectProxyServerList(param);	
				
				if(prySvrList.size() == 0){
					ProxyAgentVO pryAgtVO = new ProxyAgentVO();
					pryAgtVO.setSvr_use_yn("Y");
					pryAgtVO.setAgt_sn(Integer.parseInt(request.getParameter("agt_sn")));
					pryAgtVO.setLst_mdfr_id(lst_mdfr_id);
					
					ProxyServerVO prySvrVO = new ProxyServerVO();
					prySvrVO.setPry_svr_id(Integer.parseInt(request.getParameter("pry_svr_id")));
					prySvrVO.setPry_svr_nm(request.getParameter("pry_svr_nm"));
					prySvrVO.setDay_data_del_term(Integer.parseInt(request.getParameter("day_data_del_term")));
					prySvrVO.setMin_data_del_term(Integer.parseInt(request.getParameter("min_data_del_term")));
					prySvrVO.setUse_yn(request.getParameter("use_yn"));
					prySvrVO.setMaster_gbn(request.getParameter("master_gbn"));
					prySvrVO.setDb_svr_id(Integer.parseInt(request.getParameter("db_svr_id")));
					prySvrVO.setLst_mdfr_id(lst_mdfr_id);
					
					proxySettingService.updateProxyAgentInfo(pryAgtVO);
					proxySettingService.updateProxyServerInfo(prySvrVO);
					
					resultObj.put("result",true);
					resultObj.put("errMsg","작업이 완료되었습니다.");
					txManager.commit(status);
					
					// 화면접근이력 이력 남기기
					historyVO.setExe_dtl_cd("DX-T0159_04");//Proxy 설정관리 - 서버 정보 등록/수정
					historyVO.setMnu_id(45);
					accessHistoryService.insertHistory(historyVO);
				}else{
					resultObj.put("result",false);
					resultObj.put("errMsg","서버명이 다른 서버와 중복되었습니다.");
				}
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
		
		JSONObject resultObj = null;
		TransactionStatus status = txManager.getTransaction(def);
		try {	
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultObj;
			}else{
				resultObj = new JSONObject();
				
				int prySvrId = Integer.parseInt(request.getParameter("pry_svr_id"));
				
				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				String lst_mdfr_id = loginVo.getUsr_id();
				
				//서버 내리기
				
				
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("svr_use_yn", "N");
				param.put("lst_mdfr_id", lst_mdfr_id);
				param.put("pry_svr_id", prySvrId);
				
				//update t_pry_agt_i의 svr_use_yn = N으로 업데이트
				proxySettingService.updateProxyAgentInfoFromProxyId(param);
				//delete t_prycng_g
				proxySettingService.deleteProxyConfHistList(prySvrId);
				//delete t_pry_actstate_cng_g
				proxySettingService.deleteProxyActStateConfHistList(prySvrId);
				//delete t_pry_svr_status_g
				proxySettingService.deleteProxySvrStatusHistList(prySvrId);
				//delete t_pry_lsn_svr_i 
				proxySettingService.deletePryListenerSvrList(prySvrId);
				//delete t_pry_lsn_i
				proxySettingService.deletePryListenerList(prySvrId);
				//delete t_pry_vipcng_i
				proxySettingService.deletePryVipConfList(prySvrId);
				//delete t_pry_glb_i
				proxySettingService.deleteGlobalConfList(prySvrId);
				//delete t_pry_svr_i
				proxySettingService.deleteProxyServer(prySvrId);
				
				resultObj.put("result",true);
				resultObj.put("errMsg","작업이 완료되었습니다.");
				txManager.commit(status);
				
				CmmnUtils.saveHistory(request, historyVO);
				// 화면접근이력 이력 남기기
				historyVO.setExe_dtl_cd("DX-T0159_06");//Proxy 설정관리 - 서버 삭제
				historyVO.setMnu_id(45);
				accessHistoryService.insertHistory(historyVO);
				
			}
		} catch (Exception e) {
			e.printStackTrace();
			resultObj.put("result",false);
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
			CmmnUtils.saveHistory(request, historyVO);

			// 화면접근이력 이력 남기기
			historyVO.setExe_dtl_cd("DX-T0159_07");//Proxy 설정관리 - 서버 정보 조회
			historyVO.setMnu_id(45);
			accessHistoryService.insertHistory(historyVO);
			
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
	public int getIntOfJsonObj(JSONObject jobj, String key){
		return Integer.parseInt(String.valueOf(jobj.get(key)));
	}
	
	public String getStringOfJsonObj(JSONObject jobj, String key){
		return String.valueOf(jobj.get(key));
	}
	
	public boolean nullCheckOfJsonObj(JSONObject jobj, String key){
		if(jobj.get(key) == null || "".equals(jobj.get(key))){
			return true;
		}else{
			return false;
		}
	}
	
	public boolean zeroCheckOfJsonObj(JSONObject jobj, String key){
		if(jobj.get(key) == null || Integer.parseInt(jobj.get(key).toString()) == 0 ){
			return true;
		}else{
			return false;
		}
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
		
		JSONObject resultObj = null;
		TransactionStatus status = txManager.getTransaction(def);
		try {	
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultObj;
			}else{
				resultObj = new JSONObject();
				
				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				String lst_mdfr_id = loginVo.getUsr_id();
				
				JSONParser jparser = new JSONParser();
				JSONObject confData = new JSONObject();
				confData = (JSONObject)jparser.parse(request.getParameter("confData").replaceAll("&quot;", "\""));
				
				System.out.println(confData.toJSONString());
				
				int prySvrId = getIntOfJsonObj(confData,"pry_svr_id");
				
				ProxyGlobalVO global = new ProxyGlobalVO();
				global.setCl_con_max_tm(getStringOfJsonObj(confData,"cl_con_max_tm"));
				global.setCon_del_tm(getStringOfJsonObj(confData,"con_del_tm"));
				global.setSvr_con_max_tm(getStringOfJsonObj(confData,"svr_con_max_tm"));
				global.setChk_tm(getStringOfJsonObj(confData,"chk_tm"));
				global.setIf_nm(getStringOfJsonObj(confData,"if_nm"));
				global.setObj_ip(getStringOfJsonObj(confData,"obj_ip"));
				global.setPeer_server_ip(getStringOfJsonObj(confData,"peer_server_ip"));
				global.setPry_svr_id(prySvrId);
				global.setPry_glb_id(getIntOfJsonObj(confData,"pry_glb_id"));
				global.setMax_con_cnt(getIntOfJsonObj(confData,"max_con_cnt"));
				global.setLst_mdfr_id(lst_mdfr_id);
				
				System.out.println("update global conf info ----------------------------------------");
				System.out.println(CommonUtil.toMap(global).toString());
				//update global conf Info
				proxySettingService.updateProxyGlobalConf(global);
				
				JSONArray vipcngJArray = (JSONArray)confData.get("vipcng");
				int vipcngSize = vipcngJArray.size();
				ProxyVipConfigVO vipConf[] = new ProxyVipConfigVO[vipcngSize];
				for(int i=0; i<vipcngSize; i++){
					JSONObject vipcngJobj = (JSONObject)vipcngJArray.get(i);
					System.out.println(vipcngJobj.toJSONString());
					vipConf[i] = new ProxyVipConfigVO();
					vipConf[i].setPry_svr_id(prySvrId);
					if(!nullCheckOfJsonObj(vipcngJobj, "vip_cng_id")){
						vipConf[i].setVip_cng_id(getIntOfJsonObj(vipcngJobj,"vip_cng_id"));
					}
					vipConf[i].setV_ip(getStringOfJsonObj(vipcngJobj,"v_ip"));
					vipConf[i].setV_rot_id(getStringOfJsonObj(vipcngJobj, "v_rot_id"));
					vipConf[i].setChk_tm(getIntOfJsonObj(vipcngJobj,"chk_tm"));
					vipConf[i].setV_if_nm(getStringOfJsonObj(vipcngJobj,"v_if_nm"));
					vipConf[i].setPriority(getIntOfJsonObj(vipcngJobj,"priority"));
					vipConf[i].setState_nm(getStringOfJsonObj(vipcngJobj,"state_nm"));
					vipConf[i].setLst_mdfr_id(lst_mdfr_id);
					
					System.out.println("insert/update vip instance info ----------------------------------------");
					System.out.println(CommonUtil.toMap(vipConf[i]).toString());
					//insert/update vip instance
					proxySettingService.insertUpdatePryVipConf(vipConf[i]);
				}
				
				JSONArray delVipcngJArray = (JSONArray)confData.get("delVipcng");
				int delVipcngSize = delVipcngJArray.size();
				ProxyVipConfigVO delVipConf[] = new ProxyVipConfigVO[delVipcngSize];
				for(int i=0; i<delVipcngSize; i++){
					JSONObject delVipcngJobj = (JSONObject)delVipcngJArray.get(i);
					System.out.println(delVipcngJobj.toJSONString());
					delVipConf[i] = new ProxyVipConfigVO();
					delVipConf[i].setPry_svr_id(prySvrId);
					delVipConf[i].setVip_cng_id(getIntOfJsonObj(delVipcngJobj,"vip_cng_id"));
					
					System.out.println("delete vip instance info ----------------------------------------");
					System.out.println(CommonUtil.toMap(delVipConf[i]).toString());
					//delete vip instance
					proxySettingService.deletePryVipConf(delVipConf[i]);
				}
				
				JSONArray listenerJArray = (JSONArray)confData.get("listener");
				int listenerSize = listenerJArray.size();
				ProxyListenerVO listener[] = new ProxyListenerVO[listenerSize];
				for(int i=0; i<listenerSize; i++){
					JSONObject listenerObj = (JSONObject)listenerJArray.get(i);
					System.out.println(listenerObj.toJSONString());
					listener[i] = new ProxyListenerVO();
					listener[i].setPry_svr_id(prySvrId);
					if(!nullCheckOfJsonObj(listenerObj, "lsn_id")){
						listener[i].setLsn_id(getIntOfJsonObj(listenerObj, "lsn_id"));
					}
					listener[i].setCon_bind_port(getStringOfJsonObj(listenerObj, "con_bind_port"));
					listener[i].setLsn_desc(getStringOfJsonObj(listenerObj,"lsn_desc"));
					listener[i].setDb_usr_id(getStringOfJsonObj(listenerObj, "db_usr_id"));
					listener[i].setDb_id(getIntOfJsonObj(listenerObj,"db_id"));
					listener[i].setDb_nm(getStringOfJsonObj(listenerObj, "db_nm"));
					listener[i].setCon_sim_query(getStringOfJsonObj(listenerObj, "con_sim_query"));
					listener[i].setField_nm(getStringOfJsonObj(listenerObj, "field_nm"));
					listener[i].setField_val(getStringOfJsonObj(listenerObj, "field_val"));
					listener[i].setLst_mdfr_id(lst_mdfr_id);
					
					System.out.println("insert/update proxy listenener info ----------------------------------------");
					System.out.println(CommonUtil.toMap(listener[i]).toString());
					//UPDATE/INSERT PROXY LISTENER
					proxySettingService.insertUpdatePryListener(listener[i]);
					
					if(listenerObj.get("lsn_svr_edit_list") != null){
						JSONArray listnSvrArry = (JSONArray) listenerObj.get("lsn_svr_edit_list");
						int listnSvrSize = listnSvrArry.size();
						ProxyListenerServerVO listnSvr[] = new ProxyListenerServerVO[listnSvrSize];
						for(int j=0; j<listnSvrSize; j++){
							JSONObject listnSvrObj = (JSONObject)listnSvrArry.get(j);
							listnSvr[j] = new ProxyListenerServerVO();
							listnSvr[j].setPry_svr_id(prySvrId);
							
							if(!nullCheckOfJsonObj(listnSvrObj, "lsn_id")){//newLsnId
								listnSvr[j].setLsn_id(getIntOfJsonObj(listnSvrObj, "lsn_id"));
							}else{
								int newLsnId = proxySettingService.selectPryListenerMaxId();
								System.out.println("newLsnID ----------------------------------------------------------------- :: "+newLsnId);
								listnSvr[j].setLsn_id(newLsnId);
							}
							
							if(!nullCheckOfJsonObj(listnSvrObj, "lsn_svr_id")){
								listnSvr[j].setLsn_svr_id(getIntOfJsonObj(listnSvrObj, "lsn_svr_id"));
							}
							listnSvr[j].setDb_con_addr(getStringOfJsonObj(listnSvrObj,"db_con_addr"));
							listnSvr[j].setChk_portno(getIntOfJsonObj(listnSvrObj, "chk_portno"));
							listnSvr[j].setBackup_yn(getStringOfJsonObj(listnSvrObj,"backup_yn"));
							listnSvr[j].setLst_mdfr_id(lst_mdfr_id);
							
							System.out.println("insert/update proxy listenener Server info ----------------------------------------");
							System.out.println(CommonUtil.toMap(listnSvr[j]).toString());
							//UPDATE/INSERT PROXY LISTENER Server List
							proxySettingService.insertUpdatePryListenerSvr(listnSvr[j]);
						}
					}
					
					if(listenerObj.get("lsn_svr_del_list") != null){
						JSONArray delListnSvrArry = (JSONArray) listenerObj.get("lsn_svr_del_list"); 
						int delListnSvrSize = delListnSvrArry.size();
						ProxyListenerServerVO delListnSvr[] = new ProxyListenerServerVO[delListnSvrSize];
						for(int j=0; j<delListnSvrSize; j++){
							JSONObject delListnSvrObj = (JSONObject)delListnSvrArry.get(j);
							delListnSvr[j] = new ProxyListenerServerVO();
							delListnSvr[j].setPry_svr_id(prySvrId);
							delListnSvr[j].setLsn_id(getIntOfJsonObj(delListnSvrObj, "lsn_id"));
							delListnSvr[j].setLsn_svr_id(getIntOfJsonObj(delListnSvrObj, "lsn_svr_id"));
							delListnSvr[j].setDb_con_addr(getStringOfJsonObj(delListnSvrObj, "db_con_addr"));
							System.out.println("delete proxy listenener Server info ----------------------------------------");
							System.out.println(CommonUtil.toMap(delListnSvr[j]).toString());
							//delete proxy listener server list
							proxySettingService.deletePryListenerSvr(delListnSvr[j]);
						}
					}
				}
				
				
				JSONArray delListnJArray = (JSONArray)confData.get("delListener");
				int delListnSize = delListnJArray.size();
				ProxyListenerVO delListn[] = new ProxyListenerVO[delListnSize];
				for(int i=0; i<delListnSize; i++){
					JSONObject delListnObj = (JSONObject)delListnJArray.get(i);
					delListn[i] = new ProxyListenerVO();
					delListn[i].setPry_svr_id(prySvrId);
					delListn[i].setLsn_id(getIntOfJsonObj(delListnObj,"lsn_id"));
					
					System.out.println("delete proxy listenener info ----------------------------------------");
					System.out.println(CommonUtil.toMap(delListn[i]).toString());
					//delete proxy listener
					proxySettingService.deletePryListener(delListn[i]);
				}
				
				//agent 호출  > conf를 만들어서 던져??? agent에서 만들어??
				
				
				//agent가 할 일
				//conf 파일 만들어?? conf 신규 반영
				//
				
				//재기동 이력 남기기 
				//이전 config 파일 이력 남기기
				
				//기동 상태 return 받으면 ... 
				
				
				resultObj.put("result",true);
				resultObj.put("errMsg","작업이 완료되었습니다.");
				
				CmmnUtils.saveHistory(request, historyVO);
				// 화면접근이력 이력 남기기
				historyVO.setExe_dtl_cd("DX-T0159_09");//Proxy 설정관리 - 서버 삭제
				historyVO.setMnu_id(45);
				accessHistoryService.insertHistory(historyVO);
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
	
}
