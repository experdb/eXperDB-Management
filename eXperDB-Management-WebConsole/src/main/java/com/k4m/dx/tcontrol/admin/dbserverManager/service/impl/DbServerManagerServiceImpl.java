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

	@Override
	public Map exeCheck(int db_svr_id) {
		return dbServerManagerDAO.exeCheck(db_svr_id);
	}


	/*
	 * DB서버 삭제
	 * 1. 전송매핑 삭제 ---------------------------------
	 * 2. 서버접근제어 삭제 ----------------------------
	 * 3. 백업작업삭제 ---------------------------------
	 * 4. 스케줄 삭제 ----------------------------------
	 * 5. 백업작업설정정보 삭제 -----------------------
	 * 6. 사용자DB권한정보 삭제 -----------------------
	 * 7. DB정보 삭제 ----------------------------------
	 * 8. 사용자DB서버권한정보 삭제 ------------------
	 * 9. DB서버아이피주소정보 삭제 ------------------
	 * 10. DB서버정보 삭제 ----------------------------
	 */
	@Override
	public void dbSvrDelete(int db_svr_id) {
		// 1.전송매핑 테이블 내역삭제
		dbServerManagerDAO.dbSvrDelete(db_svr_id);
		
		// 2.서버접근제어이력정보 삭제
		dbServerManagerDAO.deleteServerAccessControl(db_svr_id);
		
		// 3 백업작업 삭제
		dbServerManagerDAO.deleteBckWrk(db_svr_id);
		
		// 4 스케줄 삭제
		dbServerManagerDAO.deleteSchedule(db_svr_id);
		
		// 5. WORK정보 삭제
		dbServerManagerDAO.deleteWrkcng(db_svr_id);
		
		// 6. 백업작업설정정보 삭제
		dbServerManagerDAO.deleteBckWrkcng(db_svr_id);
		
		// 7. 사용자DB권한정보 삭제
		dbServerManagerDAO.deleteUsrDbAut(db_svr_id);
		
		// 8. DB정보 삭제
		dbServerManagerDAO.deleteDbInfo(db_svr_id);
		
		// 8. 사용자DB서버권한정보 삭제
		dbServerManagerDAO.deleteUsrDbSvrAut(db_svr_id);
		
		// 9. DB서버아이피주소정보 삭제
		dbServerManagerDAO.deleteDbSvrIpAdr(db_svr_id);
		
		// 10. DB서버정보 삭제
		dbServerManagerDAO.deleteDbServer(db_svr_id);
		
	}

	@Override
	public List<DbVO> selectDBSync(int db_svr_id) throws Exception {
		return dbServerManagerDAO.selectDBSync(db_svr_id);
	}

	@Override
	public void syncUpdate(HashMap<String, Object> paramvalue) throws Exception {
		dbServerManagerDAO.syncUpdate(paramvalue);
	}

	@Override
	public List<DbServerVO> selectPgDbmsList() throws Exception {
		return dbServerManagerDAO.selectPgDbmsList();
	}

	@Override
	public void updateIpadr(IpadrVO ipadrVO) throws Exception {
		dbServerManagerDAO.updateIpadr(ipadrVO);		
	}

	@Override
	public void deleteIpadr(HashMap<String, Object> paramvalue) throws Exception {
		dbServerManagerDAO.deleteIpadr(paramvalue);			
	}

	@Override
	public int selectIpadrCnt() throws Exception {
		return dbServerManagerDAO.selectIpadrCnt();
	}



}
