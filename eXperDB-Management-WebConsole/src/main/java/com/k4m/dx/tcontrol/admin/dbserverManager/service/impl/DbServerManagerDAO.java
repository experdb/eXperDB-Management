package com.k4m.dx.tcontrol.admin.dbserverManager.service.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.IpadrVO;
import com.k4m.dx.tcontrol.backup.service.DbVO;
import com.k4m.dx.tcontrol.common.service.AgentInfoVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("dbServerManagerDAO")
public class DbServerManagerDAO extends EgovAbstractMapper{

	
	/**
	 * DB서버 정보 조회
	 * 
	 * @param dbServerVO
	 * @return List
	 * @throws Exception
	 */	
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<DbServerVO> selectDbServerList(DbServerVO dbServerVO) throws SQLException {
		List<DbServerVO> sl = null;
		sl = (List<DbServerVO>) list("dbserverManagerSql.selectDbServerList", dbServerVO);
		return sl;
	}

	
	/**
	 * DB서버 정보 등록
	 * 
	 * @param dbServerVO
	 * @return 
	 * @throws Exception
	 */	
	public void insertDbServer(DbServerVO dbServerVO) throws SQLException {
		insert("dbserverManagerSql.insertDbServer", dbServerVO);		
	}

	
	/**
	 * DB서버 정보 수정
	 * 
	 * @param dbServerVO
	 * @return 
	 * @throws Exception
	 */	
	public void updateDbServer(DbServerVO dbServerVO) throws SQLException {
		update("dbserverManagerSql.updateDbServer", dbServerVO);	
	}


	/**
	 * DB 삭제
	 * 
	 * @param dbServerVO
	 * @return 
	 * @throws Exception
	 */	
	public void deleteDB(DbServerVO dbServerVO) throws SQLException{
		delete("dbserverManagerSql.deleteDB", dbServerVO);	
	}


	/**
	 * DB 등록
	 * 
	 * @param paramvalue
	 * @return 
	 * @throws Exception
	 */	
	public void insertDB(HashMap<String, Object> paramvalue) {
		insert("dbserverManagerSql.insertDB",paramvalue );		
	}

	
	/**
	 * DB 정보 조회
	 * 
	 * @param 
	 * @return List
	 * @throws Exception
	 */	
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<DbVO> selectDbList() {
		List<DbVO> sl = null;
		sl = (List<DbVO>) list("dbserverManagerSql.selectDbList", null);
		return sl;
	}


	/**
	 * Repository DB 정보 조회
	 * @param paramvalue 
	 * 
	 * @param 
	 * @return List
	 * @throws Exception
	 */	
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<Map<String, Object>> selectRepoDBList(HashMap<String, Object> paramvalue) {
		List<Map<String, Object>>  sl = null;
		sl = (List<Map<String, Object>>) list("dbserverManagerSql.selectRepoDBList", paramvalue);
		return sl;
	}


	/**
	 * Repository DB에 등록되어 있는 DB의 서버명 SelectBox 
	 * @param db_svr_id 
	 * 
	 * @param 
	 * @return List
	 * @throws Exception
	 */	
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<Map<String, Object>> selectSvrList(int db_svr_id) {
		List<Map<String, Object>>  sl = null;
		sl = (List<Map<String, Object>>) list("dbserverManagerSql.selectSvrList", db_svr_id);
		return sl;
	}


	public int dbServerIpCheck(String ipadr) {
		int resultSet = 0;
		resultSet = (int) getSqlSession().selectOne("dbserverManagerSql.dbServerIpCheck", ipadr);
		return resultSet;
	}


	public int selectDBcnt(HashMap<String, Object> paramvalue) {
		int resultSet = 0;
		resultSet = (int) getSqlSession().selectOne("dbserverManagerSql.selectDBcnt", paramvalue);
		return resultSet;
	}


	public void updateDB(HashMap<String, Object> paramvalue) {
		update("dbserverManagerSql.updateDB",paramvalue );		
	}


	public int db_svr_nmCheck(String db_svr_nm) {
		int resultSet = 0;
		resultSet = (int) getSqlSession().selectOne("dbserverManagerSql.db_svr_nmCheck", db_svr_nm);
		return resultSet;
	}


	public List<DbVO> selectDbListTree(int db_svr_id) {
		List<DbVO> sl = null;
		sl = (List<DbVO>) list("dbserverManagerSql.selectDbListTree", db_svr_id);
		return sl;
	}


	public List<Map<String, Object>> selectIpList(AgentInfoVO agentInfoVO) {
		List<Map<String, Object>>  sl = null;
		sl = (List<Map<String, Object>>) list("dbserverManagerSql.selectIpList",agentInfoVO);
		return sl;
	}


	public int selectDbsvrid() {
		int resultSet = 0;
		resultSet = (int) getSqlSession().selectOne("dbserverManagerSql.selectDbsvrid", null);
		return resultSet;
	}


	public void insertIpadr(IpadrVO ipadrVO) {
		insert("dbserverManagerSql.insertIpadr", ipadrVO);		
	}


	public Map exeCheck(int db_svr_id) {
		Map mp = new HashMap();
		int connectorExe = (int) getSqlSession().selectOne("dbserverManagerSql.connectorExeCheck", db_svr_id);
		int scheduleExe = (int) getSqlSession().selectOne("dbserverManagerSql.scheduleExeCheck", db_svr_id);
		
		mp.put("connChk", connectorExe);
		mp.put("scheduleChk", scheduleExe);
		
		return mp;
	}


	/*
	 * DB서버 삭제
	 * 1. 전송매핑 삭제 ---------------------------------
	 * 1-1. 전송매핑 테이블 내역 삭제
	 * 1-2. 전송대상매핑관계 삭제
	 * ---------------------------------------------------
	 * 
	 * 2. 서버접근제어 삭제 ----------------------------
	 * 2-1. 서버접근제어이력정보 삭제
	 * 2-2. 서버접근제어정보 삭제
	 * ---------------------------------------------------
	 * 
	 * 3. 백업작업삭제 ----------------------------------
	 * 3-1 백업작업ID 조회
	 * 3-2. 백업오브젝트내역 삭제
	 * 3-3. 백업옵션정보 삭제
	 * ---------------------------------------------------
	 * 
	 * 4. 스케줄 삭제 -----------------------------------
	 * 4-1 스케줄ID 조회
	 * 4-2 작업실행로그 삭제
	 * 4-3 스케줄상세 삭제
	 * 4-4 스케줄기본 삭제
	 * ---------------------------------------------------
	 * 
	 * 5. 백업작업설정정보 삭제 ------------------------
	 * 
	 * 6. 사용자DB권한정보 삭제 -----------------------
	 * 
	 * 7. DB정보 삭제 ----------------------------------
	 * 
	 * 8. 사용자DB서버권한정보 삭제 ------------------
	 * 
	 * 9. DB서버아이피주소정보 삭제 ------------------
	 * 
	 * 10. DB서버정보 삭제 ----------------------------
	 */
	
	// 1. 전송매핑 삭제
	public void dbSvrDelete(int db_svr_id) {
		// 1-1.전송매핑 테이블 내역삭제
		delete("dbserverManagerSql.deleteConnMappingTable", db_svr_id);		
		// 1-2. 전송대상매핑관계 삭제
		delete("dbserverManagerSql.deleteConnMappingRelation", db_svr_id);		
	}
	
	// 2. 서버접근제어 삭제
	public void deleteServerAccessControl(int db_svr_id) {
		// 2-1. 서버접근제어이력정보 삭제		
		delete("dbserverManagerSql.deleteServerAccessControlHistory", db_svr_id);	
		// 2-2. 서버접근제어정보 삭제
		delete("dbserverManagerSql.deleteServerAccessControlInfo", db_svr_id);	
	}

	// 3. 백업작업삭제
	public void deleteBckWrk(int db_svr_id) {
		List<Map<String, Object>>  sl = null;		
		//3-1 백업작업ID 조회
		sl = (List<Map<String, Object>>) list("dbserverManagerSql.selectBckWrkId",db_svr_id);
		
		HashMap<String , Object> paramvalue = new HashMap<String, Object>();
		List<String> ids = new ArrayList<String>(); 
		
		
		for(int i=0; i<sl.size(); i++){
			ids.add(sl.get(i).get("bck_wrk_id").toString()); 
		}
		
		if(ids.size() != 0 ){
			paramvalue.put("bck_wrk_id", ids);
			
			//3-2 백업오브젝트내역 삭제
			delete("dbserverManagerSql.deleteBckObjHistory", paramvalue);		
			//3-2 백업옵션정보 삭제
			delete("dbserverManagerSql.deleteBckOptInfo", paramvalue);		
		}
	
	}

	// 4. 스케줄 삭제
	public void deleteSchedule(int db_svr_id) {
		List<Map<String, Object>>  sl = null;
		// 4-1 스케줄ID 조회
		sl = (List<Map<String, Object>>) list("dbserverManagerSql.selectScheduleId",db_svr_id);
		
		List<String> ids = new ArrayList<String>(); 
		HashMap<String , Object> paramvalue = new HashMap<String, Object>();
		
		for(int i=0; i<sl.size(); i++){
			ids.add(sl.get(i).get("scd_id").toString()); 
		}
		if(ids.size() != 0 ){
			paramvalue.put("scd_id", ids);
			
			//4-2 작업실행로그 삭제
			delete("dbserverManagerSql.deleteWrkexe", paramvalue);				
			//4-3 스케줄상세 삭제
			delete("dbserverManagerSql.deleteScdD", paramvalue);		
			//4-4 스케줄기본 삭제
			delete("dbserverManagerSql.deleteScdM", paramvalue);	
		}
	}	
	
	// 5. WORK정보 삭제
	public void deleteWrkcng(int db_svr_id) {
		delete("dbserverManagerSql.deleteWrkcng", db_svr_id);			
	}
	
	// 6. 백업작업설정정보 삭제
	public void deleteBckWrkcng(int db_svr_id) {
		delete("dbserverManagerSql.deleteBckWrkcng", db_svr_id);			
	}
	
	// 7. 사용자DB권한정보 삭제
	public void deleteUsrDbAut(int db_svr_id) {
		delete("dbserverManagerSql.deleteUsrDbAut", db_svr_id);		
	}
	
	// 8. DB정보 삭제
	public void deleteDbInfo(int db_svr_id) {
		delete("dbserverManagerSql.deleteDbInfo", db_svr_id);	
	}
	
	// 9. 사용자DB서버권한정보 삭제
	public void deleteUsrDbSvrAut(int db_svr_id) {
		delete("dbserverManagerSql.deleteUsrDbSvrAut", db_svr_id);		
	}	
	
	// 10. DB서버아이피주소정보 삭제
	public void deleteDbSvrIpAdr(int db_svr_id) {
		delete("dbserverManagerSql.deleteDbSvrIpAdr", db_svr_id);		
	}	
	
	// 11. DB서버정보 삭제
	public void deleteDbServer(int db_svr_id) {
		delete("dbserverManagerSql.deleteDbServer", db_svr_id);	
	}


	public List<DbVO> selectDBSync(int db_svr_id) {
		List<DbVO> sl = null;
		sl = (List<DbVO>) list("dbserverManagerSql.selectDBSync", db_svr_id);
		return sl;
	}


	public void syncUpdate(HashMap<String, Object> paramvalue) {
		update("dbserverManagerSql.syncUpdate", paramvalue);		
	}


	public List<DbServerVO> selectPgDbmsList() {
		List<DbServerVO>  sl = null;
		sl = (List<DbServerVO>) list("dbserverManagerSql.selectPgDbmsList", null);
		return sl;
	}


	public void updateIpadr(IpadrVO ipadrVO) {
		update("dbserverManagerSql.updateIpadr",ipadrVO );		
	}


	public void deleteIpadr(HashMap<String, Object> paramvalue) {
		delete("dbserverManagerSql.deleteIpadr",paramvalue );		
	}


	public int selectIpadrCnt() {
		int resultSet = 0;
		resultSet = (int) getSqlSession().selectOne("dbserverManagerSql.selectIpadrCnt", null);
		return resultSet;
	}


}




