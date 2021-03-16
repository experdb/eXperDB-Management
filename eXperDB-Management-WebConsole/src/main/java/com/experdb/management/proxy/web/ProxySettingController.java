package com.experdb.management.proxy.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

//import com.experdb.management.proxy.cmmn.CommonUtil;
import com.experdb.management.proxy.service.ProxyAgentVO;
import com.experdb.management.proxy.service.ProxyGlobalVO;
import com.experdb.management.proxy.service.ProxyListenerVO;
import com.experdb.management.proxy.service.ProxyServerVO;
import com.experdb.management.proxy.service.ProxySettingService;
import com.experdb.management.proxy.service.ProxyVipConfigVO;
import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityService;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.cmmn.SHA256;
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
				historyVO.setExe_dtl_cd("DX-T0159");
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
				historyVO.setExe_dtl_cd("DX-T0159_01");
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
				historyVO.setExe_dtl_cd("DX-T0159_02");
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
				historyVO.setExe_dtl_cd("DX-T0159_03");
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
	 * Proxy 서버 리스트를 조회한다.
	 * 
	 * @param request
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectPoxyServerTable.do")
	public @ResponseBody List<ProxyServerVO> selectPoxyServerTable(HttpServletRequest request, HttpServletResponse response) {
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
	 * 프록시 서버 정보 
	 * 
	 * @param request
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/getPoxyServerConf.do")
	public @ResponseBody JSONObject getPoxyServerConf(HttpServletRequest request, HttpServletResponse response) {
		
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
					
					//Global 정보
					ProxyGlobalVO globalInfo = proxySettingService.selectProxyGlobal(param);
					System.out.println("global_info");
					resultObj.put("global_info", globalInfo);
					//Proxy Listener List 정보
					List<ProxyListenerVO> listenerList = proxySettingService.selectProxyListenerList(param);	
					System.out.println(listenerList);
					resultObj.put("listener_list", listenerList);
					//VIP List 정보
					List<ProxyVipConfigVO> vipConfigList = proxySettingService.selectProxyVipConfList(param);	
					System.out.println(vipConfigList);
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
	public @ResponseBody Map<String, Object> proxyServerReg(HttpServletRequest request, HttpServletResponse response) {
		System.out.println("/prySvrReg.do");
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001802");
				
		DefaultTransactionDefinition def  = new DefaultTransactionDefinition();
		
		Map<String, Object> resultObj = null;
		TransactionStatus status = txManager.getTransaction(def);
		try {	
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
	
	/*
	*//**
	 * 사용자 리스트를 조회한다.
	 * 
	 * @param request
	 * @return resultSet
	 * @throws Exception
	 *//*
	@RequestMapping(value = "/selectMenuAutUserManager.do")
	public @ResponseBody List<UserVO> selectUserManager(HttpServletRequest request, HttpServletResponse response) {
		
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000501");
				
		List<UserVO> resultSet = null;
		Map<String, Object> param = new HashMap<String, Object>();
		try {	
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultSet;
			}else{
				String type=request.getParameter("type");
				String search = request.getParameter("search");
				String use_yn = request.getParameter("use_yn");
							
				param.put("type", type);
				param.put("search", search);
				param.put("use_yn", use_yn);
			
				resultSet = userManagerService.selectUserManager(param);	
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;

	}
	
	
	*//**
	 * 메뉴권한정보 조회
	 * 
	 * @return resultSet
	 * @throws Exception
	 *//*
	@SuppressWarnings("unused")
	@RequestMapping(value = "/menuAuthorityList.do")
	@ResponseBody
	public List<MenuAuthorityVO> menuAuthorityList(@ModelAttribute("menuAuthorityVO") MenuAuthorityVO menuAuthorityVO, HttpServletRequest request, HttpServletResponse response) {
		
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000501");
				
		List<MenuAuthorityVO> resultSet = null;
		try {		
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				System.out.println("@@@@@@@@@@@@@@@@@@@@");
				response.sendRedirect("/autError.do");
				return resultSet;
			}else{
				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				String usr_id = loginVo.getUsr_id();
				
				menuAuthorityVO.setUsr_id(usr_id);
				
				resultSet = menuAuthorityService.selectUsrmnuautList(menuAuthorityVO);		
			//}	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}	
	
	
	*//**
	 * 사용자메뉴권한정보 조회
	 * 
	 * @return resultSet
	 * @throws Exception
	 *//*
	@SuppressWarnings("unused")
	@RequestMapping(value = "/selectUsrmnuautList.do")
	@ResponseBody
	public List<MenuAuthorityVO> selectUsrmnuautList(@ModelAttribute("userVo") UserVO userVo, @ModelAttribute("menuAuthorityVO") MenuAuthorityVO menuAuthorityVO, HttpServletResponse response) {
		
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000501");
				
		List<MenuAuthorityVO> resultSet = null;
		List<MenuAuthorityVO> addMenu = null;
		try {		
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultSet;
			}else{
				
				addMenu=menuAuthorityService.selectAddMenu(menuAuthorityVO);
				
				//추가된 메뉴조회 하여, 있을경우 추가된 메뉴 권한 N, 등록
				if(addMenu.size() > 0){
					for(int i =0; i<addMenu.size(); i++){
						userVo.setMnu_id(addMenu.get(i).getMnu_id());
						menuAuthorityService.insertUsrmnuaut(userVo);
					}
				}
				
				resultSet = menuAuthorityService.selectUsrmnuautList(menuAuthorityVO);		
			}	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}	

	
	*//**
	 * 메뉴권한 업데이트
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 *//*
	@RequestMapping(value = "/updateUsrMnuAut.do")
	@ResponseBody
	public void updateUsrMnuAut(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000501");

		try {
			//쓰기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("wrt_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
			}else{
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0036_01");
				historyVO.setMnu_id(14);
				accessHistoryService.insertHistory(historyVO);
							
				String strRows = request.getParameter("datasArr").toString().replaceAll("&quot;", "\"");
				JSONArray rows = (JSONArray) new JSONParser().parse(strRows);
				
				for(int i=0; i<rows.size(); i++){
					JSONObject jsonObject = (JSONObject) rows.get(i);
					int mnu_id=menuAuthorityService.selectMenuId(jsonObject.get("mnu_cd").toString());			
					Map<String, Object> param = new HashMap<String, Object>();
					param.put("mnu_id", mnu_id);
					param.put("usr_id", jsonObject.get("usr_id").toString());
					param.put("read_aut_yn", jsonObject.get("read_aut_yn").toString());
					param.put("wrt_aut_yn", jsonObject.get("wrt_aut_yn").toString());
					menuAuthorityService.updateUsrMnuAut(param);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	*//**
	 * 전송설정 메뉴권한정보 조회
	 * 
	 * @return resultSet
	 * @throws Exception
	 *//*
	@SuppressWarnings("unused")
	@RequestMapping(value = "/transferAuthorityList.do")
	@ResponseBody
	public List<MenuAuthorityVO> transferAuthorityList(@ModelAttribute("menuAuthorityVO") MenuAuthorityVO menuAuthorityVO, HttpServletRequest request, HttpServletResponse response) {
			
		List<MenuAuthorityVO> resultSet = null;
		try {		
				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				String usr_id = loginVo.getUsr_id();
				
				menuAuthorityVO.setUsr_id(usr_id);
				
				resultSet = menuAuthorityService.transferAuthorityList(menuAuthorityVO);				
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}	*/
}
