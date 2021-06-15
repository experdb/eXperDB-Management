package com.k4m.dx.tcontrol.restore.web;

import java.util.HashMap;
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

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityService;
import com.k4m.dx.tcontrol.backup.service.BackupService;
import com.k4m.dx.tcontrol.backup.service.WorkVO;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.cmmn.client.ClientInfoCmmn;
import com.k4m.dx.tcontrol.common.service.AgentInfoVO;
import com.k4m.dx.tcontrol.common.service.CmmnServerInfoService;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.login.service.LoginVO;
import com.k4m.dx.tcontrol.restore.service.RestoreDumpVO;
import com.k4m.dx.tcontrol.restore.service.RestoreRmanVO;
import com.k4m.dx.tcontrol.restore.service.RestoreService;

/**
 * [Restore] DB  복구이력 클래스를 정의한다.
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
public class RestoreHistoryController {
	
	@Autowired
	private BackupService backupService;
	
	@Autowired
	private MenuAuthorityService menuAuthorityService;
	
	@Autowired
	private AccessHistoryService accessHistoryService;

	@Autowired
	private RestoreService restoreService;
	
	@Autowired
	private CmmnServerInfoService cmmnServerInfoService;
	
	private List<Map<String, Object>> menuAut;
	
	
	/**
	 * [Restore] 복구이력 화면을 보여준다.
	 * @param historyVO, workVO, request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/restoreHistory.do")
	public ModelAndView restoreHistory(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, @ModelAttribute("workVo") WorkVO workVO) {
		
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000303");
		
		ModelAndView mv = new ModelAndView();
		try {
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0133");
				accessHistoryService.insertHistory(historyVO);
				
				
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));

				mv.setViewName("restore/restoreHistory");
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
		
		// Get DBServer Name
		try {
			mv.addObject("db_svr_nm", backupService.selectDbSvrNm(workVO).getDb_svr_nm());
			mv.addObject("db_svr_id",workVO.getDb_svr_id());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		if(request.getParameter("tabGbn") != null){
			mv.addObject("tabGbn",request.getParameter("tabGbn"));
		}
		
		return mv;
	}
	
	/**
	 * Rman restore Log List
	 * @param restoreRmanVO, historyVO, request
	 * @return List<WorkLogVO>
	 * @throws Exception
	 */
	@RequestMapping(value="/rmanRestoreHistory.do")
	@ResponseBody
	public List<RestoreRmanVO> rmanRestoreHistory(@ModelAttribute("restoreRmanVO") RestoreRmanVO restoreRmanVO, HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) throws Exception{
		List<RestoreRmanVO> resultSet = null;

		// 화면접근이력 이력 남기기
		try {
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0133_02");
			accessHistoryService.insertHistory(historyVO);
			
			resultSet = restoreService.rmanRestoreHistory(restoreRmanVO);
		} catch (Exception e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}

		return resultSet;
	}
	
	/**
	 * Rman restore Log List
	 * @param WorkLogVO
	 * @return List<WorkLogVO>
	 * @throws Exception
	 */
	@RequestMapping(value="/dumpRestoreHistory.do")
	@ResponseBody
	public List<RestoreDumpVO> dumpRestoreHistory(@ModelAttribute("restoreDumpVO") RestoreDumpVO restoreDumpVO, HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) throws Exception{
		List<RestoreDumpVO> resultSet = null;

		// 화면접근이력 이력 남기기
		try {
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0133_03");
			accessHistoryService.insertHistory(historyVO);
			
			resultSet = restoreService.dumpRestoreHistory(restoreDumpVO);
		} catch (Exception e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}

		return resultSet;
	}

	/**
	 * RMAN 복구이력에서 특정 이력 선택시, 로그정보 호출
	 * 
	 * @param scd_nm
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/restoreLogInfo.do")
	public @ResponseBody Map<String, Object> restoreLogInfo(HttpServletRequest request, HttpServletResponse response) {

		Map<String, Object> result = new HashMap<String, Object>();
		
		try {
			String restore_sn = request.getParameter("restore_sn");
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			String flag = request.getParameter("flag");
			
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
			
			if(flag.equals("rman")){			
				result = cic.restoreLog(IP, PORT, restore_sn);
			}else{
				result = cic.dumpRestoreLog(IP, PORT, restore_sn);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}	

	/**
	 * DUMP 복구이력에서 특정 이력 선택시, 로그정보 호출
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/restoreLogView.do")
	public ModelAndView restoreLogView(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, ModelMap model) {
		ModelAndView mv = new ModelAndView("jsonView");

		String restore_sn = request.getParameter("restore_sn");
		int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
		String flag = request.getParameter("flag");

		try {
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0133_04");
			accessHistoryService.insertHistory(historyVO);

			mv.addObject("restore_sn", restore_sn);
			mv.addObject("db_svr_id", db_svr_id);
			mv.addObject("flag", flag);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
		}

		return mv;
	}
	
	
	/**
	 * [Restore] 복구이력 화면을 보여준다.
	 * @param historyVO, workVO, request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/restoreDumpHistory.do")
	public ModelAndView dumpRestoreHistory(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, @ModelAttribute("workVo") WorkVO workVO) {
		
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000303");
		
		ModelAndView mv = new ModelAndView();
		try {
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0133");
				accessHistoryService.insertHistory(historyVO);
				
				
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));

				mv.setViewName("restore/dumpRestoreHistory");
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
		
		// Get DBServer Name
		try {
			mv.addObject("db_svr_nm", backupService.selectDbSvrNm(workVO).getDb_svr_nm());
			mv.addObject("db_svr_id",workVO.getDb_svr_id());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		if(request.getParameter("tabGbn") != null){
			mv.addObject("tabGbn",request.getParameter("tabGbn"));
		}
		
		return mv;
	}
}