package com.k4m.dx.tcontrol.accesscontrol.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.accesscontrol.service.AccessControlService;
import com.k4m.dx.tcontrol.accesscontrol.service.AccessControlVO;
import com.k4m.dx.tcontrol.accesscontrol.service.DbIDbServerVO;

@Service("AccessControlServiceImpl")
public class AccessControlServiceImpl implements AccessControlService {

	@Resource(name = "accessControlDAO")
	private AccessControlDAO accessControlDAO;

	@Override
	public List<DbIDbServerVO> selectDatabaseList(int db_svr_id) throws Exception {
		return accessControlDAO.selectDatabaseList(db_svr_id);
	}

	@Override
	public DbIDbServerVO selectServerDb(int db_id) throws Exception {
		return accessControlDAO.selectServerDb(db_id);
	}

	@Override
	public void deleteDbAccessControl(int db_id) throws Exception {
		accessControlDAO.deleteDbAccessControl(db_id);
	}

	@Override
	public void insertAccessControl(AccessControlVO accessControlVO) throws Exception {
		accessControlDAO.insertAccessControl(accessControlVO);
	}

}
