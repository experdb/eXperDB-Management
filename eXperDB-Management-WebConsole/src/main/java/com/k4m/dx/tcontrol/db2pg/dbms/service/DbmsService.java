package com.k4m.dx.tcontrol.db2pg.dbms.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;

public interface DbmsService {

	/**
	 * DB2PG DBMS구분에 따른 케릭터셋 호출
	 */
	List<Map<String, Object>> selectCharSetList(HashMap<String, Object> paramvalue) throws Exception;

	/**
	 * DB2PG DBMS시스템 리스트 조회
	 */
	List<Db2pgSysInfVO> selectDb2pgDBMS(Db2pgSysInfVO db2pgSysInfVO) throws Exception;

	/**
	 * DB2PG DBMS시스템명 중복체크
	 */
	int db2pg_sys_nmCheck(String db2pg_sys_nm) throws Exception;

	/**
	 * DB2PG DBMS시스템 등록
	 */
	void insertDb2pgDBMS(Db2pgSysInfVO db2pgSysInfVO) throws Exception;

	/**
	 * DB2PG DBMS구분
	 */
	List<Map<String, Object>> dbmsGrb() throws Exception;

	/**
	 * DB2PG LIST DBMS구분
	 */
	List<Map<String, Object>> dbmsListDbmsGrb() throws Exception;

	/**
	 * DB2PG DBMS시스템 수정
	 */
	void updateDb2pgDBMS(Db2pgSysInfVO db2pgSysInfVO) throws Exception;

	/**
	 * DB2PG DBMS시스템 리스트 조회(Oracle, MySQL, MsSQL)
	 */
	List<Db2pgSysInfVO> selectDDLDb2pgDBMS(Db2pgSysInfVO db2pgSysInfVO) throws Exception;

	/**
	 * DB2PG DBMS시스템 삭제
	 */
	void deleteDBMS(int db2pg_sys_id) throws Exception;

	/**
	 * DB2PG 스케줄 체크
	 */
	int exeMigCheck() throws Exception;
	

	int db2pg_ddl_check(Map<String, Object> param);
	

	int db2pg_mig_check(Map<String, Object> param);

}
