package com.k4m.dx.tcontrol.admin.agentmonitoring.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.agentmonitoring.service.AgentMonitoringService;
import com.k4m.dx.tcontrol.admin.agentmonitoring.service.AgentMonitoringVO;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.HistoryVO;

/**
 * Agent 모니터링 컨트롤러 클래스를 정의한다.
 *
 * @author 김주영
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.05.30   김주영 최초 생성
 *      </pre>
 */

@Controller
public class AgentMonitoringController {

	@Autowired
	private AccessHistoryService accessHistoryService;
	
	@Autowired
	private AgentMonitoringService agentMonitoringService;

	/**
	 * Management Agent 모니터링 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/agentMonitoring.do")
	public ModelAndView agentMonitoring(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, ModelMap model) {
		ModelAndView mv = new ModelAndView();
		try {
				
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0040");
			historyVO.setMnu_id(20);
			accessHistoryService.insertHistory(historyVO);
			
			String strDB_SVR_NM = request.getParameter("DB_SVR_NM");
			String strIPADR = request.getParameter("IPADR");
			
			if(strDB_SVR_NM == null && strIPADR ==null) {
				strDB_SVR_NM = "";
				strIPADR ="";
			}else{
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0040_01");
				historyVO.setMnu_id(20);
				accessHistoryService.insertHistory(historyVO);
			}
			
			AgentMonitoringVO vo = new AgentMonitoringVO();
			vo.setDB_SVR_NM(strDB_SVR_NM);
			vo.setIPADR(strIPADR);
			
			List<AgentMonitoringVO> list = (List<AgentMonitoringVO>) agentMonitoringService.selectAgentMonitoringList(vo);

			
			model.addAttribute("list", list);
			model.addAttribute("db_svr_nm",strDB_SVR_NM);
			model.addAttribute("ipadr",strIPADR);
			
			mv.setViewName("admin/agentMonitoring/agentMonitoring");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;

	}
	
	
	/**
	 * Encrypt Agent 모니터링 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/encryptAgentMonitoring.do")
	public ModelAndView encryptAgentMonitoring(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, ModelMap model) {
		ModelAndView mv = new ModelAndView();
		try {
			mv.setViewName("admin/agentMonitoring/encryptAgentMonitoring");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;

	}
}
