package com.k4m.dx.tcontrol.mypage.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.login.service.UserVO;
import com.k4m.dx.tcontrol.mypage.service.MyPageService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("myPageServiceImpl")
public class MyPageServiceImpl extends EgovAbstractServiceImpl implements MyPageService{
	
	@Resource(name = "myPageDAO")
	private MyPageDAO myPageDAO;

	@Override
	public List<UserVO> selectDetailMyPage(String usr_id) throws Exception {
		return myPageDAO.selectDetailMyPage(usr_id);
	}

	@Override
	public void updateMypage(UserVO userVo) throws Exception {
		myPageDAO.updateMypage(userVo);
	}

	@Override
	public List<Map<String, Object>> selectPwd(Map<String, Object> param) throws Exception {
		return myPageDAO.selectPwd(param);
	}

	@Override
	public void updatePwd(UserVO userVo) throws Exception {
		myPageDAO.updatePwd(userVo);
	}

	@Override
	public void updateTranPwd(UserVO userVo) throws Exception {
		myPageDAO.updateTranPwd(userVo);
	}

}
