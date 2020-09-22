package com.k4m.dx.tcontrol.login.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.login.service.LoginService;
import com.k4m.dx.tcontrol.login.service.UserVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;


@Service("loginServiceImpl")
public class LoginServiceImpl extends EgovAbstractServiceImpl implements LoginService{

	@Resource(name = "loginDAO")
	private LoginDAO loginDAO;
	
	@Override
	public List<UserVO> selectUserList(UserVO userVo) throws Exception {	
		return loginDAO.selectUserList(userVo);
	}

	@Override
	public int selectMasterCheck() throws Exception {
		return loginDAO.selectMasterCheck();
	}

	@Override
	public void insertKeepLogin(UserVO userVo) throws Exception {
		loginDAO.insertKeepLogin(userVo);		
	}


	@Override
	public UserVO checkUserWithSessionKey(UserVO userVo) throws Exception {	
		return loginDAO.checkUserWithSessionKey(userVo);
	}

}
