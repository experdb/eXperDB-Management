package com.k4m.dx.tcontrol.login.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.login.service.LoginService;
import com.k4m.dx.tcontrol.login.service.UserVO;


@Service("loginServiceImpl")
public class LoginServiceImpl implements LoginService{

	@Resource(name = "loginDAO")
	private LoginDAO loginDAO;
	
	@Override
	public List<UserVO> selectUserList(UserVO userVo) throws Exception {	
		return loginDAO.selectUserList(userVo);
	}

}
