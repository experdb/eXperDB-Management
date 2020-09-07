package com.k4m.dx.tcontrol.login.service;

import java.util.List;

import com.k4m.dx.tcontrol.script.service.ScriptVO;

public interface LoginService {

	/**
	 * 사용자 정보 조회(로그인)
	 * 
	 * @param userVo
	 * @return
	 * @throws Exception
	 */
	List<UserVO> selectUserList(UserVO userVo) throws Exception;

	/**
	 * HA구성 master 체크
	 * 
	 * @param 
	 * @return
	 * @throws Exception
	 */
	int selectMasterCheck() throws Exception;
	
	/**
	 * 로그인 sessing 저장
	 * @param ScriptVO
	 * @return 
	 * @throws Exception
	 */
	public void insertKeepLogin(UserVO userVO) throws Exception;
	
	/**
	 * 로그인 쿠키체크
	 * @param ScriptVO
	 * @return 
	 * @throws Exception
	 */
	public UserVO checkUserWithSessionKey(UserVO userVo) throws Exception;
}
