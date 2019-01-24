package com.k4m.dx.tcontrol.restore.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

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
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityService;
import com.k4m.dx.tcontrol.backup.service.BackupService;
import com.k4m.dx.tcontrol.backup.service.WorkVO;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
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
	private MenuAuthorityService menuAuthorityService;
	
	@Autowired
	private AccessHistoryService accessHistoryService;
	
	@Autowired
	private RestoreService restoreService;
	
	private List<Map<String, Object>> menuAut;
	
	
	/**
	 * [Restore] 긴급복구 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/emergencyRestore.do")
	public ModelAndView emergencyRestore(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, @ModelAttribute("workVo") WorkVO workVO) {
		
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
				historyVO.setExe_dtl_cd("DX-T0009");
				historyVO.setMnu_id(11);
				accessHistoryService.insertHistory(historyVO);
				
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
				mv.setViewName("restore/emergencyRestore");
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
				historyVO.setExe_dtl_cd("DX-T0009");
				historyVO.setMnu_id(11);
				accessHistoryService.insertHistory(historyVO);
				
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
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
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return mv;
	}	
	
	
	/**
	 *  [Restore] RMAN 복구 정보 등록 한다.
	 * 
	 * @param dbServerVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertRmanRestore.do")
	public @ResponseBody void insertRmanRestore(
			@ModelAttribute("accessControlHistoryVO") AccessControlHistoryVO accessControlHistoryVO,
			@ModelAttribute("accessControlVO") AccessControlVO accessControlVO, @ModelAttribute("restoreRmanVO") RestoreRmanVO restoreRmanVO, @ModelAttribute("historyVO") HistoryVO historyVO,
			HttpServletRequest request, HttpServletResponse response) throws ParseException {

		// 해당메뉴 권한 조회 (공통메소드호출)
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000301");
		
		try {
			// 쓰기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if (menuAut.get(0).get("wrt_aut_yn").equals("N")) {
				response.sendRedirect("/autError.do");
			} else {
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0005_01");
				historyVO.setMnu_id(9);
				accessHistoryService.insertHistory(historyVO);

				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				String id = loginVo.getUsr_id();

				restoreRmanVO.setRegr_id(id);

				restoreService.insertRmanRestore(restoreRmanVO);		
			}
		} catch (Exception e) {
			e.printStackTrace();
		}	
	}	
	
	
	/**
	 * 복구명을 중복 체크한다.
	 * 
	 * @param scd_nm
	 * @return
	 * @throws Exception
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
	
}
