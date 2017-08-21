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

}
