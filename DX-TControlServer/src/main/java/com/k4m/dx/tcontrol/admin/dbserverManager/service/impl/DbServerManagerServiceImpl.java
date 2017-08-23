package com.k4m.dx.tcontrol.admin.dbserverManager.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerManagerService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.backup.service.DbVO;

@Service("DbServerManagerServiceImpl")
public class DbServerManagerServiceImpl implements DbServerManagerService {

	@Resource(name = "dbServerManagerDAO")
	private DbServerManagerDAO dbServerManagerDAO;

	@Override
	public List<DbServerVO> selectDbServerList(DbServerVO dbServerVO) throws Exception {
		return dbServerManagerDAO.selectDbServerList(dbServerVO);
	}

	@Override
	public void insertDbServer(DbServerVO dbServerVO) throws Exception {
		dbServerManagerDAO.insertDbServer(dbServerVO);
	}

	@Override
	public void updateDbServer(DbServerVO dbServerVO) throws Exception {
		dbServerManagerDAO.updateDbServer(dbServerVO);
	}

	@Override
	public void deleteDB(DbServerVO dbServerVO) throws Exception {
		dbServerManagerDAO.deleteDB(dbServerVO);
	}

	@Override
	public void insertDB(HashMap<String, Object> paramvalue) throws Exception {
		dbServerManagerDAO.insertDB(paramvalue);
	}

	@Override
	public List<DbVO> selectDbList() throws Exception {
		return dbServerManagerDAO.selectDbList();
	}

	@Override
	public List<Map<String, Object>> selectRepoDBList(HashMap<String, Object> paramvalue) throws Exception {
		return dbServerManagerDAO.selectRepoDBList(paramvalue);
	}

	@Override
	public List<Map<String, Object>> selectSvrList(int db_svr_id) throws Exception {
		return dbServerManagerDAO.selectSvrList(db_svr_id);
	}

	@Override
	public int dbServerIpCheck(String ipadr) throws Exception {
		return dbServerManagerDAO.dbServerIpCheck(ipadr);
	}

	@Override
	public int selectDBcnt(DbServerVO dbServerVO) throws Exception {
		return dbServerManagerDAO.selectDBcnt(dbServerVO);
	}

	@Override
	public void updateDB(HashMap<String, Object> paramvalue) throws Exception {
		dbServerManagerDAO.updateDB(paramvalue);
	}

}
