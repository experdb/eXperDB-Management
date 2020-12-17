package com.k4m.dx.tcontrol.admin.usermanager.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.login.service.UserVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("userManagerDAO")
public class UserManagerDAO extends EgovAbstractMapper{
	
	/**
	 * 사용자 등록
	 * 
	 * @param userVo
	 * @throws SQLException
	 */
	public void insertUserManager(UserVO userVo) throws SQLException{
		insert("userManagerSql.insertUserManager", userVo);

	}
	
	
	/**
	 * 사용자 조회
	 * 
	 * @param param
	 * @return List
	 * @throws SQLException
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<UserVO> selectUserManager(Map<String, Object> param)throws SQLException {
		List<UserVO> result = null;
		result = (List<UserVO>) list("userManagerSql.selectUserManager", param);
		return result;
	}

	
	/**
	 * 사용자 아이디 중복 체크
	 * 
	 * @param usr_id
	 * @return resultSet
	 * @throws SQLException
	 */
	public int userManagerIdCheck(String usr_id) throws SQLException {
		int resultSet = 0;
		resultSet = (int) getSqlSession().selectOne("userManagerSql.userManagerIdCheck", usr_id);
		return resultSet;
	}

	
	/**
	 * 사용자 삭제
	 * 
	 * @param string
	 * @throws SQLException
	 */
	public void deleteUserManager(String string) throws SQLException {
		delete("userManagerSql.deleteUserManager", string);
	}

	
	/**
	 * 사용자 상세정보 조회
	 * 
	 * @param usr_id
	 * @return List
	 * @throws SQLException
	 */
	public UserVO selectDetailUserManager(String usr_id) throws SQLException {
		return (UserVO) selectOne("userManagerSql.selectDetailUserManager", usr_id);
	}

	
	/**
	 * 사용자 수정
	 * 
	 * @param userVo
	 * @throws SQLException
	 */
	public void updateUserManager(UserVO userVo) throws SQLException {
		update("userManagerSql.updateUserManager", userVo);	
	}
	
	/**
	 * top 화면 profile 조회
	 * 
	 * @param instanceScaleVO
	 * @throws Exception
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public Map<String, Object> selectProfieView(Map<String, Object> param) {
		return (Map<String, Object>) selectOne("userManagerSql.selectProfieView", param);
	}
	
	/**
	 * 사용자 등록 backup
	 * 
	 * @param userVo
	 * @throws SQLException
	 */
	public void insertUserManagerHd(UserVO userVo) throws SQLException{
		insert("userManagerSql.insertUserManagerHd", userVo);

	}
	
	/**
	 * 사용자 상세정보 조회 backup
	 * 
	 * @param usr_id
	 * @return List
	 * @throws SQLException
	 */
	public UserVO selectDetailUserManagerHd(String usr_id) throws SQLException {
		return (UserVO) selectOne("userManagerSql.selectDetailUserManagerHd", usr_id);
	}
	
	/**
	 * 사용자 등록 backup
	 * 
	 * @param userVo
	 * @throws SQLException
	 */
	public void insertTransUser(UserVO userVo) throws SQLException{
		insert("userManagerSql.insertTransUser", userVo);
	}
	
	/**
	 * 사용자 삭제(백업)
	 * 
	 * @param string
	 * @throws SQLException
	 */
	public void deleteUserManagerHd(String string) throws SQLException {
		delete("userManagerSql.deleteUserManagerHd", string);
	}

}
