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
import org.springframework.web.servlet.ModelAndView;

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
	
	
	
	@RequestMapping(value = "/")
	public ModelAndView loginCheck(HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			HttpSession session = request.getSession();
			String usr_id = (String) session.getAttribute("usr_id");
			if(usr_id==null){
				mv.setViewName("login");
			}else{
				mv.setViewName("redirect:/index.do");
			}		
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
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
	public ModelAndView login(@ModelAttribute("userVo") UserVO userVo, ModelMap model, HttpServletResponse response,
			HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) {
		ModelAndView mv = new ModelAndView();
		String id = userVo.getUsr_id();
		String pw = SHA256.SHA256(userVo.getPwd());
		try {
			List<UserVO> userList = loginService.selectUserList(userVo);
			mv.setViewName("login");
			int intLoginCnt = userList.size();
			if (intLoginCnt == 0) {
				mv.addObject("error", "등록되지 않은 사용자 입니다.");
			} else if (!id.equals(userList.get(0).getUsr_id()) || !pw.equals(userList.get(0).getPwd())) {
				mv.addObject("error", "아이디나 비밀번호가 잘못되었습니다.");
			} else if (userList.get(0).getUse_yn().equals("N")) {
				mv.addObject("error", "사용할 수 없는 아이디 입니다.");
			} else if (userList.get(0).getUsr_expr_dt().equals("N")) {
				mv.addObject("error", "사용 만료된 아이디 입니다.");
			} else {
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
				request.getSession().setAttribute("usr_nm", userList.get(0).getUsr_nm());

				InetAddress local = InetAddress.getLocalHost();
				String ip = local.getHostAddress();
				request.getSession().setAttribute("ip", ip);

				// 로그인 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0003");
				accessHistoryService.insertHistory(historyVO);

				mv.setViewName("redirect:/index.do");
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
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
