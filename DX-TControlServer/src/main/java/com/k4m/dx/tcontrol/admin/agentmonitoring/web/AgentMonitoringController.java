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
	private AgentMonitoringService aentMonitoringService;

	/**
	 * Agent 모니터링 화면을 보여준다.
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
			// Agent모니터링 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0037");
			accessHistoryService.insertHistory(historyVO);
			
			String strDB_SVR_NM = request.getParameter("DB_SVR_NM");
			
			if(strDB_SVR_NM == null) strDB_SVR_NM = "";
			
			AgentMonitoringVO vo = new AgentMonitoringVO();
			vo.setDB_SVR_NM(strDB_SVR_NM);
			
			List<AgentMonitoringVO> list = (List<AgentMonitoringVO>) aentMonitoringService.selectAgentMonitoringList(vo);
			
			model.addAttribute("list", list);
			
			mv.setViewName("admin/agentMonitoring/agentMonitoring");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;

	}
}
