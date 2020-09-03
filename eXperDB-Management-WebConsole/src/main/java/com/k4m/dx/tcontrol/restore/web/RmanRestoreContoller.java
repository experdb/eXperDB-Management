package com.k4m.dx.tcontrol.restore.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.accesscontrol.service.AccessControlHistoryVO;
import com.k4m.dx.tcontrol.accesscontrol.service.AccessControlVO;
import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.dbauthority.service.DbAuthorityService;
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
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.login.service.LoginVO;
import com.k4m.dx.tcontrol.restore.service.RestoreRmanVO;
import com.k4m.dx.tcontrol.restore.service.RestoreService;

/**
 * [Restore] DB  RMAN 복구 클래스를 정의한다.
 *
 * @author 변승우
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2019.01.09   변승우 최초 생성
 *      </pre>
 */

@Controller
public class RmanRestoreContoller {
	
	@Autowired
	private BackupService backupService;
	
	@Autowired
	private AccessHistoryService accessHistoryService;
	
	@Autowired
	private RestoreService restoreService;
	
	@Autowired
	private CmmnServerInfoService cmmnServerInfoService;
	
	@Autowired
	private DbAuthorityService dbAuthorityService;
	
	private List<Map<String, Object>> dbSvrAut;
	
	/**
	 * [Restore] 긴급복구 화면을 보여준다.
	 * 
	 * @param historyVO, workVO, request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/emergencyRestore.do")
	public ModelAndView emergencyRestore(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, @ModelAttribute("workVo") WorkVO workVO) {
		int db_svr_id = workVO.getDb_svr_id();
		CmmnUtils cu = new CmmnUtils();
		dbSvrAut = cu.selectUserDBSvrAutList(dbAuthorityService,db_svr_id);
		ModelAndView mv = new ModelAndView();

		try {
			if (dbSvrAut.get(0).get("emergency_restore_aut_yn").equals("N")) {
				mv.setViewName("error/autError");
			}else{
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0129");
				accessHistoryService.insertHistory(historyVO);
				
				mv.setViewName("restore/emergencyRestore");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		// Get DBServer Name
		try {
			DbServerVO dbServerVO = new DbServerVO();
			dbServerVO = backupService.selectDbSvrNm(workVO);
			
			mv.addObject("db_svr_nm", dbServerVO.getDb_svr_nm());
			mv.addObject("ipadr", dbServerVO.getIpadr());
			mv.addObject("dbList",backupService.selectDbList(workVO));
			mv.addObject("db_svr_id",workVO.getDb_svr_id());
			
			db_svr_id = workVO.getDb_svr_id();
			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);

			DbServerVO DbServerVO = (DbServerVO) cmmnServerInfoService.selectServerInfo(schDbServerVO);
			String strIpAdr = DbServerVO.getIpadr();
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(strIpAdr);

			AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
			
			String IP = DbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();
			
			ClientInfoCmmn cic = new ClientInfoCmmn();
			Map resulte = cic.restorePath(IP, PORT);
		
			mv.addObject("pgalog",resulte.get("PGALOG"));
			mv.addObject("srvlog",resulte.get("SRVLOG"));
			mv.addObject("pgdata",resulte.get("PGDATA"));
			mv.addObject("pgrbak",resulte.get("PGRBAK"));
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * [Restore] 시점복구 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/timeRestore.do")
	public ModelAndView timeRestore(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, @ModelAttribute("workVo") WorkVO workVO) {
		int db_svr_id = workVO.getDb_svr_id();
		CmmnUtils cu = new CmmnUtils();
		dbSvrAut = cu.selectUserDBSvrAutList(dbAuthorityService,db_svr_id);
		ModelAndView mv = new ModelAndView();
		try {
			if (dbSvrAut.get(0).get("point_restore_aut_yn").equals("N")) {
				mv.setViewName("error/autError");
			}else{
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0130");
				accessHistoryService.insertHistory(historyVO);
				
				mv.setViewName("restore/timeRestore");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		// Get DBServer Name
		try {
			mv.addObject("db_svr_nm", backupService.selectDbSvrNm(workVO).getDb_svr_nm());
			mv.addObject("ipadr", backupService.selectDbSvrNm(workVO).getIpadr());
			mv.addObject("dbList",backupService.selectDbList(workVO));
			mv.addObject("db_svr_id",workVO.getDb_svr_id());
			
			db_svr_id = workVO.getDb_svr_id();
			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			DbServerVO DbServerVO = (DbServerVO) cmmnServerInfoService.selectServerInfo(schDbServerVO);
			String strIpAdr = DbServerVO.getIpadr();
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(strIpAdr);
			AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
			
			String IP = DbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();
			
			ClientInfoCmmn cic = new ClientInfoCmmn();
			Map result = cic.restorePath(IP, PORT);
		
			mv.addObject("pgalog",result.get("PGALOG"));
			mv.addObject("srvlog",result.get("SRVLOG"));
			mv.addObject("pgdata",result.get("PGDATA"));
			mv.addObject("pgrbak",result.get("PGRBAK"));
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return mv;
	}	
	
	
	/**
	 * RMAN 복구 실행전 (select pg_switch_wal())
	 * 
	 * @param 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/pgWalFileSwitch.do")
	public @ResponseBody Map<String, Object> pgWalFileSwitch(HttpServletRequest request, HttpServletResponse response) {
		
		Map<String, Object> result = new HashMap<String, Object>();
		int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
		
		try {
			AES256 aes = new AES256(AES256_KEY.ENC_KEY);

			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			DbServerVO DbServerVO = (DbServerVO) cmmnServerInfoService.selectServerInfo(schDbServerVO);
			String strIpAdr = DbServerVO.getIpadr();
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(strIpAdr);
			AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
			
			String IP = DbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();
			
			JSONObject serverObj = new JSONObject();
			
			serverObj.put(ClientProtocolID.SERVER_NAME, DbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_IP, DbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, DbServerVO.getPortno());
			serverObj.put(ClientProtocolID.DATABASE_NAME, DbServerVO.getDft_db_nm());
			serverObj.put(ClientProtocolID.USER_ID, DbServerVO.getSvr_spr_usr_id());
			serverObj.put(ClientProtocolID.USER_PWD, aes.aesDecode(DbServerVO.getSvr_spr_scm_pwd()));
						
			System.out.println("===============서버정보================");
			System.out.println("SERVER_NAME = "+DbServerVO.getIpadr());
			System.out.println("SERVER_IP = "+DbServerVO.getIpadr());
			System.out.println("SERVER_PORT = "+DbServerVO.getPortno());
			System.out.println("DATABASE_NAME = "+DbServerVO.getDft_db_nm());
			System.out.println("USER_ID = "+DbServerVO.getSvr_spr_usr_id());
			System.out.println("USER_PWD = "+aes.aesDecode(DbServerVO.getSvr_spr_scm_pwd()));				
			System.out.println("=====================================");
			
			ClientInfoCmmn cic = new ClientInfoCmmn();
			result = cic.switchWalFile(serverObj, IP, PORT);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 *  [Restore] RMAN 복구 정보 등록 한다.
	 * 
	 * @param accessControlHistoryVO, accessControlVO, restoreRmanVO, historyVO, request, response
	 * @return 
	 * @throws ParseException
	 */
	@RequestMapping(value = "/insertRmanRestore.do")
	public @ResponseBody String insertRmanRestore(
			@ModelAttribute("accessControlHistoryVO") AccessControlHistoryVO accessControlHistoryVO,
			@ModelAttribute("accessControlVO") AccessControlVO accessControlVO, @ModelAttribute("restoreRmanVO") RestoreRmanVO restoreRmanVO, @ModelAttribute("historyVO") HistoryVO historyVO,
			HttpServletRequest request, HttpServletResponse response) throws ParseException {

		int db_svr_id = restoreRmanVO.getDb_svr_id();
		CmmnUtils cu = new CmmnUtils();
		dbSvrAut = cu.selectUserDBSvrAutList(dbAuthorityService,db_svr_id);

		String snResult = "S";

		RestoreRmanVO latestRestoreSN= null;
		
		try {
			if (dbSvrAut.get(0).get("emergency_restore_aut_yn").equals("N")) {
				response.sendRedirect("/autError.do");
			} else {
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0129_01");
				accessHistoryService.insertHistory(historyVO);
	
				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				String id = loginVo.getUsr_id();
				restoreRmanVO.setRegr_id(id);
	
				restoreService.insertRmanRestore(restoreRmanVO);		
			}
		} catch (Exception e) {
			e.printStackTrace();
			snResult = "D";
		}

		// Get Latest Restore SN
		if(snResult.equals("S")){
			try {
				latestRestoreSN = restoreService.latestRestoreSN();
				restoreRmanVO.setRestore_sn(latestRestoreSN.getRestore_sn());
			} catch (Exception e) {
				e.printStackTrace();
				snResult = "F";
			}
		}
		
		// Start Rman Restore
		if(snResult.equals("S")){
			try{
				AES256 aes = new AES256(AES256_KEY.ENC_KEY);
				
				db_svr_id = restoreRmanVO.getDb_svr_id();
				DbServerVO schDbServerVO = new DbServerVO();
				schDbServerVO.setDb_svr_id(db_svr_id);
				DbServerVO DbServerVO = (DbServerVO) cmmnServerInfoService.selectServerInfo(schDbServerVO);
				String strIpAdr = DbServerVO.getIpadr();
				AgentInfoVO vo = new AgentInfoVO();
				vo.setIPADR(strIpAdr);
				AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
				
				String IP = DbServerVO.getIpadr();
				int PORT = agentInfo.getSOCKET_PORT();
				
				JSONObject serverObj = new JSONObject();
				
				serverObj.put(ClientProtocolID.SERVER_NAME, DbServerVO.getIpadr());
				serverObj.put(ClientProtocolID.SERVER_IP, DbServerVO.getIpadr());
				serverObj.put(ClientProtocolID.SERVER_PORT, DbServerVO.getPortno());
				serverObj.put(ClientProtocolID.DATABASE_NAME, DbServerVO.getDft_db_nm());
				serverObj.put(ClientProtocolID.USER_ID, DbServerVO.getSvr_spr_usr_id());
				serverObj.put(ClientProtocolID.USER_PWD, aes.aesDecode(DbServerVO.getSvr_spr_scm_pwd()));
							
				System.out.println("===============서버정보================");
				System.out.println("SERVER_NAME = "+DbServerVO.getIpadr());
				System.out.println("SERVER_IP = "+DbServerVO.getIpadr());
				System.out.println("SERVER_PORT = "+DbServerVO.getPortno());
				System.out.println("DATABASE_NAME = "+DbServerVO.getDft_db_nm());
				System.out.println("USER_ID = "+DbServerVO.getSvr_spr_usr_id());
				System.out.println("USER_PWD = "+aes.aesDecode(DbServerVO.getSvr_spr_scm_pwd()));				
				System.out.println("=====================================");

				ClientInfoCmmn cic = new ClientInfoCmmn();
				cic.rmanRestoreStart(serverObj, IP, PORT, restoreRmanVO);
			} catch (Exception e) {
				snResult = "F";
				e.printStackTrace();
			}
		}
		
		return snResult;
	}	

	/**
	 * 복구명을 중복 체크한다.
	 * 
	 * @param restore_nm
	 * @return String
	 * @throws
	 */
	@RequestMapping(value = "/restore_nmCheck.do")
	public @ResponseBody String restore_nmCheck(@RequestParam("restore_nm") String restore_nm) {
		try {
			int resultSet = restoreService.restore_nmCheck(restore_nm);
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
	 * RMAN 복구 실행시, 로그정보 호출
	 * 
	 * @param request, response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/restoreLogCall.do")
	public @ResponseBody Map<String, Object> restoreLogCall(HttpServletRequest request, HttpServletResponse response) {
		
		RestoreRmanVO latestRestoreSN= null;
		Map<String, Object> result = new HashMap<String, Object>();
		
		try {
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			
			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			DbServerVO DbServerVO = (DbServerVO) cmmnServerInfoService.selectServerInfo(schDbServerVO);
			String strIpAdr = DbServerVO.getIpadr();
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(strIpAdr);

			AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
			
			String IP = DbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();
			
			latestRestoreSN = restoreService.latestRestoreSN();
			String restore_sn = String.valueOf(latestRestoreSN.getRestore_sn());
			
			ClientInfoCmmn cic = new ClientInfoCmmn();
			result = cic.restoreLog(IP, PORT, restore_sn);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
}