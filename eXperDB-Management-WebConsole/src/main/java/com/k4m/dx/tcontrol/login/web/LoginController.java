package com.k4m.dx.tcontrol.login.web;

import java.io.FileInputStream;
import java.net.InetAddress;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.postgresql.util.PSQLException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
import org.springframework.web.util.WebUtils;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.usermanager.service.UserManagerService;
import com.k4m.dx.tcontrol.cmmn.AES256;
import com.k4m.dx.tcontrol.cmmn.AES256_KEY;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.cmmn.EgovHttpSessionBindingListener;
import com.k4m.dx.tcontrol.cmmn.SHA256;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.encrypt.service.call.CommonServiceCall;
import com.k4m.dx.tcontrol.functions.schedule.EgovBatchListnerUtl;
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
	private UserManagerService userManagerService;

	@Autowired
	private LoginService loginService;

	@Autowired
	private AccessHistoryService accessHistoryService;

	private static final Logger logger = LoggerFactory.getLogger(EgovBatchListnerUtl.class);

	@RequestMapping(value = "/")
	public ModelAndView loginCheck(HttpServletRequest request, HttpServletResponse response) {

		ModelAndView mv = new ModelAndView();
		try {       
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			
			Properties props = new Properties();
			props.load(new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));			
			
			String lang = props.get("lang").toString();				
		    Locale locale = new Locale(lang);
		    LocaleResolver localeResolver = RequestContextUtils.getLocaleResolver(request);
		    localeResolver.setLocale(request, response, locale);
			
			if(loginVo==null){
            	//생성한 쿠키 조회
            	Cookie loginCookie = WebUtils.getCookie(request,"loginCookie");

            	if ( loginCookie !=null ){// 쿠키 존재시
            		String cookitId = loginCookie.getValue(); //sessionId 확인
            		String sessionId = cookitId.substring(0, cookitId.indexOf("_"));
            		String sessionPwd = cookitId.substring(cookitId.indexOf("_")+1, cookitId.length());

            		UserVO userVO = new UserVO();
            		userVO.setPrmId(sessionId);
            		
            		UserVO userVORe = loginService.checkUserWithSessionKey(userVO);


                    if ( userVORe !=null ){// 사용자 존재시
                    	List<UserVO> userList = loginService.selectUserList(userVORe);
                    
        				LoginVO loginVoSs = new LoginVO();
        				loginVoSs.setUsr_id(userList.get(0).getUsr_id());
        				loginVoSs.setUsr_nm(userList.get(0).getUsr_nm());

        				InetAddress local = InetAddress.getLocalHost();
        				String ip = getClientIP(request);

        				loginVoSs.setIp(ip);
        				
        				/*백업 사용유무 추가 2021-04-14  변승우 */
        				String backup_use_yn = props.get("bnr.useyn").toString(); 
        				loginVoSs.setBackup_use_yn(backup_use_yn);
        				
        				String encp_use_yn = props.get("encrypt.useyn").toString();
        				
        				loginVoSs.setEncp_use_yn(encp_use_yn);
        				
        				String version = props.get("version").toString();
        				loginVoSs.setVersion(version);
        				
        				String pg_audit = props.get("pg_audit").toString();
        				loginVoSs.setPg_audit(pg_audit);
        				
        				String transfer = props.get("transfer").toString();
        				loginVoSs.setTransfer(transfer);
        				
        				/*proxy 메뉴사용유무 추가 2021-04-23 */
        				String proxy_menu_use_yn = "";
        				if (props.get("proxy.menu.useyn") != null) {
        					proxy_menu_use_yn = props.get("proxy.menu.useyn").toString(); 
        				}
        				loginVoSs.setProxy_menu_use_yn(proxy_menu_use_yn);
        				
        				/*proxy 사용유무 추가 2021-04-23 */
        				String proxy_use_yn = "";
        				if (props.get("proxy.useyn") != null) {
        					proxy_use_yn = props.get("proxy.useyn").toString(); 
        				}		
        				loginVoSs.setProxy_use_yn(proxy_use_yn);

        				if(encp_use_yn.equals("Y")){
        					String restIp = props.get("encrypt.server.url").toString();
        					int restPort = Integer.parseInt(props.get("encrypt.server.port").toString());
        					try{
        						CommonServiceCall cic = new CommonServiceCall();
        						JSONObject result = cic.login(restIp,restPort, userVORe.getUsr_id(), sessionPwd);
        						loginVoSs.setRestIp(restIp);
        						loginVoSs.setRestPort(restPort);
        						loginVoSs.setTockenValue((String) (result.get("tockenValue")==null?"":result.get("tockenValue")));
        						loginVoSs.setEctityUid((String) (result.get("ectityUid")==null?"":result.get("ectityUid")));

        					}catch(Exception e){
        						loginVoSs.setRestIp(restIp);
        						loginVoSs.setRestPort(restPort);
        						loginVoSs.setTockenValue("");
        						loginVoSs.setEctityUid("");
        					}
        				}
        				
        				//로그인 시간 추가
        				SimpleDateFormat loginSf= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        				Date loginTime = new Date();
        				loginVoSs.setLoginChkTime(loginSf.format(loginTime));

                        // 세션을 생성시켜 준다.
        				session.setAttribute("session", loginVoSs);
        				
        				mv.setViewName("redirect:/experdb.do");
                    } else {
                    	mv.setViewName("login");
                    }
            	} else {
            		mv.setViewName("login");
            	}
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
	public ModelAndView sessionOut(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();
		try {

            //쿠키를 가져와보고
            Cookie loginCookie = WebUtils.getCookie(request,"loginCookie");

            if ( loginCookie !=null ){
        		String cookitId = loginCookie.getValue(); //sessionId 확인
        		String sessionId = cookitId.substring(0, cookitId.indexOf("_"));

        		UserVO userVO = new UserVO();
        		userVO.setPrmId(sessionId);
        		
        		UserVO userVORe = loginService.checkUserWithSessionKey(userVO);

                // null이 아니면 존재하면!
                loginCookie.setPath("/");
                // 쿠키는 없앨 때 유효시간을 0으로 설정하는 것 !!! invalidate같은거 없음.
                loginCookie.setMaxAge(0);
                // 쿠키 설정을 적용한다.
                response.addCookie(loginCookie);
                 
                // 사용자 테이블에서도 유효기간을 현재시간으로 다시 세팅해줘야함.
/*                Date date =new Date(System.currentTimeMillis());
                */

                if ( userVORe !=null ){// 사용자 존재시
	    			try{
	    				userVORe.setPrmId("none");
	    				userVORe.setSessionDate(null);
	    				loginService.insertKeepLogin(userVORe);
	    			} catch (Exception e) {
	    				e.printStackTrace();
	    			}
                }
            }

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
			String salt_value = "";
			
			if (userVo.getUsr_id() == null || userVo.getPwd() == null) {
				mv.addObject("error", "msg03");
				mv.setViewName("login");
				return mv;
			}
			
			UserVO userInfoHd = (UserVO) userManagerService.selectDetailUserManagerHd(userVo.getUsr_id());
			if (userInfoHd != null){
				if (!"".equals(userInfoHd.getSalt_value())) {
					salt_value = userInfoHd.getSalt_value();
				} 
			}

			if (salt_value == null || "".equals(salt_value)) {
				salt_value = SHA256.getSalt();
			}
			
			/*sha-256 암호화 변경 2020-11-26 */
			//String pw = SHA256.getSHA256(userVo.getPwd()); // 패스워드 암호화
			String pw = SHA256.setSHA256(userVo.getPwd(), salt_value);

			String login_chk = userVo.getLoginChkYn();
		
			try {
				int masterCheck = loginService.selectMasterCheck();
	
				if(masterCheck>0){
					
					mv.addObject("error", "msg176");
					mv.setViewName("login");
					return mv;
				}
			} catch (PSQLException e) {
				e.printStackTrace();
	
				mv.setViewName("login");
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
				loginVo.setAut_id(userList.get(0).getAut_id());
				//session 제거
		        if ( session.getAttribute("session") !=null ){
		            // 기존에 login이란 세션 값이 존재한다면
		            session.removeAttribute("session");// 기존값을 제거해 준다.
		        }

				InetAddress local = InetAddress.getLocalHost();
				String ip = getClientIP(request);

				loginVo.setIp(ip);

				Properties props = new Properties();
				props.load(new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));			
				
				String lang = props.get("lang").toString();				
			    Locale locale = new Locale(lang);
			    LocaleResolver localeResolver = RequestContextUtils.getLocaleResolver(request);
			    localeResolver.setLocale(request, response, locale);
				
			    /*백업 사용유무 추가 2021-04-14  변승우 */
				String backup_use_yn = props.get("bnr.useyn").toString(); 
				loginVo.setBackup_use_yn(backup_use_yn);
			    			    
				String encp_use_yn = props.get("encrypt.useyn").toString();
				
				loginVo.setEncp_use_yn(encp_use_yn);
				
				String version = props.get("version").toString();
				loginVo.setVersion(version);
				
				String pg_audit = props.get("pg_audit").toString();
				loginVo.setPg_audit(pg_audit);
				
				String transfer = props.get("transfer").toString();
				loginVo.setTransfer(transfer);

				/*proxy 메뉴사용유무 추가 2021-04-23 */
				String proxy_menu_use_yn = "";
				if (props.get("proxy.menu.useyn") != null) {
					proxy_menu_use_yn = props.get("proxy.menu.useyn").toString(); 
				}
				loginVo.setProxy_menu_use_yn(proxy_menu_use_yn);
				
			    /*proxy 사용유무 추가 2021-04-23  */
				String proxy_use_yn = "";
				if (props.get("proxy.useyn") != null) {
					proxy_use_yn = props.get("proxy.useyn").toString(); 
				}		
				loginVo.setProxy_use_yn(proxy_use_yn);
				
				if(encp_use_yn.equals("Y")){
					String restIp = props.get("encrypt.server.url").toString();
					int restPort = Integer.parseInt(props.get("encrypt.server.port").toString());
					try{
						CommonServiceCall cic = new CommonServiceCall();
						JSONObject result = cic.login(restIp,restPort,id,userVo.getPwd());
						/*JSONObject result = cic.login(restIp,restPort,id,userVo.getPwd());*/
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
				
				//로그인 성공시 
				if (loginVo != null) {
		            /*
		             *  [   세션 추가되는 부분      ]
		             */
					if (login_chk != null) { // 체크한 경우
						if ("Y".equals(login_chk)) { // dto 클래스 안에 useCookie 항목에 폼에서 넘어온 쿠키사용 여부(true/false)가 들어있을 것임
			                // 쿠키 사용한다는게 체크되어 있으면...
			                // 쿠키를 생성하고 현재 로그인되어 있을 때 생성되었던 세션의 id를 쿠키에 저장한다.

							Cookie cookie =new Cookie("loginCookie", session.getId().toString() + "_" + userVo.getPwd());
			                // 쿠키를 찾을 경로를 컨텍스트 경로로 변경해 주고...
			                cookie.setPath("/");

			                int amount =60 *60 *24;
			                cookie.setMaxAge(amount);// 단위는 (초)임으로 1일정도로 유효시간을 설정해 준다.
			                // 쿠키를 적용해 준다.
			                response.addCookie(cookie);

			                Date sessionLimit =new Date(System.currentTimeMillis() + (1000*amount));
			                
			                // 현재 세션 id와 유효시간을 사용자 테이블에 저장한다.
			    			try{
			    				userVo.setPrmId(session.getId());
			    				userVo.setSessionDate(sessionLimit);

			    				loginService.insertKeepLogin(userVo);
			    			} catch (Exception e) {
			    				e.printStackTrace();
			    			}

						}
					}
				}
				/*중복로그인방지*/
				EgovHttpSessionBindingListener listener = new EgovHttpSessionBindingListener();
				request.getSession().setAttribute(userList.get(0).getUsr_id(), listener);
				
				// 로그인 이력 남기기
				CmmnUtils.saveHistoryLogin(loginVo, login_chk, id, request, historyVO);
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
				
				session.removeAttribute("session");
				request.getSession().invalidate();
				
	            Cookie loginCookie = WebUtils.getCookie(request,"loginCookie");

	            if ( loginCookie !=null ){
	        		String cookitId = loginCookie.getValue(); //sessionId 확인
	        		String sessionId = cookitId.substring(0, cookitId.indexOf("_"));

	        		UserVO userVO = new UserVO();
	        		userVO.setPrmId(sessionId);

	                // null이 아니면 존재하면!
	                loginCookie.setPath("/");
	                // 쿠키는 없앨 때 유효시간을 0으로 설정하는 것 !!! invalidate같은거 없음.
	                loginCookie.setMaxAge(0);
	                // 쿠키 설정을 적용한다.
	                response.addCookie(loginCookie);
	                 
	                // 사용자 테이블에서도 유효기간을 현재시간으로 다시 세팅해줘야함.
	/*                Date date =new Date(System.currentTimeMillis());
	                */
	        		UserVO userVORe = loginService.checkUserWithSessionKey(userVO);

	                if ( userVORe !=null ){// 사용자 존재시
		    			try{
		    				userVORe.setPrmId("none");
		    				userVORe.setSessionDate(null);
		    				loginService.insertKeepLogin(userVORe);
		    			} catch (Exception e) {
		    				e.printStackTrace();
		    			}
	                }
	            }
			}
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
	
	public static String getClientIP(HttpServletRequest request) {
	    String ip = request.getHeader("X-Forwarded-For");

	    if (ip == null) {
	        ip = request.getHeader("Proxy-Client-IP");
	        logger.info("> Proxy-Client-IP : " + ip);
	    }
	    if (ip == null) {
	        ip = request.getHeader("WL-Proxy-Client-IP");
	        logger.info(">  WL-Proxy-Client-IP : " + ip);
	    }
	    if (ip == null) {
	        ip = request.getHeader("HTTP_CLIENT_IP");
	        logger.info("> HTTP_CLIENT_IP : " + ip);
	    }
	    if (ip == null) {
	        ip = request.getHeader("HTTP_X_FORWARDED_FOR");
	        logger.info("> HTTP_X_FORWARDED_FOR : " + ip);
	    }
	    if (ip == null) {
	        ip = request.getRemoteAddr();
	        logger.info("> getRemoteAddr : "+ip);
	    }
	    logger.info("> Result : IP Address : "+ip);

	    return ip;
	}
}