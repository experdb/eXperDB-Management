package com.k4m.dx.tcontrol.backup.web;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.dbauthority.service.DbAuthorityService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.backup.service.BackupService;
import com.k4m.dx.tcontrol.backup.service.DbVO;
import com.k4m.dx.tcontrol.backup.service.WorkLogVO;
import com.k4m.dx.tcontrol.backup.service.WorkObjVO;
import com.k4m.dx.tcontrol.backup.service.WorkOptDetailVO;
import com.k4m.dx.tcontrol.backup.service.WorkOptVO;
import com.k4m.dx.tcontrol.backup.service.WorkVO;
import com.k4m.dx.tcontrol.cmmn.AES256;
import com.k4m.dx.tcontrol.cmmn.AES256_KEY;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.cmmn.client.ClientInfoCmmn;
import com.k4m.dx.tcontrol.cmmn.client.ClientProtocolID;
import com.k4m.dx.tcontrol.common.service.CmmnCodeDtlService;
import com.k4m.dx.tcontrol.common.service.CmmnCodeVO;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.common.service.PageVO;

@Controller
public class BackupController {
	@Autowired
	private BackupService backupService;
	
	@Autowired
	private CmmnCodeDtlService cmmnCodeDtlService;
	
	@Autowired
	private AccessHistoryService accessHistoryService;
	
	@Autowired
	private DbAuthorityService dbAuthorityService;
	
	private List<Map<String, Object>> dbSvrAut;
	
	/**
	 * Work List View page
	 * @param WorkVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/backup/workList.do")
	public ModelAndView workList(@ModelAttribute("workVo") WorkVO workVO, HttpServletRequest request) {
		
		//유저 디비서버 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		dbSvrAut = cu.selectUserDBSvrAutList(dbAuthorityService);
		
		ModelAndView mv = new ModelAndView();
		
		//읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
		if(dbSvrAut.get(0).get("bck_cng_aut_yn").equals("N")){
			mv.setViewName("error/autError");				
		}else{	
			try {
				HttpSession session = request.getSession();
				String usr_id = (String) session.getAttribute("usr_id");
				workVO.setUsr_id(usr_id);
				
				mv.addObject("dbList",backupService.selectDbList(workVO));
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
	
			try {
				mv.addObject("db_svr_nm", backupService.selectDbSvrNm(workVO).getDb_svr_nm());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}	
			mv.addObject("db_svr_id",workVO.getDb_svr_id());
			mv.setViewName("backup/workList");
		}
		return mv;
	}

	
	/**
	 * Work List
	 * @param WorkVO
	 * @return List<WorkVO>
	 */
	@RequestMapping(value="/backup/getWorkList.do")
	@ResponseBody
	public List<WorkVO> rmanDataList(@ModelAttribute("workVo") WorkVO workVO, HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO){
		List<WorkVO> resultSet = null;
		
		// 사용자관리 이력 남기기
		try {
			CmmnUtils.saveHistory(request, historyVO);
			if(workVO.getBck_bsn_dscd().equals("TC000201")){
				historyVO.setExe_dtl_cd("DX-T0019");
			}else{
				historyVO.setExe_dtl_cd("DX-T0021");
			}
			accessHistoryService.insertHistory(historyVO);
		} catch (Exception e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
		
		try {
			resultSet = backupService.selectWorkList(workVO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return resultSet;
	}
	
	/**
	 * Backup Log View page
	 * @param WorkVO
	 * @return ModelAndView
	 */
	@RequestMapping(value = "/backup/workLogList.do")
	public ModelAndView rmanLogList(@ModelAttribute("workVo") WorkVO workVO, HttpServletRequest request) {
		
		//유저 디비서버 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		dbSvrAut = cu.selectUserDBSvrAutList(dbAuthorityService);
				
		ModelAndView mv = new ModelAndView();

		//읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
		if(dbSvrAut.get(0).get("bck_hist_aut_yn").equals("N")){
			mv.setViewName("error/autError");				
		}else{	
			// Get DB list
			try {
				HttpSession session = request.getSession();
				String usr_id = (String) session.getAttribute("usr_id");
				workVO.setUsr_id(usr_id);

				mv.addObject("dbList",backupService.selectDbList(workVO));
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			
			// Get DBServer Name
			try {
				mv.addObject("db_svr_nm", backupService.selectDbSvrNm(workVO).getDb_svr_nm());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			mv.addObject("db_svr_id",workVO.getDb_svr_id());
			mv.setViewName("backup/workLogList");
		}
		return mv;	
	}
	
	/**
	 * Backup Log List
	 * @param WorkLogVO
	 * @return List<WorkLogVO>
	 * @throws Exception
	 */
	@RequestMapping(value="/backup/selectWorkLogList.do")
	@ResponseBody
	public List<WorkLogVO> selectWorkLogList(@ModelAttribute("workLogVo") WorkLogVO workLogVO, HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) throws Exception{
		
		// 사용자관리 이력 남기기
		try {
			CmmnUtils.saveHistory(request, historyVO);
			if(workLogVO.getBck_bsn_dscd().equals("TC000201")){
				historyVO.setExe_dtl_cd("DX-T0025");
			}else{
				historyVO.setExe_dtl_cd("DX-T0026");
			}
			accessHistoryService.insertHistory(historyVO);
		} catch (Exception e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
				
		List<WorkLogVO> resultSet = null;
		resultSet = backupService.selectWorkLogList(workLogVO);

		return resultSet;
	}
	
	/**
	 * Rman Backup Registration View page
	 * @param WorkVO
	 * @return ModelAndView
	 */
	@SuppressWarnings("null")
	@RequestMapping(value = "/popup/rmanRegForm.do")
	public ModelAndView rmanRegForm(@ModelAttribute("workVo") WorkVO workVO, HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) {
		ModelAndView mv = new ModelAndView();

		// 사용자관리 이력 남기기
		try {
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0020");
			accessHistoryService.insertHistory(historyVO);
		} catch (Exception e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
				
		mv.addObject("db_svr_id",workVO.getDb_svr_id());
		mv.setViewName("popup/rmanRegForm");
		return mv;
	}
	
	/**
	 * Dump Backup Registration View page
	 * @param WorkVO
	 * @return ModelAndView
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/popup/dumpRegForm.do")
	public ModelAndView dumpRegForm(@ModelAttribute("workVo") WorkVO workVO, HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) {
		ModelAndView mv = new ModelAndView();
		
		// 사용자관리 이력 남기기
		try {
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0022");
			accessHistoryService.insertHistory(historyVO);
		} catch (Exception e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
		
		// Get DB List
		try {
			HttpSession session = request.getSession();
			String usr_id = (String) session.getAttribute("usr_id");
			workVO.setUsr_id(usr_id);
			
			mv.addObject("dbList", backupService.selectDbList(workVO));
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		// Get Incoding Code List
		try {
			PageVO pageVO = new PageVO();
			pageVO.setGrp_cd("TC0005");
			pageVO.setSearchCondition("0");
			List<CmmnCodeVO> cmmnCodeVO = cmmnCodeDtlService.cmmnDtlCodeSearch(pageVO);
			mv.addObject("incodeList",cmmnCodeVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		// Get DB ROLE List
		try {
			AES256 aes = new AES256(AES256_KEY.ENC_KEY);
			DbServerVO dbServerVO = backupService.selectDbSvrNm(workVO);
			JSONObject serverObj = new JSONObject();
			
			serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getDb_svr_nm());
			serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());
			serverObj.put(ClientProtocolID.DATABASE_NAME, dbServerVO.getDft_db_nm());
			serverObj.put(ClientProtocolID.USER_ID, dbServerVO.getSvr_spr_usr_id());
			//serverObj.put(ClientProtocolID.USER_PWD, dbServerVO.getSvr_spr_scm_pwd());
			serverObj.put(ClientProtocolID.USER_PWD, aes.aesDecode(dbServerVO.getSvr_spr_scm_pwd()));
			ClientInfoCmmn cic = new ClientInfoCmmn();

			mv.addObject("roleList",cic.role_List(serverObj));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		mv.addObject("db_svr_id",workVO.getDb_svr_id());
		mv.setViewName("popup/dumpRegForm");
		return mv;	
	}
	
	/**
	 * Rman Backup Work Insert
	 * @param WorkVO
	 * @return String
	 * @throws IOException 
	 */
	@RequestMapping(value = "/popup/workRmanWrite.do")
	public void workRmanWrite(@ModelAttribute("workVO") WorkVO workVO, HttpServletResponse response, HttpServletRequest request) throws IOException {
		String result = "S";

		try {
			HttpSession session = request.getSession();
			String usr_id = (String) session.getAttribute("usr_id");
			workVO.setFrst_regr_id(usr_id);
			backupService.insertRmanWork(workVO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			result = "F";
		}
		
		response.getWriter().println(result);
	}

	/**
	 * Dump Backup Work Insert
	 * @param WorkVO
	 * @return String
	 * @throws IOException 
	 */
	@RequestMapping(value = "/popup/workDumpWrite.do")
	public void workDumpWrite(@ModelAttribute("workVO") WorkVO workVO, HttpServletResponse response, HttpServletRequest request) throws IOException{
		WorkVO resultSet = null;
		String result = "S";

		// Data Insert
		try {
			HttpSession session = request.getSession();
			String usr_id = (String) session.getAttribute("usr_id");
			workVO.setFrst_regr_id(usr_id);
			backupService.insertDumpWork(workVO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			result = "F";
		}
		
		// Get Last wrk_id
		if(result.equals("S")){
			try {
				resultSet = backupService.lastWorkId();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		// Return wrk_id=0 for Insert Fail
		if(result.equals("F")) resultSet.setWrk_id(0);

		response.getWriter().println(resultSet.getWrk_id());
	}
	
	/**
	 * Backup Work Option insert
	 * @param WorkOptVO
	 * @return
	 */
	@RequestMapping(value = "/popup/workOptWrite.do")
	public void workOptWrite(@ModelAttribute("WorkOptVO") WorkOptVO workOptVO, HttpServletRequest request){
		HttpSession session = request.getSession();
		String usr_id = (String) session.getAttribute("usr_id");
		workOptVO.setFrst_regr_id(usr_id);		
		try{
			backupService.insertWorkOpt(workOptVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * Rman Backup Reregistration View page
	 * @param WorkVO
	 * @return ModelAndView
	 */
	@SuppressWarnings("null")
	@RequestMapping(value = "/popup/rmanRegReForm.do")
	public ModelAndView rmanRegReForm(@ModelAttribute("workVo") WorkVO workVO, HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO)  {
		ModelAndView mv = new ModelAndView();

		// 사용자관리 이력 남기기
		try {
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0020_01");
			accessHistoryService.insertHistory(historyVO);
		} catch (Exception e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
		
		// Get Rman Backup Information
		try {
			workVO.setBck_bsn_dscd("TC000201");
			mv.addObject("workInfo", backupService.selectWorkList(workVO));
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		// Get Incoding Code List
		try {
			PageVO pageVO = new PageVO();
			pageVO.setGrp_cd("TC0005");
			pageVO.setSearchCondition("0");
			List<CmmnCodeVO> cmmnCodeVO = cmmnCodeDtlService.cmmnDtlCodeSearch(pageVO);
			mv.addObject("incodeList",cmmnCodeVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		mv.addObject("db_svr_id",workVO.getDb_svr_id());
		mv.addObject("wrk_id",workVO.getWrk_id());
		
		mv.setViewName("popup/rmanRegReForm");
		return mv;	
	}
	
	/**
	 * Dump백업 수정팝업 페이지를 반환한다.
	 * @param WorkVO
	 * @return ModelAndView
	 */
	@SuppressWarnings({ "null", "unchecked" })
	@RequestMapping(value = "/popup/dumpRegReForm.do")
	public ModelAndView dumpRegReForm(@ModelAttribute("workVo") WorkVO workVO, HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) {
		ModelAndView mv = new ModelAndView();

		// 사용자관리 이력 남기기
		try {
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0022_01");
			accessHistoryService.insertHistory(historyVO);
		} catch (Exception e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
		
		// Get DB List
		try {
			HttpSession session = request.getSession();
			String usr_id = (String) session.getAttribute("usr_id");
			workVO.setUsr_id(usr_id);
			
			mv.addObject("dbList", backupService.selectDbList(workVO));
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		// Work info
		workVO.setBck_bsn_dscd("TC000202");
		try {
			mv.addObject("workInfo", backupService.selectWorkList(workVO));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		// Work Option List
		try {
			mv.addObject("workOptInfo", backupService.selectWorkOptList(workVO));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		// Work Object List
		try {
			mv.addObject("workObjList", backupService.selectWorkObj(workVO));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		// Get Incoding code List
		try {
			PageVO pageVO = new PageVO();
			pageVO.setGrp_cd("TC0005");
			pageVO.setSearchCondition("0");
			List<CmmnCodeVO> cmmnCodeVO = cmmnCodeDtlService.cmmnDtlCodeSearch(pageVO);
			mv.addObject("incodeList",cmmnCodeVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		// Server Role List
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
			mv.addObject("roleList",cic.role_List(serverObj));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		mv.addObject("db_svr_id",workVO.getDb_svr_id());
		mv.addObject("wrk_id",workVO.getWrk_id());
		mv.setViewName("popup/dumpRegReForm");
		return mv;	
	}
	
	/**
	 * Rman Backup Work Update
	 * @param WorkVO
	 * @return String
	 * @throws IOException 
	 */
	@RequestMapping(value = "/popup/workRmanReWrite.do")
	public void workRmanReWrite(@ModelAttribute("workVO") WorkVO workVO, HttpServletResponse response, HttpServletRequest request) throws IOException{
		String result = "S";

		try {
			HttpSession session = request.getSession();
			String usr_id = (String) session.getAttribute("usr_id");
			workVO.setLst_mdfr_id(usr_id);
			backupService.updateRmanWork(workVO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			result = "F";
		}

		response.getWriter().println(result);
	}
	
	/**
	 * Dump Backup Work Update
	 * @param WorkVO
	 * @return String
	 * @throws IOException 
	 */
	@RequestMapping(value = "/popup/workDumpReWrite.do")
	public void workDumpReWrite(@ModelAttribute("workVO") WorkVO workVO, HttpServletResponse response, HttpServletRequest request) throws IOException{
		String result = "F";

		try {
			HttpSession session = request.getSession();
			String usr_id = (String) session.getAttribute("usr_id");
			workVO.setLst_mdfr_id(usr_id);
			backupService.updateDumpWork(workVO);
			result = "S";
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			result = "F";
		}
		
		// work option delete
		try {
			WorkOptVO workOptVO = new WorkOptVO();
			workOptVO.setWrk_id(workVO.getWrk_id());
			backupService.deleteWorkOpt(workOptVO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		// work object delete 
		try {
			backupService.deleteWorkObj(workVO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		response.getWriter().println(result);
	}
	
	/**
	 * Work Delete
	 * @param WorkVO
	 * @return String
	 * @throws IOException 
	 */
	@RequestMapping(value = "/popup/workDelete.do")
	public void workDelete(@ModelAttribute("workVO") WorkVO workVO, HttpServletResponse response, HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) throws IOException{
		
		// 사용자관리 이력 남기기
		try {
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0020_02");
			accessHistoryService.insertHistory(historyVO);
		} catch (Exception e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}

		// work option delete
		WorkOptVO workOptVO = new WorkOptVO();
		workOptVO.setWrk_id(workVO.getWrk_id());
		try {
			backupService.deleteWorkOpt(workOptVO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		// work object delete
		try {
			backupService.deleteWorkObj(workVO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		// work delete
		try {
			backupService.deleteWork(workVO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		response.getWriter().println(workVO.getWrk_id());
	}
	
	/**
	 * Object insert
	 * @param WorkObjVO
	 * @return 
	 */
	@RequestMapping(value = "/popup/workObjWrite.do")
	public void workObjWrite(@ModelAttribute("WorkObjVO") WorkObjVO workObjVO, HttpServletRequest request){
		HttpSession session = request.getSession();
		String usr_id = (String) session.getAttribute("usr_id");

		try{
			workObjVO.setFrst_regr_id(usr_id);
			backupService.insertWorkObj(workObjVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * Object delete
	 * @param WorkVO
	 * @return 
	 */
	@RequestMapping(value = "/popup/workObjDelete.do")
	public void workObjDelete(@ModelAttribute("WorkVO") WorkVO workVO, HttpServletResponse response){
		try {
			backupService.deleteWorkObj(workVO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	
	/**
	 * work명을 중복 체크한다.
	 * 
	 * @param scd_nm
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/wrk_nmCheck.do")
	public @ResponseBody String wrk_nmCheck(@RequestParam("wrk_nm") String wrk_nm) {
		try {
			int resultSet = backupService.wrk_nmCheck(wrk_nm);
			if (resultSet > 0) {
				// 중복값이 존재함.
				return "false";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "true";
	}
}
