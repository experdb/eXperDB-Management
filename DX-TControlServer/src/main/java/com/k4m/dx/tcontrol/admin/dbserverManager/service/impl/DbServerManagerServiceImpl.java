package com.k4m.dx.tcontrol.admin.dbserverManager.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerManagerService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;

@Service("DbServerManagerServiceImpl")
public class DbServerManagerServiceImpl implements DbServerManagerService {

	@Resource(name = "dbServerManagerDAO")
	private DbServerManagerDAO dbServerManagerDAO;

	public List<DbServerVO> selectDbServerList(DbServerVO dbServerVO) throws Exception {
		return dbServerManagerDAO.selectDbServerList(dbServerVO);
	}

	public void insertDbServer(DbServerVO dbServerVO) throws Exception {
		dbServerManagerDAO.insertDbServer(dbServerVO);	
	}
}
