package com.k4m.dx.tcontrol.mypage.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

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
	public List<UserVO> selectDetailMyPage(String usr_id) throws SQLException{
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
	public void updateMypage(UserVO userVo) throws SQLException {
		update("mypageSql.updateMypage",userVo);
	}


	/**
	 * 현재 비밀번호 조회
	 * 
	 * @param param
	 * @throws SQLException
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<Map<String, Object>> selectPwd(Map<String, Object> param) throws SQLException{
		return (List<Map<String, Object>>) list("mypageSql.selectPwd",param);
	}

	/**
	 * 비밀번호 업데이트
	 * 
	 * @param userVo
	 * @throws SQLException
	 */
	public void updatePwd(UserVO userVo) throws SQLException{
		update("mypageSql.updatePwd",userVo);
	}

	/**
	 * 비밀번호 업데이트
	 * 
	 * @param userVo
	 * @throws SQLException
	 */
	public void updateTranPwd(UserVO userVo) throws SQLException{
		update("mypageSql.updateTranPwd",userVo);
	}
	
	

}
