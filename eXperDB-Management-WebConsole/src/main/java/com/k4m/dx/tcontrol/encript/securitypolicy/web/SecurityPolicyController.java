package com.k4m.dx.tcontrol.encript.securitypolicy.web;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.encript.service.call.SecurityPolicyServiceCall;

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
public class SecurityPolicyController {

	@Autowired
	private AccessHistoryService accessHistoryService;

	String restIp = "127.0.0.1";
	int restPort = 8443;
	String strTocken = "viPUUa9Jz/YJrsDwh+ITtkPxJL/U3ji9X+p4Y4BRrRg=";
	
	/**
	 * 보안정책관리 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/securityPolicy.do")
	public ModelAndView securityPolicy(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0055");
			accessHistoryService.insertHistory(historyVO);

			mv.setViewName("encript/securityPolicy/securityPolicy");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	
	/**
	 * 보안정책관리 리스트를 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectSecurityPolicy.do")
	public @ResponseBody JSONObject selectSecurityPolicy(HttpServletRequest request) {
		SecurityPolicyServiceCall sic = new SecurityPolicyServiceCall();
		JSONObject result = new JSONObject();
		try {
			result = sic.selectProfileList(restIp, restPort, strTocken);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * 보안정책등록 화면을 보여준다.
	 * 
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/securityPolicyInsert.do")
	public ModelAndView securityPolicyInsert(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {

//			// 화면접근이력 이력 남기기
//			historyVO.setExe_dtl_cd("DX-T0056");
//			historyVO.setMnu_id(12);
//			accessHistoryService.insertHistory(historyVO);

			mv.setViewName("encript/securityPolicy/securityPolicyInsert");

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * 보안정책수정 화면을 보여준다.
	 * 
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/securityPolicyModify.do")
	public ModelAndView securityPolicyModify(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {

//			// 화면접근이력 이력 남기기
//			historyVO.setExe_dtl_cd("DX-T0056");
//			historyVO.setMnu_id(12);
//			accessHistoryService.insertHistory(historyVO);

			mv.setViewName("encript/securityPolicy/securityPolicyModify");

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * 암복호화 정책 등록 팝업을 보여준다.
	 * 
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/securityPolicyRegForm.do")
	public ModelAndView securityPolicyRegForm(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {

//			// 화면접근이력 이력 남기기
//			historyVO.setExe_dtl_cd("DX-T0056");
//			historyVO.setMnu_id(12);
//			accessHistoryService.insertHistory(historyVO);

			mv.setViewName("encript/popup/securityPolicyRegForm");

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * 접근제어 정책 등록 팝업을 보여준다.
	 * 
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/accessPolicyRegForm.do")
	public ModelAndView accessPolicyRegForm(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {

//			// 화면접근이력 이력 남기기
//			historyVO.setExe_dtl_cd("DX-T0056");
//			historyVO.setMnu_id(12);
//			accessHistoryService.insertHistory(historyVO);

			mv.setViewName("encript/popup/accessPolicyRegForm");

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
}
