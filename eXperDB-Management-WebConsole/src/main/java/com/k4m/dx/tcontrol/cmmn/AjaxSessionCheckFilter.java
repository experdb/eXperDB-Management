package com.k4m.dx.tcontrol.cmmn;

import java.io.IOException;
import java.util.Iterator;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.AuthenticationException;

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
	public class AjaxSessionCheckFilter implements Filter{
		
		/**
		 * Default AJAX request Header
		 */
		private String ajaxHaeder = "AJAX";
		
		public void destroy() {
		}

		public void doFilter(ServletRequest request, ServletResponse response,
				FilterChain chain) throws IOException, ServletException {
		    HttpServletRequest req = (HttpServletRequest) request;
	        HttpServletResponse res = (HttpServletResponse) response;
	        
	        if(isAjaxRequest(req)) {
                if(req.getSession().getAttribute("usr_id") == null){
                	res.sendError(HttpServletResponse.SC_FORBIDDEN);
                }
                
                try {
                	chain.doFilter(req, res);
                } catch (AccessDeniedException e) {
                    res.sendError(HttpServletResponse.SC_FORBIDDEN);
                } catch (AuthenticationException e) {
                    res.sendError(HttpServletResponse.SC_UNAUTHORIZED);
                }
	                

	        } else
	        	chain.doFilter(req, res);
		}

		private boolean isAjaxRequest(HttpServletRequest req) {
			return req.getHeader(ajaxHaeder) != null && req.getHeader(ajaxHaeder).equals(Boolean.TRUE.toString());
		}


		public void init(FilterConfig filterConfig) throws ServletException {}

		/**
		 * Set AJAX Request Header (Default is AJAX)
		 * @param ajaxHeader
		 */
		public void setAjaxHaeder(String ajaxHeader) {
			this.ajaxHaeder = ajaxHeader;
		}
}
