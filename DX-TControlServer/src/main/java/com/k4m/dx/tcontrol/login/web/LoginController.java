package com.k4m.dx.tcontrol.login.web;

import java.net.InetAddress;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.cmmn.SHA256;
import com.k4m.dx.tcontrol.cmmn.cmmnExcepHndlr;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.login.service.LoginService;
import com.k4m.dx.tcontrol.login.service.UserVO;

/**
 * 로그인 컨트롤러 클래스를 정의한다.
 *
 * @author 변승우
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.05.24   변승우 최초 생성
 *      </pre>
 */

@Controller
public class LoginController {

	@Autowired
	private LoginService loginService;

	@Autowired
	private AccessHistoryService accessHistoryService;
	
	/**
	 * 로그인을 한다.
	 * 
	 * @param userVo
	 * @param model
	 * @param request
	 * @param historyVO
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/login.do")
	public String login(@ModelAttribute("userVo") UserVO userVo, ModelMap model, HttpServletRequest request,@ModelAttribute("historyVO") HistoryVO historyVO) {

		System.out.println("유저아이디 : " + userVo.getUsr_id());
		System.out.println("유저비밀번호 : " + userVo.getPwd());

		String id = userVo.getUsr_id();
		String pw = SHA256.SHA256(userVo.getPwd());

		try {
			List<UserVO> userList = loginService.selectUserList(userVo);

			int intLoginCnt = userList.size();

			if (intLoginCnt == 0) {
				throw new cmmnExcepHndlr("등록되지 않은 사용자 입니다. 관리자에게 문의 하여주십시오.");
				// System.out.println("등록되지 않은 사용자 입니다. 관리자에게 문의 하여주십시오.");
			} else {
				if (!id.equals(userList.get(0).getUsr_id())) {
					System.out.println("유저 ID가 틀립니다.");
				} else if (!pw.equals(userList.get(0).getPwd())) {
					System.out.println("비밀번호가 틀립니다.");
				} else {
					// session 설정
					HttpSession session = request.getSession();
					request.getSession().setAttribute("session", session);
					request.getSession().setAttribute("usr_id", userList.get(0).getUsr_id());
					
					InetAddress local = InetAddress.getLocalHost();
					String ip = local.getHostAddress();
					request.getSession().setAttribute("ip", ip);

					
					// 로그인 이력 남기기
					CmmnUtils.saveHistory(request, historyVO);
					historyVO.setExe_dtl_cd("DX-T0003");
					accessHistoryService.insertHistory(historyVO);
					

					return "redirect:/index.do";
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "redirect:/";
	}

	/**
	 * 로그아웃을 한다.
	 * 
	 * @param userVo
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/logout.do")
	public String loginout(@ModelAttribute("userVo") UserVO userVo, @ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		try {
			// 로그아웃 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0003_01");
			accessHistoryService.insertHistory(historyVO);
			
			HttpSession session = request.getSession();
			session.invalidate();
			return "redirect:/";
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "redirect:/";
	}
}
