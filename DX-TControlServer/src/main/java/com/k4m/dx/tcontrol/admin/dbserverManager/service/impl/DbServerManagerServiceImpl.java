package com.k4m.dx.tcontrol.admin.dbserverManager.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerManagerService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.IpadrVO;
import com.k4m.dx.tcontrol.backup.service.DbVO;
import com.k4m.dx.tcontrol.common.service.AgentInfoVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("DbServerManagerServiceImpl")
public class DbServerManagerServiceImpl extends EgovAbstractServiceImpl implements DbServerManagerService {

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
	public int selectDBcnt(HashMap<String, Object> paramvalue) throws Exception {
		return dbServerManagerDAO.selectDBcnt(paramvalue);
	}

	@Override
	public void updateDB(HashMap<String, Object> paramvalue) throws Exception {
		dbServerManagerDAO.updateDB(paramvalue);
	}

	@Override
	public int db_svr_nmCheck(String db_svr_nm) throws Exception {
		return dbServerManagerDAO.db_svr_nmCheck(db_svr_nm);
	}

	@Override
	public List<DbVO> selectDbListTree(int db_svr_id) throws Exception {
		return dbServerManagerDAO.selectDbListTree(db_svr_id);
	}

	@Override
	public List<Map<String, Object>> selectIpList(AgentInfoVO agentInfoVO) throws Exception {
		return dbServerManagerDAO.selectIpList(agentInfoVO);
	}

	@Override
	public int selectDbsvrid() throws Exception {
		return dbServerManagerDAO.selectDbsvrid();
	}

	@Override
	public void insertIpadr(IpadrVO ipadrVO) throws Exception {
		dbServerManagerDAO.insertIpadr(ipadrVO);
	}

}
