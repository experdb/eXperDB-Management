package com.k4m.dx.tcontrol.mypage.service;

import java.util.List;

import com.k4m.dx.tcontrol.login.service.UserVO;

public interface MyPageService {
	
	/**
	 * mypage 상세조회
	 * @param userVo
	 * @return
	 * @throws Exception
	 */
	List<UserVO> selectDetailMyPage(String usr_id) throws Exception;
	
	/**
	 * mypage 수정
	 * @param userVo
	 * @return
	 * @throws Exception
	 */
	void updateMypage(UserVO userVo) throws Exception;
	

}
