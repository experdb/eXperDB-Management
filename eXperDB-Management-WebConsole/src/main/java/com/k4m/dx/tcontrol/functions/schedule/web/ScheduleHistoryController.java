package com.k4m.dx.tcontrol.functions.schedule.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityService;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleHistoryService;
import com.k4m.dx.tcontrol.login.service.LoginVO;
import com.k4m.dx.tcontrol.sample.service.PagingVO;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;


/**
 * 스케줄이력 컨트롤러 클래스를 정의한다.
 *
 * @author 변승우
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.07.03   변승우 최초 생성
 *      </pre>
 */
@Controller
public class ScheduleHistoryController {
	
	@Autowired
	private AccessHistoryService accessHistoryService;
	
	@Autowired
	private MenuAuthorityService menuAuthorityService;
	
	@Autowired
	private ScheduleHistoryService scheduleHistoryService;
	
	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;
	
	private List<Map<String, Object>> menuAut;
	
	/**
	 * 스케줄이력 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectScheduleHistoryView.do")
	public ModelAndView selectScheduleHistoryView(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("pagingVO") PagingVO pagingVO, ModelMap model, HttpServletRequest request) {
		
		//해당메뉴 권한 조회 (공통메소드호출)
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000103");
		
		ModelAndView mv = new ModelAndView();
		try {			
			//읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{				
				
				String exe_result = request.getParameter("exe_result");
				
				//화면접근이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0046");
				historyVO.setMnu_id(4);
				accessHistoryService.insertHistory(historyVO);
				
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
	
				/** EgovPropertyService.sample */
				pagingVO.setPageUnit(propertiesService.getInt("pageUnit"));
				pagingVO.setPageSize(propertiesService.getInt("pageSize"));
	
				/** pageing setting */
				PaginationInfo paginationInfo = new PaginationInfo();
				paginationInfo.setCurrentPageNo(pagingVO.getPageIndex());
				paginationInfo.setRecordCountPerPage(pagingVO.getPageUnit());
				paginationInfo.setPageSize(pagingVO.getPageSize());
	
				pagingVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
				pagingVO.setLastIndex(paginationInfo.getLastRecordIndex());
				pagingVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());
				
				model.addAttribute("paginationInfo", paginationInfo);
				model.addAttribute("exe_result", exe_result);
				mv.setViewName("functions/scheduler/scheduleHistory");
			}	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * 스케줄이력을 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectScheduleHistoryNew.do")
	@ResponseBody
	public List<Map<String, Object>> selectScheduleHistoryNew(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("pagingVO") PagingVO pagingVO, ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		List<Map<String, Object>> result = null;
		//해당메뉴 권한 조회 (공통메소드호출)
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000103");
		
		ModelAndView mv = new ModelAndView();
		try {		
			//읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{		
				
				//화면접근이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0046_01");
				historyVO.setMnu_id(4);
				accessHistoryService.insertHistory(historyVO);
				
				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				String usr_id = loginVo.getUsr_id();
				
				Map<String, Object> param = new HashMap<String, Object>();
	
				String lgi_dtm_start = request.getParameter("lgi_dtm_start");
				String lgi_dtm_end = request.getParameter("lgi_dtm_end");
				String scd_nm = request.getParameter("scd_nm");
				String db_svr_nm = request.getParameter("db_svr_nm");
				String exe_result = request.getParameter("exe_result");
				String order_type = request.getParameter("order_type");
				String order = request.getParameter("order");
						
				param.put("lgi_dtm_start", lgi_dtm_start);
				param.put("lgi_dtm_end", lgi_dtm_end);
				param.put("scd_nm", "%"+scd_nm+"%");
				param.put("db_svr_nm", "%"+db_svr_nm+"%");
				param.put("exe_result", exe_result);
				param.put("order_type", order_type);
				param.put("order", order);
				param.put("usr_id", usr_id);
	
				System.out.println("********PARAMETER*******");
				System.out.println("DB서버 : "+ "%"+db_svr_nm+"%");
				System.out.println("스케줄명 : "+ "%"+scd_nm+"%");
				System.out.println("시작날짜 : "+ lgi_dtm_start);
				System.out.println("종료날짜 : " +lgi_dtm_end);
				System.out.println("실행결과 : " +exe_result);
				System.out.println("*************************");

				result = scheduleHistoryService.selectScheduleHistoryNew(param);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}
	
	@RequestMapping(value = "/selectScheduleHistory.do")
	@ResponseBody
	public ModelAndView selectScheduleHistory(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("pagingVO") PagingVO pagingVO, ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		
		//해당메뉴 권한 조회 (공통메소드호출)
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000103");
		
		ModelAndView mv = new ModelAndView();
		try {		
			//읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{		
				
				//화면접근이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0046_01");
				historyVO.setMnu_id(4);
				accessHistoryService.insertHistory(historyVO);
				
				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				String usr_id = loginVo.getUsr_id();
				
				Map<String, Object> param = new HashMap<String, Object>();
	
				String lgi_dtm_start = request.getParameter("lgi_dtm_start");
				String lgi_dtm_end = request.getParameter("lgi_dtm_end");
				String scd_nm = request.getParameter("scd_nm");
				String db_svr_nm = request.getParameter("db_svr_nm");
				String exe_result = request.getParameter("exe_result");
				String order_type = request.getParameter("order_type");
				String order = request.getParameter("order");
						
				param.put("lgi_dtm_start", lgi_dtm_start);
				param.put("lgi_dtm_end", lgi_dtm_end);
				param.put("scd_nm", "%"+scd_nm+"%");
				param.put("db_svr_nm", "%"+db_svr_nm+"%");
				param.put("exe_result", exe_result);
				param.put("order_type", order_type);
				param.put("order", order);
				param.put("usr_id", usr_id);
	
				System.out.println("********PARAMETER*******");
				System.out.println("DB서버 : "+ "%"+db_svr_nm+"%");
				System.out.println("스케줄명 : "+ "%"+scd_nm+"%");
				System.out.println("시작날짜 : "+ lgi_dtm_start);
				System.out.println("종료날짜 : " +lgi_dtm_end);
				System.out.println("실행결과 : " +exe_result);
				System.out.println("*************************");
				
				/** EgovPropertyService.sample */
				pagingVO.setPageUnit(propertiesService.getInt("pageUnit"));
				pagingVO.setPageSize(propertiesService.getInt("pageSize"));
	
				/** pageing setting */
				PaginationInfo paginationInfo = new PaginationInfo();
				paginationInfo.setCurrentPageNo(pagingVO.getPageIndex());
				paginationInfo.setRecordCountPerPage(pagingVO.getPageUnit());
				paginationInfo.setPageSize(pagingVO.getPageSize());
	
				pagingVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
				pagingVO.setLastIndex(paginationInfo.getLastRecordIndex());
				pagingVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());
			
				List<Map<String, Object>> result = scheduleHistoryService.selectScheduleHistory(pagingVO,param);
				
				int totCnt = scheduleHistoryService.selectScheduleHistoryTotCnt(param);
				paginationInfo.setTotalRecordCount(totCnt);
				model.addAttribute("result", result);
								
				model.addAttribute("lgi_dtm_start", lgi_dtm_start);
				model.addAttribute("lgi_dtm_end", lgi_dtm_end);
				model.addAttribute("paginationInfo", paginationInfo);
				model.addAttribute("svr_nm", db_svr_nm);
				model.addAttribute("exe_result", exe_result);
				model.addAttribute("scd_nm", scd_nm);
				model.addAttribute("order", order);
				model.addAttribute("order_type", order_type);
				
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
				
				mv.setViewName("functions/scheduler/scheduleHistory");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	/**
	 * 스케줄수행이력 상세보기 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/scheduleHistoryDetail.do")
	public ModelAndView transferTargetDetail(@ModelAttribute("historyVO") HistoryVO historyVO,
			HttpServletRequest request) {
		ModelAndView mv = new ModelAndView("jsonView");
		List<Map<String, Object>> result = null;
		try {
			// 화면접근이력 이력 남기기
//			CmmnUtils.saveHistory(request, historyVO);
//			historyVO.setExe_dtl_cd("DX-T0018");
//			historyVO.setMnu_id(33);
//			accessHistoryService.insertHistory(historyVO);
			
			int exe_sn=Integer.parseInt(request.getParameter("exe_sn"));
			String locale_type = LocaleContextHolder.getLocale().getLanguage();
			result = scheduleHistoryService.selectScheduleHistoryDetail(exe_sn, locale_type);
			
			mv.addObject("exe_sn",exe_sn);
			mv.addObject("result",result);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}	
	
	
	/**
	 * work 정보를 조회한다.
	 * 
	 * @param request
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectScheduleHistoryWorkDetail.do")
	public @ResponseBody List<Map<String, Object>> selectScheduleHistoryWorkDetail(@ModelAttribute("historyVO") HistoryVO historyVO,HttpServletRequest request,HttpServletResponse response) {
		List<Map<String, Object>> result = null;
		try {
			int exe_sn = Integer.parseInt(request.getParameter("exe_sn")); 
			String locale_type = LocaleContextHolder.getLocale().getLanguage();
			result = scheduleHistoryService.selectScheduleHistoryWorkDetail(exe_sn, locale_type);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;

	}
	
	/**
	 * 스케줄실패 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectScheduleHistoryFail.do")
	public ModelAndView selectScheduleHistoryFail(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		
		//해당메뉴 권한 조회 (공통메소드호출)
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000103");
		
		ModelAndView mv = new ModelAndView();
		try {			
			//읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{				
				//화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0047");
				accessHistoryService.insertHistory(historyVO);
				
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
				mv.setViewName("functions/scheduler/scheduleHistoryFail");
			}			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	/**
	 * 스케줄이력을 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
/*	@RequestMapping(value = "/selectScheduleHistoryFail.do")
	@ResponseBody
	public ModelAndView selectScheduleHistoryFail(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("pagingVO") PagingVO pagingVO, ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		
		//해당메뉴 권한 조회 (공통메소드호출)
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000103");
		
		ModelAndView mv = new ModelAndView();
		try {		
			//읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{		
				
				//이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0048_01");
				accessHistoryService.insertHistory(historyVO);

				List<Map<String, Object>> result = scheduleHistoryService.selectScheduleHistory();
						
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
				
				mv.setViewName("functions/scheduler/scheduleHistoryFail");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}*/
	
	
	/**
	 * 스케줄 실패 work List를 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectScheduleFailList.do")
	@ResponseBody
	public List<Map<String, Object>> selectScheduleFailList(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
	
		//해당메뉴 권한 조회 (공통메소드호출)
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000103");
		Map<String, Object> param = new HashMap<String, Object>();	
		List<Map<String, Object>> result = null;
		
		try {					
			
			String scd_nm = request.getParameter("scd_nm");
			String wrk_nm = request.getParameter("wrk_nm");
			String fix_rsltcd = request.getParameter("fix_rsltcd");
		
			param.put("scd_nm", scd_nm);
			param.put("wrk_nm", wrk_nm);
			param.put("fix_rsltcd", fix_rsltcd);
					
			//이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
		//	historyVO.setExe_dtl_cd("DX-T0048_02");
		//	accessHistoryService.insertHistory(historyVO);
			
			//읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return result;
			}else{		
				result = scheduleHistoryService.selectScheduleHistoryFail(param);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	/**
	 * 스케줄명 조회 [SELECT BOX] 
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectScheduleNmList.do")
	@ResponseBody
	public List<Map<String, Object>> selectScheduleNmList(HttpServletRequest request) {
		List<Map<String, Object>> resultSet = null;
		try {			
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String usr_id = loginVo.getUsr_id();
			
			Map<String, Object> param = new HashMap<String, Object>();
			
			String wrk_start_dtm = request.getParameter("wrk_start_dtm");
			String wrk_end_dtm = request.getParameter("wrk_end_dtm");
			
			param.put("wrk_start_dtm", wrk_start_dtm);
			param.put("wrk_end_dtm", wrk_end_dtm);
			param.put("usr_id", usr_id);
			
			resultSet = scheduleHistoryService.selectScheduleNmList(param);	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
	
	
	/**
	 * DBMS 조회 [SELECT BOX] 
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectScheduleDBMSList.do")
	@ResponseBody
	public List<Map<String, Object>> selectScheduleDBMSList(HttpServletRequest request) {
		List<Map<String, Object>> resultSet = null;
		try {			
			Map<String, Object> param = new HashMap<String, Object>();
			
			String wrk_start_dtm = request.getParameter("wrk_start_dtm");
			String wrk_end_dtm = request.getParameter("wrk_end_dtm");
			
			param.put("wrk_start_dtm", wrk_start_dtm);
			param.put("wrk_end_dtm", wrk_end_dtm);
			
			resultSet = scheduleHistoryService.selectScheduleDBMSList(param);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
	
	/**
	 * 스케줄명 조회 [SELECT BOX] 
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectWrkNmList.do")
	@ResponseBody
	public List<Map<String, Object>> selectWrkNmList(HttpServletRequest request) {
	
		List<Map<String, Object>> resultSet = null;
		try {			
			Map<String, Object> param = new HashMap<String, Object>();
			
			String scd_nm = request.getParameter("scd_nm");

			param.put("scd_nm", scd_nm);

			resultSet = scheduleHistoryService.selectWrkNmList(param);	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
}
