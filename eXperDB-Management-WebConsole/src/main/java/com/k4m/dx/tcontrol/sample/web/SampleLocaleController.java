package com.k4m.dx.tcontrol.sample.web;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.sample.service.PagingVO;
import com.k4m.dx.tcontrol.sample.service.SampleListService;
import com.k4m.dx.tcontrol.sample.service.SampleListVO;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

/**
 * SampleLocale 컨트롤러 클래스를 정의한다.
 *
 * @author 변승우
 * @see <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.05.22   변승우 최초 생성
 * </pre>
 */

@Controller
public class SampleLocaleController {
	
	@Autowired
	private SampleListService sampleListService;
	
	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;
	
	/**
	 * 샘플리스트를 조회한다.
	 * @param sampleListVo
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectsampleLocaleList.do")
	public ModelAndView selectsampleLocaleList(@ModelAttribute("sampleListVo") SampleListVO sampleListVo,@ModelAttribute("searchVO") PagingVO searchVO, ModelMap model){
		 ModelAndView mv = new ModelAndView();
			try {			
				/** EgovPropertyService.sample */
				searchVO.setPageUnit(propertiesService.getInt("pageUnit"));
				searchVO.setPageSize(propertiesService.getInt("pageSize"));

				/** pageing setting */
				PaginationInfo paginationInfo = new PaginationInfo();
				paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
				paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());
				paginationInfo.setPageSize(searchVO.getPageSize());

				searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
				searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
				searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

				List<SampleListVO> sampleList = sampleListService.selectSampleList(searchVO);
				model.addAttribute("resultList", sampleList);

				int totCnt = sampleListService.selectSampleListTotCnt(searchVO);
				paginationInfo.setTotalRecordCount(totCnt);
				model.addAttribute("paginationInfo", paginationInfo);

				mv.setViewName("sample/sampleLocale");
				return mv;		       
			} catch(Exception e) {
				e.printStackTrace();
			}
			 return mv;

	}

}
