package com.k4m.dx.tcontrol.admin.usermanager.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.admin.usermanager.service.UserManagerService;
import com.k4m.dx.tcontrol.login.service.UserVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("UserManagerServiceImpl")
public class UserManagerServiceImpl extends EgovAbstractServiceImpl implements UserManagerService {

	@Resource(name = "userManagerDAO")
	private UserManagerDAO userManagerDAO;

	public void insertUserManager(UserVO userVo) throws Exception {
		userManagerDAO.insertUserManager(userVo);
	}

	public void insertUserManagerHd(UserVO userVo) throws Exception {
		userManagerDAO.insertUserManagerHd(userVo);
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

	public UserVO selectDetailUserManager(String usr_id) throws Exception {
		return userManagerDAO.selectDetailUserManager(usr_id);
	}

	public void updateUserManager(UserVO userVo) throws Exception {
		userManagerDAO.updateUserManager(userVo);
	}

	public Map<String, Object> selectProfieView(Map<String, Object> param) throws Exception {
		return userManagerDAO.selectProfieView(param);
	}

	public UserVO selectDetailUserManagerHd(String usr_id) throws Exception {
		return userManagerDAO.selectDetailUserManagerHd(usr_id);
	}

	public void insertTransUser(UserVO userVo) throws Exception {
		userManagerDAO.insertTransUser(userVo);
	}

	public void deleteUserManagerHd(String string) throws Exception {
		userManagerDAO.deleteUserManagerHd(string);
	}

}
