package com.k4m.dx.tcontrol.db2pg.setting.service;

import java.util.List;
import java.util.Map;

import com.k4m.dx.tcontrol.db2pg.dbms.service.Db2pgSysInfVO;

public interface Db2pgSettingService {

	/**
	 * 공통 코드 조회
	 * 
	 * @param String
	 * @return CodeVO
	 * @throws Exception
	 */
	List<CodeVO> selectCode(String grp_cd) throws Exception;

	/**
	 * DDL WORK 리스트 조회
	 * 
	 * @param Map
	 * @return DDLConfigVO
	 * @throws Exception
	 */
	List<DDLConfigVO> selectDDLWork(Map<String, Object> param) throws Exception;

	/**
	 * Data WORK 리스트 조회
	 * 
	 * @param Map
	 * @return DDLConfigVO
	 * @throws Exception
	 */
	List<DataConfigVO> selectDataWork(Map<String, Object> param) throws Exception;

	/**
	 * 추출 대상 테이블 작업 ID SEQ 조회
	 * 
	 * @return int
	 * @throws Exception
	 */
	int selectExrttrgSrctblsSeq() throws Exception;

	/**
	 * 추출 제외 테이블 작업 ID SEQ 조회
	 * 
	 * @return int
	 * @throws Exception
	 */
	int selectExrtexctSrctblsSeq() throws Exception;

	/**
	 * 사용자 쿼리 내역 ID SEQ 조회
	 * 
	 * @return int
	 * @throws Exception
	 */
	int selectExrtusrQryIdSeq() throws Exception;

	/**
	 * 추출 대상 테이블 등록
	 * 
	 * @param srctableVO
	 * @throws Exception
	 */
	void insertExrttrgSrcTb(SrcTableVO srctableVO) throws Exception;

	/**
	 * 추출 제외 테이블 등록
	 * 
	 * @param srctableVO
	 * @throws Exception
	 */
	void insertExrtexctSrcTb(SrcTableVO srctableVO) throws Exception;

	/**
	 * DDL WORK 등록
	 * 
	 * @param ddlConfigVO
	 * @throws Exception
	 */
	void insertDDLWork(DDLConfigVO ddlConfigVO) throws Exception;

	/**
	 * DDL WORK 수정
	 * 
	 * @param ddlConfigVO
	 * @throws Exception
	 */
	void updateDDLWork(DDLConfigVO ddlConfigVO) throws Exception;

	/**
	 * DDL WORK 삭제
	 * 
	 * @param db2pg_ddl_wrk_id
	 * @throws Exception
	 */
	void deleteDDLWork(int db2pg_ddl_wrk_id) throws Exception;

	/**
	 * 사용자 쿼리 등록
	 * 
	 * @param dataConfigVO
	 * @throws Exception
	 */
	void insertUsrQry(QueryVO queryVO) throws Exception;

	/**
	 * Data WORK 등록
	 * 
	 * @param dataConfigVO
	 * @throws Exception
	 */
	int insertDataWork(DataConfigVO dataConfigVO) throws Exception;

	/**
	 * Data WORK 수정
	 * 
	 * @param dataConfigVO
	 * @throws Exception
	 */
	void updateDataWork(DataConfigVO dataConfigVO) throws Exception;

	/**
	 * Data WORK 삭제
	 * 
	 * @param dataConfigVO
	 * @throws Exception
	 */
	void deleteDataWork(int db2pg_trsf_wrk_id) throws Exception;
	
	/**
	 * Data User Query 삭제
	 * @param int
	 * @throws Exception
	 */
	void deleteUsrQry(int db2pg_trsf_wrk_id) throws Exception;

	/**
	 * DDL WORK 상세정보
	 * 
	 * @param ddlConfigVO
	 * @throws Exception
	 */
	DDLConfigVO selectDetailDDLWork(int db2pg_ddl_wrk_id) throws Exception;

	/**
	 * Data WORK 상세정보
	 * 
	 * @param dataConfigVO
	 * @throws Exception
	 */
	DataConfigVO selectDetailDataWork(int db2pg_trsf_wrk_id) throws Exception;

	/**
	 * Data WORK User Query 
	 * 
	 * @param queryVO
	 * @throws Exception
	 */
	List<QueryVO> selectDetailUsrQry(int db2pg_trsf_wrk_id) throws Exception;

	/**
	 * DBMS 접속정보
	 * 
	 * @param ddlConfigVO
	 * @throws Exception
	 */
	Db2pgSysInfVO selectDBMS(int db2pg_sys_id) throws Exception;

	/**
	 * DB2PG WORK 등록
	 * 
	 * @param ddlConfigVO
	 * @throws Exception
	 */
	void insertDb2pgWork(DDLConfigVO ddlConfigVO) throws Exception;

	/**
	 * DB2PG Data WORK 등록
	 * 
	 * @param dataConfigVO
	 * @throws Exception
	 */
	void insertDb2pgWorkData(DataConfigVO dataConfigVO) throws Exception;

	/**
	 * WORK ID SEQ 조회
	 * 
	 * @return int
	 * @throws Exception
	 */
	int selectWorkSeq() throws Exception;
	
	
	/**
	 * DDL 저장경로 수정
	 * 
	 * @return int
	 * @throws Exception
	 */
	void updateDDLSavePth(Map<String, Object> param) throws Exception;
	
	
	
	/**
	 * 이관 저장경로 수정
	 * 
	 * @return int
	 * @throws Exception
	 */
	void updateTransSavePth(Map<String, Object> param) throws Exception;

	
}
