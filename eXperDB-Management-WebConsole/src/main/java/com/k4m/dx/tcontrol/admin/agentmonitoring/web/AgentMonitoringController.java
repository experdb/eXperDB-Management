package com.k4m.dx.tcontrol.admin.agentmonitoring.web;

import java.io.FileNotFoundException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityService;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.encrypt.service.call.AgentMonitoringServiceCall;
import com.k4m.dx.tcontrol.encrypt.service.call.CommonServiceCall;
import com.k4m.dx.tcontrol.encrypt.service.call.UserManagerServiceCall;
import com.k4m.dx.tcontrol.login.service.LoginVO;

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

	@Autowired
	private MenuAuthorityService menuAuthorityService;
	
	private List<Map<String, Object>> menuAut;
	
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
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000702");	
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
				
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0123");
				historyVO.setMnu_id(20);
				accessHistoryService.insertHistory(historyVO);
				
				mv.setViewName("admin/agentMonitoring/encryptAgentMonitoring");
			}

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
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		String restIp = loginVo.getRestIp();
		int restPort = loginVo.getRestPort();
		String strTocken = loginVo.getTockenValue();
		String loginId = loginVo.getUsr_id();
		String entityId = loginVo.getEctityUid();

		try {		
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0123");
			historyVO.setMnu_id(20);
			accessHistoryService.insertHistory(historyVO);
										
			CommonServiceCall csc = new CommonServiceCall();			
			AgentMonitoringServiceCall amsc = new AgentMonitoringServiceCall();		
			
			try{
				agentList = csc.selectEntityList2(restIp, restPort, strTocken, loginId, entityId);	
				if(agentList.size()==0){
					result.put("resultCode", "0000000000");
					return result;
				}
			}catch(Exception e){
				result.put("resultCode", "8000000002");
				return result;
			}
			
			agentStatusList = amsc.selectSystemStatus(restIp, restPort, strTocken, loginId, entityId);
			
			for(int j=0; j<agentStatusList.size(); j++){
				for(int m=0; m<agentList.size(); m++){
					JSONObject jsonObj = (JSONObject) agentStatusList.get(j);
					if(jsonObj.get("monitoredName").equals(agentList.get(m).get("createName"))){	
						JSONObject jObj = new JSONObject();			
						jObj.put("getEntityUid", agentList.get(m).get("getEntityUid"));
						jObj.put("monitoredName", jsonObj.get("monitoredName"));
						jObj.put("status", "stop");
						jObj.put("resultCode", jsonObj.get("resultCode"));
						jObj.put("resultMessage", jsonObj.get("resultMessage"));
						tResult.add(jObj);
					}
				}
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
					addList.put("getEntityUid", agentList.get(k).get("getEntityUid"));
					addList.put("monitoredName", agentList.get(k).get("createName"));
					addList.put("status", "start");
					tResult.add(addList);
				}
			}
			result.put("list", tResult);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}		
	
	
	/**
	 * 에이전트를 삭제한다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return 
	 * @throws Exception
	 */
	@RequestMapping(value = "/deleteEncryptAgentMonitoring.do")
	public @ResponseBody JSONObject deleteEncryptAgentMonitoring(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletResponse response, HttpServletRequest request) {
		UserManagerServiceCall uic= new UserManagerServiceCall();
		JSONObject result = new JSONObject();
		try {
//			CmmnUtils cu = new CmmnUtils();
//			menuAut = cu.selectMenuAut(menuAuthorityService, "MN0004");
//			
//			//쓰기권한이 없는경우
//			if(menuAut.get(0).get("wrt_aut_yn").equals("N")){
//				response.sendRedirect("/autError.do");
//			}
			
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0123_02");
			historyVO.setMnu_id(20);
			accessHistoryService.insertHistory(historyVO);
			
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String strTocken = loginVo.getTockenValue();
			String loginId = loginVo.getUsr_id();
			String entityId = loginVo.getEctityUid();
			String restIp = loginVo.getRestIp();
			int restPort = loginVo.getRestPort();		
			
			String[] param = request.getParameter("entityuid").toString().split(",");
			for (int i = 0; i < param.length; i++) {
				try{
					result = uic.deleteEntity(restIp, restPort, strTocken, loginId, entityId, param[i]);
				}catch (Exception e) {
					result.put("resultCode", "8000000002");
					return result;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
}
