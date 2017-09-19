package com.k4m.dx.tcontrol.accesscontrol.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.accesscontrol.service.AccessControlHistoryVO;
import com.k4m.dx.tcontrol.accesscontrol.service.AccessControlService;
import com.k4m.dx.tcontrol.accesscontrol.service.AccessControlVO;
import com.k4m.dx.tcontrol.accesscontrol.service.DbAutVO;
import com.k4m.dx.tcontrol.accesscontrol.service.DbIDbServerVO;

@Service("AccessControlServiceImpl")
public class AccessControlServiceImpl implements AccessControlService {

	@Resource(name = "accessControlDAO")
	private AccessControlDAO accessControlDAO;

	@Override
	public List<DbIDbServerVO> selectDatabaseList(DbAutVO dbAutVO) throws Exception {
		return accessControlDAO.selectDatabaseList(dbAutVO);
	}
	
	@Override
	public void deleteDbAccessControl(int db_svr_id) throws Exception {
		accessControlDAO.deleteDbAccessControl(db_svr_id);
	}

	@Override
	public void insertAccessControl(AccessControlVO accessControlVO) throws Exception {
		accessControlDAO.insertAccessControl(accessControlVO);
	}

	@Override
	public void insertAccessControlHistory(AccessControlHistoryVO accessControlHistoryVO) throws Exception {
		accessControlDAO.insertAccessControlHistory(accessControlHistoryVO);
		
	}



}
