package com.k4m.dx.tcontrol.cmmn;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class SessionCheckInterceptor extends HandlerInterceptorAdapter{


    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        try {
        	 //System.out.println("Interceptor{preHandle}............................................ start");
    		Cookie[] cookies = request.getCookies();
    		for (int i = 0; i < cookies.length; i++) {			
    			if(cookies[i].getName().equals("r_login_id")){
	    			request.getSession().setAttribute("usr_id", cookies[i].getValue());
	    			cookies[i].setMaxAge(0);                 //쿠키 유지기간을 0으로함
	    			cookies[i].setPath("/");                    //쿠키 접근 경로 지정
	    			response.addCookie(cookies[i]);      //쿠키저장
    			}else if(cookies[i].getName().equals("r_logout_id")){
    				HttpSession session = request.getSession();
    				session.invalidate();
	    			cookies[i].setMaxAge(0);                 //쿠키 유지기간을 0으로함
	    			cookies[i].setPath("/");                    //쿠키 접근 경로 지정
	    			response.addCookie(cookies[i]);      //쿠키저장
    			}
    		}
    		
            if(request.getSession().getAttribute("usr_id") == null){
                    response.sendRedirect("/");
                    return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
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


}
