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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.accesscontrol.service.AccessControlHistoryVO;
import com.k4m.dx.tcontrol.accesscontrol.service.AccessControlVO;
import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.dbauthority.service.DbAuthorityService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.backup.service.BackupService;
import com.k4m.dx.tcontrol.backup.service.WorkLogVO;
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
import com.k4m.dx.tcontrol.restore.service.RestoreDumpVO;
import com.k4m.dx.tcontrol.restore.service.RestoreService;

/**
 * [Restore] DB  덤프복구 클래스를 정의한다.
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
public class DumpRestoreController {
	@Autowired
	private AccessHistoryService accessHistoryService;
	
	@Autowired
	private BackupService backupService;
	
	@Autowired
	private DbAuthorityService dbAuthorityService;
	
	@Autowired
	private RestoreService restoreService;
	
	private List<Map<String, Object>> dbSvrAut;
	
	@Autowired
	private CmmnServerInfoService cmmnServerInfoService;
	
	/**
	 * [Restore] 덤프복구 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/dumpRestore.do")
	public ModelAndView dumpyRestore(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request,@ModelAttribute("workVo") WorkVO workVO) {
		int db_svr_id = workVO.getDb_svr_id();
		CmmnUtils cu = new CmmnUtils();
		dbSvrAut = cu.selectUserDBSvrAutList(dbAuthorityService,db_svr_id);
		
		ModelAndView mv = new ModelAndView();
		try {
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if (dbSvrAut.get(0).get("dump_restore_aut_yn").equals("N")) {
				mv.setViewName("error/autError");
			}else{
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0131");
				accessHistoryService.insertHistory(historyVO);
					
				mv.setViewName("restore/dumpRestoreList");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		// Get DB list
		try {		
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String usr_id = loginVo.getUsr_id();
			workVO.setUsr_id(usr_id);

		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		// Get DBServer Name
		try {
			mv.addObject("db_svr_nm", backupService.selectDbSvrNm(workVO).getDb_svr_nm());
			mv.addObject("dbList",backupService.selectDbList(workVO));
			mv.addObject("db_svr_id",workVO.getDb_svr_id());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return mv;
	}

	
	/**
	 * Dump restore Log List
	 * @param WorkLogVO
	 * @return List<WorkLogVO>
	 * @throws Exception
	 */
	@RequestMapping(value="/selectDumpRestoreLogList.do")
	@ResponseBody
	public List<WorkLogVO> selectDumpRestoreLogList(@ModelAttribute("workLogVo") WorkLogVO workLogVO, HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) throws Exception{
		
		// 화면접근이력 이력 남기기
		try {
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0131");
			accessHistoryService.insertHistory(historyVO);
		} catch (Exception e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
				
		List<WorkLogVO> resultSet = null;
		resultSet = restoreService.selectDumpRestoreLogList(workLogVO);

		return resultSet;
	}
	
	
	/**
	 * [Restore] 덤프복구 등록 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/dumpRestoreRegVeiw.do")
	public ModelAndView dumpRestoreRegVeiw(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request,@ModelAttribute("workVo") WorkVO workVO) {
		int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
		int exe_sn = Integer.parseInt(request.getParameter("exe_sn"));
		int wrk_id = Integer.parseInt(request.getParameter("wrk_id"));
		
		workVO.setBck_wrk_id(wrk_id);
		
		CmmnUtils cu = new CmmnUtils();
		dbSvrAut = cu.selectUserDBSvrAutList(dbAuthorityService,db_svr_id);
		
		ModelAndView mv = new ModelAndView();
		try {
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if (dbSvrAut.get(0).get("dump_restore_aut_yn").equals("N")) {
				mv.setViewName("error/autError");
			}else{
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0132");
				accessHistoryService.insertHistory(historyVO);

				mv.addObject("exe_sn", exe_sn);
				mv.addObject("db_svr_id", db_svr_id);
				mv.addObject("wrk_id", wrk_id);
				mv.setViewName("restore/dumpRestoreRegVeiw");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		// Get DB List
		try {
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String usr_id = loginVo.getUsr_id();
			workVO.setUsr_id(usr_id);
			
			mv.addObject("dbList", backupService.selectDbList(workVO));
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		try {
			mv.addObject("workOptInfo", backupService.selectWorkOptList(workVO));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return mv;
	}
	
	
	
	@RequestMapping(value="/selectBckInfo.do")
	@ResponseBody
	public List<WorkLogVO> selectBckInfo(@ModelAttribute("workLogVo") WorkLogVO workLogVO, HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) throws Exception{
		
		int exe_sn = Integer.parseInt(request.getParameter("exe_sn"));
		String db_svr_id = request.getParameter("db_svr_id");
		
		try {		
			workLogVO.setDb_svr_id(db_svr_id);
			workLogVO.setExe_sn(exe_sn);
		} catch (Exception e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
				
		List<WorkLogVO> resultSet = null;
		resultSet = restoreService.selectBckInfo(workLogVO);

		return resultSet;
	}	
	
	
	/**
	 *  [Restore] DUMP 복구 정보 등록 한다.
	 * 
	 * @param dbServerVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertDumpRestore.do")
	public @ResponseBody void insertDumpRestore(
			@ModelAttribute("accessControlHistoryVO") AccessControlHistoryVO accessControlHistoryVO,
			@ModelAttribute("accessControlVO") AccessControlVO accessControlVO, @ModelAttribute("restoreRmanVO") RestoreDumpVO restoreDumpVO, @ModelAttribute("historyVO") HistoryVO historyVO,
			HttpServletRequest request, HttpServletResponse response) throws ParseException {

		int db_svr_id = restoreDumpVO.getDb_svr_id();
		CmmnUtils cu = new CmmnUtils();
		dbSvrAut = cu.selectUserDBSvrAutList(dbAuthorityService,db_svr_id);
		
		String insertResult = "S";
		String snResult = "S";
		RestoreDumpVO latestRestoreSN= null;
		
			try {
				if (dbSvrAut.get(0).get("dump_restore_aut_yn").equals("N")) {
					response.sendRedirect("/autError.do");
				} else {
					// 화면접근이력 이력 남기기
					CmmnUtils.saveHistory(request, historyVO);
					historyVO.setExe_dtl_cd("DX-T0132_01");
					accessHistoryService.insertHistory(historyVO);
	
					HttpSession session = request.getSession();
					LoginVO loginVo = (LoginVO) session.getAttribute("session");
					String id = loginVo.getUsr_id();
	
					restoreDumpVO.setRegr_id(id);
	
					restoreService.insertDumpRestore(restoreDumpVO);		
				}
			} catch (Exception e) {
				e.printStackTrace();
				insertResult = "F";
			}

			
		// Get Latest Restore SN
		if(insertResult.equals("S")){
			try {
				latestRestoreSN = restoreService.latestDumpRestoreSN();
				restoreDumpVO.setRestore_sn(latestRestoreSN.getRestore_sn());
			} catch (Exception e) {
				e.printStackTrace();
				snResult = "F";
			}
		}
		
		// Start Dump Restore
			if(snResult.equals("S")){
			try{
				AES256 aes = new AES256(AES256_KEY.ENC_KEY);
				
				db_svr_id = restoreDumpVO.getDb_svr_id();
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
				
				System.out.println("백업파일경로="+restoreDumpVO.getBck_file_pth());

				ClientInfoCmmn cic = new ClientInfoCmmn();
				cic.dumpRestoreStart(serverObj, IP, PORT, restoreDumpVO);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}				
	}		
	
	
	/**
	 * DUMP 복구 실행시, 로그정보 호출
	 * 
	 * @param scd_nm
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dumpRestoreLogCall.do")
	public @ResponseBody Map<String, Object> restoreLogCall(HttpServletRequest request, HttpServletResponse response) {
		
		RestoreDumpVO latestRestoreSN= null;
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
			
			
			latestRestoreSN = restoreService.latestDumpRestoreSN();
			String restore_sn = String.valueOf(latestRestoreSN.getRestore_sn());
				
			ClientInfoCmmn cic = new ClientInfoCmmn();
			result = cic.dumpRestoreLog(IP, PORT, restore_sn);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}	
}
