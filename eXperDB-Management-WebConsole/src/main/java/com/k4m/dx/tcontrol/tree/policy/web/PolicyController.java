package com.k4m.dx.tcontrol.tree.policy.web;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.HistoryVO;

/**
 * PolicyController 컨트롤러 클래스를 정의한다.
 *
 * @author 김주영
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.11.20   김주영 최초 생성
 *      </pre>
 */
@Controller
public class PolicyController {

	@Autowired
	private AccessHistoryService accessHistoryService;

	/**
	 * 보안정책관리 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/policyList.do")
	public ModelAndView workList(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0055");
			accessHistoryService.insertHistory(historyVO);

			mv.setViewName("policy/policyList");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * 보안정책 등록 화면을 보여준다.
	 * 
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/policyRegForm.do")
	public ModelAndView userManagerForm(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {

//			// 화면접근이력 이력 남기기
//			historyVO.setExe_dtl_cd("DX-T0056");
//			historyVO.setMnu_id(12);
//			accessHistoryService.insertHistory(historyVO);

			mv.setViewName("popup/policyRegForm");

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;

	}
}
