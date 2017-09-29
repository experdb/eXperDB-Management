package com.k4m.dx.tcontrol.admin.dbauthority.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.admin.dbauthority.service.DbAuthorityService;



@Service("DbAuthorityServiceImpl")
public class DbAuthorityServiceImpl implements DbAuthorityService{

	@Resource(name = "dbAuthorityDAO")
	private DbAuthorityDAO dbAuthorityDAO;

	
	@Override
	public List<Map<String, Object>> selectSvrList() throws Exception {
		return dbAuthorityDAO.selectSvrList();
	}


	@Override
	public void insertUsrDbSvrAut(Map<String, Object> param) throws Exception {
		dbAuthorityDAO.insertUsrDbSvrAut(param);
	}


	@Override
	public List<Map<String, Object>> selectDBList() throws Exception {
		return dbAuthorityDAO.selectDBList();
	}


	@Override
	public void insertUsrDbAut(Map<String, Object> param) throws Exception {
		dbAuthorityDAO.insertUsrDbAut(param);
	}


	/**
	 *  사용자삭제시, 디비서버권한 삭제
	 * @param 
	 * @throws Exception
	 */
	@Override
	public void deleteDbSvrAuthority(String string) throws Exception {
		dbAuthorityDAO.deleteDbSvrAuthority(string);
	}

	
	/**
	 *  사용자삭제시, 디비권한 삭제
	 * @param 
	 * @throws Exception
	 */
	@Override
	public void deleteDbAuthority(String string) throws Exception {
		dbAuthorityDAO.deleteDbAuthority(string);
	}

	
	/**
	 *  유저 디비서버권한 정보 조회
	 * @param 
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectUsrDBSrvAutInfo(String usr_id) throws Exception {
		return dbAuthorityDAO.selectUsrDBSrvAutInfo(usr_id);
	}

	
	/**
	 *  유저 디비서버권한 저장
	 * @param 
	 * @throws Exception
	 */
	@Override
	public void updateUsrDBSrvAutInfo(Object object) throws Exception {
		dbAuthorityDAO.updateUsrDBSrvAutInfo(object);
	}
	
	
	/**
	 *  유저 디비서버권한 저장
	 * @param 
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectDBAutInfo() throws Exception {
		return dbAuthorityDAO.selectDBAutInfo();
	}

	
	/**
	 * 유저 디비권한 정보 조회
	 * @param usr_id 
	 * @param 
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectUsrDBAutInfo(String usr_id) throws Exception {
		return dbAuthorityDAO.selectUsrDBAutInfo(usr_id);
	}


	/**
	 *  유저 디비권한 저장
	 * @param usr_id 
	 * @param 
	 * @throws Exception
	 */
	@Override
	public void updateUsrDBAutInfo(Object object) throws Exception {
		dbAuthorityDAO.updateUsrDBAutInfo(object);	
	}


	@Override
	public int selectUsrDBSrvAutInfoCnt(Object object) throws Exception {
		return dbAuthorityDAO.selectUsrDBSrvAutInfoCnt(object);
	}


	@Override
	public void insertUsrDBSrvAutInfo(Object object) throws Exception {
		dbAuthorityDAO.insertUsrDBSrvAutInfo(object);		
	}


	@Override
	public int selectUsrDBAutInfoCnt(Object object) throws Exception {
		return dbAuthorityDAO.selectUsrDBAutInfoCnt(object);
	}


	@Override
	public void insertUsrDBAutInfo(Object object) throws Exception {
		dbAuthorityDAO.insertUsrDBAutInfo(object);	
	}


	@Override
	public List<Map<String, Object>> selectUserDBSvrAutList(String usr_id) {
		return dbAuthorityDAO.selectUserDBSvrAutList(usr_id);
	}


	@Override
	public List<Map<String, Object>> selectTreeDBSvrList(String usr_id) throws Exception {
		return dbAuthorityDAO.selectTreeDBSvrList(usr_id);
	}

}
