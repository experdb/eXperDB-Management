package com.k4m.dx.tcontrol.admin.agentmonitoring.web;

import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.agentmonitoring.service.AgentMonitoringService;
import com.k4m.dx.tcontrol.admin.agentmonitoring.service.AgentMonitoringVO;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.encrypt.service.call.AgentMonitoringServiceCall;
import com.k4m.dx.tcontrol.encrypt.service.call.CommonServiceCall;

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
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0123");
			historyVO.setMnu_id(20);
			accessHistoryService.insertHistory(historyVO);
			
			mv.setViewName("admin/agentMonitoring/encryptAgentMonitoring");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	/**
	 * 암호화 에이전트 상태 조회
	 * @param historyVO
	 * @param request
	 * @return JSON Object result
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/selectEncryptAgentMonitoring.do")
	public @ResponseBody JSONObject selectEncryptAgentMonitoring(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) throws FileNotFoundException {
		
		JSONArray agentStatusList = new JSONArray();
		
		JSONArray tResult = new JSONArray();
		
		JSONObject result = new JSONObject();
		
		List<Map<String, Object>> agentList = null;
		List<Map<String, Object>> agentStatusListResult = null;

		HttpSession session = request.getSession();
		String restIp = (String)session.getAttribute("restIp");
		int restPort = (int)session.getAttribute("restPort");
		String strTocken = (String)session.getAttribute("tockenValue");
		String loginId = (String)session.getAttribute("usr_id");
		String entityId = (String)session.getAttribute("ectityUid");	

		try {		
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0123");
			historyVO.setMnu_id(20);
			accessHistoryService.insertHistory(historyVO);
										
			CommonServiceCall csc = new CommonServiceCall();			
			AgentMonitoringServiceCall amsc = new AgentMonitoringServiceCall();		
			
			agentList = csc.selectEntityList2(restIp, restPort, strTocken, loginId, entityId);			
			agentStatusList = amsc.selectSystemStatus(restIp, restPort, strTocken, loginId, entityId);
			
			for(int j=0; j<agentStatusList.size(); j++){
				tResult.add(agentStatusList.get(j));
			}
					
			agentStatusListResult = (List<Map<String, Object>>) agentStatusList;
			
			for(int k=0; k<agentList.size(); k++){
				result.put("resultCode", agentList.get(0).get("resultCode"));
				result.put("resultMessage", agentList.get(0).get("resultMessage"));
				int temp =0;
				for(int i=0; i<agentStatusListResult.size(); i++){					
					if(agentList.get(k).get("createName").equals(agentStatusListResult.get(i).get("monitoredName"))){
						temp ++;
					}
				}
				if(temp == 0){
					JSONObject addList = new JSONObject();
					addList.put("monitoredName", agentList.get(k).get("createName"));
					addList.put("status", "start");
					tResult.add(addList);
				}
			}
			
			result.put("list", tResult);
			
			System.out.println(result);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}		
}
