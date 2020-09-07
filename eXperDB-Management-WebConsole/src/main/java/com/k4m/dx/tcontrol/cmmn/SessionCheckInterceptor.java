package com.k4m.dx.tcontrol.cmmn;

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
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.ResourceUtils;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.springframework.web.util.WebUtils;

import com.k4m.dx.tcontrol.encrypt.service.call.CommonServiceCall;
import com.k4m.dx.tcontrol.login.service.LoginService;
import com.k4m.dx.tcontrol.login.service.LoginVO;
import com.k4m.dx.tcontrol.login.service.UserVO;

/**
* @author 박태혁
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2018.04.23   박태혁 최초 생성
*      </pre>
*/

public class SessionCheckInterceptor extends HandlerInterceptorAdapter{

	@Autowired
	private LoginService loginService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        try {
        	HttpSession session = request.getSession();
    		LoginVO loginVo = (LoginVO) session.getAttribute("session");

            if(loginVo == null){
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

        				Properties props = new Properties();
        				props.load(new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));			
        				
        				String lang = props.get("lang").toString();				
        			    Locale locale = new Locale(lang);
        			    LocaleResolver localeResolver = RequestContextUtils.getLocaleResolver(request);
        			    localeResolver.setLocale(request, response, locale);
        				
        				String encp_use_yn = props.get("encrypt.useyn").toString();
        				
        				loginVoSs.setEncp_use_yn(encp_use_yn);
        				
        				String version = props.get("version").toString();
        				loginVoSs.setVersion(version);
        				
        				String pg_audit = props.get("pg_audit").toString();
        				loginVoSs.setPg_audit(pg_audit);
        				
        				String transfer = props.get("transfer").toString();
        				loginVoSs.setTransfer(transfer);
        				
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
                        return true;
                    }
            	}

            	response.sendRedirect("/sessionOut.do");
            	return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
        	response.sendRedirect("/sessionOut.do");
        	return false;
        }
        //admin 세션key 존재시 main 페이지 이동
        return true;
    }
 
    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
    	 //System.out.println("Interceptor{postHandle}............................................ start");
    	super.postHandle(request, response, handler, modelAndView);
    }
 
    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        super.afterCompletion(request, response, handler, ex);
    }
 
    @Override
    public void afterConcurrentHandlingStarted(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        super.afterConcurrentHandlingStarted(request, response, handler);
    }
    
	public static String getClientIP(HttpServletRequest request) {
	    String ip = request.getHeader("X-Forwarded-For");

	    if (ip == null) {
	        ip = request.getHeader("Proxy-Client-IP");
	    }
	    if (ip == null) {
	        ip = request.getHeader("WL-Proxy-Client-IP");
	    }
	    if (ip == null) {
	        ip = request.getHeader("HTTP_CLIENT_IP");
	    }
	    if (ip == null) {
	        ip = request.getHeader("HTTP_X_FORWARDED_FOR");
	    }
	    if (ip == null) {
	        ip = request.getRemoteAddr();
	    }
	    return ip;
	}


}
