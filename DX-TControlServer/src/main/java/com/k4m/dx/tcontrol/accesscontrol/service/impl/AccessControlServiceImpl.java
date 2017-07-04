package com.k4m.dx.tcontrol.accesscontrol.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.accesscontrol.service.AccessControlService;
import com.k4m.dx.tcontrol.backup.service.DbVO;

@Service("AccessControlServiceImpl")
public class AccessControlServiceImpl implements AccessControlService{
	
	@Resource(name = "accessControlDAO")
	private AccessControlDAO accessControlDAO;

	@Override
	public List<DbVO> selectDatabaseList(int db_svr_id) throws Exception {
		// TODO Auto-generated method stub
		return accessControlDAO.selectDatabaseList(db_svr_id);
	}


}
