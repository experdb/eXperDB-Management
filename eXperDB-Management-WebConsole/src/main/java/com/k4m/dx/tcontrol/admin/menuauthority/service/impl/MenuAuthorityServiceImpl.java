package com.k4m.dx.tcontrol.admin.menuauthority.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityService;
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityVO;
import com.k4m.dx.tcontrol.login.service.UserVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;


@Service("menuAuthorityService")
public class MenuAuthorityServiceImpl extends EgovAbstractServiceImpl implements MenuAuthorityService{
	
	@Resource(name = "MenuAuthorityDAO")
	private MenuAuthorityDAO menuAuthorityDAO;

	
	/**
	 * 사용자 메뉴권한 조회
	 * @param 
	 * @throws Exception
	 */
	@Override
	public List<MenuAuthorityVO> selectUsrmnuautList(MenuAuthorityVO menuAuthorityVO) throws Exception {
		return menuAuthorityDAO.selectUsrmnuautList(menuAuthorityVO);
	}

	
	/**
	 * 사용자 메뉴ID 조회
	 * @param 
	 * @throws Exception
	 */
	@Override
	public List<UserVO> selectMnuIdList() throws Exception {
		return menuAuthorityDAO.selectMnuIdList();
	}
	
	
	/**
	 * 사용자 등록시 메뉴권한 등록
	 * @param 
	 * @throws Exception
	 */
	@Override
	public void insertUsrmnuaut(UserVO userVo) throws Exception {
		menuAuthorityDAO.insertUsrmnuaut(userVo);		
	}


	/**
	 * 사용자 메뉴권한 수정
	 * @param 
	 * @throws Exception
	 */
	@Override
	public void updateUsrMnuAut(Map<String, Object> param) throws Exception {
		menuAuthorityDAO.updateUsrMnuAut(param);	
		
	}

	/**
	 * mnu_id 조회
	 * @param mnu_cd 
	 * @throws Exception
	 */
	@Override
	public int selectMenuId(String mnu_cd) throws Exception {
		return menuAuthorityDAO.selectMenuId(mnu_cd);
	}


	/**
	 * 사용자 화면권한 조회
	 * @param 
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectMenuAut(Map<String, Object> param) throws Exception {
		return menuAuthorityDAO.selectMenuAut(param);
	}

	
	/**
	 * 사용자 삭제시 권한삭제
	 * @param 
	 * @throws Exception
	 */
	@Override
	public void deleteMenuAuthority(String string) throws Exception {
		menuAuthorityDAO.deleteMenuAuthority(string);	
	}


	@Override
	public List<MenuAuthorityVO> transferAuthorityList(MenuAuthorityVO menuAuthorityVO) {
		return menuAuthorityDAO.transferAuthorityList(menuAuthorityVO);
	}


	@Override
	public List<MenuAuthorityVO> selectAddMenu(MenuAuthorityVO menuAuthorityVO) {
		return menuAuthorityDAO.selectAddMenu(menuAuthorityVO);
	}

}
