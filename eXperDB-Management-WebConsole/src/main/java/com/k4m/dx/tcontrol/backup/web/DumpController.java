package com.k4m.dx.tcontrol.backup.web;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.dbauthority.service.DbAuthorityService;
import com.k4m.dx.tcontrol.backup.service.BackupService;
import com.k4m.dx.tcontrol.backup.service.DbVO;
import com.k4m.dx.tcontrol.backup.service.WorkVO;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.CmmnCodeDtlService;
import com.k4m.dx.tcontrol.common.service.CmmnCodeVO;
import com.k4m.dx.tcontrol.common.service.CmmnServerInfoService;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.common.service.PageVO;
import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleService;
import com.k4m.dx.tcontrol.login.service.LoginVO;

@Controller
public class DumpController {

	@Autowired
	private BackupService backupService;
	
	@Autowired
	private CmmnCodeDtlService cmmnCodeDtlService;
	
	@Autowired
	private AccessHistoryService accessHistoryService;
	
	@Autowired
	private DbAuthorityService dbAuthorityService;
	
	@Autowired
	private CmmnServerInfoService cmmnServerInfoService;
	
	@Autowired
	private ScheduleService scheduleService ;
	
	private List<Map<String, Object>> dbSvrAut;
	
	/**
	 * Mybatis Transaction 
	 */
	@Autowired
	private PlatformTransactionManager txManager;
	
	
	/**
	 * Work List View page
	 * @param WorkVO, historyVO, request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/backup/dumpList.do")
	public ModelAndView dumpList(@ModelAttribute("historyVO") HistoryVO historyVO,@ModelAttribute("workVo") WorkVO workVO, HttpServletRequest request) {
		int db_svr_id=workVO.getDb_svr_id();

		//유저 디비서버 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		dbSvrAut = cu.selectUserDBSvrAutList(dbAuthorityService,db_svr_id);
		ModelAndView mv = new ModelAndView();

		//읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
		if(dbSvrAut.get(0).get("bck_cng_aut_yn").equals("N")){
			mv.setViewName("error/autError");				
		}else{			
			try {
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0021");
				accessHistoryService.insertHistory(historyVO);
				
				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				String usr_id = loginVo.getUsr_id();
				workVO.setUsr_id(usr_id);
				
				mv.addObject("dbList",backupService.selectDbList(workVO));
				
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
	
			try {
				mv.addObject("db_svr_nm", backupService.selectDbSvrNm(workVO).getDb_svr_nm());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			if(request.getParameter("tabGbn") != null){
				mv.addObject("tabGbn",request.getParameter("tabGbn"));
			}

			mv.addObject("db_svr_id",workVO.getDb_svr_id());
			mv.setViewName("backup/dumpList");
		}
		return mv;
	}
	
	
	
	/**
	 * Backup Log View page
	 * @param WorkVO, historyVO, request
	 * @return ModelAndView
	 */
	@RequestMapping(value = "/backup/dumpLogList.do")
	public ModelAndView rmanLogList(@ModelAttribute("historyVO") HistoryVO historyVO,@ModelAttribute("workVo") WorkVO workVO, HttpServletRequest request) {
		int db_svr_id=workVO.getDb_svr_id();
		//유저 디비서버 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		dbSvrAut = cu.selectUserDBSvrAutList(dbAuthorityService,db_svr_id);
				
		ModelAndView mv = new ModelAndView();

		//읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
		if(dbSvrAut.get(0).get("bck_hist_aut_yn").equals("N")){
			mv.setViewName("error/autError");				
		}else{	
			try {
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0026");
				accessHistoryService.insertHistory(historyVO);
				
				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				String usr_id = loginVo.getUsr_id();
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

			if(request.getParameter("tabGbn") != null){
				mv.addObject("tabGbn",request.getParameter("tabGbn"));
			}
			
			mv.addObject("db_svr_id",workVO.getDb_svr_id());
			mv.setViewName("backup/dumpLogList");
		}
		return mv;	
	}
	
	
	/**
	 * 스케줄러 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/dumpSchedulerView.do")
	public ModelAndView dumpSchedulerView(@ModelAttribute("workVO") WorkVO workVO, @ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
		String db_svr_nm = request.getParameter("db_svr_nm");

		//해당메뉴 권한 조회 (공통메소드호출)
		CmmnUtils cu = new CmmnUtils();
		dbSvrAut = cu.selectUserDBSvrAutList(dbAuthorityService,db_svr_id);
		ModelAndView mv = new ModelAndView();
		List<DbVO> resultSet = null;
		
		try {			
			 if(dbSvrAut.get(0).get("policy_change_his_aut_yn").equals("N")){
				 mv.setViewName("error/autError");
			 }else{
				//화면접근이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0051");
				accessHistoryService.insertHistory(historyVO);
				
				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				String usr_id = loginVo.getUsr_id();
				workVO.setDb_svr_id(db_svr_id);
				workVO.setUsr_id(usr_id);
				
				resultSet=backupService.selectDbList(workVO);
				
				SimpleDateFormat frm= new SimpleDateFormat ("yyyyMMdd");
				Calendar cal = Calendar.getInstance();
				String end_date = frm.format(cal.getTime());
	
				mv.addObject("month",end_date);
				
				mv.addObject("dbList",resultSet);		
				mv.addObject("db_svr_id",db_svr_id);
				mv.addObject("db_svr_nm",db_svr_nm);
				mv.setViewName("functions/scheduler/dumpSchedulerView");
			 }
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
}
