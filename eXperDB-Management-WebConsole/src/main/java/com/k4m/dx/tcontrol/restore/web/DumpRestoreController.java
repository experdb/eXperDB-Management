package com.k4m.dx.tcontrol.restore.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.dbauthority.service.DbAuthorityService;
import com.k4m.dx.tcontrol.backup.service.BackupService;
import com.k4m.dx.tcontrol.backup.service.WorkVO;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.login.service.LoginVO;

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
	
	private List<Map<String, Object>> dbSvrAut;
	
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
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0026");
			accessHistoryService.insertHistory(historyVO);
			
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
	 * [Restore] 덤프복구 등록 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/dumpRestoreRegVeiw.do")
	public ModelAndView dumpRestoreRegVeiw(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request,@ModelAttribute("workVo") WorkVO workVO) {
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
				//historyVO.setExe_dtl_cd("DX-T0009");
				accessHistoryService.insertHistory(historyVO);
				
				mv.setViewName("restore/dumpRestoreRegVeiw");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
}
