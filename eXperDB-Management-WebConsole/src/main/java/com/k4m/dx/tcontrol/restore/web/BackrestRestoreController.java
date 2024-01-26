package com.k4m.dx.tcontrol.restore.web;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.backup.service.BackupService;
import com.k4m.dx.tcontrol.backup.service.WorkVO;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.cmmn.client.ClientInfoCmmn;
import com.k4m.dx.tcontrol.cmmn.client.ClientProtocolID;
import com.k4m.dx.tcontrol.common.service.AgentInfoVO;
import com.k4m.dx.tcontrol.common.service.CmmnServerInfoService;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.functions.schedule.service.WrkExeVO;
import com.k4m.dx.tcontrol.login.service.LoginVO;
import com.k4m.dx.tcontrol.restore.service.RestoreRmanVO;
import com.k4m.dx.tcontrol.restore.service.RestoreService;

@Controller
public class BackrestRestoreController {

	@Autowired
	private BackupService backupService;
	
	@Autowired
	private AccessHistoryService accessHistoryService;

	@Autowired
	private RestoreService restoreService;

	@Autowired
	private CmmnServerInfoService cmmnServerInfoService;

	
	/**
	 * Backrest Restore All Agent Info Select
	 * 
	 * @param WorkVO, request, dbServerVO, historyVO
	 * @return ModelAndView
	 */
	@SuppressWarnings("null")
	@RequestMapping(value = "/restore/backrestAllAgentList.do")
	public ModelAndView backrestAllAgentList(@ModelAttribute("workVo") WorkVO workVO, HttpServletRequest request,
			@ModelAttribute("dbServerVO") DbServerVO dbServerVO, @ModelAttribute("historyVO") HistoryVO historyVO) {
		ModelAndView mv = new ModelAndView("jsonView");
		String resultCode = "";

		try {
			mv.addObject("agent_list", backupService.selectAllAgentInfo(dbServerVO));
			WrkExeVO wrkExeVO = backupService.selectBackupSvrInfo(workVO);
			
			if(!wrkExeVO.equals(null)) {
				resultCode = "S";
				
				mv.addObject("db_svr_nm", backupService.selectDbSvrNm(workVO).getDb_svr_nm());
				mv.addObject("backrest_gbn", wrkExeVO.getBackrest_gbn());
				
				if(wrkExeVO.getBackrest_gbn().equals("remote")) {
					mv.addObject("remote_ip", wrkExeVO.getRemote_ip());
				}
			}
			
		} catch (Exception e) {
			resultCode = "E";
			e.printStackTrace();
		}
		
		mv.addObject("result_code", resultCode);
		mv.addObject("db_svr_id", workVO.getDb_svr_id());

		return mv;
	}
	
	
	/**
	 * [Restore] 복원 설정 화면을 보여준다.
	 * 
	 * @param historyVO, workVO, request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@SuppressWarnings("unlikely-arg-type")
	@RequestMapping(value = "/backrestRestore.do")
	public ModelAndView backrestRestore(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request,
			@ModelAttribute("workVo") WorkVO workVO) {
		ModelAndView mv = new ModelAndView("jsonView");
		int db_svr_id = workVO.getDb_svr_id();
		

		// 화면접근이력 이력 남기기
		try {
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0185");
			accessHistoryService.insertHistory(historyVO);
			mv.setViewName("restore/backrestRestore");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		try {
			DbServerVO dbServerVO = new DbServerVO();
			dbServerVO = backupService.selectDbSvrNm(workVO);
			
			mv.addObject("db_svr_nm", dbServerVO.getDb_svr_nm());
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		mv.addObject("db_svr_id", db_svr_id);

		return mv;

	}
	
	
	/**
	 * Backrest 백업. 복구명을 중복 체크한다.
	 * 
	 * @param restoreName
	 * @return String
	 * @throws
	 */
	@RequestMapping(value = "/backrest_nmCheck.do")
	public @ResponseBody String backrestRestoreNameCheck(@RequestParam("backrest_nm") String backrestWrkName) {
		try {
			int resultSet = restoreService.backrestNameCheck(backrestWrkName);
			if (resultSet > 0) {
				// 중복값이 존재함.
				return "false";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "true";
	}
	
	
	

	/**
	 * [Restore] BACKREST 복구 정보 등록한다.
	 * 
	 * @param historyVO, workVO, request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertBackrestRestore.do")
	public ModelAndView insertBackrestRestore(
			@ModelAttribute("restoreRmanVO") RestoreRmanVO restoreBackrestVO,
			@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse respons) {
		ModelAndView mv = new ModelAndView("jsonView");
		
		String snResult = "S";

		try {
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0186");
			accessHistoryService.insertHistory(historyVO);

			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String id = loginVo.getUsr_id();
			restoreBackrestVO.setRegr_id(id);
			
			Calendar calendar = Calendar.getInstance();
			java.util.Date date = calendar.getTime();
			String today = (new SimpleDateFormat("yyyyMMddHHmmss").format(date));
			
			restoreBackrestVO.setExelog(restoreBackrestVO.getRestore_nm() + "_" + today);
			
			mv.addObject("exelog", restoreBackrestVO.getRestore_nm() + "_" + today);

			restoreService.insertRmanRestore(restoreBackrestVO);
		} catch (Exception e) {
			snResult = "F";
			e.printStackTrace();
		}
		
		mv.addObject("snResult", snResult);

		return mv;
	}
	
	
	/**
	 * [Restore] BACKREST 복구 실행한다.
	 * 
	 * @param workVO, dbServerVO, request, paramMap
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/executeBackrestRestore.do")
	@ResponseBody
	public void executeBackrestRestore(@ModelAttribute("workVo") WorkVO workVO, @ModelAttribute("dbServerVO") DbServerVO dbServerVO, HttpServletRequest request,  @RequestParam Map<String, Object> paramMap) {
		try {
			createBackrestRestoreConfig(workVO, dbServerVO, request, paramMap);
			
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(dbServerVO.getIpadr());
			AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
			int port = agentInfo.getSOCKET_PORT();
						
			JSONObject jObj = new JSONObject();
			
			jObj.put(ClientProtocolID.WRK_NM, request.getParameter("restore_nm"));
			jObj.put(ClientProtocolID.EXELOG, request.getParameter("exelog"));
			jObj.put(ClientProtocolID.RESTORE_FLAG, request.getParameter("restore_type"));
			jObj.put(ClientProtocolID.TIME_RESTORE, request.getParameter("time_restore"));
			
			jObj.put(ClientProtocolID.DBLIST_MAP, paramMap.get("dbList_map"));
			jObj.put(ClientProtocolID.LIST_TYPE, request.getParameter("list_type"));
			
			ClientInfoCmmn cic = new ClientInfoCmmn();
			JSONObject result = new JSONObject(); 
			
			result = cic.executeBackrestRestore(dbServerVO.getIpadr(), port, jObj);
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	/**
	 * Backrest restore, log 경로 조회
	 * 
	 * @param request
	 * @return JSONObject
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectBackrestRestoreLog.do")
	@ResponseBody
	public JSONObject selectBackrestRestoreLog(HttpServletRequest request) throws Exception {
		
		String IP = request.getParameter("ipadr");
		
		AgentInfoVO vo = new AgentInfoVO();
		vo.setIPADR(IP);
		AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);

		int PORT = agentInfo.getSOCKET_PORT();
				
		JSONObject jObj = new JSONObject();
		
		String exelog = request.getParameter("exelog");
		
		jObj.put(ClientProtocolID.EXELOG, exelog);
		
		ClientInfoCmmn cic = new ClientInfoCmmn();
		JSONObject result = new JSONObject(); 
		result = cic.getBackrestRestoreLog(IP, PORT, jObj);

		return result;
	}
	
	
	/**
	 * Backrest 복원시, Hostuser 조회
	 * 
	 * @param request
	 * @return JSONObject
	 * @throws Exception
	 */
	public JSONObject selectHostuser(String ipadr){
		JSONObject result = new JSONObject(); 
		
		try {
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(ipadr);
			AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
			int PORT = agentInfo.getSOCKET_PORT();
			
			JSONObject jObj = new JSONObject();
			
			ClientInfoCmmn cic = new ClientInfoCmmn();
			result = cic.selectHostuser(ipadr, PORT, jObj);
			
		} catch (Exception e) {
			e.printStackTrace();
		}		
		
		return result;
	}
	
	
	
	/**
	 * Backrest Restore config 생성
	 * 
	 * @param workVO, dbServerVO, request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "unlikely-arg-type" })
	public void createBackrestRestoreConfig(WorkVO workVO, DbServerVO dbServerVO, HttpServletRequest request, Map<String, Object> paramMap) {
		ClientInfoCmmn cic = new ClientInfoCmmn();
		JSONObject result = new JSONObject();
		List<Map<String, Object>> backupRemoteInfo = null;
		
		try {			
			AgentInfoVO vo = new AgentInfoVO();
			//선택된 복원서버
			vo.setIPADR(dbServerVO.getIpadr());
			AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);

			String ip = dbServerVO.getIpadr();
			int port = agentInfo.getSOCKET_PORT();
			JSONObject jObj = new JSONObject();
			
			String backupType = request.getParameter("backup_location");
			WrkExeVO wrkExeVO = backupService.selectBackupSvrInfo(workVO);
			
			if(backupType.equals("remote")){
				backupRemoteInfo = backupService.selectBckInfo(wrkExeVO.getWrk_id());
				
				if(backupRemoteInfo.get(0).get("remote_ip").equals(dbServerVO.getIpadr())) {
					backupType = "remoteLocal";
				}
				
				jObj.put(ClientProtocolID.REMOTE_IP, backupRemoteInfo.get(0).get("remote_ip"));
				jObj.put(ClientProtocolID.REMOTE_PORT, backupRemoteInfo.get(0).get("remote_port"));
				jObj.put(ClientProtocolID.REMOTE_USR, backupRemoteInfo.get(0).get("remote_usr"));
			}else if(backupType.equals("local")) {
				List<DbServerVO> backupInfoServerVO = backupService.selectBckTargetServer(wrkExeVO.getDb_svr_ipadr_id());
				
				if(!String.valueOf(workVO.getDb_svr_id()).equals(request.getParameter("restore_db_svr_id"))) {
					backupType = "localRemote";
					
					JSONObject hostuserResult = selectHostuser(backupInfoServerVO.get(0).getIpadr());
					String hostuser = String.valueOf(hostuserResult.get(ClientProtocolID.RESULT_DATA));
					
					jObj.put(ClientProtocolID.DBMS_IP, backupInfoServerVO.get(0).getIpadr());
					jObj.put(ClientProtocolID.HOSTUSER, hostuser);
					jObj.put(ClientProtocolID.SSH_PORT, request.getParameter("ssh_port"));
				}else {
					if(!String.valueOf(wrkExeVO.getDb_svr_ipadr_id()).equals(String.valueOf(dbServerVO.getDb_svr_ipadr_id()))) {
						backupType = "HAlocal";
						jObj.put(ClientProtocolID.DBMS_IP, backupInfoServerVO.get(0).getIpadr());
						
					}
				}
			}else {
				jObj.put(ClientProtocolID.CLOUD_MAP, paramMap.get("cloud_map"));
			}
			
			jObj.put(ClientProtocolID.WRK_NM, request.getParameter("restore_nm"));
			jObj.put(ClientProtocolID.BCK_FILE_PTH, wrkExeVO.getBck_file_pth());
			jObj.put(ClientProtocolID.PGDATA, dbServerVO.getPgdata_pth());
			jObj.put(ClientProtocolID.DBMS_PORT, dbServerVO.getPortno());
			jObj.put(ClientProtocolID.SPR_USR_ID, dbServerVO.getSvr_spr_usr_id());
			jObj.put(ClientProtocolID.STORAGE_OPT, backupType);
						
			result = cic.createBackrestRestoreConf(ip, port, jObj);

		} catch (Exception e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
	}
}
