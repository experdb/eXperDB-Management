package com.k4m.dx.tcontrol.mypage.service.impl;

import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.login.service.UserVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("myPageDAO")
public class MyPageDAO extends EgovAbstractMapper{
	
	
	/**
	 * mypage 상세 조회
	 * 
	 * @param param
	 * @return result
	 * @throws SQLException
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<UserVO> selectDetailMyPage(String usr_id) {
		List<UserVO> result = null;
		result = (List<UserVO>) list("mypageSql.selectDetailMyPage",usr_id);
		return result;
	}
	
	
	/**
	 * mypage 수정
	 * 
	 * @param userVo
	 * @throws SQLException
	 */
	public void updateMypage(UserVO userVo) {
		insert("mypageSql.updateMypage",userVo);
	}


}
