package com.experdb.management.proxy.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.experdb.management.proxy.service.ProxyAgentService;
import com.experdb.management.proxy.service.ProxyAgentVO;
import com.experdb.management.proxy.service.ProxySettingService;
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityService;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.CmmnCodeDtlService;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.login.service.LoginVO;

/**
 *Proxy 설정관리
 *
 * @author 최정환
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2021.03.03   최정환		 최초 생성
 *      </pre>
 */
@Controller
@RequestMapping("/proxyAgent")
public class ProxyAgentController {

	@Autowired
	private ProxySettingService proxySettingService;
	@Autowired
	private ProxyAgentService proxyAgentService;

	@Autowired
	private MenuAuthorityService menuAuthorityService;

	private List<Map<String, Object>> menuAut;
	
	private String sohw_menu_id = "55";

	/**
	 * proxy Agent 모니터링 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/proxyAgent.do")
	public ModelAndView agentMonitoring(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, ModelMap model) {
		
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001805");
		
		ModelAndView mv = new ModelAndView();

		try {
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{
				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");

				// 화면접근이력 이력 남기기 - Proxy 설정 관리 화면
				proxySettingService.accessSaveHistory(request, historyVO, "DX-T0161", sohw_menu_id);

				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
				
				int agentSize = proxyAgentService.selectAgentCount();
				mv.addObject("agent_size", agentSize);
				mv.addObject("aut_id", loginVo.getAut_id());

				mv.setViewName("proxy/agent/proxyAgentMonitoring");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * proxy agent 목록 조회
	 * 
	 * @param historyVO, proxyAgentVO, response, request
	 * @return List<ProxyAgentVO>
	 */
	@RequestMapping(value = "/selectProxyAgentList.do")
	@ResponseBody
	public List<ProxyAgentVO> selectProxyAgentList(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("proxyAgentVO") ProxyAgentVO proxyAgentVO, HttpServletResponse response, HttpServletRequest request) {
		
		List<ProxyAgentVO> resultSet = null;
		
		try {
			// 화면접근이력 이력 남기기 - Proxy agent 목록 조회
			proxySettingService.accessSaveHistory(request, historyVO, "DX-T0161_01", sohw_menu_id);

			resultSet = proxyAgentService.selectProxyAgentList(proxyAgentVO);
		}catch(Exception e){
			e.printStackTrace();
		}
		return resultSet;
	}
	
	/**
	 * proxy agent 기동 / 정지 실행
	 * @param response, request
	 * @return result
	 * @throws
	 */
	@RequestMapping(value = "/proxyAgentExcute.do")
	@ResponseBody
	public String proxyAgentExcute(HttpServletResponse response, HttpServletRequest request) {
		String result = "fail";

		try {
			ProxyAgentVO proxyAgentVO = new ProxyAgentVO();
			proxyAgentVO.setAgt_sn(Integer.parseInt(request.getParameter("agt_sn")));
			proxyAgentVO.setIpadr(request.getParameter("ipadr").toString());
			proxyAgentVO.setSocket_port(Integer.parseInt(request.getParameter("socket_port")));
			proxyAgentVO.setAgt_cndt_cd(request.getParameter("agt_cndt_cd").toString());

			result = proxyAgentService.proxyAgentExcute(proxyAgentVO);	
		} catch (Exception e) {
			result = "fail";
			e.printStackTrace();
		}
		return result;
	}
}