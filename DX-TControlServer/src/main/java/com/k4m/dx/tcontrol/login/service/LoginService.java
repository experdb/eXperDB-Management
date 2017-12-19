package com.k4m.dx.tcontrol.login.service;

import java.util.List;

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

}
