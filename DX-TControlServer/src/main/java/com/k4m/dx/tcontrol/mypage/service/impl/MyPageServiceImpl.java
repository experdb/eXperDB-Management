package com.k4m.dx.tcontrol.mypage.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.login.service.UserVO;
import com.k4m.dx.tcontrol.mypage.service.MyPageService;

@Service("myPageServiceImpl")
public class MyPageServiceImpl implements MyPageService{
	
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


}
