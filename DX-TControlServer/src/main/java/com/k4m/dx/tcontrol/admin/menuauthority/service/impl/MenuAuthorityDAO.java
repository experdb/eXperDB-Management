package com.k4m.dx.tcontrol.admin.menuauthority.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityVO;
import com.k4m.dx.tcontrol.login.service.UserVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;


@Repository("MenuAuthorityDAO")
public class MenuAuthorityDAO extends EgovAbstractMapper{

	
	/**
	 * 사용자 메뉴권한 조회
	 * @param 
	 * @throws Exception
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<MenuAuthorityVO> selectUsrmnuautList(MenuAuthorityVO menuAuthorityVO) {
		List<MenuAuthorityVO> sl = null;
		sl = (List<MenuAuthorityVO>) list("menuauthoritySql.selectUsrmnuautList", menuAuthorityVO);
		return sl;
	}

	
	/**
	 * 메뉴ID 조회
	 * @param 
	 * @throws Exception
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<UserVO> selectMnuIdList() {
		List<UserVO> sl = null;
		sl = (List<UserVO>) list("menuauthoritySql.selectMnuIdList", "");
		return sl;
	}
	
	
	/**
	 * 사용자 등록시 메뉴권한 등록
	 * @param 
	 * @throws Exception
	 */
	public void insertUsrmnuaut(UserVO userVo) {
		insert("menuauthoritySql.insertUsrmnuaut",userVo);	
	}

	
	/**
	 * 사용자 메뉴권한 수정
	 * @param 
	 * @throws Exception
	 */
	public void updateUsrMnuAut(Object object) {
		insert("menuauthoritySql.updateUsrMnuAut",object);			
	}


	/**
	 * 사용자 화면권한 조회
	 * @param 
	 * @throws Exception
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<Map<String, Object>> selectMenuAut(Map<String, Object> param) {
		List<Map<String, Object>> sl = null;
		sl = (List<Map<String, Object>>) list("menuauthoritySql.selectMenuAut", param);
		return sl;
	}

	
	/**
	 * 사용자 삭제시 권한삭제
	 * @param 
	 * @throws Exception
	 */
	public void deleteMenuAuthority(String string) {
		delete("menuauthoritySql.deleteMenuAuthority",string);	
	}
	
}
