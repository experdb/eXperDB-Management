package com.k4m.dx.tcontrol.admin.accesshistory.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import com.k4m.dx.tcontrol.login.service.UserVO;
import com.k4m.dx.tcontrol.sample.service.PagingVO;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

/**
 * 접근내역 컨트롤러 클래스를 정의한다.
 *
 * @author 김주영
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.06.07   김주영 최초 생성
 *      </pre>
 */
@Controller
public class AccessHistoryController {

	@Autowired
	private AccessHistoryService accessHistoryService;

	@Autowired
	private MenuAuthorityService menuAuthorityService;

	private List<Map<String, Object>> menuAut;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/**
	 * 접근이력 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/accessHistory.do")
	public ModelAndView accessHistory(@ModelAttribute("pagingVO") PagingVO pagingVO, ModelMap model,
			@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();	
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000601");
			String locale_type = LocaleContextHolder.getLocale().getLanguage();
			
			if (menuAut.get(0).get("read_aut_yn").equals("N")) {
				mv.setViewName("error/autError");
				return mv;
			}
			mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
			mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));

			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0039");
			historyVO.setMnu_id(18);
			accessHistoryService.insertHistory(historyVO);
			
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

			List<HistoryVO> ScreenNames = accessHistoryService.selectAccessScreenName(locale_type);
			model.addAttribute("ScreenNames", ScreenNames);
			model.addAttribute("paginationInfo", paginationInfo);

			mv.setViewName("admin/accessHistory/accessHistory");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;

	}

	/**
	 * 접근이력을 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectAccessHistory.do")
	@ResponseBody
	public ModelAndView selectAccessHistory(@ModelAttribute("pagingVO") PagingVO pagingVO, ModelMap model,
			@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000601");

			if (menuAut.get(0).get("read_aut_yn").equals("N")) {
				mv.setViewName("error/autError");
				return mv;
			}

			mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
			mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));

			Map<String, Object> param = new HashMap<String, Object>();
			String lgi_dtm_start = request.getParameter("lgi_dtm_start");
			String lgi_dtm_end = request.getParameter("lgi_dtm_end");
			String type = request.getParameter("type");
			String search = request.getParameter("search");
			String order_type = request.getParameter("order_type");
			String order = request.getParameter("order");
			String sys_cd = request.getParameter("sys_cd");		
			String locale_type = LocaleContextHolder.getLocale().getLanguage();
			
			if (search != null) {
				model.addAttribute("search", search);
				search = "%" + search + "%";
			}
			param.put("lgi_dtm_start", lgi_dtm_start);
			param.put("lgi_dtm_end", lgi_dtm_end);
			param.put("type", type);
			param.put("search", search);
			param.put("order_type", order_type);
			param.put("order", order);
			param.put("sys_cd", sys_cd);

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

			List<Map<String, Object>> result = accessHistoryService.selectAccessHistory(pagingVO, param);
			
			int totCnt = accessHistoryService.selectAccessHistoryTotCnt(param);
			paginationInfo.setTotalRecordCount(totCnt);
			
			List<HistoryVO> ScreenNames = accessHistoryService.selectAccessScreenName(locale_type);
			model.addAttribute("ScreenNames", ScreenNames);
			model.addAttribute("sys_cd", sys_cd);
			model.addAttribute("lgi_dtm_start", lgi_dtm_start);
			model.addAttribute("lgi_dtm_end", lgi_dtm_end);
			model.addAttribute("type", type);
			model.addAttribute("order", order);
			model.addAttribute("order_type", order_type);
			model.addAttribute("paginationInfo", paginationInfo);
			model.addAttribute("result", result);

			mv.setViewName("admin/accessHistory/accessHistory");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * 접근이력을 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectSearchAccessHistoryNew.do")
	@ResponseBody
	public List<Map<String, Object>> selectSearchAccessHistoryNew(@ModelAttribute("pagingVO") PagingVO pagingVO, ModelMap model,
			@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		List<Map<String, Object>> result = null;
		
		CmmnUtils cu = new CmmnUtils();

		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0039_02");
			historyVO.setMnu_id(18);
			accessHistoryService.insertHistory(historyVO);

			Map<String, Object> param = new HashMap<String, Object>();
			
			String lgi_dtm_start = request.getParameter("lgi_dtm_start");
			String lgi_dtm_end = request.getParameter("lgi_dtm_end");
			String type = request.getParameter("type");
			String search = request.getParameter("search");
			String order_type = request.getParameter("order_type");
			String order = request.getParameter("order");
			String sys_cd = request.getParameter("sys_cd");		
			String locale_type = LocaleContextHolder.getLocale().getLanguage();
			
			if (search != null) {
				model.addAttribute("search", search);
				search = "%" + search + "%";
			}
			
			param.put("lgi_dtm_start", lgi_dtm_start);
			param.put("lgi_dtm_end", lgi_dtm_end);
			param.put("type", type);
			param.put("search", search);
			param.put("order_type", order_type);
			param.put("order", order);
			param.put("sys_cd", sys_cd);
			param.put("locale_type", locale_type);
			
			System.out.println("locale check!!! : " + locale_type);
			System.out.println("locale String EN check !!! " + locale_type.equals("en"));
			System.out.println("locale String KR check !!! " + locale_type.equals("ko"));

			result = accessHistoryService.selectAccessHistoryNew(param);
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * 접근이력을 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectSearchAccessHistory.do")
	@ResponseBody
	public ModelAndView selectSearchAccessHistory(@ModelAttribute("pagingVO") PagingVO pagingVO, ModelMap model,
			@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000601");
			if (menuAut.get(0).get("read_aut_yn").equals("N")) {
				mv.setViewName("error/autError");
				return mv;
			}
			mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
			mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));

			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0039_02");
			historyVO.setMnu_id(18);
			accessHistoryService.insertHistory(historyVO);

			Map<String, Object> param = new HashMap<String, Object>();
			String lgi_dtm_start = request.getParameter("lgi_dtm_start");
			String lgi_dtm_end = request.getParameter("lgi_dtm_end");
			String type = request.getParameter("type");
			String search = request.getParameter("search");
			String order_type = request.getParameter("order_type");
			String order = request.getParameter("order");
			String sys_cd = request.getParameter("sys_cd");		
			String locale_type = LocaleContextHolder.getLocale().getLanguage();
			
			if (search != null) {
				model.addAttribute("search", search);
				search = "%" + search + "%";
			}
			param.put("lgi_dtm_start", lgi_dtm_start);
			param.put("lgi_dtm_end", lgi_dtm_end);
			param.put("type", type);
			param.put("search", search);
			param.put("order_type", order_type);
			param.put("order", order);
			param.put("sys_cd", sys_cd);
			param.put("locale_type", locale_type);

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

			List<Map<String, Object>> result = accessHistoryService.selectAccessHistory(pagingVO, param);
			
			int totCnt = accessHistoryService.selectAccessHistoryTotCnt(param);
			paginationInfo.setTotalRecordCount(totCnt);
			
			List<HistoryVO> ScreenNames = accessHistoryService.selectAccessScreenName(locale_type);
			model.addAttribute("ScreenNames", ScreenNames);
			model.addAttribute("sys_cd", sys_cd);
			model.addAttribute("lgi_dtm_start", lgi_dtm_start);
			model.addAttribute("lgi_dtm_end", lgi_dtm_end);
			model.addAttribute("type", type);
			model.addAttribute("order", order);
			model.addAttribute("order_type", order_type);
			model.addAttribute("paginationInfo", paginationInfo);
			model.addAttribute("result", result);

			mv.setViewName("admin/accessHistory/accessHistory");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * 접근이력 엑셀을 저장한다.
	 * 
	 * @param request
	 * @throws Exception
	 */
	@RequestMapping("/accessHistory_Excel.do")
	public ModelAndView accessHistory_Excel(@ModelAttribute("historyVO") HistoryVO historyVO,
			HttpServletResponse response, HttpServletRequest request) throws Exception {
		List<UserVO> resultSet = null;
		Map<String, Object> param = new HashMap<String, Object>();
		try {
            Cookie cookie = new Cookie("fileDownload", "true");
            cookie.setPath("/");
            response.addCookie(cookie);
			
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000601");

			if (menuAut.get(0).get("read_aut_yn").equals("N")) {
				response.sendRedirect("/autError.do");
				return null;
			}

			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0039_01");
			historyVO.setMnu_id(18);
			accessHistoryService.insertHistory(historyVO);

			String lgi_dtm_start = request.getParameter("lgi_dtm_start");
			String lgi_dtm_end = request.getParameter("lgi_dtm_end");
			String type = request.getParameter("excel_type");
			String search = request.getParameter("excel_search");
			String order_type = request.getParameter("excel_order_type");
			String order = request.getParameter("excel_order");
			String sys_cd = request.getParameter("excel_sys_cd");
			String locale_type = LocaleContextHolder.getLocale().getLanguage();

			param.put("lgi_dtm_start", lgi_dtm_start);
			param.put("lgi_dtm_end", lgi_dtm_end);
			param.put("type", type);
			param.put("search", search);
			param.put("order_type", order_type);
			param.put("order", order);
			param.put("sys_cd", sys_cd);
			param.put("locale_type", locale_type);

			resultSet = accessHistoryService.selectAccessHistoryExcel(param);

			Map<String, Object> map = new HashMap<String, Object>();
			map.put("category", resultSet);

			//return new ModelAndView("categoryExcelView", "categoryMap", map);
			
			return new ModelAndView("overallExcelView", "categoryMap", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

}
