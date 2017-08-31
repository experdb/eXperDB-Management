package com.k4m.dx.tcontrol.cmmn_web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

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
import com.k4m.dx.tcontrol.cmmn.client.ClientInfoCmmn;
import com.k4m.dx.tcontrol.cmmn.client.ClientProtocolID;
import com.k4m.dx.tcontrol.common.service.AgentInfoVO;
import com.k4m.dx.tcontrol.common.service.CmmnServerInfoService;
import com.k4m.dx.tcontrol.common.service.CmmnVO;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.dashboard.service.DashboardService;
import com.k4m.dx.tcontrol.dashboard.service.DashboardVO;

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
	private BackupService backupService;
	
	@Autowired
	private AccessHistoryService accessHistoryService;
	
	@Autowired
	private CmmnServerInfoService cmmnServerInfoService;
	
	@Autowired
	private DashboardService dashboardService;
	
	/**
	 * 메인(홈)을 보여준다.
	 * @return ModelAndView mv
	 */	
	@RequestMapping(value = "/index.do")
	public ModelAndView index(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, ModelMap model) throws Exception {
		
		// 메인 이력 남기기
		CmmnUtils.saveHistory(request, historyVO);
		historyVO.setExe_dtl_cd("DX-T0004");
		accessHistoryService.insertHistory(historyVO);
		
		//스케줄 정보
		DashboardVO scheduleInfoVO = (DashboardVO) dashboardService.selectDashboardScheduleInfo();
		
		//백업정보
		DashboardVO backupInfoVO = (DashboardVO) dashboardService.selectDashboardBackupInfo();
		
		DashboardVO vo = new DashboardVO();
		
		List<DashboardVO> serverInfoVO = (List<DashboardVO>) dashboardService.selectDashboardServerInfo(vo);
		
		
		
		
		ModelAndView mv = new ModelAndView();
		mv.addObject("scheduleInfo", scheduleInfoVO);
		mv.addObject("backupInfo", backupInfoVO);
		mv.addObject("serverInfo", serverInfoVO);
		
		mv.setViewName("view/index");
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
	 * Tbale 리스트를 조회한다.
	 * @param WorkVO
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/selectTableList.do")
	@ResponseBody
	public Map<String, Object> selectTableList (@ModelAttribute("workVO") WorkVO workVO, HttpServletRequest request) {
		Map<String, Object> result =new HashMap<String, Object>();

		try {
			AES256 aes = new AES256(AES256_KEY.ENC_KEY);
			DbServerVO dbServerVO = backupService.selectDbSvrNm(workVO);
			JSONObject serverObj = new JSONObject();
			
			serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getDb_svr_nm());
			serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());
			serverObj.put(ClientProtocolID.DATABASE_NAME, dbServerVO.getDft_db_nm());
			serverObj.put(ClientProtocolID.USER_ID, dbServerVO.getSvr_spr_usr_id());
			serverObj.put(ClientProtocolID.USER_PWD, aes.aesDecode(dbServerVO.getSvr_spr_scm_pwd()));
			
			ClientInfoCmmn cic = new ClientInfoCmmn();
			result = cic.table_List(serverObj,  String.valueOf(workVO.getUsr_role_nm()));
			
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
			
			serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getDb_svr_nm());
			serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());
			serverObj.put(ClientProtocolID.DATABASE_NAME, workVO.getDb_nm());
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
	public Map<String, Object> existDirCheck (@ModelAttribute("workVO") WorkVO workVO, HttpServletRequest request) {
		Map<String, Object> result =new HashMap<String, Object>();
		String directory_path = request.getParameter("path");
		try {
			AES256 aes = new AES256(AES256_KEY.ENC_KEY);
			DbServerVO dbServerVO = backupService.selectDbSvrNm(workVO);
			JSONObject serverObj = new JSONObject();
			
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(dbServerVO.getIpadr());
			
			AgentInfoVO agentInfo =  (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
			
			String IP = dbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();
			
			serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getDb_svr_nm());
			serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());
			//serverObj.put(ClientProtocolID.USER_PWD, dbServerVO.getSvr_spr_scm_pwd());
			serverObj.put(ClientProtocolID.USER_PWD, aes.aesDecode(dbServerVO.getSvr_spr_scm_pwd()));

			ClientInfoCmmn cic = new ClientInfoCmmn();
			result = cic.directory_exist(serverObj,directory_path, IP, PORT);
			
			//System.out.println(result);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
}
