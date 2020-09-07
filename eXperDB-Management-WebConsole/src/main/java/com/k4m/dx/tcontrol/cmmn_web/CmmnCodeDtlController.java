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

import com.k4m.dx.tcontrol.common.service.CmmnCodeDtlService;
import com.k4m.dx.tcontrol.common.service.CmmnCodeVO;
import com.k4m.dx.tcontrol.common.service.PageVO;
import com.k4m.dx.tcontrol.login.service.LoginVO;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;


/**
 * 상세코드관리 컨트롤러 클래스를 정의한다.
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
public class CmmnCodeDtlController {

	@Autowired
	private CmmnCodeDtlService cmmnCodeDtlService;
	
	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;
	
    /**
	 * 코드 목록을 조회한다.
     * @param loginVO
     * @param searchVO
     * @param model
     * @throws Exception
     */
    @RequestMapping(value="/cmmnCodeDtlList.do")
	public ModelAndView cmmnCodeDtlList (@ModelAttribute("cmmnCodeVO") CmmnCodeVO cmmnCodeVO, @ModelAttribute("pageVO") PageVO pageVO, ModelMap model) throws Exception {
    	ModelAndView mv = new ModelAndView();
    	
		String grp_cd = cmmnCodeVO.getGrp_cd();
		pageVO.setGrp_cd(grp_cd);
		
    	try {
    		
    		pageVO.setPageUnit(propertiesService.getInt("pageUnit"));
    		pageVO.setPageSize(propertiesService.getInt("pageSize"));

        	//** pageing *//
        	PaginationInfo paginationInfo = new PaginationInfo();
    		paginationInfo.setCurrentPageNo(pageVO.getPageIndex());
    		paginationInfo.setRecordCountPerPage(pageVO.getPageUnit());
    		paginationInfo.setPageSize(pageVO.getPageSize());
    		
    		pageVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
    		pageVO.setLastIndex(paginationInfo.getLastRecordIndex());
    		pageVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());		

    		@SuppressWarnings("unchecked")
			List<CmmnCodeVO> cmmnCodeList = cmmnCodeDtlService.cmmnCodeDtlList(pageVO, cmmnCodeVO);
			model.addAttribute("resultList", cmmnCodeList);
			model.addAttribute("grp_cd", grp_cd);
			
			
			int totCnt = cmmnCodeDtlService.selectCmmnCodeDtlListTotCnt(pageVO);
			paginationInfo.setTotalRecordCount(totCnt);
			model.addAttribute("paginationInfo", paginationInfo);

			mv.setViewName("cmmn/codeDtl/cmmnCodeDtlList");
			return mv;
			
			} catch (Exception e) {
				e.printStackTrace();
			}
			return mv;
	}
    
	/**
	 * 코드 등록/수정 폼 호출
	 * @return ModelAndView mv
	 */	
	@RequestMapping(value = "/cmmnCodeDtlRegist.do")
	public ModelAndView cmmnCodeDtlRegist(@ModelAttribute("cmmnCodeVO") CmmnCodeVO cmmnCodeVO, HttpServletRequest request, ModelMap model) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		try{
			String grp_cd = cmmnCodeVO.getGrp_cd();
			String regFlag = request.getParameter("regFlag");
	
			if(regFlag.equals("detail")){
				//List<CmmnCodeVO> cmmnCodeDetailList = cmmnCodeService.selectCmmnCodeDetailList( cmmnCodeVO);
				//model.addAttribute("resultList", cmmnCodeDetailList);
				//mv.setViewName("cmmn/cmmnCodeDetail");					
			}
			else{
				model.addAttribute("grp_cd", grp_cd);
				mv.setViewName("cmmn/codeDtl/cmmnCodeDtlRegist");		
			}				
		}catch (Exception e) {
			e.printStackTrace();
		}		
		return mv;	
	}
	
	
	/**
	 * 코드를 등록한다.
	 * @param cmmnCodeVO
	 * @throws Exception
	 * @return "forward:/cmmnCodeDtlList.do"
	 */	
	@RequestMapping(value = "/insertCmmnDtlCode.do")
	public String insertCmmnDtlCode(@ModelAttribute("cmmnCodeVO") CmmnCodeVO cmmnCodeVO, HttpServletRequest request){
		try {
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String usr_id = loginVo.getUsr_id();
			cmmnCodeVO.setUsr_id(usr_id);
			
			cmmnCodeDtlService.insertCmmnDtlCode(cmmnCodeVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "forward:/cmmnCodeDtlList.do";
	}
	
	
	
	/**
	 * 코드를 삭제한다.
	 * @param cmmnCodeVO
	 * @throws Exception
	 * @return "forward:/cmmnCodeDtlList.do"
	 */
	@RequestMapping(value = "/deleteCmmnDtlCode.do")
	public String deleteCmmnDtlCode(@ModelAttribute("cmmnCodeVO") CmmnCodeVO cmmnCodeVO){
		try {
			cmmnCodeDtlService.deleteCmmnDtlCode(cmmnCodeVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "forward:/cmmnCodeDtlList.do";
	}
	
	
	   /**
		 * 코드 목록을 조건 검색 조회한다.
	     * @param loginVO
	     * @param searchVO
	     * @param model
	     * @throws Exception
	     */
	    @RequestMapping(value="/cmmnDtlCodeSearch.do")
		public ModelAndView cmmnDtlCodeSearch (@ModelAttribute("cmmnCodeVO") CmmnCodeVO cmmnCodeVO, @ModelAttribute("pagingVO") PageVO pageVO, ModelMap model) throws Exception {
	    	ModelAndView mv = new ModelAndView();
	    
			String grp_cd = cmmnCodeVO.getGrp_cd();	
			pageVO.setGrp_cd(grp_cd);
			
	    	try {
				List<CmmnCodeVO> cmmnCodeList = cmmnCodeDtlService.cmmnDtlCodeSearch(pageVO);
				model.addAttribute("resultList", cmmnCodeList);
				model.addAttribute("grp_cd", grp_cd);

				mv.setViewName("cmmn/codeDtl/cmmnCodeDtlList");
				return mv;
				
				} catch (Exception e) {
					e.printStackTrace();
				}
				return mv;
		}
}
