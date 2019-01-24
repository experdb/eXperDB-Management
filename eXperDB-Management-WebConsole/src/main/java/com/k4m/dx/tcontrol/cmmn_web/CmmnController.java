package com.k4m.dx.tcontrol.cmmn_web;

import java.util.ArrayList;
import java.util.HashMap;
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
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.backup.service.BackupService;
import com.k4m.dx.tcontrol.backup.service.WorkVO;
import com.k4m.dx.tcontrol.cmmn.AES256;
import com.k4m.dx.tcontrol.cmmn.AES256_KEY;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.cmmn.client.ClientAdapter;
import com.k4m.dx.tcontrol.cmmn.client.ClientInfoCmmn;
import com.k4m.dx.tcontrol.cmmn.client.ClientProtocolID;
import com.k4m.dx.tcontrol.cmmn.client.ClientTranCodeType;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.SystemCode;
import com.k4m.dx.tcontrol.common.service.AgentInfoVO;
import com.k4m.dx.tcontrol.common.service.CmmnServerInfoService;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.dashboard.service.DashboardService;
import com.k4m.dx.tcontrol.dashboard.service.DashboardVO;
import com.k4m.dx.tcontrol.encrypt.service.call.AgentMonitoringServiceCall;
import com.k4m.dx.tcontrol.encrypt.service.call.CommonServiceCall;
import com.k4m.dx.tcontrol.encrypt.service.call.StatisticsServiceCall;
import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleService;
import com.k4m.dx.tcontrol.login.service.LoginVO;
import com.k4m.dx.tcontrol.script.service.ScriptService;

/**
 * 공통 컨트롤러 클래스를 정의한다.
 *
 * @author 변승우
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.05.24   변승우 최초 생성
 *      </pre>
 */

@Controller
public class CmmnController {
	
	@Autowired
	private ScriptService scriptService;
	
	@Autowired
	private BackupService backupService;
	
	@Autowired
	private AccessHistoryService accessHistoryService;
	
	@Autowired
	private CmmnServerInfoService cmmnServerInfoService;
	
	@Autowired
	private DashboardService dashboardService;
	
	@Autowired
	private ScheduleService scheduleService;
	
	
	/**
	 * 메인(홈)을 보여준다.
	 * @return ModelAndView mv
	 */	
	@RequestMapping(value = "/experdb.do")
	public ModelAndView experdb(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, ModelMap model) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("experdb/body");
		return mv;	
	}
	
	/**
	 * 대시보드화면을 보여준다.
	 * @return ModelAndView mv
	 */	
	@RequestMapping(value = "/dashboard.do")
	public ModelAndView dashboard(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, ModelMap model) throws Exception {
		ModelAndView mv = new ModelAndView();
		try {
			// 메인 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0004");
			accessHistoryService.insertHistory(historyVO);

			AES256 dec = new AES256(AES256_KEY.ENC_KEY);

			// 스케줄 정보
			DashboardVO scheduleInfoVO = (DashboardVO) dashboardService.selectDashboardScheduleInfo();

			// 백업정보
			DashboardVO backupInfoVO = (DashboardVO) dashboardService.selectDashboardBackupInfo();

			DashboardVO dashVo = new DashboardVO();

			// DBMS정보(DB전체 개수 조회, audit 설정 조회)
			List<DashboardVO> serverInfoVOSelect = (List<DashboardVO>) dashboardService.selectDashboardServerInfo(dashVo);
			List<DashboardVO> serverInfoVO = new ArrayList<DashboardVO>();
			if(serverInfoVOSelect.size()>0){
				for(int i=0; i<serverInfoVOSelect.size(); i++){
					dashVo = new DashboardVO();
					String db_svr_nm = serverInfoVOSelect.get(i).getDb_svr_nm();
					List<DbServerVO> resultSet = cmmnServerInfoService.selectDbServerList(db_svr_nm);
					AgentInfoVO vo = new AgentInfoVO();
					vo.setIPADR(resultSet.get(i).getIpadr());
					AgentInfoVO agentInfo = (AgentInfoVO)cmmnServerInfoService.selectAgentInfo(vo);
					String IP = resultSet.get(i).getIpadr();
					int PORT = agentInfo.getSOCKET_PORT();
					JSONObject serverObj = new JSONObject();
					serverObj.put(ClientProtocolID.SERVER_NAME,resultSet.get(i).getDb_svr_nm());
					serverObj.put(ClientProtocolID.SERVER_IP,resultSet.get(i).getIpadr());
					serverObj.put(ClientProtocolID.SERVER_PORT,resultSet.get(i).getPortno());
					serverObj.put(ClientProtocolID.DATABASE_NAME,resultSet.get(i).getDft_db_nm());
					serverObj.put(ClientProtocolID.USER_ID,resultSet.get(i).getSvr_spr_usr_id());
					serverObj.put(ClientProtocolID.USER_PWD,dec.aesDecode(resultSet.get(i).getSvr_spr_scm_pwd()));
					ClientInfoCmmn cic = new ClientInfoCmmn();
					Map<String, Object> result = new HashMap<String, Object>();
					result = cic.db_List(serverObj, IP, PORT);
					JSONArray data = (JSONArray) result.get("data");
					
					ClientAdapter CA = new ClientAdapter(IP, PORT);
					JSONObject objList;
					CA.open();
					objList = CA.dxT007(ClientTranCodeType.DxT007, ClientProtocolID.COMMAND_CODE_R, serverObj );
					CA.close();
					String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);
					//strResultCode=0 이면 감사 Enabled 아니면 - 표시
					if(strResultCode.equals("0")){
						dashVo.setAudit_state("Enabled");
					}else{
						dashVo.setAudit_state("-");
					}
					dashVo.setDb_svr_nm(serverInfoVOSelect.get(i).getDb_svr_nm());
					dashVo.setIpadr(serverInfoVOSelect.get(i).getIpadr());
					dashVo.setDb_cnt(serverInfoVOSelect.get(i).getDb_cnt());
					dashVo.setUndb_cnt(data.size()-serverInfoVOSelect.get(i).getDb_cnt());
					dashVo.setConnect_cnt(serverInfoVOSelect.get(i).getConnect_cnt());
					dashVo.setExecute_cnt(serverInfoVOSelect.get(i).getExecute_cnt());
					dashVo.setLst_mdf_dtm(serverInfoVOSelect.get(i).getLst_mdf_dtm());
					dashVo.setAgt_cndt_cd(serverInfoVOSelect.get(i).getAgt_cndt_cd());
					serverInfoVO.add(dashVo);
				}
			}

			
			// 백업정보(DUMP)
			List<DashboardVO> backupDumpInfoVO = (List<DashboardVO>) dashboardService.selectDashboardBackupDumpInfo(dashVo);

			// 백업정보(RMAN)
			List<DashboardVO> backupRmanInfoVO = (List<DashboardVO>) dashboardService.selectDashboardBackupRmanInfo(dashVo);

			// 관리상태_작업관리(전체스케줄수행건수)
			int scd_total = dashboardService.selectDashboardScheduleTotal();
			// 관리상태_작업관리(스케줄실패건수)
			int scd_fail = dashboardService.selectDashboardScheduleFail();
			// 작업관리 식 : 100-((실패건수/전체수행건수)*100)
			int wrk_state = (int) (100 - ((double) scd_fail / (double) scd_total * 100));
			System.out.println("작업관리 : " + wrk_state+"%");

			// 관리상태_서버관리(전체서버건수)
			int svr_total = dashboardService.selectDashboardServerTotal();
			// 관리상태_서버관리(사용서버건수)
			int svr_use = dashboardService.selectDashboardServerUse();
			// 관리상태_서버관리(중지되어있는 서버수)
			int svr_death = dashboardService.selectDashboardServerDeath();
			int svr_state = 0;
			if (svr_death == 0) {
				Boolean auditCheck = true;
				List<DbServerVO> dbServerVO = (List<DbServerVO>) dashboardService.selectDashboardServer();
				for (int i = 0; i < dbServerVO.size(); i++) {
					String Ip = dbServerVO.get(i).getIpadr();
					int port = dbServerVO.get(i).getSocket_port();
					JSONObject serverObj = new JSONObject();
					JSONObject objSettingInfo = new JSONObject();
					serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.get(i).getDb_svr_nm());
					serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.get(i).getIpadr());
					serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.get(i).getPortno());
					serverObj.put(ClientProtocolID.DATABASE_NAME, dbServerVO.get(i).getDft_db_nm());
					serverObj.put(ClientProtocolID.USER_ID, dbServerVO.get(i).getSvr_spr_usr_id());
					serverObj.put(ClientProtocolID.USER_PWD, dec.aesDecode(dbServerVO.get(i).getSvr_spr_scm_pwd()));
					JSONObject objList;
					ClientAdapter CA = new ClientAdapter(Ip, port);
					CA.open();
					objList = CA.dxT007(ClientTranCodeType.DxT007, ClientProtocolID.COMMAND_CODE_R, serverObj,objSettingInfo);
					String strResultCode = (String) objList.get(ClientProtocolID.RESULT_CODE);
					System.out.println("RESULT_CODE : " + strResultCode);
					
					CA.close();

					if (!strResultCode.equals("0")) {
						auditCheck = false;
					}
				}
				// audit 설치 되어 있을 시 -> 서버관리 식: (관리건수/총건수)*100
				if (auditCheck == true) {
					 svr_state = (int) ((double)((double)svr_use/(double)svr_total)*100);
				} else {
					// audit 설치 안되어 있을 시 -> 감시로 표시
					svr_state = 35;
				}
			}
			System.out.println("서버관리 : " + svr_state+"%");
			
			// 관리상태_백업관리(전체등록건수)
			int bak_total = dashboardService.selectDashboardBackupTotal();
			// 관리상태_백업관리(실패건수)
			int bak_fail = dashboardService.selectDashboardBackupFail();
			// 관리상태_백업관리(사용하지않는건수)
			int bak_nouse = dashboardService.selectDashboardBackupNouse();
			//백업관리 식 : (미등록건수/등록건수*100)-(실패건수*5)
			int bak_state = (int) ((double) bak_nouse / (double) bak_total * 100) - (bak_fail * 5);
			System.out.println("백업관리 : " + bak_state+"%");

			mv.addObject("scheduleInfo", scheduleInfoVO);
			mv.addObject("backupInfo", backupInfoVO);
			mv.addObject("serverInfo", serverInfoVO);
			mv.addObject("backupDumpInfo", backupDumpInfoVO);
			mv.addObject("backupRmanInfo", backupRmanInfoVO);
			mv.addObject("wrk_state", wrk_state);
			mv.addObject("svr_state", svr_state);
			mv.addObject("bak_state", bak_state);
		} catch (Exception e) {
			e.printStackTrace();
		}
		mv.setViewName("dashboard");
		return mv;
	}


	
	

	
	/**
	 *  권한 에러 화면을 보여준다.
	 * 
	 * @param 
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/autError.do")
	public ModelAndView autError(HttpServletRequest request) {
				
		ModelAndView mv = new ModelAndView();
		try {	
				mv.setViewName("error/autError");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	/**
	 * DB서버에 대한 DB 리스트를 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectServerDBList.do")
	@ResponseBody
	public Map<String, Object> selectServerDBList (@ModelAttribute("dbServerVO") DbServerVO dbServerVO, HttpServletRequest request) {
		
		Map<String, Object> result =new HashMap<String, Object>();
	
		try {
			AES256 aes = new AES256(AES256_KEY.ENC_KEY);
			String db_svr_nm = request.getParameter("db_svr_nm");
			System.out.println(db_svr_nm);
			
			List<DbServerVO> resultSet = cmmnServerInfoService.selectDbServerList(db_svr_nm);
			
			JSONObject serverObj = new JSONObject();
			
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(resultSet.get(0).getIpadr());
			
			AgentInfoVO agentInfo =  (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
			
			String IP = resultSet.get(0).getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();
			
			serverObj.put(ClientProtocolID.SERVER_NAME, resultSet.get(0).getDb_svr_nm());
			serverObj.put(ClientProtocolID.SERVER_IP, resultSet.get(0).getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, resultSet.get(0).getPortno());
			serverObj.put(ClientProtocolID.DATABASE_NAME, resultSet.get(0).getDft_db_nm());
			serverObj.put(ClientProtocolID.USER_ID, resultSet.get(0).getSvr_spr_usr_id());
			serverObj.put(ClientProtocolID.USER_PWD, aes.aesDecode(resultSet.get(0).getSvr_spr_scm_pwd()));
			
				
			ClientInfoCmmn cic = new ClientInfoCmmn();
			result = cic.db_List(serverObj, IP, PORT);
	
			//System.out.println(result);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	

	
	/**
	 * Object 리스트를 조회한다.
	 * @param WorkVO
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/getObjectList.do")
	@ResponseBody
	public Map<String, Object> getObjectList (@ModelAttribute("workVO") WorkVO workVO, HttpServletRequest request) {
		Map<String, Object> result =new HashMap<String, Object>();

		try {
			AES256 aes = new AES256(AES256_KEY.ENC_KEY);
			DbServerVO dbServerVO = backupService.selectDbSvrNm(workVO);
			JSONObject serverObj = new JSONObject();
			
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(dbServerVO.getIpadr());
			
			AgentInfoVO agentInfo =  (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
			
			String IP = dbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();
			
			String db_nm = request.getParameter("db_nm");
			
			serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getDb_svr_nm());
			serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());
			serverObj.put(ClientProtocolID.DATABASE_NAME,  db_nm);
			serverObj.put(ClientProtocolID.USER_ID, dbServerVO.getSvr_spr_usr_id());
			//serverObj.put(ClientProtocolID.USER_PWD, dbServerVO.getSvr_spr_scm_pwd());
			serverObj.put(ClientProtocolID.USER_PWD, aes.aesDecode(dbServerVO.getSvr_spr_scm_pwd()));
			
			ClientInfoCmmn cic = new ClientInfoCmmn();
			result = cic.object_List(serverObj, IP, PORT);
			
			//System.out.println(result);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * 디렉토리 존재유무 체크
	 * @param WorkVO
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/existDirCheck.do")
	@ResponseBody
	public Map<String, Object> existDirCheck (@ModelAttribute("workVO") WorkVO workVO, HttpServletRequest request, @ModelAttribute("dbServerVO") DbServerVO dbServerVO) {
		Map<String, Object> result =new HashMap<String, Object>();
		String directory_path = request.getParameter("path");
		List<DbServerVO> ipResult = null;		
		
		int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
		try {
			ipResult = (List<DbServerVO>) cmmnServerInfoService.selectAllIpadrList(db_svr_id);
			
			for(int i=0; i<ipResult.size(); i++){
				JSONObject serverObj = new JSONObject();
				
				AgentInfoVO vo = new AgentInfoVO();
				vo.setIPADR(ipResult.get(i).getIpadr());
				
				AgentInfoVO agentInfo =  (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
				
				String IP = ipResult.get(i).getIpadr();
				int PORT = agentInfo.getSOCKET_PORT();
				
				serverObj.put(ClientProtocolID.SERVER_NAME, ipResult.get(i).getDb_svr_nm());
				serverObj.put(ClientProtocolID.SERVER_IP, ipResult.get(i).getIpadr());
				serverObj.put(ClientProtocolID.SERVER_PORT, ipResult.get(i).getPortno());

				ClientInfoCmmn cic = new ClientInfoCmmn();
				result = cic.directory_exist(serverObj,directory_path, IP, PORT);	
				

				int resultCd = Integer.parseInt(result.get("resultCode").toString());
				
				if(resultCd == 1){
					return result;
				}
				
			}	
			//System.out.println(result);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	/**
	 * 스케줄 정보
	 * @param 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/selectScdInfo.do")
	@ResponseBody
	public List<Map<String, Object>> selectScdInfo(HttpServletRequest request) {
		List<Map<String, Object>> result = null;
		
		try {
			int scd_id = Integer.parseInt(request.getParameter("scd_id"));
			result = scheduleService.selectScdInfo(scd_id);	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	/**
	 * WORK 정보
	 * @param 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/selectWrkInfo.do")
	@ResponseBody
	public List<Map<String, Object>> selectWrkInfo(HttpServletRequest request) {
		List<Map<String, Object>> result = null;
		
		try {
			int wrk_id = Integer.parseInt(request.getParameter("wrk_id"));
			
			result = scheduleService.selectWrkInfo(wrk_id);	
			System.out.println(result.size());
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}	
	
	
	/**
	 * WORK OPTION 정보(DUMP)
	 * @param 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/workOptionLayer.do")
	@ResponseBody
	public List<Map<String, Object>> workOptionLayer(@ModelAttribute("workVO") WorkVO workVO, HttpServletRequest request) {
		List<Map<String, Object>> result = null;
		
		try {
			int bck_wrk_id = Integer.parseInt(request.getParameter("bck_wrk_id"));	
			result = backupService.selectWorkOptionLayer(bck_wrk_id);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}	

	
	
	
	/**
	 * WORK Object 리스트 조회
	 * @param 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/workObjectListTreeLayer.do")
	@ResponseBody
	public List<Map<String, Object>> workObjectListTreeLayer(@ModelAttribute("workVO") WorkVO workVO, HttpServletRequest request) {
		List<Map<String, Object>> result = null;
		
		try {
			int bck_wrk_id = Integer.parseInt(request.getParameter("bck_wrk_id"));	
			result = backupService.selectWorkObjectLayer(bck_wrk_id);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}	

	
	/**
	 * 아이피 정보
	 * @param 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/selectIpadrList.do")
	@ResponseBody
	public List<Map<String, Object>> selectIpadrList(HttpServletRequest request) {
		List<Map<String, Object>> result = null;
		
		try {
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));			
			result = cmmnServerInfoService.selectIpadrList(db_svr_id);	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}	
	
	
	/**
	 * 작업로그정보
	 * @param 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/selectWrkErrorMsg.do")
	@ResponseBody
	public List<Map<String, Object>> selectWrkErrorMsg(HttpServletRequest request) {
		List<Map<String, Object>> result = null;
		
		try {
			int exe_sn = Integer.parseInt(request.getParameter("exe_sn"));			
			result = cmmnServerInfoService.selectWrkErrorMsg(exe_sn);	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}		
	
	
	/**
	 * HA구성확인
	 * @param 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/selectHaCnt.do")
	@ResponseBody
	public List<Map<String, Object>> selectHaCnt(HttpServletRequest request) {
		List<Map<String, Object>> result = null;
		
		try {
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));			
			result = cmmnServerInfoService.selectHaCnt(db_svr_id);	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}		
	
		
	/**
	 * 대시보드 암호화통계
	 * @param 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/selectDashSecurityStatistics.do")	
	public @ResponseBody JSONObject selectDashSecurityStatistics(HttpServletRequest request) {
		
		JSONArray agentStatusList = new JSONArray();		
		JSONArray tResult = new JSONArray();		
		JSONObject result = new JSONObject();
		
		List<Map<String, Object>> agentList = null;
		List<Map<String, Object>> agentStatusListResult = null;
		
		//통계결과
		JSONObject statisticsResult = new JSONObject();
		List<Map<String, Object>> statisticsListResult = null;
		
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		String restIp = loginVo.getRestIp();
		int restPort = loginVo.getRestPort();
		String strTocken = loginVo.getTockenValue();
		String loginId = loginVo.getUsr_id();
		String entityId = loginVo.getEctityUid();

		try {								
			
			String from = request.getParameter("from");
			String to = request.getParameter("to");
			String categoryColumn = request.getParameter("categoryColumn");
			
			CommonServiceCall csc = new CommonServiceCall();			
			AgentMonitoringServiceCall amsc = new AgentMonitoringServiceCall();		
			
			agentList = csc.selectEntityList2(restIp, restPort, strTocken, loginId, entityId);			
			agentStatusList = amsc.selectSystemStatus(restIp, restPort, strTocken, loginId, entityId);
				
			agentStatusListResult = (List<Map<String, Object>>) agentStatusList;
		
			//암호화통계 결과
			StatisticsServiceCall ssc = new StatisticsServiceCall();
			statisticsResult = ssc.selectAuditLogSiteHourForStat(restIp, restPort, strTocken, loginId, entityId, from, to, categoryColumn);
			statisticsListResult= (List<Map<String, Object>>) statisticsResult.get("list");
			
			if(statisticsListResult.size() == 0){
				result.put("resultCode", statisticsResult.get("resultCode"));
				result.put("resultMessage", statisticsResult.get("resultMessage"));
			}else{
				for(int i=0; i<agentStatusListResult.size(); i++){	
					agentStatusListResult.get(i).put("encryptSuccessCount", "0");
					agentStatusListResult.get(i).put("encryptFailCount", "0");
					agentStatusListResult.get(i).put("decryptSuccessCount", "0");
					agentStatusListResult.get(i).put("decryptFailCount", "0");
					agentStatusListResult.get(i).put("sumCount", "0");
				
					tResult.add(agentStatusListResult.get(i));
				}
			
				if(statisticsListResult.get(0).get("categoryColumn").equals("-")){	
					for(int k=0; k<agentList.size(); k++){
						result.put("resultCode", agentList.get(0).get("resultCode"));
						result.put("resultMessage", agentList.get(0).get("resultMessage"));
						
						agentList.get(k).put("encryptSuccessCount", "0");
						agentList.get(k).put("encryptFailCount", "0");
						agentList.get(k).put("decryptSuccessCount", "0");
						agentList.get(k).put("decryptFailCount", "0");
						agentList.get(k).put("sumCount", "0");
						
						int temp =0;
						for(int i=0; i<agentStatusListResult.size(); i++){					
							if(agentList.get(k).get("createName").equals(agentStatusListResult.get(i).get("monitoredName"))){
								temp ++;
							}
						}
						if(temp == 0){
							JSONObject addList = new JSONObject();
							addList.put("monitoredName", agentList.get(k).get("createName"));
							addList.put("encryptSuccessCount", agentList.get(k).get("encryptSuccessCount"));
							addList.put("encryptFailCount", agentList.get(k).get("encryptFailCount"));
							addList.put("decryptSuccessCount", agentList.get(k).get("decryptSuccessCount"));
							addList.put("decryptFailCount", agentList.get(k).get("decryptFailCount"));
							addList.put("sumCount", agentList.get(k).get("sumCount"));
							addList.put("status", "start");
							tResult.add(addList);
						}
					}				
				}else{
					for(int k=0; k<agentList.size(); k++){
						int temp =0;
						result.put("resultCode", agentList.get(0).get("resultCode"));
						result.put("resultMessage", agentList.get(0).get("resultMessage"));
						for(int i =0; i<statisticsListResult.size(); i++){
							if(agentList.get(k).get("createName").toString().contains(statisticsListResult.get(i).get("categoryColumn").toString())){
								agentList.get(k).put("encryptSuccessCount", statisticsListResult.get(i).get("encryptSuccessCount"));
								agentList.get(k).put("encryptFailCount", statisticsListResult.get(i).get("encryptFailCount"));
								agentList.get(k).put("decryptSuccessCount", statisticsListResult.get(i).get("decryptSuccessCount"));
								agentList.get(k).put("decryptFailCount", statisticsListResult.get(i).get("decryptFailCount"));
								agentList.get(k).put("sumCount", statisticsListResult.get(i).get("sumCount"));
							}
						}						
						for(int i=0; i<agentStatusListResult.size(); i++){
							result.put("resultCode", agentStatusListResult.get(0).get("resultCode"));
							result.put("resultMessage", agentStatusListResult.get(0).get("resultMessage"));
							if(agentList.get(k).get("createName").equals(agentStatusListResult.get(i).get("monitoredName"))){
								temp ++;
							}
						}
						if(temp == 0){
							JSONObject addList = new JSONObject();
							addList.put("monitoredName", agentList.get(k).get("createName"));
							addList.put("encryptSuccessCount", agentList.get(k).get("encryptSuccessCount"));
							addList.put("encryptFailCount", agentList.get(k).get("encryptFailCount"));
							addList.put("decryptSuccessCount", agentList.get(k).get("decryptSuccessCount"));
							addList.put("decryptFailCount", agentList.get(k).get("decryptFailCount"));
							addList.put("sumCount", agentList.get(k).get("sumCount"));
							addList.put("status", "start");
							tResult.add(addList);
						}
					}
	
				}
				
			}
			
			/*for(int k=0; k<agentList.size(); k++){
				int temp =0;
				for(int i=0; i<agentStatusListResult.size(); i++){
					result.put("resultCode", agentStatusListResult.get(0).get("resultCode"));
					result.put("resultMessage", agentStatusListResult.get(0).get("resultMessage"));
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
			}*/
			
			result.put("list", tResult);
			System.out.println("결과="+ result);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}		
	
	
	
	/**
	 * 데시보드 서버상태
	 * @param 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/serverStatus.do")	
	public @ResponseBody JSONObject serverStatus(HttpServletRequest request) {
	
				JSONObject result = new JSONObject();

				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				String restIp = loginVo.getRestIp();
				int restPort = loginVo.getRestPort();
				String strTocken = loginVo.getTockenValue();
				String loginId = loginVo.getUsr_id();
				String entityId = loginVo.getEctityUid();

				try{
					CommonServiceCall csc = new CommonServiceCall();					
					result = csc.selectServerStatus(restIp, restPort, strTocken, loginId, entityId);
				}catch(Exception e){
					result.put("resultCode", "8000000002");
				}
		return result;
	}
	
	
	/**
	 * ScriptWORK 정보
	 * @param 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/selectSciptExeInfo.do")
	@ResponseBody
	public List<Map<String, Object>> selectSciptExeInfo(HttpServletRequest request) {
		List<Map<String, Object>> result = null;
		
		try {
			int wrk_id = Integer.parseInt(request.getParameter("wrk_id"));
			
			result = scriptService.selectSciptExeInfo(wrk_id);	
			System.out.println(result.size());
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}	
	
	
	
}
