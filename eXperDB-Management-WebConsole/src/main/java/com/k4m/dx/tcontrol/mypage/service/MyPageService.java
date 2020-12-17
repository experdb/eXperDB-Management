package com.k4m.dx.tcontrol.mypage.service;

import java.util.List;
import java.util.Map;

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

	/**
	 * 현재 비밀번호 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectPwd(Map<String, Object> param) throws Exception;

	/**
	 * 비밀번호 수정
	 * @param userVo
	 * @throws Exception
	 */
	void updatePwd(UserVO userVo) throws Exception;

	/**
	 * 비밀번호 수정
	 * @param userVo
	 * @throws Exception
	 */
	void updateTranPwd(UserVO userVo) throws Exception;

}
