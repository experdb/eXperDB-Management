package com.k4m.dx.tcontrol.cmmn_web;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.common.service.CmmnCodeService;
import com.k4m.dx.tcontrol.common.service.CmmnCodeVO;
import com.k4m.dx.tcontrol.common.service.PageVO;
import com.k4m.dx.tcontrol.login.service.LoginVO;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;


/**
 * 공통 코드관리 컨트롤러 클래스를 정의한다.
 *
 * @author 변승우
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.06.08   변승우 최초 생성
 *      </pre>
 */

@Controller
public class CmmnCodeController {

	@Autowired
	private CmmnCodeService cmmnCodeService;
	
	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;
	
    /**
	 * 그룹코드 목록을 조회한다.
     * @param loginVO
     * @param searchVO
     * @param model
     * @throws Exception
     */
    @RequestMapping(value="/cmmnCodeList.do")
	public ModelAndView cmmnCodeList (@ModelAttribute("cmmnCodeVO") CmmnCodeVO cmmnCodeVO, @ModelAttribute("pageVO") PageVO pageVO, ModelMap model) throws Exception {
    	ModelAndView mv = new ModelAndView();
    	
    	try {
    		    		
    		pageVO.setPageUnit(propertiesService.getInt("pageUnit"));
    		pageVO.setPageSize(propertiesService.getInt("pageSize"));

        	/** pageing */
        	PaginationInfo paginationInfo = new PaginationInfo();
    		paginationInfo.setCurrentPageNo(pageVO.getPageIndex());
    		paginationInfo.setRecordCountPerPage(pageVO.getPageUnit());
    		paginationInfo.setPageSize(pageVO.getPageSize());
    		
    		pageVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
    		pageVO.setLastIndex(paginationInfo.getLastRecordIndex());
    		pageVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());		
    			
    		@SuppressWarnings("unchecked")
			List<CmmnCodeVO> cmmnCodeList = cmmnCodeService.selectCmmnCodeList(pageVO, cmmnCodeVO);
			model.addAttribute("resultList", cmmnCodeList);

			
			int totCnt = cmmnCodeService.selectCmmnCodeListTotCnt(pageVO);
			paginationInfo.setTotalRecordCount(totCnt);
			model.addAttribute("paginationInfo", paginationInfo);

			mv.setViewName("cmmn/cmmnCodeList");
			return mv;
			
			} catch (Exception e) {
				e.printStackTrace();
			}
			return mv;
	}
    
	/**
	 * 그룹코드 등록/수정 폼 호출
	 * @return ModelAndView mv
	 */	
	@RequestMapping(value = "/cmmnCodeRegist.do")
	public ModelAndView cmmnCodeRegist(@ModelAttribute("cmmnCodeVO") CmmnCodeVO cmmnCodeVO, HttpServletRequest request, ModelMap model) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		try{
			
			String regFlag = request.getParameter("regFlag");
	
			if(regFlag.equals("detail")){
				List<CmmnCodeVO> cmmnCodeDetailList = cmmnCodeService.selectCmmnCodeDetailList(cmmnCodeVO);
				model.addAttribute("resultList", cmmnCodeDetailList);
				mv.setViewName("cmmn/cmmnCodeDetail");					
			}
			else{
				mv.setViewName("cmmn/cmmnCodeRegist");		
			}				
		}catch (Exception e) {
			e.printStackTrace();
		}		
		return mv;	
	}
	
	
	/**
	 * 그룹코드를 등록한다.
	 * @param cmmnCodeVO
	 * @throws Exception
	 * @return "forward:/cmmnCodeList.do"
	 */	
	@RequestMapping(value = "/insertCmmnCode.do")
	public String insertCmmnCode(@ModelAttribute("cmmnCodeVO") CmmnCodeVO cmmnCodeVO, HttpServletRequest request){
		try {
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String usr_id = loginVo.getUsr_id();
			cmmnCodeVO.setUsr_id(usr_id);
			
			cmmnCodeService.insertCmmnCode(cmmnCodeVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "forward:/cmmnCodeList.do";
	}
	
	
	/**
	 * 그룹코드를 수정한다.
	 * @param cmmnCodeVO
	 * @throws Exception
	 * @return "forward:/cmmnCodeList.do"
	 */
	@RequestMapping(value = "/updateCmmnCode.do")
	public String updateCmmnCode(@ModelAttribute("cmmnCodeVO") CmmnCodeVO cmmnCodeVO, HttpServletRequest request){
		try {		
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String usr_id = loginVo.getUsr_id();
			cmmnCodeVO.setUsr_id(usr_id);

			cmmnCodeService.updateCmmnCode(cmmnCodeVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "forward:/cmmnCodeList.do";
	}
	
	
	/**
	 * 그룹코드를 삭제한다.
	 * @param cmmnCodeVO
	 * @throws Exception
	 * @return "forward:/cmmnCodeList.do"
	 */
	@RequestMapping(value = "/deleteCmmnCode.do")
	public String deleteCmmnCode(@ModelAttribute("cmmnCodeVO") CmmnCodeVO cmmnCodeVO){
		try {
			cmmnCodeService.deleteCmmnCode(cmmnCodeVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "forward:/cmmnCodeList.do";
	}
	
	
	   /**
		 * 그룹코드 목록을 조건 검색 조회한다.
	     * @param loginVO
	     * @param searchVO
	     * @param model
	     * @throws Exception
	     */
	    @RequestMapping(value="/cmmnCodeSearch.do")
		public ModelAndView cmmnCodeSearch (@ModelAttribute("cmmnCodeVO") CmmnCodeVO cmmnCodeVO, @ModelAttribute("pagingVO") PageVO pageVO, ModelMap model) throws Exception {
	    	ModelAndView mv = new ModelAndView();
	    	try {
				List<CmmnCodeVO> cmmnCodeList = cmmnCodeService.cmmnCodeSearch(pageVO);
				model.addAttribute("resultList", cmmnCodeList);
				mv.setViewName("cmmn/cmmnCodeList");
				return mv;
				
				} catch (Exception e) {
					e.printStackTrace();
				}
				return mv;
		}	
}
