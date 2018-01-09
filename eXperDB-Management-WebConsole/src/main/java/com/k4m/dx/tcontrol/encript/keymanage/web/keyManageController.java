package com.k4m.dx.tcontrol.encript.keymanage.web;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.common.service.HistoryVO;

/**
 * keyManageController 컨트롤러 클래스를 정의한다.
 *
 * @author 김주영
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2018.01.09   김주영 최초 생성
 *      </pre>
 */
@Controller
public class keyManageController {

	@Autowired
	private AccessHistoryService accessHistoryService;

	/**
	 * 암호화 키 리스트 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/keyManage.do")
	public ModelAndView keyManage(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			// 화면접근이력 이력 남기기
//			CmmnUtils.saveHistory(request, historyVO);
//			historyVO.setExe_dtl_cd("DX-T0055");
//			accessHistoryService.insertHistory(historyVO);

			mv.setViewName("encript/keyManage/keyManage");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	
	/**
	 * 암호화 키 등록 팝업을 보여준다.
	 * 
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/keyManageRegForm.do")
	public ModelAndView keyManageRegForm(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {

//			// 화면접근이력 이력 남기기
//			historyVO.setExe_dtl_cd("DX-T0056");
//			historyVO.setMnu_id(12);
//			accessHistoryService.insertHistory(historyVO);

			mv.setViewName("encript/popup/keyManageRegForm");

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;

	}
	
	/**
	 * 암호화 키 수정 팝업을 보여준다.
	 * 
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/keyManageRegReForm.do")
	public ModelAndView keyManageRegReForm(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {

//			// 화면접근이력 이력 남기기
//			historyVO.setExe_dtl_cd("DX-T0056");
//			historyVO.setMnu_id(12);
//			accessHistoryService.insertHistory(historyVO);

			mv.setViewName("encript/popup/keyManageRegReForm");

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;

	}
}
