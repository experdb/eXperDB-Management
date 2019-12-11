package com.k4m.dx.tcontrol.admin.menuauthority.service;

import java.util.List;
import java.util.Map;

import com.k4m.dx.tcontrol.login.service.UserVO;

public interface MenuAuthorityService {

	/**
	 * 사용자 메뉴권한 조회
	 * @param 
	 * @throws Exception
	 */
	List<MenuAuthorityVO> selectUsrmnuautList(MenuAuthorityVO menuAuthorityVO) throws Exception;

	
	/**
	 * 메뉴ID 조회
	 * @param 
	 * @throws Exception
	 */
	List<UserVO> selectMnuIdList() throws Exception;
	
	
	/**
	 * 사용자 등록시 메뉴권한 등록
	 * @param 
	 * @throws Exception
	 */
	void insertUsrmnuaut(UserVO userVo) throws Exception;


	/**
	 * 사용자 메뉴권한 수정
	 * @param 
	 * @throws Exception
	 */
	void updateUsrMnuAut(Map<String, Object> param) throws Exception;


	/**
	 * mnu_id 조회
	 * @param mnu_cd
	 * @throws Exception
	 */
	int selectMenuId(String mnu_cd) throws Exception;


	/**
	 * 사용자 화면권한 조회
	 * @param 
	 * @throws Exception
	 */
	List<Map<String, Object>> selectMenuAut(Map<String, Object> param) throws Exception;


	/**
	 * 사용자 삭제시 권한삭제
	 * @param 
	 * @throws Exception
	 */
	void deleteMenuAuthority(String string) throws Exception;


	/**
	 * 전송설정 메뉴권한
	 * @param 
	 * @throws Exception
	 */
	List<MenuAuthorityVO> transferAuthorityList(MenuAuthorityVO menuAuthorityVO);

	
	/**
	 * 추가된 메뉴권한 확인
	 * @param 
	 * @throws Exception
	 */
	List<MenuAuthorityVO> selectAddMenu(MenuAuthorityVO menuAuthorityVO);


}
