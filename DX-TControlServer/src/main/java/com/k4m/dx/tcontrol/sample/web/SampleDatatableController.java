package com.k4m.dx.tcontrol.sample.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.sample.service.SampleDatatableService;
import com.k4m.dx.tcontrol.sample.service.SampleListService;
import com.k4m.dx.tcontrol.sample.service.SampleListVO;

/**
 * SampleDatatable 컨트롤러 클래스를 정의한다.
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
public class SampleDatatableController {
	
	@Autowired
	private SampleDatatableService sampleDatatableService;
	
	@Autowired
	private SampleListService sampleListService;
	
	
	/**
	 * 샘플 데이터테이블 페이지를 보여준다.
	 * @return ModelAndView mv
	 * @throws Exception
	 */	
	@RequestMapping(value = "/sampleDatatableList.do")
	public ModelAndView sampleDatatableList() throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("sample/sampleDatatable");
		return mv;	
	}
	

	/**
	 * 샘플 데이터테이블 리스트를 조회한다.
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value="/selectSampleDatatableList.do")
	@ResponseBody
	public List<SampleListVO> selectSampleDatatableList(){
		List<SampleListVO> resultSet = null;
		try {
			resultSet = sampleDatatableService.selectSampleDatatableList();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
		
	}
	
	
	/**
	 * 샘플 데이터테이블 글 등록 화면을 조회한다.
	 * @param sampleListVo
	 * @param req
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/sampleDatatableForm.do")
	public ModelAndView sampleDatatableForm(@ModelAttribute("sampleListVo") SampleListVO sampleListVo,HttpServletRequest req){	
		ModelAndView mv = new ModelAndView();
		String registerFlag=req.getParameter("registerFlag");			
			try {	
				mv.addObject("registerFlag", registerFlag);
				if (registerFlag.equals("update")) {
					List<SampleListVO> result = sampleListService.selectDetailSampleList(sampleListVo);
					mv.addObject("result", result);
				}
				mv.setViewName("sample/sampleDatatableForm");
				return mv;		       
			} catch(Exception e) {
				e.printStackTrace();
			}
			 return mv;
	}
	
	
	/**
	 * 샘플 데이터테이블 글을 등록한다.
	 * @param sampleListVo
	 * @throws Exception
	 * @return true
	 */
	@RequestMapping(value = "/insertSampleDatatable.do")
	public boolean insertSampleDatatable(@ModelAttribute("sampleListVo") SampleListVO sampleListVo){
		try {
			sampleListService.insertSampleList(sampleListVo);		
		} catch(Exception e) {
			e.printStackTrace();
		}
		return true;
	}
	
	
	/**
	 * 샘플 데이터테이블 글을 수정한다.
	 * @param sampleListVo
	 * @throws Exception
	 * @return true
	 */
	@RequestMapping(value = "/updateSampleDatatable.do")
	public boolean updateSampleDatatable(@ModelAttribute("sampleListVo") SampleListVO sampleListVo){
		try {
			sampleListService.updateSampleList(sampleListVo);
		} catch(Exception e) {
			e.printStackTrace();
		}
		return true;
	}
	
	
	/**
	 * 샘플 데이터테이블 글을 삭제한다.
	 * @param sampleListVo
	 * @throws Exception
	 * @return true
	 */
	@RequestMapping(value = "/deleteSampleDatatable.do")
	public boolean deleteSampleDatatable(@ModelAttribute("sampleListVo") SampleListVO sampleListVo){
		try {
			sampleListService.deleteSampleList(sampleListVo);	
		} catch(Exception e) {
			e.printStackTrace();
		}
		return true;
	}
	
}
