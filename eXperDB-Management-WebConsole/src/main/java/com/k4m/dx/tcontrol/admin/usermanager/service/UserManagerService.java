package com.k4m.dx.tcontrol.admin.usermanager.service;

import java.util.List;
import java.util.Map;

import com.k4m.dx.tcontrol.login.service.UserVO;

public interface UserManagerService {
	
	/**
	 * 사용자 등록
	 * @param userVo
	 * @throws Exception
	 */
	public void insertUserManager(UserVO userVo)throws Exception;
	
	
	/**
	 * 사용자 조회
	 * @param 
	 * @throws Exception
	 */
	public List<UserVO> selectUserManager(Map<String, Object> param)throws Exception;

	
	/**
	 * 사용자 아이디 중복 체크
	 * @param usr_id
	 * @throws Exception
	 */
	public int userManagerIdCheck(String usr_id)throws Exception;


	/**
	 * 사용자 삭제
	 * @param string
	 * @throws Exception
	 */
	public void deleteUserManager(String string)throws Exception;


	/**
	 * 사용자 삭제(백업)
	 * @param string
	 * @throws Exception
	 */
	public void deleteUserManagerHd(String string)throws Exception;

	
	/**
	 * 사용자 상세정보 조회
	 * @param string
	 * @throws Exception
	 */
	public UserVO selectDetailUserManager(String usr_id)throws Exception;


	/**
	 * 사용자 수정
	 * @param string
	 * @throws Exception
	 */
	public void updateUserManager(UserVO userVo)throws Exception;

	/**
	 * top화면 profile 조회
	 * @param 
	 * @throws Exception
	 */
	public Map<String, Object> selectProfieView(Map<String, Object> param)throws Exception;
	
	/**
	 * 사용자 등록 backup
	 * @param userVo
	 * @throws Exception
	 */
	public void insertUserManagerHd(UserVO userVo)throws Exception;
	
	/**
	 * 사용자 상세정보 조회 backup
	 * @param string
	 * @throws Exception
	 */
	public UserVO selectDetailUserManagerHd(String usr_id)throws Exception;
	
	/**
	 * 사용자 등록 backup
	 * @param userVo
	 * @throws Exception
	 */
	public void insertTransUser(UserVO userVo)throws Exception;
	
	
}
