package com.k4m.dx.tcontrol.admin.usermanager.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.admin.usermanager.service.UserManagerService;
import com.k4m.dx.tcontrol.login.service.UserVO;

@Service("UserManagerServiceImpl")
public class UserManagerServiceImpl implements UserManagerService {

	@Resource(name = "UserManagerDAO")
	private UserManagerDAO userManagerDAO;

	public void insertUserManager(UserVO userVo) throws Exception {
		userManagerDAO.insertUserManager(userVo);
	}

	public List<UserVO> selectUserManager(Map<String, Object> param) throws Exception {
		return userManagerDAO.selectUserManager(param);
	}

	public int userManagerIdCheck(String usr_id) throws Exception {
		return userManagerDAO.userManagerIdCheck(usr_id);
	}

	public void deleteUserManager(String string) throws Exception {
		userManagerDAO.deleteUserManager(string);
	}

	public List<UserVO> selectDetailUserManager(String usr_id) throws Exception {
		return userManagerDAO.selectDetailUserManager(usr_id);
	}

	public void updateUserManager(UserVO userVo) throws Exception {
		userManagerDAO.updateUserManager(userVo);
	}
}
