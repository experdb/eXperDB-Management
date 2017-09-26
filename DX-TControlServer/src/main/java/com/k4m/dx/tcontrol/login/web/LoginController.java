package com.k4m.dx.tcontrol.login.web;

import java.net.InetAddress;
import java.util.List;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.cmmn.SHA256;
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
	public @ResponseBody String login(@ModelAttribute("userVo") UserVO userVo, ModelMap model, HttpServletResponse response,
			HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) {
		try {
			System.out.println("아이디 : " + userVo.getUsr_id());
			System.out.println("패스워드 : " + userVo.getPwd());
			
			String pw = SHA256.SHA256(userVo.getPwd());
			List<UserVO> userList = loginService.selectUserList(userVo);
			int intLoginCnt = userList.size();
			if (intLoginCnt == 0) {
				return "idFail";
			} else {
				if (!pw.equals(userList.get(0).getPwd())) {
					return "passwordFail";
				}else if(userList.get(0).getUse_yn().equals("N")){
					return "useynFail";
				}else if(userList.get(0).getUsr_expr_dt().equals("N")){
					return "usrexprdtFail";
				}else {
					// 쿠키설정
					Cookie idCookie = new Cookie("s_login_id", userList.get(0).getUsr_id());
					idCookie.setMaxAge(-1);
					if (idCookie != null && !idCookie.equals("")) {
						idCookie.setPath("/");
					}
					response.addCookie(idCookie);

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

					return "loginSuccess";
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "false";
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
	public String loginout(@ModelAttribute("userVo") UserVO userVo, @ModelAttribute("historyVO") HistoryVO historyVO,
			HttpServletRequest request, HttpServletResponse response) {
		try {
			// 쿠키설정
			Cookie idCookie = new Cookie("s_logout_id", request.getSession().getId());
			idCookie.setMaxAge(-1);
			if (idCookie != null && !idCookie.equals("")) {
				idCookie.setPath("/");
			}
			response.addCookie(idCookie);

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
