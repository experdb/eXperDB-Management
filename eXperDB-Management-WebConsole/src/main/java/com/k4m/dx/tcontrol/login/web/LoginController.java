package com.k4m.dx.tcontrol.login.web;

import java.io.FileInputStream;
import java.net.InetAddress;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.ResourceUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.cmmn.AES256;
import com.k4m.dx.tcontrol.cmmn.AES256_KEY;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.cmmn.EgovHttpSessionBindingListener;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.encrypt.service.call.CommonServiceCall;
import com.k4m.dx.tcontrol.login.service.LoginService;
import com.k4m.dx.tcontrol.login.service.LoginVO;
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
	public ModelAndView loginCheck(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();
		try {       
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			
			if(loginVo==null){
				mv.setViewName("login");
			}else{
				mv.setViewName("redirect:/experdb.do");
			}		
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	/**
	 * 세션아웃 화면을 보여준다.
	 * 
	 * @param userVo
	 * @param model
	 * @param request
	 * @param historyVO
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/sessionOut.do")
	public ModelAndView sessionOut() {
		ModelAndView mv = new ModelAndView();
		try {
			mv.setViewName("logout");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	/**
	 * 로그인 화면을 보여준다.
	 * 
	 * @param userVo
	 * @param model
	 * @param request
	 * @param historyVO
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/login.do")
	public ModelAndView login() {
		ModelAndView mv = new ModelAndView();
		try {
			mv.setViewName("login");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * 로그인을 처리 한다.
	 * 
	 * @param userVo
	 * @param model
	 * @param request
	 * @param historyVO
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/loginAction.do")
	public ModelAndView loginAction(@ModelAttribute("userVo") UserVO userVo, ModelMap model, HttpServletResponse response,
			HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) {
		ModelAndView mv = new ModelAndView();
		try {
			AES256 aes = new AES256(AES256_KEY.ENC_KEY);
			String id = userVo.getUsr_id();
			
			if (userVo.getUsr_id() == null || userVo.getPwd() == null) {
				mv.addObject("error", "msg03");
				mv.setViewName("login");
				return mv;
			}

			String pw = aes.aesEncode(userVo.getPwd());
			
			String login_chk = userVo.getLoginChkYn();
			
			int masterCheck = loginService.selectMasterCheck();
			if(masterCheck>0){
				mv.addObject("error", "msg176");
				return mv;
			}
			List<UserVO> userList = loginService.selectUserList(userVo);
			int intLoginCnt = userList.size();
			if (intLoginCnt == 0) {
				mv.addObject("error", "msg156");
				mv.setViewName("login");
				return mv;
			} else if (!id.equals(userList.get(0).getUsr_id()) || !pw.equals(userList.get(0).getPwd())) {
				mv.addObject("error", "msg157");
				mv.setViewName("login");
				return mv;
			} else if (userList.get(0).getUse_yn().equals("N")) {
				mv.addObject("error", "msg158");
				mv.setViewName("login");
				return mv;
			} else if (userList.get(0).getUsr_expr_dt().equals("N")) {
				mv.addObject("error", "msg159");
				mv.setViewName("login");
				return mv;
			} else {
				// session 설정
				HttpSession session = request.getSession();
				LoginVO loginVo = new LoginVO();
				loginVo.setUsr_id(userList.get(0).getUsr_id());
				loginVo.setUsr_nm(userList.get(0).getUsr_nm());
		
				InetAddress local = InetAddress.getLocalHost();
				String ip = request.getRemoteAddr();
				loginVo.setIp(ip);

				Properties props = new Properties();
				props.load(new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));			
				
				String lang = props.get("lang").toString();				
			    Locale locale = new Locale(lang);
			    LocaleResolver localeResolver = RequestContextUtils.getLocaleResolver(request);
			    localeResolver.setLocale(request, response, locale);
				
				String encp_use_yn = props.get("encrypt.useyn").toString();
				
System.out.println("==================================encp_use_yn=============================" + encp_use_yn);
				
				loginVo.setEncp_use_yn(encp_use_yn);
				
				String version = props.get("version").toString();
				loginVo.setVersion(version);
				
				String pg_audit = props.get("pg_audit").toString();
				loginVo.setPg_audit(pg_audit);
				
				String transfer = props.get("transfer").toString();
				loginVo.setTransfer(transfer);
				
				if(encp_use_yn.equals("Y")){
					String restIp = props.get("encrypt.server.url").toString();
					int restPort = Integer.parseInt(props.get("encrypt.server.port").toString());
					try{
						CommonServiceCall cic = new CommonServiceCall();
						JSONObject result = cic.login(restIp,restPort,id,userVo.getPwd());
						loginVo.setRestIp(restIp);
						loginVo.setRestPort(restPort);
						loginVo.setTockenValue((String) (result.get("tockenValue")==null?"":result.get("tockenValue")));
						loginVo.setEctityUid((String) (result.get("ectityUid")==null?"":result.get("ectityUid")));

					}catch(Exception e){
						loginVo.setRestIp(restIp);
						loginVo.setRestPort(restPort);
						loginVo.setTockenValue("");
						loginVo.setEctityUid("");
					}
				}
				
				//로그인 시간 추가
				SimpleDateFormat loginSf= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				Date loginTime = new Date();
				loginVo.setLoginChkTime(loginSf.format(loginTime));

				session.setAttribute("session", loginVo);

				// 사용자의 로그인 유지 여부를 null 체크로 확인 
				if (login_chk != null) { // 체크한 경우
					if ("Y".equals(login_chk)) {
						session.setAttribute("loginChkId", id);
					}
				}

				/*중복로그인방지*/
				EgovHttpSessionBindingListener listener = new EgovHttpSessionBindingListener();
				request.getSession().setAttribute(userList.get(0).getUsr_id(), listener);
				
				// 로그인 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0003");
				accessHistoryService.insertHistory(historyVO);

				mv.setViewName("redirect:/experdb.do");
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
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
		
			if(loginVo !=null){
				// 로그아웃 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0003_01");
				accessHistoryService.insertHistory(historyVO);			
			}						
			request.getSession().invalidate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "redirect:/";
	}

	/**
	 * locale 실행
	 * 
	 * @param userVo
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/setChangeLocale.do")
	public @ResponseBody void setChangeLocale(HttpServletRequest request, HttpServletResponse response) {
		try {
			String lang = request.getParameter("locale");
			Locale locale = new Locale(lang);
			LocaleResolver localeResolver = RequestContextUtils.getLocaleResolver(request);
			localeResolver.setLocale(request, response, locale);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
