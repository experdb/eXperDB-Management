package com.k4m.dx.tcontrol.restore.service.impl;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.restore.service.RestoreRmanVO;
import com.k4m.dx.tcontrol.restore.service.RestoreService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("RestoreServiceImpl")
public class RestoreServiceImpl extends EgovAbstractServiceImpl implements RestoreService{

	@Resource(name = "restoreDAO")
	private RestoreDAO restoreDAO;

	@Override
	public void insertRmanRestore(RestoreRmanVO restoreRmanVO) throws Exception {
		restoreDAO.insertRmanRestore(restoreRmanVO);
	}

	@Override
	public int restore_nmCheck(String restore_nm) throws Exception {	
		return restoreDAO.restore_nmCheck(restore_nm);
	}

}
