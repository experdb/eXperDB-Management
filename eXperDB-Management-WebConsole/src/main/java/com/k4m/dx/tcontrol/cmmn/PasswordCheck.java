package com.k4m.dx.tcontrol.cmmn;

import java.io.IOException;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

import com.k4m.dx.tcontrol.admin.usermanager.service.UserManagerService;
import com.k4m.dx.tcontrol.login.service.LoginService;
import com.k4m.dx.tcontrol.login.service.LoginVO;
import com.k4m.dx.tcontrol.login.service.UserVO;

@Controller
public class PasswordCheck {

	@Autowired
	private UserManagerService userManagerService;

	
	/**
	 * 패스워드 정보 확인.
	 * 
	 * @param userVo
	 * @param model
	 * @param request
	 * @param historyVO
	 * @return ModelAndView mv
	 * @throws Exception
	 */
		@RequestMapping(value = "/psswordCheck.do")
		public @ResponseBody String passwordCheck(HttpServletRequest request, HttpServletResponse response) {
			ModelAndView mv = new ModelAndView();
			try {       
				// session 설정
				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				String usr_id = loginVo.getUsr_id();
				String salt_value = "";
				
				String password = request.getParameter("password");
	
				UserVO result = (UserVO) userManagerService.selectDetailUserManager(usr_id);
				
				UserVO userInfoHd = (UserVO) userManagerService.selectDetailUserManagerHd(usr_id);
				if (userInfoHd != null){
					if (!"".equals(userInfoHd.getSalt_value())) {
						salt_value = userInfoHd.getSalt_value();
					} 
				}

				if (salt_value == null || "".equals(salt_value)) {
					salt_value = SHA256.getSalt();
				}

				/*sha-256 암호화 변경 2020-11-26 */
				password = SHA256.setSHA256(password, salt_value);

				if(!password.equals(result.getPwd())){
					return "false";
				}	
			} catch (Exception e) {
				e.printStackTrace();
			}
			return "true";
		}
}
