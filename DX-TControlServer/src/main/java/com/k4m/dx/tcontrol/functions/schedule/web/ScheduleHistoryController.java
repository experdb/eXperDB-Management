package com.k4m.dx.tcontrol.functions.schedule.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
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
				
				//이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0048");
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
				
				//이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0048_01");
				accessHistoryService.insertHistory(historyVO);
				
				Map<String, Object> param = new HashMap<String, Object>();
	
				String lgi_dtm_start = request.getParameter("lgi_dtm_start");
				String lgi_dtm_end = request.getParameter("lgi_dtm_end");
				String scd_nm = request.getParameter("scd_nm");
				String db_svr_nm = request.getParameter("db_svr_nm");
				if(scd_nm == null){
					scd_nm="%"+scd_nm+"%";
				}
				
				param.put("lgi_dtm_start", lgi_dtm_start);
				param.put("lgi_dtm_end", lgi_dtm_end);
				param.put("scd_nm", scd_nm);
				param.put("db_svr_nm", db_svr_nm);
	
				System.out.println("********PARAMETER*******");
				System.out.println("DB서버 : "+ db_svr_nm);
				System.out.println("스케줄명 : "+ scd_nm);
				System.out.println("시작날짜 : "+ lgi_dtm_start);
				System.out.println("종료날짜 : " +lgi_dtm_end);
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
				
				mv.setViewName("functions/scheduler/scheduleHistory");
						
				model.addAttribute("lgi_dtm_start", lgi_dtm_start);
				model.addAttribute("lgi_dtm_end", lgi_dtm_end);
				model.addAttribute("paginationInfo", paginationInfo);
				model.addAttribute("svr_nm", db_svr_nm);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
}
