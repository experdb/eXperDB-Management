package com.k4m.dx.tcontrol.security;

import java.io.IOException;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.ibatis.session.SqlSession;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.logout.LogoutSuccessHandler;
import org.springframework.security.web.authentication.logout.SimpleUrlLogoutSuccessHandler;
import org.springframework.stereotype.Service;

@Service 
public class CustomAuthenticationProviderLogout extends SimpleUrlLogoutSuccessHandler implements LogoutSuccessHandler {
	
	
	private SqlSession sqlSession;
	
    public void setSqlSession(SqlSession sqlsession) {
		this.sqlSession = sqlsession;
	}


	@Override
	public void onLogoutSuccess(HttpServletRequest arg0,
			HttpServletResponse arg1, Authentication arg2) throws IOException,
			ServletException {
		// TODO Auto-generated method stub
		
		System.out.println("===========로그아웃 성공");
		super.onLogoutSuccess(arg0, arg1, arg2);

	}

}
